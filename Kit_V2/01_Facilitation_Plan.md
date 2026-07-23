# Facilitation Plan
## Cloud, Database & Cybersecurity Essentials — Integrated IT Fundamentals Training
**MCT Instructor Playbook | 5 Days / 40 Hours | Azure-Standardized Labs**

**Audience:** IT staff at a Nigerian petroleum/oil & gas regulatory agency (NNPC Ltd / NUPRC / NMDPRA-type environment) — a mix of system administrators, DBAs, DevOps engineers, and technical managers. Intermediate IT level, mixed cloud maturity, SQL helpful but not mandatory.

**How to use this document:** This is the instructor's operational playbook, distinct from the slide deck and lab guides. It contains the minute-by-minute run sheet, talking points, misconceptions to preempt, prep checklists, and contingency plans for every day. Read the day's section the night before delivery.

---

## Table of Contents
1. [Before the Course — Master Prep Checklist](#before-the-course--master-prep-checklist)
2. [Room, Logistics & Remote-Attendee Setup](#room-logistics--remote-attendee-setup)
3. [Day 1 — Cloud Fundamentals Recap](#day-1--cloud-fundamentals-recap)
4. [Day 2 — Database Fundamentals](#day-2--database-fundamentals)
5. [Day 3 — Database Administration & Performance](#day-3--database-administration--performance)
6. [Day 4 — Cybersecurity Essentials](#day-4--cybersecurity-essentials)
7. [Day 5 — Integrated Lab & Capstone](#day-5--integrated-lab--capstone)
8. [Assessment Cadence](#assessment-cadence)
9. [Contingency & Troubleshooting](#contingency--troubleshooting)
10. [Facilitator Confidence Primer](#facilitator-confidence-primer)

---

## Before the Course — Master Prep Checklist

Complete this checklist **5–7 business days** before Day 1, with a final pass the night before.

### Azure subscription & account setup
- [ ] Confirm whether learners bring **individual Azure free accounts** or use a **shared training subscription** provisioned by the agency's IT/procurement. Prefer individual free accounts — free-offer quotas (Azure SQL DB free offer, PostgreSQL Flexible Server free tier) are per-subscription, so shared subscriptions exhaust quota fast with 10+ learners.
- [ ] Each learner creates (or is issued) an Azure account **before Day 1** via "Start free" in the Azure SQL hub — [aka.ms/azuresqlhub](https://aka.ms/azuresqlhub) — or the general Azure free account signup. Confirm the free-offer terms: up to **10 General Purpose serverless Azure SQL databases per subscription**, **100,000 vCore-seconds compute + 32 GB data + 32 GB backup storage free per month, for the life of the subscription** ([Microsoft Learn — Azure SQL free offer](https://learn.microsoft.com/en-us/azure/azure-sql/database/free-offer)).
- [ ] Confirm PostgreSQL alternative-track quota for anyone who prefers it: **Azure Database for PostgreSQL Flexible Server — free for 12 months on an Azure free account, 750 hours of Burstable B1MS compute + 32 GB storage + 32 GB backup per month** ([Microsoft Learn — Deploy PostgreSQL Flexible Server on Azure free account](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/how-to-deploy-on-azure-free-account)).
- [ ] Verify each learner has a **valid phone number/email for verification** and (if using a corporate tenant) that Global Admin has pre-approved external Azure free-tier signups — regulator IT security policies sometimes block self-service cloud signups.
- [ ] Collect learner initials/usernames in advance to pre-build the **resource-group naming roster** (see below).
- [ ] Send a **pre-course email** 3 days out with: signup instructions, tool downloads, hardware/network requirements, and the Day 1 agenda.

### Resource group & tagging convention (enforce from Day 1)
- [ ] Each learner uses **one shared resource group for the whole course**: `rg-<initials>-course` (e.g., `rg-cae-course` for Chidi A. Eze).
- [ ] All resources tagged `course=cdcs` (Cloud, Database & Cybersecurity) for easy identification and cleanup.
- [ ] Print/share a roster mapping learner name → initials → resource group name → subscription type (individual free / shared). Keep this roster visible in your instructor notes for quick troubleshooting lookups.

### Tools install (test on a clean machine, not just your own laptop)
- [ ] **Azure Data Studio** — primary recommended client (lightweight, cross-platform, good for the Linux/Mac users likely on a mixed sysadmin team).
- [ ] **SQL Server Management Studio (SSMS)** — offer as the Windows-only alternative for DBAs who already know it.
- [ ] Modern browser (Edge or Chrome) for the Azure portal — confirm no corporate proxy blocks `portal.azure.com`, `*.database.windows.net`, or `*.postgres.database.azure.com`.
- [ ] Optional: **Azure CLI** and/or **Cloud Shell** access for learners comfortable with command line (offer, don't require).
- [ ] Confirm each learner's laptop firewall allows outbound **TCP 1433** (Azure SQL) and **TCP 5432** (PostgreSQL Flexible Server) — corporate/regulator networks often block these by default. This is the single most common Day 2 blocker.

### Network / VPN considerations for a regulator environment
- [ ] Ask the agency's IT/security team in advance whether learner laptops sit behind a **restrictive corporate firewall or VPN** that blocks direct internet egress to Azure endpoints. If so:
  - Request a temporary outbound allow-list for `*.database.windows.net:1433`, `*.postgres.database.azure.com:5432`, and `portal.azure.com`, or
  - Arrange for training-room laptops/Wi-Fi to sit on a separate, less-restricted guest network for the duration of the course.
- [ ] Confirm whether the venue's internet is agency-provided or independent — regulator buildings in Lagos/Abuja often have their own MPLS/leased-line internet that may have stricter egress rules than commercial ISPs.
- [ ] Test **actual Azure SQL/PostgreSQL connectivity from the training room** at least once before Day 1, not just "internet works." A successful browser page load does not guarantee port 1433/5432 egress.
- [ ] Have the **local Docker fallback** (below) ready regardless — treat it as insurance, not a last resort you improvise on the spot.

### Local backup lab environment (Lagos connectivity insurance)
Lagos/Abuja internet can be unstable (power/fibre cuts). Prepare this **in parallel with Azure setup**, not as an afterthought:
- [ ] Pre-build a **Docker Compose bundle** with `mcr.microsoft.com/mssql/server` (SQL Server on Linux, Developer edition) and `postgres` images, pre-pulled onto a USB drive or shared local file server.
- [ ] Test the bundle boots offline on a representative learner laptop spec (RAM ≥ 8GB recommended for SQL Server container).
- [ ] Prepare a **local-only version of each lab guide** with connection strings pointing to `localhost` instead of `<server>.database.windows.net`. Keep exercises functionally identical; only the connection endpoint changes.
- [ ] Brief yourself on the pivot script: "We'll continue with a local SQL Server container so no one loses lab time; everything else about the exercise is identical — we'll revisit the Azure-hosted version once connectivity is restored." (See [Contingency & Troubleshooting](#contingency--troubleshooting).)

### Content & materials
- [ ] Print/PDF the brochure outcomes map and pin it to your own notes — you will explicitly tie back to it each day.
- [ ] Stage all lab guides, datasets, checklists, and slides in a shared drive/USB, organized by day (`Day1/`, `Day2/`, etc.).
- [ ] Prepare the oil & gas regulator sample datasets (licensing/permit registry, crude oil production reporting, downstream fuel distribution, field inspection records, environmental compliance data, revenue/royalty tracking) — used across Days 2, 3, and 5.
- [ ] Dry-run every lab yourself end-to-end within 48 hours of teaching it, using a **fresh** free-tier subscription if possible (catches quota-exhaustion and first-time-provisioning delays learners will hit).

### Night-before checklist (repeat each night of the course)
- [ ] Re-verify tomorrow's Azure resources are provisioned/reachable (or torn down per guardrails — see each day's prep list).
- [ ] Confirm projector/screen-share, room booking, and catering/break timing for tomorrow.
- [ ] Re-check Lagos weather/power advisories if relevant to travel or venue power stability; charge a portable hotspot as an internet fallback.
- [ ] Skim tomorrow's "Facilitator prep checklist" and "Confidence primer" sections below.

---

## Room, Logistics & Remote-Attendee Setup

### Physical room
| Item | Requirement |
|---|---|
| Layout | Pods of 3–4 (mixed DBA/sysadmin/manager per pod — see pairing strategy per day) |
| Power | Confirm surge-protected multi-sockets at every pod; Lagos power cuts are common — have a UPS or generator backup confirmed with the venue |
| Screen/projector | Test HDMI/USB-C adapters with your actual laptop the day before; bring your own adapter |
| Whiteboard | For architecture sketches (Days 1, 5) and execution-plan diagrams (Day 3) |
| Internet | Wired connection for instructor machine if available; Wi-Fi for learners with a tested throughput check (see Before the Course) |
| Printed materials | One printed lab guide + cheat sheet per learner as a no-connectivity fallback reference |

### Remote-attendee considerations (if hybrid)
- [ ] Use a platform with breakout rooms (Teams/Zoom) so remote learners can be grouped with in-room pods for labs — announce pairings explicitly at block start.
- [ ] Share your screen for every demo, and additionally share the **exact CLI/SQL commands** in a shared chat/doc in real time — remote learners can't see your keyboard.
- [ ] Ask a **co-facilitator or TA** to monitor the remote chat continuously; solo-facilitating a hybrid room while running demos is not sustainable at this content density.
- [ ] Record all sessions (with consent, and mindful that regulator content/discussion may be sensitive — avoid recording open Q&A about internal agency systems).
- [ ] Send remote learners the resource group naming convention and dataset links 24 hours ahead so they aren't blocked waiting for file transfer during the session.

### General logistics
- [ ] Confirm start time accounts for Lagos traffic — build a 10–15 minute buffer into the "9:00 AM" start for Day 1 only; hold firm after that once norms are set.
- [ ] Have name cards/tents showing name + role (DBA/sysadmin/manager) so you can target questions and pairing decisions quickly.
- [ ] Confirm catering timing aligns with the lunch block in the schedule below.

---

## Day 1 — Cloud Fundamentals Recap

### 1. Day goal & learning outcomes tie-back
**Goal:** Re-anchor learners in core cloud concepts and build the decision-making muscle to choose the right Azure service for a regulator workload — the foundation every later day builds on.

Maps to brochure outcomes:
- IaaS/PaaS/SaaS distinctions and when to use each.
- Cloud service selection criteria and decision frameworks.
- Deployment patterns & architectures (public/private/hybrid, regions/availability zones).
- Provider comparison context (why this course standardizes on Azure, how it compares conceptually to AWS/GCP without turning into a bake-off).
- **Hands-on tie-back:** learners analyze a cloud service selection case study and recommend Azure services from business requirements — directly rehearsing the Day 5 capstone's architecture-decision skill.

### 2. Minute-by-minute schedule (09:00–17:00)

| Time | Segment | Format | Facilitator notes |
|---|---|---|---|
| 09:00–09:20 | Welcome, agenda, ground rules, roster/name check | Discussion | Set the regulator framing immediately: "Everything this week maps to systems you actually run — licensing registries, production reporting, compliance data." Note who is DBA/sysadmin/manager for pairing later. |
| 09:20–09:45 | Icebreaker + skills self-assessment (cloud, SQL, security — 1-5 scale) | Discussion | Use a quick show-of-hands or sticky-note poll. This drives your pairing decisions for the whole week — capture it in your notes. |
| 09:45–10:30 | Teaching Block 1: Cloud service models (IaaS/PaaS/SaaS) + shared responsibility | Lecture + demo | Live-show Azure portal: create a VM (IaaS) vs. show Azure SQL DB/App Service (PaaS) side by side. Use the "renting a building vs. renting a furnished office vs. buying a ready meal" analogy (see talking points). |
| 10:30–10:45 | **Short break** | — | — |
| 10:45–11:30 | Teaching Block 2: Deployment patterns & architectures (public/private/hybrid, regions, availability zones) | Lecture + discussion | Anchor to data residency: "If NUPRC production data must stay demonstrably within approved boundaries, which deployment/region pattern applies, and what do you tell an auditor?" |
| 11:30–12:15 | Teaching Block 3: Cloud service selection criteria & decision frameworks | Lecture + discussion | Walk through a scoring framework (cost, compliance/data residency, availability SLA, skills/ops burden, vendor lock-in). Use it live against a mini scenario before the lab. |
| 12:15–13:15 | **Lunch** | — | — |
| 13:15–13:30 | Recap + lab framing | Discussion | Re-state the lab's link to the capstone explicitly. |
| 13:30–15:30 | **Hands-on Lab:** Analyze a cloud service selection case study; recommend Azure services from business requirements | Lab | Case study: modernizing a regulator's field-inspection record system. Circulate constantly; use the pairing strategy below. |
| 15:30–15:45 | **Short break** | — | — |
| 15:45–16:30 | Lab debrief — pairs present recommendations, instructor challenges assumptions | Discussion | Ask "what would change your recommendation if data residency were non-negotiable?" to surface trade-off thinking. |
| 16:30–16:50 | Provider comparison context (conceptual, not exhaustive) | Lecture | Keep brief — 15-20 min. Purpose is orientation, not AWS/GCP depth. |
| 16:50–17:00 | Wrap & checkpoint: Day 1 exit poll (3 questions) + preview Day 2 | Discussion | See check-for-understanding questions below; use as a lightweight formative checkpoint. |

### 3. Teaching flow & talking points

**Topic: IaaS / PaaS / SaaS**
- **How to explain it:** Responsibility shifts from you to the provider as you move from IaaS → PaaS → SaaS. With IaaS you manage the OS, patching, scaling; with PaaS the provider manages the runtime and you manage the app/data; with SaaS you just use the app.
- **Analogy:** "IaaS is renting an empty plot of land — you build everything. PaaS is renting a furnished office — the building, power, and security are handled, you bring your business. SaaS is ordering a ready meal — you just eat." For the regulator audience, extend it: "Running your own on-prem Oracle/SQL Server for the licensing database is like IaaS-level land; Azure SQL Database managed PaaS is the furnished office — Microsoft handles patching, backups, and HA, your DBAs focus on the licensing data model and query performance."
- **Common misconception to preempt:** "PaaS means we lose control of our data." Clarify: you still own and control the data and access to it; the provider manages the underlying platform (patching, OS, HA infrastructure), not your data governance. Data residency, encryption, and access control remain the customer's configuration responsibility (shared responsibility model).
- **Check-for-understanding questions:**
  1. "If NMDPRA wants to stop worrying about OS patching for its downstream fuel distribution monitoring database, but still control the schema and query tuning — which model fits, and which Azure service?"
  2. "What's the shared responsibility split for a PaaS database service — who patches the OS, who manages access control?"
  3. "Name one reason a regulator might still choose IaaS (VMs) over PaaS for a specific workload."

**Topic: Deployment patterns & architectures**
- **How to explain it:** Public cloud gives shared, elastic infrastructure; private cloud/on-prem gives full control; hybrid blends both — often the realistic answer for regulated bodies with legacy systems.
- **Oil & gas regulator example:** A regulator might keep a legacy revenue/royalty system on-prem for legal/audit continuity while moving new field-inspection or public-facing licensing portals to Azure — a textbook hybrid pattern.
- **Common misconception to preempt:** "Cloud = less secure" or "cloud = data leaves Nigeria automatically." Clarify: Azure lets you select specific **regions** — data residency is a deliberate architectural and contractual choice, not an automatic consequence of "the cloud." Discuss which Azure regions are realistic choices and why region selection is a compliance decision, not just a latency one.
- **Check-for-understanding questions:**
  1. "Why might a regulator choose a hybrid pattern rather than going all-in on public cloud immediately?"
  2. "How does selecting an Azure region relate to a data residency requirement?"

**Topic: Cloud service selection criteria & decision frameworks**
- **How to explain it:** Give learners a repeatable framework, not a one-off answer: cost model (CapEx vs OpEx), compliance/data residency, availability/SLA needs, operational skill availability, and lock-in risk. Weight the criteria against the specific workload.
- **Oil & gas regulator example:** Compare hosting a public-facing crude oil production reporting portal (high availability, moderate sensitivity, bursty traffic around reporting deadlines — good PaaS/App Service + Azure SQL fit) vs. an internal environmental-compliance archive (low traffic, long retention, cost-sensitive — good candidate for cooler storage tiers and reserved capacity).
- **Common misconception to preempt:** "Cheapest option is always right." Push back: cheapest compute that violates an availability requirement for a regulatory reporting deadline is a compliance and reputational risk, not a saving.
- **Check-for-understanding questions:**
  1. "Which two criteria would you weight most heavily for a public-facing royalty payment portal, and why?"
  2. "Give an example where the cheapest technical option is the wrong business choice for this agency."

### 4. Facilitator prep checklist (Day 1)
- [ ] Pre-provision your **own** demo subscription with one VM (can be stopped, just needs to exist to show in portal) and one Azure SQL Database (serverless, paused) to demo IaaS vs PaaS live without waiting on provisioning during class.
- [ ] Test showing both the **Azure SQL free-offer "Start free"** flow ([aka.ms/azuresqlhub](https://aka.ms/azuresqlhub)) and the general Azure free account signup, in case learners haven't signed up yet.
- [ ] Print/prepare the case study handout (cloud service selection: field-inspection record system modernization) — one per learner or pair.
- [ ] Confirm the decision-framework scoring template (slide or handout) is ready to project during Block 3.
- [ ] Test screen-share of Azure portal navigation (Resource Groups, Create Resource blade) in the actual training room network.
- [ ] Have the region list ready to discuss (which Azure regions are commonly discussed for African/EMEA data residency conversations) — know this cold before the class asks.

### 5. Materials/handouts referenced
- Slide deck: `Day1_Cloud_Fundamentals.pptx`
- Case study handout: `Day1_CaseStudy_FieldInspectionModernization.pdf`
- Decision framework template: `Day1_ServiceSelection_ScoringTemplate.xlsx`
- Cheat sheet: `Day1_IaaS_PaaS_SaaS_CheatSheet.pdf`

### 6. Energy & engagement tactics
- Use the Day 1 skills self-assessment to build **mixed pods**: pair a manager (business framing strength) with a sysadmin/DBA (technical depth) for the case study — this mirrors how real recommendations get made in the agency and prevents managers from disengaging during technical stretches.
- Managers often worry they'll "slow down" a technical discussion — explicitly invite them to challenge cost/compliance trade-offs; this is their strength and keeps them anchored.
- For strong DBAs/sysadmins who finish the framework fast, give a stretch prompt: "Now argue the opposite recommendation — what's the strongest case for on-prem here?"
- Do a mid-morning stand-and-stretch or 2-minute "turn to your neighbor" micro-discussion before Block 2 — attention dips noticeably by 10:45 after travel-heavy mornings.

---

## Day 2 — Database Fundamentals

### 1. Day goal & learning outcomes tie-back
**Goal:** Build solid RDBMS fundamentals and hands-on SQL fluency using an Azure-hosted database, so every learner — including non-DBAs — can read, write, and reason about relational data.

Maps to brochure outcomes:
- RDBMS core concepts, normalization, indexing fundamentals, CRUD SQL, backup strategies.
- **Hands-on tie-back:** model a small inventory database schema and execute CRUD SQL — this schema/dataset pattern is reused and extended on Day 3 (performance) and referenced again on Day 5 (capstone's managed database).

### 2. Minute-by-minute schedule (09:00–17:00)

| Time | Segment | Format | Facilitator notes |
|---|---|---|---|
| 09:00–09:15 | Recap of Day 1 + exit-poll review | Discussion | Address any Day 1 exit-poll misconceptions before moving on. |
| 09:15–10:00 | Teaching Block 1: RDBMS core concepts (tables, rows, keys, relationships) | Lecture + demo | Use the licensing/permit registry as the running example: licenses table, licensees table, inspections table. |
| 10:00–10:45 | Teaching Block 2: Normalization (1NF–3NF) | Lecture + demo | Live-normalize a deliberately bad "one big spreadsheet" of licensing data into 3NF, on the whiteboard or a shared doc. |
| 10:45–11:00 | **Short break** | — | — |
| 11:00–11:45 | Teaching Block 3: Indexing fundamentals | Lecture + demo | Conceptual only today — deep execution-plan work is Day 3. Use the "book index" analogy. |
| 11:45–12:30 | Environment setup: connect Azure Data Studio/SSMS to each learner's Azure SQL Database | Demo + hands-on | This always takes longer than planned — budget generously and expect firewall/connection-string issues (see contingency section). |
| 12:30–13:30 | **Lunch** | — | — |
| 13:30–13:45 | CRUD SQL walkthrough (live-coded) | Demo | Demo INSERT/SELECT/UPDATE/DELETE against the inventory schema before releasing learners to the lab. |
| 13:45–15:45 | **Hands-on Lab:** Model a small inventory database schema (spare parts / field equipment inventory) + execute CRUD SQL | Lab | Circulate constantly. Use pairing strategy below — this is the day non-DBAs most need support. |
| 15:45–16:00 | **Short break** | — | — |
| 16:00–16:30 | Backup strategies overview (conceptual intro; deep dive is Day 3) | Lecture | Introduce automated backups + PITR concept in Azure SQL Database as a preview, tie to "why managed PaaS backup matters for a regulator's audit trail." |
| 16:30–16:50 | Lab debrief + common errors review | Discussion | Walk through 2-3 real errors you saw during circulation (anonymized). |
| 16:50–17:00 | Wrap & checkpoint: Day 2 exit poll + preview Day 3 | Discussion | — |

### 3. Teaching flow & talking points

**Topic: RDBMS core concepts (tables, keys, relationships)**
- **How to explain it:** A table is a structured list; a primary key uniquely identifies each row; a foreign key links related tables together, preventing duplicated, inconsistent data.
- **Analogy / regulator example:** "Think of the licensing/permit registry: one table for `Licensees`, one for `Licenses`, one for `Inspections`. The `LicenseeID` foreign key on `Licenses` means you never retype a company's registration details every time they get a new license — and it's exactly how you'd guarantee that revenue/royalty tracking always ties back to a valid, existing licensee."
- **Common misconception to preempt:** "We can just put everything in one big spreadsheet-like table." Show concretely how that breaks: duplicated licensee data, update anomalies (change an address in one row, forget another), and impossible-to-enforce consistency.
- **Check-for-understanding questions:**
  1. "Why does putting a `LicenseeID` foreign key on the `Licenses` table matter for data integrity, versus just retyping the licensee name each time?"
  2. "What problem occurs if a licensee's address changes and it's stored in 50 different rows instead of one?"

**Topic: Normalization**
- **How to explain it:** Normalization progressively removes duplication and update risk by splitting data into related tables, at the cost of needing JOINs to bring it back together.
- **Analogy / regulator example:** Live-normalize a flat "inspection report spreadsheet" (inspector name, inspector phone, field site name, site location, inspection date, findings — all in one row per inspection, repeated for every inspection at that site) into separate `Inspectors`, `Sites`, and `Inspections` tables.
- **Common misconception to preempt:** "More normalization is always better." Note there's a real trade-off — highly normalized schemas require more JOINs, which matters for query performance (foreshadow Day 3). Practical schemas often stop at 3NF.
- **Check-for-understanding questions:**
  1. "What's duplicated in this flat inspection spreadsheet, and what table would you split it into?"
  2. "What's the cost of normalizing too far — what do you now need to do to get a combined report back?"

**Topic: Indexing fundamentals**
- **How to explain it:** An index is a separate, ordered structure that lets the database find rows without scanning the whole table — like an index at the back of a book.
- **Analogy / regulator example:** "Searching for one company's license by `LicenseeID` in a 2-million-row table without an index is like reading every page of a 2 million-page regulatory archive to find one filing. An index on `LicenseeID` is the back-of-book index that takes you straight there."
- **Common misconception to preempt:** "Add an index to every column, more indexes = faster." Clarify: indexes speed up reads but slow down writes (INSERT/UPDATE/DELETE must maintain the index too) and consume storage — over-indexing a heavily-written production reporting table can hurt performance. Full trade-off analysis is Day 3.
- **Check-for-understanding questions:**
  1. "Why would an index help you find one crude oil production report by date, but not necessarily help a query that touches every row anyway?"
  2. "Name one cost of adding an index, not just the benefit."

**Topic: Backup strategies (introductory)**
- **How to explain it (preview only — depth on Day 3):** Backups exist on a spectrum from full/differential/log backups (traditional) to fully automated, provider-managed backups with point-in-time restore (PITR) in PaaS databases.
- **Regulator example:** Azure SQL Database's automated backups with PITR mean a regulator can demonstrate to auditors that royalty/revenue records are recoverable to a specific point in time — relevant to both business continuity and audit-trail requirements.
- **Common misconception to preempt:** "Managed PaaS backup means we never need a DR/backup strategy conversation." Clarify: automated backups protect against data loss/corruption, but a full business continuity plan also needs geo-redundancy/failover thinking (Day 3 depth) and defined RTO/RPO targets.
- **Check-for-understanding questions:**
  1. "What does PITR let you do that a nightly full backup alone does not?"

### 4. Facilitator prep checklist (Day 2)
- [ ] Confirm every learner successfully created (or has ready) their Azure SQL Database (free-offer, serverless) **before** the 11:45 setup slot — chase stragglers via the pre-course email/roster the day before.
- [ ] Pre-test the exact Azure Data Studio and SSMS connection steps (server name format `<server>.database.windows.net`, firewall rule to allow client IP, authentication method) on the actual training room network.
- [ ] Prepare the inventory dataset (spare parts/field equipment inventory, sized for a regulator's field operations) as a ready-to-run SQL script (`CREATE TABLE` + sample `INSERT`s) for anyone who falls behind on schema design.
- [ ] Verify the licensing/permit registry example dataset used for lecture demos is loaded in your own demo database.
- [ ] Re-confirm cost-safety guardrail: remind learners to set Azure SQL DB serverless auto-pause behavior and disconnect Object Explorer when idle overnight.
- [ ] Have a **local Docker SQL Server container** ready as an immediate fallback if Azure connectivity issues block more than 2-3 learners at the 11:45 setup slot (see [Contingency & Troubleshooting](#contingency--troubleshooting)).

### 5. Materials/handouts referenced
- Slide deck: `Day2_Database_Fundamentals.pptx`
- Lab guide: `Day2_LabGuide_InventorySchemaCRUD.pdf`
- Dataset: `Day2_Dataset_FieldEquipmentInventory.sql`
- Connection setup cheat sheet: `Day2_AzureDataStudio_SSMS_ConnectionGuide.pdf`
- Checklist: `Day2_CostSafety_AutoPauseChecklist.pdf`

### 6. Energy & engagement tactics
- This is the day non-DBAs (managers, some sysadmins) are most likely to feel lost. Pair each with a stronger SQL learner explicitly for the CRUD lab — assign the stronger learner the role of "navigator explains, driver types" so both stay engaged rather than the stronger learner just doing it alone.
- Give managers a lighter but real task during the lab: reviewing the schema design for business-logic sense ("does this correctly represent how field inspections actually get recorded?") rather than writing raw SQL, if they're struggling — keeps them contributing meaningfully.
- Break the long environment-setup block into "I'll walk the room every 5 minutes" checkpoints — this is the highest-friction moment of the week; visible, frequent instructor presence prevents quiet frustration from compounding.
- Celebrate first successful `SELECT * FROM` results out loud — small visible wins matter a lot on the SQL-anxious segment of this cohort.

---

## Day 3 — Database Administration & Performance

### 1. Day goal & learning outcomes tie-back
**Goal:** Move from "can write SQL" to "can administer and troubleshoot a production-grade database" — the DBA/sysadmin-facing core of the week.

Maps to brochure outcomes:
- Advanced indexing, query execution plans, replication, backup/restore for business continuity, performance monitoring & troubleshooting.
- **Hands-on tie-back:** diagnose and resolve a performance issue using sample data and execution plan analysis — this diagnostic skill and the backup/restore concepts are explicitly reused in the Day 5 capstone's backup/DR deliverable.

### 2. Minute-by-minute schedule (09:00–17:00)

| Time | Segment | Format | Facilitator notes |
|---|---|---|---|
| 09:00–09:15 | Recap Day 2 + exit-poll review | Discussion | — |
| 09:15–10:15 | Teaching Block 1: Advanced indexing (clustered vs. non-clustered, composite indexes, covering indexes) | Lecture + demo | Use the crude oil production reporting table (large, frequently queried by date + field/site) as the running example. |
| 10:15–11:15 | Teaching Block 2: Query execution plans | Lecture + demo | Live-demo "Include Actual Execution Plan" in Azure Data Studio/SSMS against a deliberately unindexed query, then add the index and re-run. |
| 11:15–11:30 | **Short break** | — | — |
| 11:30–12:30 | Teaching Block 3: Replication, backup/restore for business continuity | Lecture + demo | Cover Azure SQL automated backups + PITR, geo-restore, active geo-replication, and failover groups conceptually; tie directly to RTO/RPO framing for regulator systems. |
| 12:30–13:30 | **Lunch** | — | — |
| 13:30–13:45 | Performance monitoring tools overview + lab framing | Demo | Quick tour of relevant Azure SQL monitoring views/metrics before releasing to lab. |
| 13:45–15:45 | **Hands-on Lab:** Diagnose & resolve a performance issue using sample data + execution plan analysis | Lab | Scenario: a slow crude oil production reporting query during month-end reporting. Circulate — this lab has the widest skill-gap risk of the week. |
| 15:45–16:00 | **Short break** | — | — |
| 16:00–16:35 | Lab debrief: compare before/after execution plans as a group | Discussion | Have 2-3 pairs share their diagnosis and fix live. |
| 16:35–16:50 | Performance monitoring & troubleshooting wrap-up (alerting, ongoing monitoring habits) | Lecture | Brief — sets up "operationalizing" mindset before security day. |
| 16:50–17:00 | Wrap & checkpoint: Day 3 exit poll + preview Day 4 | Discussion | — |

### 3. Teaching flow & talking points

**Topic: Advanced indexing**
- **How to explain it:** A clustered index physically orders the table's data; non-clustered indexes are separate lookup structures pointing back to the table; composite indexes cover multiple columns used together in WHERE/JOIN/ORDER BY; a covering index includes all columns a query needs so the engine never touches the base table.
- **Analogy / regulator example:** "If crude oil production reports are usually queried by field/site AND date range together, a composite index on `(SiteID, ReportDate)` is like organizing the archive by site first, then chronologically within each site's folder — much faster than a single alphabetical index when your real query pattern is 'this site, this month.'"
- **Common misconception to preempt:** "Just index every column that appears in any WHERE clause." Reinforce the write-cost trade-off from Day 2 with a concrete number-of-writes example, and explain that composite index **column order matters** — an index on `(SiteID, ReportDate)` doesn't equally help a query filtering only on `ReportDate`.
- **Check-for-understanding questions:**
  1. "You have one composite index on `(SiteID, ReportDate)`. Will it help a query that filters only on `ReportDate`? Why or why not?"
  2. "What's the difference between a clustered and non-clustered index in terms of how the data is physically stored?"

**Topic: Query execution plans**
- **How to explain it:** The execution plan shows exactly how the database engine will retrieve the data — table scan vs. index seek, join strategy, estimated vs. actual row counts — and is the primary diagnostic tool for "why is this query slow."
- **Analogy / regulator example:** "A table scan on the full production-reporting history to answer 'what did Field X report last week' is like manually flipping through every page of a decade of paper filings instead of going straight to this year's folder. The execution plan is how you catch the database doing that."
- **Common misconception to preempt:** "A high 'cost %' in the plan always means that's the actual bottleneck." Clarify that cost percentages are estimates based on internal statistics, and that actual vs. estimated row-count mismatches are often a more reliable troubleshooting signal (stale statistics).
- **Check-for-understanding questions:**
  1. "You see a table scan in the execution plan on a query filtering `WHERE SiteID = 12`. What's your first hypothesis and what would you check?"
  2. "What does a big gap between estimated and actual row counts in a plan usually suggest?"

**Topic: Replication & backup/restore for business continuity**
- **How to explain it:** Distinguish backup (protects against data loss/corruption, restore takes time) from replication/failover (protects against downtime, near-instant switchover) — both matter, they solve different problems, defined by RTO (how fast must we be back up) and RPO (how much data can we afford to lose).
- **Analogy / regulator example:** "If the primary region hosting the royalty/revenue tracking database goes down during a reporting deadline, active geo-replication with a failover group is like having a live mirror office ready to take over immediately — versus a backup, which is like a fire safe with yesterday's paperwork that you'd still need time to unpack and use." Frame RTO/RPO explicitly against a regulator's own audit/continuity obligations.
- **Common misconception to preempt:** "Automated PITR backups are the same thing as high availability." Clarify PITR gets you back a point in time after an incident (data recovery); geo-replication/failover groups keep the system running through an incident (availability). A mature continuity plan needs both.
- **Check-for-understanding questions:**
  1. "What's the difference between RTO and RPO, and which one does PITR primarily improve?"
  2. "If the agency's tolerance is 'we can lose at most 5 minutes of production reporting data, and must be back online within 1 hour,' which Azure capabilities are you reaching for?"

### 4. Facilitator prep checklist (Day 3)
- [ ] Pre-load a **larger sample dataset** (simulated crude oil production reporting history, tens of thousands of rows) into your demo database, with a deliberately missing/wrong index for the slow-query demo.
- [ ] Rehearse the "before/after execution plan" demo end-to-end the night before — timing and exact query text matter for a clean visual contrast.
- [ ] Confirm the lab's performance-issue scenario database is pre-loaded and reachable in every learner's Azure SQL Database, or provide the load script for them to run at lab start.
- [ ] Review current Azure SQL Database backup/geo-replication/failover group documentation for any interface changes since your last delivery (portal blades and terminology evolve).
- [ ] Prepare a one-page RTO/RPO worksheet for the replication/backup teaching block.
- [ ] Have the local Docker fallback dataset pre-loaded too, matching the same schema, in case of connectivity issues during the lab.

### 5. Materials/handouts referenced
- Slide deck: `Day3_DBA_Performance.pptx`
- Lab guide: `Day3_LabGuide_PerformanceDiagnosis.pdf`
- Dataset: `Day3_Dataset_CrudeOilProductionReporting_Large.sql`
- Checklist: `Day3_RTO_RPO_Worksheet.pdf`
- Reference card: `Day3_ExecutionPlan_ReadingCheatSheet.pdf`

### 6. Energy & engagement tactics
- This day has the widest skill gap (DBAs may find it easy, sysadmins/managers may struggle with execution plans). Pair a DBA-leaning learner with a sysadmin/manager for the performance lab, and explicitly assign the DBA to "narrate your reasoning out loud" — this reinforces their own learning while teaching the pair partner.
- For managers, reframe the lab goal as "understand what evidence a DBA should show you when they say a fix worked" rather than expecting them to write the fix themselves — gives them a legitimate, engaged role.
- Use a **competitive-but-friendly** framing for the lab debrief: ask each pair for their "before" query time and "after" query time — small, visible before/after numbers energize a 2 PM post-lunch slot.
- Watch for the post-lunch energy dip during Block 3 (replication/backup, right after lunch) — consider a 2-minute stand-up stretch or a quick poll question to re-engage before diving into RTO/RPO.

---

## Day 4 — Cybersecurity Essentials

### 1. Day goal & learning outcomes tie-back
**Goal:** Give every learner — regardless of security background — a working model of threats, controls, and identity/access management specifically as applied to Azure-hosted regulator systems, producing a concrete hardening checklist they could defend to an auditor.

Maps to brochure outcomes:
- Threat types & attack vectors, encryption at rest/in transit, IAM principles, secure configuration, patching & vulnerability management.
- **Hands-on tie-back:** harden a simple app stack and deliver a security checklist — this checklist is directly reused/extended as one of the three Day 5 capstone deliverables.

### 2. Minute-by-minute schedule (09:00–17:00)

| Time | Segment | Format | Facilitator notes |
|---|---|---|---|
| 09:00–09:15 | Recap Day 3 + exit-poll review | Discussion | — |
| 09:15–10:00 | Teaching Block 1: Threat types & attack vectors | Lecture + discussion | Use real-world-flavored regulator scenarios (phishing targeting revenue/royalty staff, SQL injection against a public licensing portal, insider misuse of field inspection records). |
| 10:00–11:00 | Teaching Block 2: Encryption at rest & in transit + IAM principles (Entra ID, RBAC, least privilege) | Lecture + demo | Demo TDE status on an Azure SQL DB, Always Encrypted concept, and TLS enforcement; then demo Entra ID RBAC role assignment. |
| 11:00–11:15 | **Short break** | — | — |
| 11:15–12:15 | Teaching Block 3: MFA & Conditional Access (regulator-specific regulatory note) + secure configuration principles | Lecture + demo | This is the mandatory MFA compliance deadline block — see talking points; demo Conditional Access policy creation in Microsoft Entra admin center. |
| 12:15–13:15 | **Lunch** | — | — |
| 13:15–13:35 | Patching & vulnerability management overview + Defender for Cloud/SQL intro + lab framing | Lecture + demo | Quick tour of Microsoft Defender for Cloud recommendations blade and Update Manager before the lab. |
| 13:35–15:35 | **Hands-on Lab:** Harden a simple app stack (App Service + Azure SQL DB) + deliver a security checklist | Lab | Learners apply TLS enforcement, firewall rules, least-privilege RBAC, and TDE verification; produce a written checklist deliverable. |
| 15:35–15:50 | **Short break** | — | — |
| 16:00–16:35 | Lab debrief: review 2-3 learner checklists live, discuss gaps | Discussion | Use this to preview the Day 5 capstone's security checklist deliverable expectations. |
| 16:35–16:50 | Microsoft Sentinel (mention/awareness level) + NDPR/NDPA 2023 compliance tie-in | Lecture | Keep Sentinel brief — awareness only, not hands-on. |
| 16:50–17:00 | Wrap & checkpoint: Day 4 exit poll + preview Day 5 capstone expectations | Discussion | Explicitly hand out/preview the Day 5 capstone brief here so learners can think overnight. |

### 3. Teaching flow & talking points

**Topic: Threat types & attack vectors**
- **How to explain it:** Group threats into categories learners can reason about: social engineering/phishing, injection attacks, misconfiguration, insider threats, and credential compromise — then map each to a concrete regulator scenario.
- **Analogy / regulator example:** "A phishing email impersonating a senior official asking finance staff to 'update royalty payment bank details' is a classic business email compromise vector — exactly the kind of attack that targets revenue/royalty tracking workflows because the financial stakes are high and staff are trained to respond quickly to senior requests."
- **Common misconception to preempt:** "Our biggest risk is external hackers." Present data-driven framing that credential compromise and misconfiguration (e.g., an open firewall rule, an over-privileged account) are frequently larger practical risks than sophisticated external attacks — directly motivates the IAM and secure-configuration blocks.
- **Check-for-understanding questions:**
  1. "What makes revenue/royalty staff a specific phishing target compared to general staff?"
  2. "Give an example of a misconfiguration (not an external attacker) that could expose field inspection records."

**Topic: Encryption at rest/in transit + IAM principles**
- **How to explain it:** Encryption at rest protects stored data if disks/backups are stolen; encryption in transit (TLS) protects data moving between client and server; IAM/least privilege ensures only the right people/systems can access data in the first place — encryption doesn't help if the attacker has a legitimate, over-privileged login.
- **Analogy / regulator example:** "Transparent Data Encryption on the Azure SQL Database holding environmental compliance data is like a locked, fireproof filing cabinet — if someone steals the physical disk, they can't read the files. TLS in transit is the locked courier bag data travels in between the office and the field. Neither one stops someone who's handed a legitimate key they shouldn't have — that's what least-privilege IAM is for."
- **Common misconception to preempt:** "Encryption means we don't need to worry about access control." Reinforce: encryption and access control (IAM/least privilege) are complementary, not substitutes — a legitimate but over-privileged account can still read/exfiltrate encrypted data because the database decrypts it for authorized queries.
- **Check-for-understanding questions:**
  1. "TDE is enabled on our database. Does that stop a DBA with full access from copying out the entire licensing table? Why or why not?"
  2. "What's the difference between what encryption-at-rest protects against and what least-privilege access control protects against?"

**Topic: MFA / Conditional Access (regulator-specific compliance note)**
- **How to explain it:** Microsoft is moving to require MFA for all Azure portal access, including Global Admins, from **October 1, 2026** ([Microsoft Tech Community — Entra ID security updates](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/microsoft-entra-id-security-updates-what-organizations-need-to-do-now/4522024)). Conditional Access policies — configured in the **Microsoft Entra admin center > Entra ID > Conditional Access** ([Microsoft Learn — Conditional Access documentation](https://learn.microsoft.com/en-us/entra/identity/conditional-access/)) — are how organizations enforce MFA and other access conditions (location, device compliance, risk level) systematically rather than ad hoc.
- **Analogy / regulator example:** "For a regulator handling royalty and licensing data, Conditional Access is like requiring a second ID check specifically when someone tries to access sensitive systems from outside the office network or an unmanaged device — not just at the front door every time, but risk-based checks where they matter most."
- **Common misconception to preempt:** "MFA is just an inconvenience layered on top of a password." Reframe: MFA / Conditional Access is the practical mitigation for the credential-compromise risk just discussed — it directly reduces the impact of a phished or leaked password, which is often the actual attack vector in real incidents, not a sophisticated zero-day.
- **Check-for-understanding questions:**
  1. "By what date does Microsoft require MFA for all Azure portal access, and who does it apply to?" *(Answer: October 1, 2026, including Global Admins — [source](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/microsoft-entra-id-security-updates-what-organizations-need-to-do-now/4522024).)*
  2. "Where do you go in the Azure/Entra ecosystem to configure a Conditional Access policy?" *(Answer: Microsoft Entra admin center > Entra ID > Conditional Access — [source](https://learn.microsoft.com/en-us/entra/identity/conditional-access/).)*
  3. "Why is risk-based Conditional Access arguably more useful for a regulator than blanket MFA for every single access, with no nuance?"

### 4. Facilitator prep checklist (Day 4)
- [ ] Pre-verify TDE is enabled by default (it is, for new Azure SQL databases) on your demo database, and know exactly where to show its status in the portal.
- [ ] Pre-create an Entra ID test user/role assignment in your demo tenant so the RBAC demo doesn't require live signup during class.
- [ ] Rehearse the Conditional Access policy creation demo path (Microsoft Entra admin center > Entra ID > Conditional Access) — interface names shift, confirm current navigation the week of delivery.
- [ ] Confirm every learner's lab app stack (App Service + Azure SQL DB) is provisioned and reachable before the lab block — this is a two-resource-type lab and has more moving parts than earlier days.
- [ ] Prepare the security checklist template (blank) for learners to fill in during the lab, plus your own completed reference version for the debrief.
- [ ] Double check current facts on the MFA enforcement deadline and Defender for Cloud/Sentinel positioning before class — security guidance changes fastest of any topic this week.

### 5. Materials/handouts referenced
- Slide deck: `Day4_Cybersecurity_Essentials.pptx`
- Lab guide: `Day4_LabGuide_HardenAppStack.pdf`
- Security checklist template: `Day4_SecurityChecklist_Template.xlsx`
- Reference: `Day4_MFA_ConditionalAccess_Factsheet.pdf`
- NDPR/NDPA 2023 quick-reference: `Day4_NDPR_NDPA_ComplianceNotes.pdf`

### 6. Energy & engagement tactics
- Security content resonates differently across the mix: managers care about compliance/audit framing (NDPR/NDPA), DBAs care about TDE/Always Encrypted mechanics, sysadmins care about network/firewall/RBAC configuration. Rotate which persona's framing you lead with per topic so no one checks out for a full block.
- For the hardening lab, pair by **complementary skill** rather than skill level: put a network-minded sysadmin with a data-minded DBA so one instinctively covers firewall/TLS/RBAC while the other covers TDE/Always Encrypted — mirrors real-world security teamwork.
- Use a "red team for 2 minutes" mini-activity before the lab: ask each pod to name one way they'd attack the unhardened app stack before they harden it — this primes engagement and gives the hardening steps purpose rather than feeling like checkbox busywork.
- This is the day most likely to raise real anxiety about the agency's actual current posture — acknowledge it directly ("this is exactly why we're doing this training") rather than deflecting, but keep specific internal-system discussion for offline conversations, not open-floor Q&A.

---

## Day 5 — Integrated Lab & Capstone

### 1. Day goal & learning outcomes tie-back
**Goal:** Synthesize all four prior days into one integrated deployment — cloud service selection, database administration, and security controls — culminating in a capstone submission and short oral defense that proves each learner (or team) can reason about and defend a real architecture decision.

Maps to brochure outcomes:
- Bring cloud+DB+security together; end-to-end deployment of an app with a managed database; comprehensive security controls; backup/DR.
- **Capstone:** deploy a sample app to Azure with a managed database + security controls.
- **Deliverables:** architecture diagram, security checklist (extends Day 4's), backup plan (extends Day 3's RTO/RPO work).
- **Final assessment:** capstone submission + short oral defense.

### 2. Minute-by-minute schedule (09:00–17:00)

| Time | Segment | Format | Facilitator notes |
|---|---|---|---|
| 09:00–09:20 | Recap Days 1-4 + capstone brief walkthrough | Discussion | Explicitly re-show how each day's work feeds today: Day 1 (service selection) → Day 2/3 (managed DB) → Day 4 (security checklist). |
| 09:20–09:40 | Capstone requirements Q&A + team/individual assignment confirmation | Discussion | Confirm whether capstone is solo or paired — recommend pairing weaker with stronger learners here explicitly (see engagement tactics). |
| 09:40–10:40 | Teaching Block 1: Integrated architecture patterns (App Service + Azure SQL DB + security controls end-to-end) | Lecture + demo | Live-demo the full reference architecture once, end-to-end, at a brisk pace — this is the "here's the shape of what you're building" moment. |
| 10:40–10:55 | **Short break** | — | — |
| 10:55–11:45 | Teaching Block 2: Backup/DR planning for the capstone (applying Day 3 concepts) | Lecture + discussion | Walk through the backup plan deliverable template; connect explicitly to RTO/RPO worksheet from Day 3. |
| 11:45–12:30 | Capstone work session 1: architecture diagram + resource deployment | Lab | Learners begin deploying: App Service + Azure SQL DB, applying naming/tagging conventions. |
| 12:30–13:30 | **Lunch** | — | — |
| 13:30–15:00 | Capstone work session 2: apply security controls + complete security checklist + backup plan | Lab | This is the longest single block of the week — circulate heavily; flag any learner not making progress by the halfway mark (14:15) for direct intervention. |
| 15:00–15:15 | **Short break** | — | — |
| 15:15–16:00 | Capstone work session 3: finalize deliverables (architecture diagram, security checklist, backup plan) + prepare oral defense | Lab | Give a firm "deliverables lock" time; use remaining minutes for oral defense prep, not new work. |
| 16:00–16:50 | **Capstone submissions + short oral defenses** | Discussion/assessment | 3-5 minutes per learner/pair: what did you build, why these choices, what would you change with more time/budget. |
| 16:50–17:00 | Course wrap: outcomes recap, certificates/next steps, final feedback | Discussion | Explicitly restate the brochure outcomes achieved; collect course feedback. |

### 3. Teaching flow & talking points

**Topic: Integrated architecture (App Service + Azure SQL DB + security controls)**
- **How to explain it:** Walk the request path end-to-end: user/browser → TLS → App Service (PaaS compute) → authenticated, least-privilege connection → Azure SQL Database (TDE at rest, private endpoint/firewall-restricted) → monitored by Defender for Cloud/Defender for SQL.
- **Analogy / regulator example:** "This is the same shape as a public-facing licensing or royalty-payment portal: citizens/licensees hit a web front end (App Service), which talks to the licensing database (Azure SQL DB) over an encrypted, tightly-restricted connection, with monitoring watching for anomalies — every piece we've covered this week shows up in this one diagram."
- **Common misconception to preempt:** "Deploying it correctly once means it's secure forever." Reinforce Day 4's patching/vulnerability management theme: this is an operational posture (Update Manager, Defender recommendations, periodic access reviews), not a one-time deployment checkbox.
- **Check-for-understanding questions:**
  1. "Trace the path of a query from a licensee's browser to the database — name every point where a security control from Day 4 applies."
  2. "Which part of this architecture is IaaS-flavored (if any), and which is PaaS? Why did we choose PaaS as the default here?"

**Topic: Backup/DR planning for the capstone**
- **How to explain it:** A backup plan deliverable should state explicit RTO/RPO targets, which Azure capability meets each (automated backups/PITR for RPO of minutes-to-hours; geo-replication/failover groups for RTO of minutes), and the operational trigger/procedure for invoking a restore or failover.
- **Analogy / regulator example:** Tie directly back to Day 3: "If this were the production reporting portal, what RTO/RPO would you actually defend to agency leadership, and which Azure feature is your evidence you can meet it?"
- **Common misconception to preempt:** "A backup plan is just 'Azure backs it up automatically, done.'" Push learners to state specific numbers (RTO/RPO) and specific Azure features, not just "it's handled."
- **Check-for-understanding questions:**
  1. "What specific RTO and RPO are you committing to in your backup plan, and what Azure feature is your evidence?"

### 4. Facilitator prep checklist (Day 5)
- [ ] Pre-build and test the **full reference architecture** (App Service + Azure SQL DB + security controls) yourself end-to-end within 48 hours, timing how long deployment actually takes on a fresh resource group — this calibrates your work-session time allocations.
- [ ] Prepare the capstone brief document, architecture diagram template, security checklist template (extended from Day 4), and backup plan template — hand out or confirm access at 09:00.
- [ ] Confirm the oral defense rubric/criteria and communicate it to learners at the 09:20 Q&A, not for the first time at 16:00.
- [ ] Pre-plan pairing assignments (weaker + stronger) before the day starts — do not leave this to chance on the busiest day of the week.
- [ ] Verify every learner's resource group and quota headroom (free-offer compute-seconds/storage) can support one more App Service + Azure SQL DB deployment — flag anyone near free-tier limits from earlier in the week (see cost-safety guardrails) and have a plan (new free-tier resource, or shared/instructor-hosted capstone environment) ready before the day starts.
- [ ] Prepare the end-of-course cleanup instructions (delete resource group) to hand out at 16:50 — see guardrails.
- [ ] Have certificates/completion materials ready.

### 5. Materials/handouts referenced
- Capstone brief: `Day5_Capstone_Brief.pdf`
- Architecture diagram template: `Day5_ArchitectureDiagram_Template.pptx` (or draw.io template)
- Security checklist (extended): `Day5_SecurityChecklist_Extended.xlsx`
- Backup plan template: `Day5_BackupPlan_Template.docx`
- Oral defense rubric: `Day5_OralDefense_Rubric.pdf`
- Course-end cleanup guide: `Day5_ResourceCleanup_Instructions.pdf`

### 6. Energy & engagement tactics
- Pairing is highest-stakes today: pair each weaker learner (per your Day 1 self-assessment + observed performance Days 2-4) with a stronger one, but assign the weaker learner as **lead presenter** for the oral defense — this forces genuine understanding transfer during the work sessions rather than the stronger learner carrying the whole deliverable silently.
- Fatigue is real by Day 5 — use the 09:00 recap to re-energize with visible pride ("look at everything you've built this week") before diving into the heaviest lab day.
- During the long 13:30-15:00 work session, do a visible "checkpoint lap" at 14:15 (halfway) and explicitly ask each pod "what's your status" rather than waiting to be asked for help — some learners won't flag they're stuck.
- Make the oral defenses genuinely low-stakes but real: frame it as "defend this to a skeptical but supportive colleague," not an exam — reduces anxiety while keeping the accountability that makes the defense valuable.
- Close the course by explicitly naming how each day's brochure outcome showed up in today's capstone — this cements the "integrated" framing the course promises.

---

## Assessment Cadence

The course uses **continuous, low-stakes formative checks** building toward the **Day 5 capstone + oral defense** as the summative assessment. No single day is a "test" — each day's activities are deliberately designed as rehearsal for a capstone component.

| Day | Formative activity | Signal it gives the instructor | Capstone component it rehearses |
|---|---|---|---|
| Day 1 | Case study exercise: recommend Azure services from business requirements; exit poll (3 Qs) | Can the learner reason about service selection trade-offs, not just recite definitions? | Capstone's architecture/service-selection reasoning and oral defense justification |
| Day 2 | Inventory schema design + CRUD SQL lab; exit poll | Can the learner model relational data and manipulate it correctly? | The managed database component of the capstone deployment |
| Day 3 | Performance diagnosis lab (execution plan before/after); exit poll | Can the learner read diagnostic evidence and connect it to a fix? | Backup/DR plan deliverable's RTO/RPO reasoning; general "show your evidence" habit needed in oral defense |
| Day 4 | App-stack hardening lab + security checklist deliverable | Can the learner apply concrete controls (TDE, RBAC, MFA/Conditional Access, firewall) and document them? | Security checklist deliverable (extended directly, not just rehearsed) |
| Day 5 | **Capstone: deployed app + managed DB + security controls; deliverables (architecture diagram, security checklist, backup plan); oral defense** | Summative: does the learner integrate everything and can they defend their choices under light questioning? | — (this is the target) |

**Instructor practice:** Keep brief (2-3 sentence) daily notes per learner after each exit poll and lab circulation — these notes drive your Day 5 pairing decisions and let you flag anyone falling behind early enough to intervene (an extra 15 minutes at lunch, a targeted example) rather than discovering a gap for the first time during the capstone.

**Exit poll format (all days):** 3 quick questions, mix of the check-for-understanding questions listed in each day's talking points, answered via show-of-hands, sticky notes, or a simple poll tool. Purpose is instructor signal, not grading.

---

## Contingency & Troubleshooting

| Scenario | Immediate action | Follow-up |
|---|---|---|
| **Azure portal/resource creation is slow** | Keep teaching the concept while resources provision in the background; have learners start reading the next lab step while waiting. Never let the room sit idle watching a spinner. | If delays exceed ~10 minutes for multiple learners, switch that pod to the local Docker fallback for the remainder of the lab and let them reconnect to Azure once resources are ready, comparing results. |
| **Learners can't create resources (permissions/quota error)** | Check the error message together — most common causes: subscription not fully activated yet, region restricted for free tier, or the free-offer database count (10 GP serverless DBs) already reached. | Direct affected learners to create the resource in a different supported region, or pair them with a learner whose environment works for that lab (temporary shared screen), and follow up individually at break. |
| **Free-tier compute/storage limits hit mid-course** (100,000 vCore-seconds or 32 GB data/32 GB backup exceeded on Azure SQL free offer) | Explain the auto-pause behavior: once the free monthly limit is reached, set the database to **"Auto-pause the database until next month"** rather than incurring charges ([Microsoft Learn — Azure SQL free offer](https://learn.microsoft.com/en-us/azure/azure-sql/database/free-offer)). | For the remainder of the day, that learner works paired with a partner or on the local Docker fallback; note it and check their standing before Day 5's capstone provisioning. |
| **PostgreSQL free-tier hours (750/month Burstable B1MS) exhausted** | Same auto-pause/cost-awareness conversation; confirm learner is on the PostgreSQL alternative track only if they opted in — most learners should be on Azure SQL DB as primary. | Offer to switch them to the Azure SQL DB primary track if PostgreSQL quota becomes a recurring blocker. |
| **Unstable/lost internet connectivity (Lagos power/fibre issues)** | Pivot the whole room immediately to the **pre-staged local Docker SQL Server/PostgreSQL fallback** — announce calmly: "We'll continue locally so no one loses lab time; everything about the exercise is identical, only the connection target changes." Switch connection strings from `<server>.database.windows.net` to `localhost` per the local lab guide variant. | Once connectivity returns, optionally have learners repeat the exercise against their real Azure resource for comparison, or simply move on if time is tight — the learning objective was already met locally. |
| **Corporate firewall blocks port 1433/5432** | Confirm with IT contact whether a temporary allow-list can be applied same-day; in the meantime, use the local Docker fallback for that learner/pod. | Escalate to the pre-course network checklist owner so this is fixed before the next day's labs, not discovered fresh each morning. |
| **A learner's laptop can't run Docker (insufficient RAM/permissions)** | Pair them with a neighbor who can run the container locally (shared screen/driver-navigator), or fall back to your instructor machine as a shared demo target for that pair only. | Flag for IT support follow-up if it's a recurring hardware/permissions constraint across multiple course deliveries. |
| **Learner significantly behind by midday** | Quiet 1-on-1 check at the next break, not in front of the room; consider giving them a pre-completed checkpoint script to catch up to the group's current step rather than making them debug from scratch under time pressure. | Note it for Day 5 pairing decisions. |
| **Room AV/projector failure** | Continue via learners' own screens with you narrating and sharing exact commands in a shared doc/chat; use the whiteboard for diagrams. | Test AV first thing each morning going forward, not just Day 1. |

---

## Facilitator Confidence Primer

Before teaching, be rock-solid on these 8-10 concepts. Each includes a crisp refresher you should be able to state fluently without notes.

**1. IaaS vs. PaaS vs. SaaS and the shared responsibility model**
Refresher: Responsibility for OS/patching/runtime shifts from customer (IaaS) to provider (PaaS) to fully provider-managed (SaaS); the customer always retains responsibility for data, identity, and access configuration regardless of model.

**2. Azure SQL Database free offer terms (exact numbers)**
Refresher: Up to **10 General Purpose serverless databases per subscription**; **100,000 vCore-seconds compute + 32 GB data + 32 GB backup storage free per month, for the life of the subscription**; serverless auto-pause when idle. Enroll via "Start free" at [aka.ms/azuresqlhub](https://aka.ms/azuresqlhub). Source: [Microsoft Learn](https://learn.microsoft.com/en-us/azure/azure-sql/database/free-offer).

**3. Azure Database for PostgreSQL Flexible Server free tier terms**
Refresher: **Free for 12 months** with an Azure free account — **750 hours of Burstable B1MS compute + 32 GB storage + 32 GB backup per month**. Source: [Microsoft Learn](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/how-to-deploy-on-azure-free-account).

**4. Normalization (1NF-3NF) — able to normalize a flat table live, on the spot**
Refresher: 1NF removes repeating groups/multivalued columns; 2NF removes partial dependencies on part of a composite key; 3NF removes transitive dependencies (non-key columns depending on other non-key columns). Practice normalizing the flat inspection-report example until you can do it without hesitation on a whiteboard.

**5. Reading an execution plan and diagnosing a table scan vs. index seek**
Refresher: A table/clustered index scan touching every row for a selective query is the classic red flag; compare estimated vs. actual row counts for statistics staleness; know how to demo adding an index and re-running to show the seek replace the scan.

**6. RTO vs. RPO, and which Azure feature addresses which**
Refresher: RPO (Recovery Point Objective) = how much data you can afford to lose, addressed by backup frequency/PITR; RTO (Recovery Time Objective) = how fast you must be back online, addressed by geo-replication/failover groups. Be able to state a concrete example RTO/RPO pair and map it to specific Azure features without hesitating.

**7. TDE vs. Always Encrypted vs. TLS in transit — what each actually protects against**
Refresher: TDE encrypts data at rest transparently (protects against stolen physical media/backups, not against authorized queries); Always Encrypted keeps sensitive columns encrypted even from database engine/DBA view for specific use cases; TLS protects data moving over the network between client and server. None of the three substitutes for access control.

**8. Entra ID, RBAC, least privilege, and Conditional Access — including the current MFA deadline**
Refresher: Microsoft requires **MFA for all Azure portal access, including Global Admins, from October 1, 2026** ([Microsoft Tech Community](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/microsoft-entra-id-security-updates-what-organizations-need-to-do-now/4522024)); Conditional Access is configured in **Microsoft Entra admin center > Entra ID > Conditional Access** ([Microsoft Learn](https://learn.microsoft.com/en-us/entra/identity/conditional-access/)). Be able to state this date and navigation path cold — it's a check-for-understanding question you will be asked back.

**9. Cost-safety guardrails for every lab (say these without looking them up)**
Refresher: Free-offer Azure SQL DB with "auto-pause until next month" once free limits are hit; deallocate VMs and stop App Service plans at end of each day; delete the resource group at course end; one resource group per learner named `rg-<initials>-course`, tagged `course=cdcs`; disconnect Object Explorer when idle so serverless auto-pauses.

**10. The integrated capstone reference architecture end-to-end**
Refresher: Browser/user → TLS → App Service (PaaS) → least-privilege authenticated connection → Azure SQL Database (TDE, firewall/private endpoint restricted) → monitored by Microsoft Defender for Cloud/Defender for SQL, with backups/PITR and optional geo-replication/failover groups for continuity. You should be able to draw this from memory in under 60 seconds — you will draw it live on Day 5.

---

*End of Facilitation Plan. Pair this document with the Day-specific lab guides, datasets, and slide decks referenced throughout. Review the relevant day's section — and the Confidence Primer — the night before each delivery day.*
