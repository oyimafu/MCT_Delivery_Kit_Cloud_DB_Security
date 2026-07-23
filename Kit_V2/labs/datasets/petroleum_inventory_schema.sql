/* ============================================================================
   PETROLEUM REGULATOR INVENTORY & ASSET DATABASE
   Course: Cloud, Database & Cybersecurity Essentials — Integrated IT Fundamentals
   Target: Azure SQL Database (T-SQL)
   Used in: Lab Day 2 (schema build + CRUD), Lab Day 4 (security hardening)

   SCENARIO
   --------
   A Nigerian downstream/midstream petroleum regulator (modelled on an
   NMDPRA/NUPRC-type agency) tracks regulated assets and consumable stock
   across its depots, terminals and field offices in Lagos, Port Harcourt,
   Warri and Kaduna: pipeline valves, pumps, flow meters, PPE and spare
   parts used by field inspection and pipeline-integrity teams.

   NORMALIZATION NOTE (3NF)
   -------------------------
   - Facilities   : one row per depot/terminal/office (location entity)
   - Suppliers    : one row per vendor (supplier entity)
   - Equipment    : regulator-owned/monitored assets, each tied to one Facility
   - StockItems   : catalogue of consumable/spare-part SKUs (item master),
                    each tied to one preferred Supplier (no repeating groups,
                    no derived/duplicated facility or supplier text fields)
   - StockMovements: transactional ledger of receipts/issues/transfers,
                    referencing StockItem + Facility (+ optional Equipment)
                    -> this is the fact table; quantity-on-hand is DERIVED
                    from this ledger, never stored redundantly.

   Run this script in Azure Data Studio or SSMS against your free-tier
   Azure SQL Database (see Lab Day 2, Step 3). Uses IDENTITY, not sequences,
   to keep the script portable and simple for classroom use.
   ============================================================================ */

SET NOCOUNT ON;
GO

/* ---------- Clean slate (safe re-run for labs) ---------- */
IF OBJECT_ID('dbo.StockMovements', 'U') IS NOT NULL DROP TABLE dbo.StockMovements;
IF OBJECT_ID('dbo.StockItems', 'U')      IS NOT NULL DROP TABLE dbo.StockItems;
IF OBJECT_ID('dbo.Equipment', 'U')       IS NOT NULL DROP TABLE dbo.Equipment;
IF OBJECT_ID('dbo.Suppliers', 'U')       IS NOT NULL DROP TABLE dbo.Suppliers;
IF OBJECT_ID('dbo.Facilities', 'U')      IS NOT NULL DROP TABLE dbo.Facilities;
GO

/* ============================================================================
   TABLE: Facilities
   Depots / terminals / field offices operated or monitored by the regulator.
   ============================================================================ */
CREATE TABLE dbo.Facilities (
    FacilityID      INT IDENTITY(1,1) PRIMARY KEY,
    FacilityCode    VARCHAR(15)     NOT NULL,
    FacilityName    NVARCHAR(120)   NOT NULL,
    FacilityType    VARCHAR(30)     NOT NULL
        CONSTRAINT CK_Facilities_Type CHECK (FacilityType IN
            ('Depot','Terminal','FieldOffice','PumpStation','Refinery')),
    City            NVARCHAR(60)    NOT NULL,
    StateRegion     NVARCHAR(60)    NOT NULL,
    Country         NVARCHAR(60)    NOT NULL DEFAULT 'Nigeria',
    IsActive        BIT             NOT NULL DEFAULT 1,
    CreatedAtUtc    DATETIME2(0)    NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_Facilities_Code UNIQUE (FacilityCode)
);
GO

/* ============================================================================
   TABLE: Suppliers
   Vendors approved to supply spare parts, PPE and metering equipment.
   ============================================================================ */
CREATE TABLE dbo.Suppliers (
    SupplierID      INT IDENTITY(1,1) PRIMARY KEY,
    SupplierCode    VARCHAR(15)     NOT NULL,
    SupplierName    NVARCHAR(150)   NOT NULL,
    ContactEmail    NVARCHAR(150)   NULL,
    ContactPhone    VARCHAR(20)     NULL,
    City            NVARCHAR(60)    NULL,
    Country         NVARCHAR(60)    NOT NULL DEFAULT 'Nigeria',
    IsApproved      BIT             NOT NULL DEFAULT 1,
    CreatedAtUtc    DATETIME2(0)    NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_Suppliers_Code UNIQUE (SupplierCode)
);
GO

/* ============================================================================
   TABLE: Equipment
   Regulated / monitored assets physically located at a Facility
   (pipeline valves, pumps, flow meters, tanks).
   ============================================================================ */
CREATE TABLE dbo.Equipment (
    EquipmentID     INT IDENTITY(1,1) PRIMARY KEY,
    AssetTag        VARCHAR(20)     NOT NULL,
    EquipmentName   NVARCHAR(120)   NOT NULL,
    EquipmentType   VARCHAR(30)     NOT NULL
        CONSTRAINT CK_Equipment_Type CHECK (EquipmentType IN
            ('PipelineValve','Pump','FlowMeter','StorageTank','PressureGauge','Compressor')),
    FacilityID      INT             NOT NULL,
    InstalledDate   DATE            NULL,
    Status          VARCHAR(20)     NOT NULL DEFAULT 'Operational'
        CONSTRAINT CK_Equipment_Status CHECK (Status IN
            ('Operational','UnderMaintenance','Decommissioned','Faulty')),
    LastInspectionDate DATE         NULL,
    CreatedAtUtc    DATETIME2(0)    NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_Equipment_AssetTag UNIQUE (AssetTag),
    CONSTRAINT FK_Equipment_Facility FOREIGN KEY (FacilityID)
        REFERENCES dbo.Facilities (FacilityID)
);
GO

/* ============================================================================
   TABLE: StockItems
   Item master / catalogue for consumables and spare parts (not equipment
   itself). Each item has one preferred supplier and a reorder threshold.
   ============================================================================ */
CREATE TABLE dbo.StockItems (
    StockItemID     INT IDENTITY(1,1) PRIMARY KEY,
    SKU             VARCHAR(20)     NOT NULL,
    ItemName        NVARCHAR(150)   NOT NULL,
    Category        VARCHAR(30)     NOT NULL
        CONSTRAINT CK_StockItems_Category CHECK (Category IN
            ('Valve','Pump','Meter','PPE','SparePart','Tool','Consumable')),
    UnitOfMeasure   VARCHAR(15)     NOT NULL DEFAULT 'EACH',
    ReorderLevel    INT             NOT NULL DEFAULT 5,
    UnitCostNGN     DECIMAL(12,2)   NOT NULL DEFAULT 0,
    PreferredSupplierID INT         NULL,
    IsActive        BIT             NOT NULL DEFAULT 1,
    CreatedAtUtc    DATETIME2(0)    NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_StockItems_SKU UNIQUE (SKU),
    CONSTRAINT FK_StockItems_Supplier FOREIGN KEY (PreferredSupplierID)
        REFERENCES dbo.Suppliers (SupplierID)
);
GO

/* ============================================================================
   TABLE: StockMovements
   Transactional ledger: every receipt, issue, or transfer of a StockItem
   at a Facility. Quantity-on-hand = SUM(SignedQuantity) per item/facility
   (derived at query time — see Lab Day 2 CRUD exercises).
   ============================================================================ */
CREATE TABLE dbo.StockMovements (
    MovementID      INT IDENTITY(1,1) PRIMARY KEY,
    StockItemID     INT             NOT NULL,
    FacilityID      INT             NOT NULL,
    EquipmentID     INT             NULL,        -- optional: part issued against a specific asset
    MovementType    VARCHAR(15)     NOT NULL
        CONSTRAINT CK_StockMovements_Type CHECK (MovementType IN
            ('RECEIPT','ISSUE','TRANSFER_IN','TRANSFER_OUT','ADJUSTMENT')),
    Quantity        INT             NOT NULL
        CONSTRAINT CK_StockMovements_Qty CHECK (Quantity <> 0),
    MovementDate    DATETIME2(0)    NOT NULL DEFAULT SYSUTCDATETIME(),
    ReferenceNote   NVARCHAR(200)   NULL,
    RecordedBy      NVARCHAR(80)    NOT NULL DEFAULT 'system',
    CONSTRAINT FK_StockMovements_Item FOREIGN KEY (StockItemID)
        REFERENCES dbo.StockItems (StockItemID),
    CONSTRAINT FK_StockMovements_Facility FOREIGN KEY (FacilityID)
        REFERENCES dbo.Facilities (FacilityID),
    CONSTRAINT FK_StockMovements_Equipment FOREIGN KEY (EquipmentID)
        REFERENCES dbo.Equipment (EquipmentID)
);
GO

/* ---------- Indexes (Lab Day 2/3 discussion) ---------- */
-- Speeds up "stock on hand per item" and "movement history per facility" queries
CREATE INDEX IX_StockMovements_Item_Facility
    ON dbo.StockMovements (StockItemID, FacilityID) INCLUDE (Quantity, MovementType);

-- Speeds up date-range reporting for auditors (e.g. "movements last quarter")
CREATE INDEX IX_StockMovements_MovementDate
    ON dbo.StockMovements (MovementDate);
GO

/* ============================================================================
   SEED DATA
   ============================================================================ */

-- Facilities (10 rows) — Lagos, Port Harcourt, Warri, Kaduna
INSERT INTO dbo.Facilities (FacilityCode, FacilityName, FacilityType, City, StateRegion) VALUES
('FAC-LAG-01','Apapa Products Depot','Depot','Lagos','Lagos State'),
('FAC-LAG-02','Ijegun Terminal','Terminal','Lagos','Lagos State'),
('FAC-LAG-03','Lagos Field Inspection Office','FieldOffice','Lagos','Lagos State'),
('FAC-PHC-01','Port Harcourt Export Terminal','Terminal','Port Harcourt','Rivers State'),
('FAC-PHC-02','Trans-Niger Pump Station 2','PumpStation','Port Harcourt','Rivers State'),
('FAC-PHC-03','Port Harcourt Refinery Liaison Office','FieldOffice','Port Harcourt','Rivers State'),
('FAC-WAR-01','Warri Products Depot','Depot','Warri','Delta State'),
('FAC-WAR-02','Warri Refinery Pump Station','PumpStation','Warri','Delta State'),
('FAC-KAD-01','Kaduna Refinery Depot','Depot','Kaduna','Kaduna State'),
('FAC-KAD-02','Kaduna Field Inspection Office','FieldOffice','Kaduna','Kaduna State');
GO

-- Suppliers (8 rows)
INSERT INTO dbo.Suppliers (SupplierCode, SupplierName, ContactEmail, ContactPhone, City) VALUES
('SUP-001','Niger Valve & Fittings Ltd','sales@nigervalve.ng','+234-1-555-0101','Lagos'),
('SUP-002','Delta Pumps Engineering','info@deltapumps.ng','+234-53-555-0102','Warri'),
('SUP-003','PH Metering Systems Co','contact@phmetering.ng','+234-84-555-0103','Port Harcourt'),
('SUP-004','SafetyFirst PPE Nigeria','orders@safetyfirst.ng','+234-1-555-0104','Lagos'),
('SUP-005','Kaduna Industrial Supplies','sales@kadindustrial.ng','+234-62-555-0105','Kaduna'),
('SUP-006','Trans-Niger Spare Parts Ltd','info@transnigerparts.ng','+234-84-555-0106','Port Harcourt'),
('SUP-007','Apapa Tools & Hardware','sales@apapatools.ng','+234-1-555-0107','Lagos'),
('SUP-008','Northern Compressor Services','contact@northcompressor.ng','+234-62-555-0108','Kaduna');
GO

-- Equipment (14 rows) across facilities
INSERT INTO dbo.Equipment (AssetTag, EquipmentName, EquipmentType, FacilityID, InstalledDate, Status, LastInspectionDate) VALUES
('EQ-LAG-0001','Apapa Manifold Gate Valve 12in','PipelineValve',1,'2019-03-14','Operational','2026-05-02'),
('EQ-LAG-0002','Apapa Transfer Pump A','Pump',1,'2020-06-01','Operational','2026-04-20'),
('EQ-LAG-0003','Ijegun Custody Transfer Meter 1','FlowMeter',2,'2018-11-11','Operational','2026-03-15'),
('EQ-LAG-0004','Ijegun Storage Tank 3','StorageTank',2,'2015-01-20','Operational','2026-02-28'),
('EQ-PHC-0001','PH Export Terminal Isolation Valve','PipelineValve',4,'2017-09-09','UnderMaintenance','2026-06-10'),
('EQ-PHC-0002','Trans-Niger Booster Pump 2','Pump',5,'2016-05-05','Operational','2026-05-18'),
('EQ-PHC-0003','Trans-Niger Line Pressure Gauge','PressureGauge',5,'2021-02-02','Operational','2026-06-01'),
('EQ-PHC-0004','PH Export Custody Meter 2','FlowMeter',4,'2019-07-07','Faulty','2026-06-20'),
('EQ-WAR-0001','Warri Depot Gate Valve 8in','PipelineValve',7,'2018-08-08','Operational','2026-04-05'),
('EQ-WAR-0002','Warri Refinery Feed Pump','Pump',8,'2014-12-01','Operational','2026-03-30'),
('EQ-WAR-0003','Warri Depot Storage Tank 1','StorageTank',7,'2013-04-17','Operational','2026-01-22'),
('EQ-KAD-0001','Kaduna Depot Transfer Meter','FlowMeter',9,'2020-10-10','Operational','2026-05-29'),
('EQ-KAD-0002','Kaduna Depot Compressor Unit','Compressor',9,'2017-03-03','Operational','2026-02-14'),
('EQ-KAD-0003','Kaduna Pipeline Check Valve','PipelineValve',9,'2019-01-01','Decommissioned','2025-12-01');
GO

-- StockItems (12 rows) — valves, pumps, meters, PPE, spares
INSERT INTO dbo.StockItems (SKU, ItemName, Category, UnitOfMeasure, ReorderLevel, UnitCostNGN, PreferredSupplierID) VALUES
('SKU-VLV-001','Gate Valve 8in Cast Steel','Valve','EACH',3,485000.00,1),
('SKU-VLV-002','Ball Valve 4in Stainless','Valve','EACH',5,215000.00,1),
('SKU-PMP-001','Centrifugal Pump Seal Kit','SparePart','EACH',10,42000.00,2),
('SKU-PMP-002','Booster Pump Impeller','SparePart','EACH',6,96000.00,2),
('SKU-MTR-001','Custody Transfer Flow Meter 6in','Meter','EACH',2,3200000.00,3),
('SKU-MTR-002','Pressure Gauge 0-100 bar','Meter','EACH',15,18500.00,3),
('SKU-PPE-001','Fire-Retardant Coverall (L)','PPE','EACH',40,12500.00,4),
('SKU-PPE-002','Safety Helmet with Chin Strap','PPE','EACH',50,6500.00,4),
('SKU-PPE-003','Gas Detector Handheld Unit','PPE','EACH',12,145000.00,4),
('SKU-SPR-001','Pipeline Flange Gasket Set','SparePart','SET',25,8500.00,6),
('SKU-TL-001','Torque Wrench Heavy Duty','Tool','EACH',8,65000.00,7),
('SKU-CMP-001','Compressor Air Filter Element','Consumable','EACH',20,9800.00,8);
GO

-- StockMovements (30 rows) — receipts and issues over recent months
INSERT INTO dbo.StockMovements (StockItemID, FacilityID, EquipmentID, MovementType, Quantity, MovementDate, ReferenceNote, RecordedBy) VALUES
(1, 1, 1, 'RECEIPT', 10, '2026-01-10 09:00:00', 'PO-2026-001 Niger Valve & Fittings', 'a.okoro'),
(1, 1, 1, 'ISSUE',   -2, '2026-02-05 11:30:00', 'Replacement on Apapa Manifold Gate Valve', 'a.okoro'),
(2, 4, NULL,'RECEIPT', 15, '2026-01-12 10:00:00', 'PO-2026-002 Niger Valve & Fittings', 'c.eze'),
(2, 4, 5,   'ISSUE',   -3, '2026-03-01 14:00:00', 'PH Export Isolation Valve maintenance', 'c.eze'),
(3, 5, 6,   'RECEIPT', 20, '2026-01-15 08:45:00', 'PO-2026-003 Delta Pumps Engineering', 'b.ibrahim'),
(3, 5, 6,   'ISSUE',   -4, '2026-02-20 13:10:00', 'Booster Pump 2 seal replacement', 'b.ibrahim'),
(4, 8, 10,  'RECEIPT', 12, '2026-01-18 09:20:00', 'PO-2026-004 Delta Pumps Engineering', 'o.tolu'),
(4, 8, 10,  'ISSUE',   -2, '2026-03-10 15:00:00', 'Warri Refinery Feed Pump overhaul', 'o.tolu'),
(5, 2, 3,   'RECEIPT', 3,  '2026-01-20 10:00:00', 'PO-2026-005 PH Metering Systems', 'n.chukwu'),
(5, 9, 12,  'TRANSFER_IN', 1, '2026-04-02 09:00:00', 'Transferred from Ijegun Terminal', 'n.chukwu'),
(5, 2, 3,   'TRANSFER_OUT', -1, '2026-04-02 09:00:00', 'Transferred to Kaduna Depot', 'n.chukwu'),
(6, 5, 7,   'RECEIPT', 25, '2026-01-22 11:00:00', 'PO-2026-006 PH Metering Systems', 'b.ibrahim'),
(6, 5, 7,   'ISSUE',   -5, '2026-05-01 10:30:00', 'Gauge calibration replacement batch', 'b.ibrahim'),
(7, 1, NULL,'RECEIPT', 100,'2026-02-01 09:00:00', 'PO-2026-007 SafetyFirst PPE', 'a.okoro'),
(7, 1, NULL,'ISSUE',   -30,'2026-02-15 08:00:00', 'Field team quarterly PPE issue', 'a.okoro'),
(7, 4, NULL,'RECEIPT', 80, '2026-02-03 09:00:00', 'PO-2026-008 SafetyFirst PPE', 'c.eze'),
(8, 1, NULL,'RECEIPT', 120,'2026-02-01 09:10:00', 'PO-2026-007 SafetyFirst PPE', 'a.okoro'),
(8, 1, NULL,'ISSUE',   -40,'2026-02-15 08:05:00', 'Field team quarterly PPE issue', 'a.okoro'),
(9, 3, NULL,'RECEIPT', 15, '2026-02-10 09:00:00', 'PO-2026-009 SafetyFirst PPE gas detectors', 'd.musa'),
(9, 6, NULL,'RECEIPT', 10, '2026-02-11 09:00:00', 'PO-2026-010 SafetyFirst PPE gas detectors', 'e.wachukwu'),
(9, 3, NULL,'ISSUE',   -4, '2026-03-05 10:00:00', 'Inspection team field kits', 'd.musa'),
(10,7, NULL,'RECEIPT', 60, '2026-02-14 09:00:00', 'PO-2026-011 Trans-Niger Spare Parts', 'o.tolu'),
(10,7, 9,   'ISSUE',   -10,'2026-03-20 13:00:00', 'Warri Depot Gate Valve flange reseal', 'o.tolu'),
(10,4, 4,   'ISSUE',   -8, '2026-04-10 13:00:00', 'PH Export custody meter reseal', 'c.eze'),
(11,1, NULL,'RECEIPT', 12, '2026-02-16 09:00:00', 'PO-2026-012 Apapa Tools & Hardware', 'a.okoro'),
(11,9, NULL,'RECEIPT', 6,  '2026-02-18 09:00:00', 'PO-2026-013 Apapa Tools & Hardware', 'n.chukwu'),
(12,9, 13,  'RECEIPT', 30, '2026-02-20 09:00:00', 'PO-2026-014 Northern Compressor Services', 'n.chukwu'),
(12,9, 13,  'ISSUE',   -6, '2026-05-05 11:00:00', 'Compressor filter service Kaduna Depot', 'n.chukwu'),
(2, 7, NULL,'ADJUSTMENT', -1, '2026-05-15 09:00:00', 'Stock count variance correction', 'o.tolu'),
(6, 9, NULL,'ADJUSTMENT', 2,  '2026-05-16 09:00:00', 'Stock count variance correction', 'n.chukwu');
GO

/* ---------- Quick sanity checks (run after seeding) ---------- */
-- SELECT COUNT(*) AS FacilityCount FROM dbo.Facilities;      -- expect 10
-- SELECT COUNT(*) AS SupplierCount FROM dbo.Suppliers;       -- expect 8
-- SELECT COUNT(*) AS EquipmentCount FROM dbo.Equipment;      -- expect 14
-- SELECT COUNT(*) AS StockItemCount FROM dbo.StockItems;     -- expect 12
-- SELECT COUNT(*) AS MovementCount FROM dbo.StockMovements;  -- expect 30

/* ---------- Example derived stock-on-hand query (used in Lab Day 2) ---------- */
-- SELECT si.SKU, si.ItemName, f.FacilityName, SUM(sm.Quantity) AS QtyOnHand
-- FROM dbo.StockMovements sm
-- JOIN dbo.StockItems si ON si.StockItemID = sm.StockItemID
-- JOIN dbo.Facilities f  ON f.FacilityID  = sm.FacilityID
-- GROUP BY si.SKU, si.ItemName, f.FacilityName
-- ORDER BY si.SKU, f.FacilityName;
