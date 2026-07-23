# Day 5 Capstone Project Brief
## Cloud, Database & Cybersecurity Essentials — Integrated IT Fundamentals Training

**Course context:** Oil & gas petroleum regulatory agency, Nigeria (NNPC Ltd / NUPRC / NMDPRA-type environment)
**Duration:** Full Day 5 (approx. 6 working hours + oral defense)
**Mode:** Individual or pairs (instructor's choice), hands-on in Azure

---

## 1. Business Context

You are part of the IT & Digital Transformation unit of a Nigerian upstream/downstream petroleum regulator. The agency is under pressure to modernize its paper- and spreadsheet-based monitoring processes while remaining compliant with the **Nigeria Data Protection Act 2023 (NDPA)** and its predecessor guidance, the **Nigeria Data Protection Regulation (NDPR)**. Regulated entities (licensees, depot operators, marketers, upstream operators) increasingly submit data electronically, and the agency's leadership has mandated that any new system:

- Runs on **Microsoft Azure**, the agency's approved cloud platform.
- Keeps regulated data **auditable, encrypted, and recoverable**.
- Demonstrates **data residency awareness** — even where an Azure Nigeria/local region is not used for the lab, the design must document where data resides and how residency risk is addressed.
- Can be justified to auditors, National Assembly oversight committees, and the agency's Data Protection Officer (DPO).

Your unit has been asked to build and defend a **minimum viable regulatory system** as a proof of concept before a full production rollout.

## 2. Choose Your Scenario (pick ONE)

### Scenario A — Downstream Fuel Distribution Monitoring
A web application that lets depot managers and field inspectors log daily petroleum product (PMS, AGO, DPK) receipts, dispatches, and station-level stock levels, so the regulator (e.g., NMDPRA-style) can monitor supply, detect diversion/hoarding, and flag stock-out risk in real time.

**Minimum functional scope:**
- Login (Entra ID-backed) for depot officer / regulator analyst / admin roles.
- Form to record a distribution entry: depot, product type, volume (litres), destination station, date/time, submitting officer.
- List/detail view of submitted entries, filterable by depot and date.
- Read-only summary view (e.g., total volume per product per day) for the regulator analyst role.

### Scenario B — Crude Oil Production & Royalty Reporting
A web application that lets upstream operators submit monthly crude oil production volumes and calculated royalty figures, so the regulator (e.g., NUPRC-style) can track production against license terms and reconcile royalty obligations.

**Minimum functional scope:**
- Login (Entra ID-backed) for operator submitter / regulator reviewer / admin roles.
- Form to submit a monthly production/royalty record: license/block ID, operator, production volume (bbl), royalty rate, computed royalty due, submission date.
- List/detail view filterable by license and reporting period.
- Read-only aggregate view (e.g., total production and royalty by month) for the regulator reviewer role.

> Keep the app deliberately small. This is a security, cloud, and database architecture exercise — not a software engineering exercise. A single table/entity, one basic CRUD form, and one summary view is sufficient. Use any stack you are comfortable with (e.g., a simple ASP.NET, Node.js, or Python app) hosted on **Azure App Service**.

## 3. Functional Scope Boundaries (what is IN and OUT)

**In scope:**
- One Azure App Service web app (PaaS) with the minimum CRUD/reporting functionality above.
- One Azure SQL Database (managed PaaS database) holding the regulated data.
- Authentication via Microsoft Entra ID; at least two distinct roles with different data access.
- Security controls per the Deliverable Templates (encryption, network protection, monitoring, patching/config).
- A backup and disaster recovery plan for the database (and, at a documentation level, the app tier).

**Out of scope (do not build, but you may mention as "future work"):**
- Multi-region active-active deployment.
- Full CI/CD pipeline (a manual deployment via Visual Studio, VS Code, or `az` CLI/Cloud Shell is fine).
- Mobile apps, offline sync, or integration with third-party systems (e.g., NNPC ERP).
- Advanced analytics/BI dashboards — a simple filtered list/summary view is enough.

## 4. Required Deliverables (exactly 3, plus the oral defense)

You must submit **three artifacts**, using the templates provided in `Capstone_Deliverable_Templates.md`:

1. **Architecture diagram** — shows the cloud resources used (App Service, Azure SQL Database, Entra ID, Key Vault, networking components), the database configuration (tier, redundancy, encryption), and the security boundaries (public internet edge, VNet/Private Endpoint boundary, identity boundary, data boundary). A Mermaid diagram or clearly labeled ASCII/text diagram is acceptable — hand-drawn diagrams photographed and embedded are also fine.
2. **Completed security checklist** — documents each implemented control (or explicitly marked "not implemented — mitigated by X" / "deferred — see Constraints") across identity, network, data protection, monitoring, and patching domains. Must align with the Day 4 checklist categories.
3. **Comprehensive backup & DR plan** — RPO/RTO targets, backup schedule, point-in-time restore (PITR) and geo-restore/failover procedure, a test-restore record, and named roles/responsibilities.

## 5. Technical Requirements Mapping

| Requirement area | Required Azure service / feature | Notes |
|---|---|---|
| Compute (app tier) | **Azure App Service** (PaaS) | Use Free (F1) or Basic (B1) tier for the lab. |
| Managed database | **Azure SQL Database** | Use the free-offer serverless General Purpose tier: up to 10 GP serverless DBs per subscription, 100,000 vCore-seconds compute + 32 GB data + 32 GB backup free per month. Start via "Start free" in the Azure SQL hub (aka.ms/azuresqlhub). ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/azure-sql/database/free-offer)) |
| Identity & access | **Microsoft Entra ID**, RBAC, least privilege | App sign-in via Entra ID; Azure resource access via Azure RBAC role assignments scoped to the resource group; separate roles for submitter vs. reviewer vs. admin. |
| Secrets management | **Azure Key Vault** | Store DB connection string / any app secrets in Key Vault; app reads via managed identity, not hardcoded config. |
| Encryption at rest | **Transparent Data Encryption (TDE)** — on by default for Azure SQL Database; consider **Always Encrypted** for highly sensitive columns (e.g., royalty figures) | Confirm and document TDE status; do not disable it. |
| Encryption in transit | **TLS 1.2+** enforced | Azure SQL Database requires encrypted connections by default; confirm App Service "HTTPS Only" is enabled. |
| Network protection | **NSG** and/or **Private Endpoint** for Azure SQL Database; Azure SQL firewall rules | Minimum: restrict server-level firewall to required IPs/services; document what a Private Endpoint would add if not implemented due to cost tier. |
| Threat protection & posture | **Microsoft Defender for Cloud** / **Defender for SQL** | Enable at subscription or resource level; document any findings and remediation status. |
| Auditing / logging | Azure SQL **Auditing**, diagnostic settings, Entra ID sign-in logs | Enable auditing to a storage account or Log Analytics workspace; this maps directly to NDPA audit-trail obligations. |
| Patching / configuration | **Update Manager** (for any VM component), App Service auto-managed runtime patching | Document patching responsibility split between Microsoft (PaaS platform) and the agency (app code, dependencies). |
| Backup / recovery | Azure SQL **automated backups + PITR**, **geo-restore**, **active geo-replication / failover groups**, Recovery Services vault (if applicable) | See backup plan template. |

## 6. Constraints

- **Cost ceiling:** Use only Free/Basic tiers. Azure SQL Database must use the free-offer serverless configuration; App Service must use F1 or B1. No production-grade (Business Critical, Premium, multi-region) tiers. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/azure-sql/database/free-offer))
- **Time ceiling:** All resources must be created, configured, tested, and screenshotted/documented within the day's lab window.
- **Data residency:** Document which Azure region you deployed to and explicitly discuss the data sovereignty implication for a Nigerian regulator (data leaving Nigeria, contractual/regulatory safeguards, and what would need to change for a production rollout, e.g., data processing agreements, DPO sign-off under NDPA).
- **No real regulated data:** Use synthetic/sample data only — no actual licensee, depot, or operator data.
- **Resource hygiene:** Deploy inside your assigned resource group (`rg-<initials>-course`), tag resources `course=cdcs`. Deallocate/stop compute at end of day; the resource group will be deleted at course end per the course cost-safety guardrails.

## 7. Regulatory Angle — Why This Matters

As a regulator, your agency is both a **data controller** (for the data you collect from licensees) and a **critical infrastructure operator** (fuel supply and crude production monitoring are strategic national functions). Your capstone must show you understand:

- **NDPR / NDPA 2023 compliance posture:** lawful basis for processing, data minimization in your schema, audit trails for who accessed/changed regulatory submissions, and breach-notification readiness (logging/alerting supports this).
- **Data sovereignty:** where the data physically resides, and what residency risk means for a sector regulator handling nationally sensitive energy data.
- **Auditability:** every login, submission, and administrative change must be traceable — this is what auditing, diagnostic logs, and RBAC evidence in your checklist are for.
- **Availability of critical systems:** downstream fuel monitoring and royalty reporting are inputs to national supply and revenue decisions; your backup/DR plan must reflect that downtime and data loss have real regulatory and economic consequences, not just IT inconvenience.

## 8. Timeline for the Day

| Time block | Activity |
|---|---|
| 09:00 – 09:30 | Kickoff briefing; scenario selection (A or B); form pairs if applicable |
| 09:30 – 11:00 | Provision Azure SQL Database (free offer) + App Service; build minimal app CRUD/summary functionality |
| 11:00 – 11:15 | Break |
| 11:15 – 13:00 | Implement security controls (Entra ID sign-in, RBAC, Key Vault, TDE confirmation, TLS/HTTPS Only, firewall/NSG, Defender for Cloud, auditing) |
| 13:00 – 13:45 | Lunch |
| 13:45 – 15:00 | Configure and test backup/PITR; document geo-restore/failover-group procedure; perform a test restore where feasible |
| 15:00 – 16:00 | Assemble the 3 deliverables using the templates; internal peer review (swap with another pair/individual) |
| 16:00 – 16:15 | Break |
| 16:15 – 17:15 | Oral defenses (approx. 10 minutes per learner/pair — see `Oral_Defense_Guide.md`) |
| 17:15 – 17:30 | Wrap-up, course close, resource group teardown reminder |

## 9. Submission Instructions

1. Create a single submission folder named `capstone-<your-initials>` containing:
   - `architecture-diagram.md` (or `.png`/`.pdf` if hand-drawn/exported) — using the template in `Capstone_Deliverable_Templates.md`.
   - `security-checklist.md` — completed, using the template in `Capstone_Deliverable_Templates.md`.
   - `backup-dr-plan.md` — completed, using the template in `Capstone_Deliverable_Templates.md`.
   - A short `evidence/` subfolder with screenshots (Azure portal blades for App Service, SQL Database, Entra ID role assignments, Key Vault, Defender for Cloud, auditing settings, and a completed backup/restore test).
2. Submit the folder to the instructor via the agreed course channel (shared drive/LMS) **before your scheduled oral defense slot**.
3. Be ready to share your screen for the oral defense — you may be asked to show a live Azure portal blade, not just a screenshot.
4. Grading follows `Capstone_Grading_Rubric.md`. A pass requires meeting the minimum threshold defined there.

---
*Sources for verified Azure facts used in this brief: [Azure SQL Database free offer — Microsoft Learn](https://learn.microsoft.com/en-us/azure/azure-sql/database/free-offer); [Azure Database for PostgreSQL Flexible Server free account deployment — Microsoft Learn](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/how-to-deploy-on-azure-free-account); [Microsoft Entra MFA requirement for Azure portal access — Microsoft Tech Community](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/microsoft-entra-id-security-updates-what-organizations-need-to-do-now/4522024); [Conditional Access overview — Microsoft Learn](https://learn.microsoft.com/en-us/entra/identity/conditional-access/).*
