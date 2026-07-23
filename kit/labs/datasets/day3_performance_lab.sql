/* ============================================================================
   DAY 3 PERFORMANCE LAB — Execution Plans, Table Scans & Indexing
   Course: Cloud, Database & Cybersecurity Essentials — Integrated IT Fundamentals
   Target: Azure SQL Database (T-SQL)
   Used in: Lab Day 3 — DBA & Performance

   SCENARIO
   --------
   The regulator's field-inspection system logs every inspection event
   performed across depots and terminals nationwide (crude oil production
   reporting checks, downstream fuel-quality checks, environmental
   compliance checks, pipeline-integrity checks). Over several years this
   table has grown to tens of thousands of rows. A report used by the
   Director of Compliance — "show all HIGH-risk findings at the Warri
   Products Depot in the last 90 days" — has become slow. You will
   reproduce the slowness, diagnose it using the execution plan, and fix it
   with an index.

   HOW TO RUN
   -----------
   Execute this script top-to-bottom in Azure Data Studio / SSMS connected
   to your free-tier Azure SQL Database. Each numbered section corresponds
   to a step in Lab_Day3_DBA_Performance.md. Read the comments — they are
   part of the lab, not just documentation.
   ============================================================================ */

SET NOCOUNT ON;
GO

/* ============================================================================
   STEP 1 — Build a large synthetic table (~12,000 rows) using a tally
   (numbers) approach — no loops needed, which is the efficient, set-based
   way to generate bulk rows in SQL Server / Azure SQL.
   ============================================================================ */

IF OBJECT_ID('dbo.InspectionEvents', 'U') IS NOT NULL DROP TABLE dbo.InspectionEvents;
GO

CREATE TABLE dbo.InspectionEvents (
    InspectionID    INT IDENTITY(1,1) PRIMARY KEY,
    FacilityCode    VARCHAR(15)     NOT NULL,
    FacilityCity    NVARCHAR(60)    NOT NULL,
    InspectionType  VARCHAR(30)     NOT NULL,
    InspectorName   NVARCHAR(80)    NOT NULL,
    InspectionDate  DATETIME2(0)    NOT NULL,
    RiskRating      VARCHAR(10)     NOT NULL,   -- LOW / MEDIUM / HIGH
    FindingsSummary NVARCHAR(400)   NULL,
    ClosedFlag      BIT             NOT NULL DEFAULT 0
);
GO

-- Tally table: generate 12,000 sequential integers using a numbers CTE
-- (cross-joining two 110-row CTEs gives 12,100 rows; TOP trims to exactly 12000).
;WITH L0 AS (SELECT 1 AS c UNION ALL SELECT 1),                                  -- 2
     L1 AS (SELECT 1 AS c FROM L0 A CROSS JOIN L0 B),                           -- 4
     L2 AS (SELECT 1 AS c FROM L1 A CROSS JOIN L1 B),                          -- 16
     L3 AS (SELECT 1 AS c FROM L2 A CROSS JOIN L2 B),                          -- 256
     L4 AS (SELECT 1 AS c FROM L3 A CROSS JOIN L3 B),                          -- 65536
     Nums AS (SELECT TOP (12000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n FROM L4)
INSERT INTO dbo.InspectionEvents (FacilityCode, FacilityCity, InspectionType, InspectorName, InspectionDate, RiskRating, FindingsSummary, ClosedFlag)
SELECT
    fac.FacilityCode,
    fac.FacilityCity,
    itype.InspectionType,
    N'Inspector ' + CAST(1 + (n % 25) AS NVARCHAR(5)),
    DATEADD(DAY, -1 * (n % 1460), '2026-07-23'),           -- spread over ~4 years back from "today"
    CASE (n % 20)
        WHEN 0 THEN 'HIGH'
        WHEN 1 THEN 'HIGH'
        WHEN 2 THEN 'MEDIUM'
        WHEN 3 THEN 'MEDIUM'
        WHEN 4 THEN 'MEDIUM'
        ELSE 'LOW'
    END,
    N'Auto-generated finding record #' + CAST(n AS NVARCHAR(10)) + N' for lab performance testing.',
    CASE WHEN (n % 7) = 0 THEN 0 ELSE 1 END
FROM Nums
CROSS APPLY (
    SELECT CASE (n % 10)
        WHEN 0 THEN 'FAC-LAG-01' WHEN 1 THEN 'FAC-LAG-02' WHEN 2 THEN 'FAC-LAG-03'
        WHEN 3 THEN 'FAC-PHC-01' WHEN 4 THEN 'FAC-PHC-02' WHEN 5 THEN 'FAC-PHC-03'
        WHEN 6 THEN 'FAC-WAR-01' WHEN 7 THEN 'FAC-WAR-02'
        WHEN 8 THEN 'FAC-KAD-01' ELSE 'FAC-KAD-02'
    END AS FacilityCode,
    CASE (n % 10)
        WHEN 0 THEN N'Lagos' WHEN 1 THEN N'Lagos' WHEN 2 THEN N'Lagos'
        WHEN 3 THEN N'Port Harcourt' WHEN 4 THEN N'Port Harcourt' WHEN 5 THEN N'Port Harcourt'
        WHEN 6 THEN N'Warri' WHEN 7 THEN N'Warri'
        WHEN 8 THEN N'Kaduna' ELSE N'Kaduna'
    END AS FacilityCity
) fac
CROSS APPLY (
    SELECT CASE (n % 4)
        WHEN 0 THEN 'CrudeProductionReporting'
        WHEN 1 THEN 'DownstreamFuelQuality'
        WHEN 2 THEN 'EnvironmentalCompliance'
        ELSE 'PipelineIntegrity'
    END AS InspectionType
) itype;
GO

-- Force a handful of guaranteed rows that exactly match our demo query,
-- so the "slow query" always returns a meaningful, non-empty result set
-- regardless of the modulo distribution above.
INSERT INTO dbo.InspectionEvents (FacilityCode, FacilityCity, InspectionType, InspectorName, InspectionDate, RiskRating, FindingsSummary, ClosedFlag)
VALUES
('FAC-WAR-01', N'Warri', 'PipelineIntegrity', N'Inspector 3', DATEADD(DAY, -10, '2026-07-23'), 'HIGH', N'Corrosion detected on outbound valve manifold — escalate to maintenance.', 0),
('FAC-WAR-01', N'Warri', 'EnvironmentalCompliance', N'Inspector 7', DATEADD(DAY, -25, '2026-07-23'), 'HIGH', N'Soil contamination near tank farm perimeter — sample sent to lab.', 0),
('FAC-WAR-01', N'Warri', 'DownstreamFuelQuality', N'Inspector 12', DATEADD(DAY, -40, '2026-07-23'), 'HIGH', N'Off-spec fuel sample flagged at loading bay 2.', 0),
('FAC-WAR-01', N'Warri', 'CrudeProductionReporting', N'Inspector 5', DATEADD(DAY, -60, '2026-07-23'), 'HIGH', N'Metered volume mismatch against manifest — investigate.', 0);
GO

-- Confirm row count
SELECT COUNT(*) AS TotalInspectionRows FROM dbo.InspectionEvents;
GO
-- Expected: 12,004 rows (12,000 generated + 4 guaranteed demo rows)

/* ============================================================================
   STEP 2 — BEFORE: run the "slow" report query and capture the execution plan.

   In Azure Data Studio: click "Explain" (or Query > Explain) before running,
   or enable "Include Actual Execution Plan" (Ctrl+M in SSMS) then execute.

   WHY IT IS SLOW:
   - There is NO index on FacilityCode, RiskRating, or InspectionDate.
   - The table has a PRIMARY KEY (clustered index) on InspectionID only.
   - SQL Server has no way to jump directly to "Warri + HIGH + last 90 days"
     rows, so it must read every single row in the table (a full "Clustered
     Index Scan") and evaluate the WHERE clause row-by-row.
   ============================================================================ */

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- BEFORE: reproduce the Director of Compliance's slow report
SELECT
    InspectionID, FacilityCode, FacilityCity, InspectionType,
    InspectorName, InspectionDate, RiskRating, FindingsSummary
FROM dbo.InspectionEvents
WHERE FacilityCode = 'FAC-WAR-01'
  AND RiskRating = 'HIGH'
  AND InspectionDate >= DATEADD(DAY, -90, '2026-07-23')
ORDER BY InspectionDate DESC;
GO

/* EXPECTED PLAN / STATS (before index) — discuss in class:
   - Operator: "Clustered Index Scan" on PK__Inspecti... (100% of query cost)
   - Estimated/Actual Number of Rows Read: ~12,004 (the whole table)
   - STATISTICS IO: high "logical reads" (roughly one page read per ~/every
     few rows -> hundreds of logical reads for a table this size)
   - STATISTICS TIME: elapsed/CPU time is small at this row count on
     serverless Azure SQL, but the *shape* of the plan (scan, not seek) is
     the same problem that becomes seconds/minutes at production scale
     (millions of rows in a real regulator inspection archive).
   - Cost driver: no supporting index means "look at everything, then filter".
*/

/* ============================================================================
   STEP 3 — DIAGNOSE: identify the scan and the missing index.

   In the graphical plan, hover over the "Clustered Index Scan" icon:
   - "Estimated Number of Rows to be Read" will be close to the full table.
   - The yellow "Predicate" tooltip shows the WHERE clause being evaluated
     per row — this is the signature of "filter after full read", not
     "seek directly to matching rows".
   Azure SQL / SSMS may also surface a green "Missing Index" suggestion
   banner above the plan — read it, but design the index deliberately
   (Step 4) rather than blindly accepting auto-suggestions in production.
   ============================================================================ */

-- Optional: view Azure SQL's own missing-index suggestions for this database
SELECT
    mid.statement                                   AS TableName,
    migs.avg_total_user_cost * migs.avg_user_impact  AS EstimatedBenefit,
    'CREATE INDEX IX_Suggested ON ' + mid.statement +
        ' (' + ISNULL(mid.equality_columns,'') +
        CASE WHEN mid.inequality_columns IS NOT NULL THEN
            (CASE WHEN mid.equality_columns IS NOT NULL THEN ',' ELSE '' END) + mid.inequality_columns
        ELSE '' END + ')' +
        ISNULL(' INCLUDE (' + mid.included_columns + ')', '') AS SuggestedIndexDDL
FROM sys.dm_db_missing_index_details mid
JOIN sys.dm_db_missing_index_groups mig ON mig.index_handle = mid.index_handle
JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
ORDER BY EstimatedBenefit DESC;
GO

/* ============================================================================
   STEP 4 — FIX: create a targeted non-clustered index.

   Column order rationale (equality columns first, then range column last):
     1. FacilityCode  -> equality predicate (=), highly selective
     2. RiskRating    -> equality predicate (=)
     3. InspectionDate-> range predicate (>=), must be last key column
   INCLUDE the columns the SELECT list needs but that aren't in the key,
   so the query becomes fully "covered" by the index (no lookup back to
   the clustered index needed).
   ============================================================================ */

CREATE NONCLUSTERED INDEX IX_InspectionEvents_Facility_Risk_Date
    ON dbo.InspectionEvents (FacilityCode, RiskRating, InspectionDate)
    INCLUDE (FacilityCity, InspectionType, InspectorName, FindingsSummary);
GO

/* ============================================================================
   STEP 5 — AFTER: re-run the identical query and compare.
   ============================================================================ */

SELECT
    InspectionID, FacilityCode, FacilityCity, InspectionType,
    InspectorName, InspectionDate, RiskRating, FindingsSummary
FROM dbo.InspectionEvents
WHERE FacilityCode = 'FAC-WAR-01'
  AND RiskRating = 'HIGH'
  AND InspectionDate >= DATEADD(DAY, -90, '2026-07-23')
ORDER BY InspectionDate DESC;
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

/* EXPECTED PLAN / STATS (after index) — discuss in class:
   - Operator: "Index Seek" on IX_InspectionEvents_Facility_Risk_Date
     (near 0% relative cost) instead of "Clustered Index Scan".
   - Estimated/Actual Number of Rows Read: only the matching rows
     (a handful — the ones for FAC-WAR-01 + HIGH + last 90 days), not 12,004.
   - STATISTICS IO: "logical reads" drops sharply (often single-digit to
     low double-digit pages vs. hundreds before).
   - No "Key Lookup" operator should appear because the INCLUDE columns
     made the index "covering" for this SELECT list — this is the
     before/after teaching moment: Seek + covering index = fast & cheap.

   TALKING POINT FOR THE CLASS:
   In a regulator's production inspection archive (potentially millions of
   rows across years of field inspections nationwide), this exact scan-to-
   seek transformation is the difference between a report that times out
   and one that returns in milliseconds — directly relevant to timely
   regulatory reporting obligations.
*/

/* ============================================================================
   STEP 6 — CLEANUP (cost-safety reminder)
   This table is large; drop it at the end of the lab so it does not count
   against your free-tier 32 GB storage limit, and disconnect Object
   Explorer afterwards so the serverless database can auto-pause.
   ============================================================================ */

-- DROP INDEX IX_InspectionEvents_Facility_Risk_Date ON dbo.InspectionEvents;
-- DROP TABLE dbo.InspectionEvents;

/* ============================================================================
   POSTGRESQL ALTERNATIVE NOTE
   ----------------------------
   - Use `generate_series(1, 12000)` instead of the tally-CTE trick to
     generate rows.
   - Use `EXPLAIN (ANALYZE, BUFFERS)` instead of "Include Actual Execution
     Plan" / STATISTICS IO — look for "Seq Scan" (before) vs. "Index Scan"
     or "Bitmap Heap Scan" (after).
   - `CREATE INDEX ix_name ON inspection_events (facility_code, risk_rating,
     inspection_date) INCLUDE (facility_city, inspection_type,
     inspector_name, findings_summary);` — PostgreSQL 11+ supports INCLUDE
     the same way.
   ============================================================================ */
