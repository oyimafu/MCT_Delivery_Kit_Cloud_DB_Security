# MCT Delivery Kit — Cloud, Database & Cybersecurity Essentials
### Integrated IT Fundamentals Training · 5 days / 40 hours · Delivered on Microsoft Azure
**Audience:** IT staff at a Nigerian petroleum regulatory agency (NNPC Ltd / NUPRC / NMDPRA-type environment)

---

## 1. How to go about this training — the short version

You are delivering a **fixed 5-day curriculum** (per the brochure) but running **all labs and the capstone on Microsoft Azure**, framed for a petroleum-regulator audience. Success rests on three things, in order of importance:

1. **Facilitation and lab logistics** — 40 hours is mostly hands-on. If the Azure environment and datasets are ready, the course runs itself. If they are not, no amount of subject knowledge will save the day. Do the pre-course setup first.
2. **Integrated storytelling** — the whole point is showing how cloud + database + security work *together*. Keep returning to one running example (the regulator's inventory / reporting system) so the capstone feels inevitable, not bolted on.
3. **Regulator relevance** — every checklist and decision should map to a real duty: data sovereignty, NDPR/NDPA, auditability, least privilege, and availability of critical systems.

**Your delivery sequence:**
- **2–3 weeks out:** read the Facilitation Plan end-to-end; complete the master pre-course checklist; provision Azure; test every lab yourself.
- **Night before each day:** run that day's prep checklist; pre-create resources; confirm connectivity.
- **Each day:** recap → teach with live Azure demos → hands-on lab (the core) → check-for-understanding → wrap tying back to the capstone.
- **Day 5:** learners build the capstone, submit 3 deliverables, and give a short oral defense graded on the rubric.

---

## 2. What's in this kit

| # | File | Use it to… |
|---|------|-----------|
| 1 | **`01_Facilitation_Plan.md`** | Your instructor playbook: minute-by-minute schedules for all 5 days, teaching talking points with regulator analogies, per-day prep checklists, engagement tactics, contingency/troubleshooting, and a facilitator confidence primer. **Read this first.** |
| 2 | **`slides/Cloud_DB_Security_Essentials_Course_Deck.pptx`** | The full course deck (51 slides, Pluralsight-standard): module dividers, "in this module" agendas, concept slides, comparison tables, demo walkthroughs, code slides, knowledge-check and summary slides for all 5 days. |
| 2b | **`Implementation_Handbook.pdf`** | **Step-by-step implementation handbook (PDF).** A user-friendly companion to these .md files that walks you through implementing *everything* in the repo end to end — prerequisites & setup, all 5 days, the capstone, an instructor delivery guide, troubleshooting/FAQ, and a cost-cleanup + glossary appendix. |
| 3 | **`labs/Lab_Day1_Cloud_Service_Selection.md`** | Day 1 lab: cloud service-selection case study + fillable decision matrix + instructor model answer. |
| 4 | **`labs/Lab_Day2_Database_Fundamentals_CRUD.md`** | Day 2 lab: create a free Azure SQL Database, build the petroleum inventory schema, run CRUD + a normalization exercise. |
| 5 | **`labs/Lab_Day3_DBA_Performance.md`** | Day 3 lab: execution-plan analysis, fix a slow query with an index, plus backup/PITR + geo-replication walkthrough. |
| 6 | **`labs/Lab_Day4_Security_Hardening.md`** | Day 4 lab: harden the database (Entra ID/RBAC, TDE, TLS, firewall/Private Endpoint, Defender for SQL, auditing) + complete the checklist. |
| 7 | **`labs/datasets/petroleum_inventory_schema.sql`** | T-SQL: 5-table normalized inventory schema + 74 seed rows (Lagos, Port Harcourt, Warri, Kaduna). Used Day 2 & Day 4. |
| 8 | **`labs/datasets/petroleum_inventory_seed.csv`** | CSV version of the movement/stock data for import exercises. |
| 9 | **`labs/datasets/day3_performance_lab.sql`** | T-SQL: builds a ~12,000-row table with a deliberately slow query and the index fix. Used Day 3. |
| 10 | **`labs/datasets/day4_security_checklist.md`** | Reusable 24-control Azure security hardening checklist (Control / Applies to / Implemented / Evidence). Used Day 4 & the capstone. |
| 11 | **`capstone/Capstone_Project_Brief.md`** | Day 5 capstone brief: scenario, functional scope, the 3 required deliverables, Azure service mapping, constraints, timeline, submission. |
| 12 | **`capstone/Capstone_Deliverable_Templates.md`** | Fill-in templates: architecture diagram (component table + ASCII + Mermaid), security checklist, and backup/DR plan. |
| 13 | **`capstone/Capstone_Grading_Rubric.md`** | 100-point weighted rubric with 4 performance levels per criterion + instructor scoring sheet + pass threshold. |
| 14 | **`capstone/Oral_Defense_Guide.md`** | How to run the 10-minute oral defense + 15 probing questions with model-answer guidance + scoring. |

---

## 3. Azure environment — set this up before anything else

**Databases (labs run on the free tier):**
- **Azure SQL Database (free offer)** — up to 10 General Purpose serverless databases per subscription, each with 100,000 vCore-seconds compute + 32 GB data + 32 GB backup free every month, for the life of the subscription. Start via the Azure SQL hub. This is the primary DB for all labs. [Microsoft Learn — free offer](https://learn.microsoft.com/en-us/azure/azure-sql/database/free-offer)
- **Azure Database for PostgreSQL Flexible Server** — offered as the alternative track: 750 hours Burstable B1MS + 32 GB storage + 32 GB backup free for 12 months on an Azure free account. [Microsoft Learn — PostgreSQL free account](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/how-to-deploy-on-azure-free-account)

**Tools:** Azure Data Studio (recommended) or SQL Server Management Studio; the Azure portal; optionally Azure CLI / Cloud Shell.

**Security services used across Days 4–5:** Microsoft Entra ID (RBAC, MFA, Conditional Access), Azure Key Vault, Transparent Data Encryption (TDE), TLS 1.2+, Microsoft Defender for Cloud / Defender for SQL, Network Security Groups + Private Endpoints, Azure Policy, auditing/diagnostic logs.

**Identity note to raise on Day 4:** from **1 October 2026, Microsoft requires MFA for all Azure portal access** (including Global Admins) — align the agency's admin accounts now. [Microsoft Entra security updates](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/microsoft-entra-id-security-updates-what-organizations-need-to-do-now/4522024)

---

## 4. Cost-safety guardrails (tell learners on Day 1, enforce daily)

- Use the **free-offer Azure SQL Database**; set *"Auto-pause the database until next month"* when the free limit is reached.
- **Stop/deallocate** VMs and App Service plans at the end of each day.
- **One resource group per learner**, named `rg-<initials>-course`, tag everything `course=cdcs`.
- **Disconnect** Azure Data Studio / SSMS Object Explorer when idle so serverless auto-pauses.
- **Delete the resource group** at the end of the course.

---

## 5. Contingency (Lagos connectivity / Azure quota)
If Azure is slow, learners can't create resources, or connectivity drops, the Facilitation Plan includes a **local SQL Server / PostgreSQL Docker fallback** so labs still run offline. Have it downloaded before Day 1.

---

*Prepared as a Microsoft Certified Trainer (MCT) delivery kit. All Azure facts carry inline source links to Microsoft Learn / Microsoft Tech Community.*
