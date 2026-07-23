# Lab — Day 2: Database Fundamentals & CRUD

**Course:** Cloud, Database & Cybersecurity Essentials — Integrated IT Fundamentals Training
**Module:** Day 2 — Database Fundamentals
**Hands-on activity (brochure):** *Model a small inventory database schema and execute SQL queries to perform CRUD operations.*

## Objective
Learners will provision a free-tier Azure SQL Database, connect using Azure Data Studio, deploy a normalized petroleum-regulator inventory/asset schema, and practice Create/Read/Update/Delete (CRUD) SQL against realistic oil & gas data (pipeline valves, pumps, meters, PPE, spares across Lagos, Port Harcourt, Warri and Kaduna facilities). Learners will also complete a short normalization mini-exercise.

## Estimated duration
3 hours (provisioning + connection: 30 min; schema deployment + walkthrough: 30 min; CRUD exercises: 90 min; normalization mini-exercise + wrap-up: 30 min).

## Prerequisites
- Completion of Day 1 lab (cloud service selection concepts).
- An Azure account (free account or organizational subscription with permission to create resources).
- [Azure Data Studio](https://learn.microsoft.com/en-us/azure-data-studio/download-azure-data-studio) or SQL Server Management Studio (SSMS) installed on the learner's laptop.
- The dataset file `datasets/petroleum_inventory_schema.sql` from this kit (copy it to your laptop before the session in case of venue connectivity issues).

## Cost-safety reminders
- Use the **Azure SQL free offer**: up to 10 General Purpose serverless databases per subscription, with 100,000 vCore-seconds compute + 32 GB data + 32 GB backup free per month, for the life of the subscription ([Azure SQL Database free offer](https://learn.microsoft.com/en-us/azure/azure-sql/database/free-offer)). Start from **aka.ms/azuresqlhub** and click **Start free**.
- Serverless compute **auto-pauses** when idle — this is good for cost, but means your first query after a break may take a few extra seconds to "wake" the database. This is expected, not a fault.
- Create **one shared resource group per learner**, named `rg-<initials>-course`, and tag every resource `course=cdcs`.
- When you finish for the day, **disconnect the Object Explorer connection** in Azure Data Studio/SSMS (right-click the connection > Disconnect) so the serverless database can auto-pause. Do not leave a query window connected overnight.
- Do not upsize the database tier beyond the free-offer serverless General Purpose tier during this course.

---

## Part 1 — Create the Azure SQL Database (free offer)

1. In a browser, go to **aka.ms/azuresqlhub** (the Azure SQL hub landing page). [Screenshot: Azure SQL hub landing page with "Start free" button]
2. Sign in with your Azure account, then select **Start free**.
3. On the **Basics** tab of the Create SQL Database wizard:
   - **Subscription:** your course subscription.
   - **Resource group:** select **Create new** → `rg-<initials>-course` (replace `<initials>` with your own, e.g. `rg-jt-course`).
   - **Database name:** `PetroleumInventoryDB`.
   - **Server:** select **Create new**:
     - **Server name:** a globally unique name, e.g. `sql-<initials>-course` (lowercase, no spaces).
     - **Location:** choose the region your instructor specifies (see the Day 1 region-decision discussion for the residency rationale).
     - **Authentication method:** **Use both SQL and Microsoft Entra authentication**. Set a SQL admin login and a strong password — record it securely; you will need it again in Day 4.
   - **Want to use SQL elastic pool?** No.
   - **Workload environment:** Development.
   - Under **Compute + storage**, select **Configure database**, choose **General Purpose – Serverless**, and confirm the free-offer banner is shown (10 free databases per subscription). [Screenshot: Create SQL Database — Compute+storage — General Purpose Serverless with free offer banner]
   - **Backup storage redundancy:** Locally-redundant (sufficient for lab).
   [Screenshot: Create SQL Database Basics tab fully filled in]
4. Go to the **Networking** tab:
   - **Connectivity method:** Public endpoint.
   - **Firewall rules — Allow Azure services and resources to access this server:** No (leave off for now; you will add a scoped rule next).
   - **Add current client IP address:** Yes. [Screenshot: Networking tab with "Add current client IP address" toggled Yes]
5. Go to **Tags**, add `course` = `cdcs`, and your initials as a `owner` tag. [Screenshot: Tags tab with course=cdcs]
6. Select **Review + create**, confirm the free-offer usage is shown, then **Create**. Wait for deployment to complete (2–5 minutes).
7. Once deployed, select **Go to resource**. On the database **Overview** blade, confirm the **Free offer** badge/usage panel is visible. [Screenshot: SQL Database Overview blade showing free offer usage]

## Part 2 — Connect with Azure Data Studio

1. Open Azure Data Studio (or SSMS).
2. Select **New Connection**.
3. Enter:
   - **Server:** the fully qualified server name from the portal Overview blade, e.g. `sql-<initials>-course.database.windows.net`.
   - **Authentication type:** SQL Login.
   - **User name / Password:** the SQL admin credentials from Part 1, Step 3.
   - **Database:** `PetroleumInventoryDB`.
   [Screenshot: Azure Data Studio New Connection dialog filled in]
4. Select **Connect**. If prompted about your client IP not being allowed, return to the Azure portal → your SQL server → **Networking** → **Add client IP** → **Save**, then retry.
5. Once connected, open a new query window against `PetroleumInventoryDB`.

## Part 3 — Deploy the schema

1. Open `datasets/petroleum_inventory_schema.sql` from this kit in Azure Data Studio (**File > Open File**).
2. Read the header comments — note the normalization design (Facilities, Suppliers, Equipment, StockItems, StockMovements) before running anything.
3. Select **Run** (or F5) to execute the entire script. It will create five tables, two indexes, and seed ~74 rows of oil & gas inventory data (valves, pumps, meters, PPE, spares across Lagos, Port Harcourt, Warri and Kaduna facilities).
4. Verify with the sanity-check queries at the bottom of the script (uncomment and run):
   ```sql
   SELECT COUNT(*) AS FacilityCount FROM dbo.Facilities;      -- expect 10
   SELECT COUNT(*) AS SupplierCount FROM dbo.Suppliers;       -- expect 8
   SELECT COUNT(*) AS EquipmentCount FROM dbo.Equipment;      -- expect 14
   SELECT COUNT(*) AS StockItemCount FROM dbo.StockItems;     -- expect 12
   SELECT COUNT(*) AS MovementCount FROM dbo.StockMovements;  -- expect 30
   ```
   [Screenshot: Query results pane showing all five COUNT results]

## Part 4 — CRUD exercises

Work through each exercise, capturing your query and result set (screenshot or copy/paste into your submission doc).

### 4.1 Create (INSERT)
```sql
-- Add a new depot in Kano (regulator expansion) 
INSERT INTO dbo.Facilities (FacilityCode, FacilityName, FacilityType, City, StateRegion)
VALUES ('FAC-KAN-01', 'Kano Products Depot', 'Depot', 'Kano', 'Kano State');

-- Receive new stock: 20 fire-retardant coveralls delivered to Kano Depot
INSERT INTO dbo.StockMovements (StockItemID, FacilityID, MovementType, Quantity, ReferenceNote, RecordedBy)
SELECT si.StockItemID, f.FacilityID, 'RECEIPT', 20, 'PO-2026-020 SafetyFirst PPE — Kano opening stock', 'your.initials'
FROM dbo.StockItems si, dbo.Facilities f
WHERE si.SKU = 'SKU-PPE-001' AND f.FacilityCode = 'FAC-KAN-01';
```

### 4.2 Read (SELECT)
```sql
-- Q1: List all HIGH-category PPE items and their preferred supplier
SELECT si.SKU, si.ItemName, sup.SupplierName
FROM dbo.StockItems si
JOIN dbo.Suppliers sup ON sup.SupplierID = si.PreferredSupplierID
WHERE si.Category = 'PPE';

-- Q2: Current stock on hand per item at the Warri Products Depot
SELECT si.SKU, si.ItemName, SUM(sm.Quantity) AS QtyOnHand
FROM dbo.StockMovements sm
JOIN dbo.StockItems si ON si.StockItemID = sm.StockItemID
JOIN dbo.Facilities f ON f.FacilityID = sm.FacilityID
WHERE f.FacilityCode = 'FAC-WAR-01'
GROUP BY si.SKU, si.ItemName
ORDER BY si.SKU;

-- Q3: Equipment currently marked Faulty or UnderMaintenance, with facility and city
SELECT e.AssetTag, e.EquipmentName, e.Status, f.FacilityName, f.City
FROM dbo.Equipment e
JOIN dbo.Facilities f ON f.FacilityID = e.FacilityID
WHERE e.Status IN ('Faulty', 'UnderMaintenance');
```

### 4.3 Update (UPDATE)
```sql
-- The PH Export Terminal Isolation Valve maintenance is complete — mark it Operational
UPDATE dbo.Equipment
SET Status = 'Operational', LastInspectionDate = '2026-07-23'
WHERE AssetTag = 'EQ-PHC-0001';

-- Raise the reorder level for gas detectors after a stock-out near-miss
UPDATE dbo.StockItems
SET ReorderLevel = 20
WHERE SKU = 'SKU-PPE-003';
```

### 4.4 Delete (DELETE)
```sql
-- Remove a duplicate/erroneous adjustment movement (example MovementID — check your actual ID first)
SELECT * FROM dbo.StockMovements WHERE ReferenceNote LIKE '%variance correction%';

-- Then delete the specific erroneous row by its real MovementID, e.g.:
-- DELETE FROM dbo.StockMovements WHERE MovementID = 29;
```
> **Why DELETE is used carefully here:** in a regulated environment, deleting transactional history is rarely appropriate — auditors expect a full trail. In real operations, prefer an `ADJUSTMENT` movement (as already modeled in the schema) over deleting historical rows. This DELETE exercise is for lab practice only; discuss this trade-off with your instructor.

## Part 5 — Normalization mini-exercise

Consider this **denormalized** flat table a junior developer proposed instead of the schema you just deployed:

```
StockMovementFlat(MovementID, ItemSKU, ItemName, ItemCategory, SupplierName, SupplierPhone,
                   FacilityName, FacilityCity, MovementType, Quantity, MovementDate)
```

1. Identify at least **three normalization problems** with this flat design (e.g. update anomalies if a supplier's phone number changes; repeating `ItemName`/`ItemCategory` on every movement row; insertion anomaly — you cannot add a new StockItem until its first movement occurs).
2. Map each column in `StockMovementFlat` to the correctly normalized table it belongs in (`StockItems`, `Suppliers`, `Facilities`, or `StockMovements`) using the schema you deployed.
3. Write one sentence explaining why `StockMovements` is the correct "fact"/transaction table and the others are "dimension"/reference tables.

## Expected results / checkpoints
- [ ] `PetroleumInventoryDB` shows the free-offer usage badge in the portal Overview blade.
- [ ] Azure Data Studio successfully connects and lists all 5 tables under `PetroleumInventoryDB > Tables`.
- [ ] Sanity-check counts match (10/8/14/12/30, growing after your INSERTs).
- [ ] All 4.1–4.4 CRUD statements run without error and return expected rows.
- [ ] Normalization mini-exercise answers submitted (3 problems + column mapping + 1-sentence justification).

## Troubleshooting tips
- **"Cannot connect: Client with IP address 'x.x.x.x' is not allowed to access the server"** — go to the SQL server's **Networking** blade in the portal and add your current client IP, then retry the connection.
- **First query after a break is slow / times out** — this is the serverless database **auto-resuming** from an auto-paused state; wait 10–30 seconds and retry.
- **"INSERT fails with FOREIGN KEY constraint conflict"** — you likely referenced a `FacilityID`/`StockItemID`/`SupplierID` that doesn't exist yet; run a `SELECT` on the parent table first to get a valid ID.
- **Free-offer usage exceeded for the month** — the portal will show an "Auto-pause the database until next month" prompt; confirm it rather than upgrading to a paid tier, per the course cost-safety guardrails.

## PostgreSQL alternative note
If practicing on **Azure Database for PostgreSQL Flexible Server** instead (free for 12 months on an Azure free account: 750 hours Burstable B1MS + 32 GB storage + 32 GB backup per month — [PostgreSQL Flexible Server free account guide](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/how-to-deploy-on-azure-free-account)):
- Replace `IDENTITY(1,1)` with `GENERATED ALWAYS AS IDENTITY` or `SERIAL`.
- Replace `NVARCHAR`/`DATETIME2` with `VARCHAR`/`TIMESTAMP`.
- Connect using Azure Data Studio's PostgreSQL extension, or `psql`/pgAdmin.
- CRUD syntax (`INSERT`, `SELECT`, `UPDATE`, `DELETE`) is nearly identical; the normalization exercise concepts are database-agnostic.

## What to submit for grading
1. Screenshot or export of the schema deployment success message and the 5-table sanity-check counts.
2. Your query text and result sets (or screenshots) for all four CRUD exercises (4.1–4.4).
3. Written answers for the normalization mini-exercise (3 problems, column mapping, 1-sentence justification).
4. Confirmation that you disconnected Azure Data Studio/SSMS at the end of the session (cost-safety step).
