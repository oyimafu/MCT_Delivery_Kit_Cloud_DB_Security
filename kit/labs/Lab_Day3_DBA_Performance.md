# Lab — Day 3: Database Administration & Performance

**Course:** Cloud, Database & Cybersecurity Essentials — Integrated IT Fundamentals Training
**Module:** Day 3 — Database Administration & Performance
**Hands-on activity (brochure):** *Diagnose and resolve a simple performance issue using sample database data and execution plan analysis.*

## Objective
Learners will generate a large synthetic inspection-events table (~12,000 rows) in their Day 2 Azure SQL Database, reproduce a slow regulator compliance report, read the actual execution plan to identify a table scan, fix it with a targeted non-clustered index, and confirm the improvement. Learners will then walk through Azure SQL backup/PITR and geo-replication concepts for business continuity.

## Estimated duration
3.5 hours (data generation + before/after scan-vs-seek exercise: 90 min; missing-index DMV + covering index deep dive: 45 min; backup/PITR + geo-replication walkthrough: 60 min; wrap-up: 15 min).

## Prerequisites
- Completion of Day 2 lab — an existing `PetroleumInventoryDB` Azure SQL Database, connected via Azure Data Studio/SSMS.
- The dataset file `datasets/day3_performance_lab.sql` from this kit.
- Basic familiarity with SELECT/WHERE/JOIN from Day 2.

## Cost-safety reminders
- The `InspectionEvents` table generated in this lab is temporary practice data. **Drop it at the end of the lab** (Step 6 of the script) so it does not consume your free-tier 32 GB data allowance long-term.
- Stay on the free-offer **General Purpose Serverless** tier — do not scale up to fix performance; the point of this lab is that indexing fixes the problem without paying for more compute.
- Disconnect Azure Data Studio/SSMS Object Explorer when you finish so the database can auto-pause ([Azure SQL Database free offer](https://learn.microsoft.com/en-us/azure/azure-sql/database/free-offer)).
- The backup/PITR walkthrough (Part 3) is **observation only** for this course — do not trigger a geo-restore or failover against the shared lab database, as this can disrupt other learners sharing the same resource group naming convention. Follow the "look, don't click Restore" guidance in Part 3.

---

## Part 1 — Generate the large table and reproduce the slow query

1. In Azure Data Studio, connect to `PetroleumInventoryDB` (same connection as Day 2).
2. Open `datasets/day3_performance_lab.sql` from this kit.
3. Read the header comment block — it explains the scenario: a Director of Compliance report ("all HIGH-risk findings at the Warri Products Depot in the last 90 days") has become slow as the `InspectionEvents` table grew.
4. Run **Step 1** of the script only (the `CREATE TABLE` + tally-CTE `INSERT` + the 4 guaranteed demo rows). This generates 12,004 rows using a set-based numbers/tally technique — no cursors or loops needed. [Screenshot: Query results showing "(12000 rows affected)" then "(4 rows affected)"]
5. Run the row-count check:
   ```sql
   SELECT COUNT(*) AS TotalInspectionRows FROM dbo.InspectionEvents;
   -- Expected: 12,004
   ```

## Part 2 — Before: capture the execution plan and identify the scan

1. In Azure Data Studio, before running the next query, enable the execution plan view: click the **Explain** button in the query toolbar (in SSMS: **Ctrl+M** to include the actual execution plan). [Screenshot: Azure Data Studio "Explain" button highlighted in query toolbar]
2. Run **Step 2** of the script (`SET STATISTICS IO ON; SET STATISTICS TIME ON;` then the report query):
   ```sql
   SELECT
       InspectionID, FacilityCode, FacilityCity, InspectionType,
       InspectorName, InspectionDate, RiskRating, FindingsSummary
   FROM dbo.InspectionEvents
   WHERE FacilityCode = 'FAC-WAR-01'
     AND RiskRating = 'HIGH'
     AND InspectionDate >= DATEADD(DAY, -90, '2026-07-23')
   ORDER BY InspectionDate DESC;
   ```
3. Open the **execution plan** tab in the results pane. Hover over the leftmost/largest operator icon. [Screenshot: Execution plan tab showing a single large "Clustered Index Scan" operator at ~100% cost]
4. Confirm you see **Clustered Index Scan** (not "Seek") on the `PK__Inspecti...` index, with **Estimated/Actual Number of Rows Read ≈ 12,004** — the entire table, even though only a handful of rows match.
5. Check the **Messages** tab for `STATISTICS IO` output — note the **logical reads** count (this will be in the hundreds for a table this size, since every 8 KB page had to be read to filter row-by-row). [Screenshot: Messages tab showing "Table 'InspectionEvents'. Scan count 1, logical reads: NNN"]
6. Record: **Before — Operator = Clustered Index Scan; Logical reads = ____; Rows read ≈ 12,004.**

> **Why this happens:** the table's only index is the clustered PRIMARY KEY on `InspectionID`. There is no index that lets SQL Server jump directly to "Warri + HIGH + last 90 days" rows, so the engine must read every row and evaluate the `WHERE` clause against each one — a full scan.

## Part 3 — Diagnose with the missing-index DMV

1. Run the missing-index query from **Step 3** of the script:
   ```sql
   SELECT
       mid.statement AS TableName,
       migs.avg_total_user_cost * migs.avg_user_impact AS EstimatedBenefit,
       'CREATE INDEX IX_Suggested ON ' + mid.statement + ' (...)' AS SuggestedIndexDDL
   FROM sys.dm_db_missing_index_details mid
   JOIN sys.dm_db_missing_index_groups mig ON mig.index_handle = mid.index_handle
   JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
   ORDER BY EstimatedBenefit DESC;
   ```
2. Compare the suggestion against the equality/range column design explained in the script comments: equality columns (`FacilityCode`, `RiskRating`) first, range column (`InspectionDate`) last, with `INCLUDE` columns for anything only needed in the `SELECT` list. [Screenshot: Missing-index DMV result row with SuggestedIndexDDL column]
3. Discuss as a class: why design the index deliberately rather than blindly running the auto-suggested DDL in production? (Answer: auto-suggestions don't account for write-heavy tables, existing similar indexes, or index-maintenance overhead — always review before applying.)

## Part 4 — Fix: create the covering index and re-run

1. Run **Step 4** of the script:
   ```sql
   CREATE NONCLUSTERED INDEX IX_InspectionEvents_Facility_Risk_Date
       ON dbo.InspectionEvents (FacilityCode, RiskRating, InspectionDate)
       INCLUDE (FacilityCity, InspectionType, InspectorName, FindingsSummary);
   ```
2. Re-run the **exact same** report query from Part 2 (Step 5 of the script).
3. Open the execution plan again. [Screenshot: Execution plan tab now showing "Index Seek" on IX_InspectionEvents_Facility_Risk_Date at near-0% cost]
4. Confirm: **Operator = Index Seek** (not Scan), and there is **no Key Lookup** operator — this means the index is "covering" (the `INCLUDE` columns satisfied the whole `SELECT` list without a second trip to the clustered index).
5. Check `STATISTICS IO` again — logical reads should now be a small single/double-digit number instead of the hundreds seen before.
6. Record: **After — Operator = Index Seek; Logical reads = ____; Rows read = only matching rows (a handful).**

### Before/after comparison table (fill in with your actual numbers)

| Metric | Before (no index) | After (covering index) |
|---|---|---|
| Plan operator | Clustered Index Scan | Index Seek |
| Rows read | ~12,004 | ____ |
| Logical reads (STATISTICS IO) | ____ | ____ |
| Key Lookup present? | N/A | No |

## Part 5 — Backup, Point-in-Time Restore (PITR) and geo-replication walkthrough

Azure SQL Database automatically backs up your database; this section is a **guided observation walkthrough** — do not actually restore or fail over the shared lab database.

1. In the Azure portal, open your `PetroleumInventoryDB` resource.
2. In the left menu, select **Manage backups** (or search "backup" in the resource's search box). Review the **retention policy** shown (default short-term retention, typically 7 days on the free/serverless tier) and the list of available restore points. [Screenshot: Manage backups blade showing retention policy and restore point list]
3. Select **Restore** to open the Point-in-Time Restore wizard, review the **Basics** tab (source database, restore point picker), then **cancel out without confirming** — this is observation only. [Screenshot: Point-in-time restore wizard Basics tab, cancel before Review+Create]
4. Navigate to your database's **Overview** blade and locate the **Failover groups** / **Geo-replication** option (usually under Data management, or via the server-level blade). Open the geo-replication map view showing candidate secondary regions. [Screenshot: Geo-replication region map on the SQL server blade]
5. Discuss as a class: for the regulator's crude-oil production reporting portal, which secondary region would you nominate for active geo-replication or a failover group, and why (tie back to the Day 1 region decision matrix and data-residency reasoning)?
6. Note: active geo-replication and failover groups typically require a higher (non-free) service tier — confirm in the portal what the current database's tier allows, and document this as a "future production consideration" rather than testing it against the free-tier lab database.

## Expected results / checkpoints
- [ ] `InspectionEvents` table created with 12,004 rows.
- [ ] "Before" execution plan captured showing Clustered Index Scan with ~12,004 rows read.
- [ ] Missing-index DMV query run and reviewed.
- [ ] Covering non-clustered index created successfully.
- [ ] "After" execution plan captured showing Index Seek with no Key Lookup and far fewer logical reads.
- [ ] Before/after comparison table completed with actual numbers from your session.
- [ ] Backup/PITR wizard and geo-replication blade both viewed (no restore/failover actually triggered).
- [ ] `InspectionEvents` table and its index dropped at the end of the lab (cost-safety cleanup, Step 6 of the script).

## Troubleshooting tips
- **Tally-CTE INSERT seems to hang** — this is a CPU-bound set-based operation; on a serverless database resuming from auto-pause, allow up to 30–60 seconds before it starts returning rows.
- **Execution plan still shows a scan after creating the index** — confirm you re-ran the *exact* query text (same column list, same WHERE clause) as Part 2; a different SELECT list may not be covered by the INCLUDE columns, forcing a Key Lookup or scan.
- **STATISTICS IO output not visible** — in Azure Data Studio, check the **Messages** tab next to Results; in SSMS it appears in the Messages sub-tab of the results pane.
- **"CREATE INDEX" fails with duplicate name error** — you already created it in a previous run; either `DROP INDEX IX_InspectionEvents_Facility_Risk_Date ON dbo.InspectionEvents;` first, or skip to Part 4 Step 2.
- **Portal "Restore" or "Failover groups" options greyed out** — expected on the free-offer serverless tier for some geo-replication features; this is a discussion point, not a blocker — proceed with the class discussion in Part 5 Step 5.

## PostgreSQL alternative note
On **Azure Database for PostgreSQL Flexible Server**:
- Generate rows with `generate_series(1, 12000)` instead of the tally-CTE trick.
- Use `EXPLAIN (ANALYZE, BUFFERS) SELECT ...` instead of "Include Actual Execution Plan"/`STATISTICS IO`. Look for **Seq Scan** (before) vs. **Index Scan** / **Bitmap Heap Scan** (after).
- Create the equivalent covering index with:
  ```sql
  CREATE INDEX ix_inspectionevents_facility_risk_date
      ON inspection_events (facility_code, risk_rating, inspection_date)
      INCLUDE (facility_city, inspection_type, inspector_name, findings_summary);
  ```
- For backup/PITR, review **Server parameters > backup retention** and the **Point-in-time restore** blade on the Flexible Server resource; geo-redundant backup is a configurable option at server-creation time ([PostgreSQL Flexible Server free account guide](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/how-to-deploy-on-azure-free-account)).

## What to submit for grading
1. Screenshots (or pasted plan XML/text) of the "before" execution plan (Clustered Index Scan) and "after" execution plan (Index Seek).
2. The completed before/after comparison table with your actual logical-reads numbers.
3. The `CREATE INDEX` statement you used and a one-sentence explanation of your column ordering choice (equality columns first, range column last).
4. A short paragraph naming your recommended geo-replication secondary region for the crude-oil production reporting portal, with justification.
5. Confirmation that you dropped the `InspectionEvents` table and its index at the end of the session.
