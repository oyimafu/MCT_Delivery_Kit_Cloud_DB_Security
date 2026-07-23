# Lab — Day 1: Cloud Service Selection Case Study

**Course:** Cloud, Database & Cybersecurity Essentials — Integrated IT Fundamentals Training
**Module:** Day 1 — Cloud Fundamentals Recap
**Hands-on activity (brochure):** *Analyze a cloud service selection case study and recommend appropriate services based on business requirements.*

## Objective
Given a realistic business requirements brief for a crude-oil production reporting portal at a Nigerian petroleum regulator, learners will:
1. Compare IaaS vs. PaaS deployment models against the stated requirements.
2. Select a managed database service and justify it.
3. Select an Azure region and justify it against Nigerian data-residency/NDPR considerations.
4. Complete a decision matrix and present a short justification.

## Estimated duration
2 hours (case study read + individual/pair work: 45 min; decision matrix completion: 45 min; group readout & instructor debrief: 30 min).

## Prerequisites
- No hands-on cloud access required for this lab — it is analysis/paper-based (or shared doc-based).
- Basic familiarity with IaaS/PaaS terminology from the Day 1 lecture.
- Optional: an Azure account signed in to browse the [Azure regions page](https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/) and the [Azure products by region page](https://azure.microsoft.com/en-us/explore/global-infrastructure/products-by-region/) for reference during the exercise.

## Cost-safety reminders
- This lab does **not** require deploying any resources — it is a selection/justification exercise.
- If learners want to browse the Azure portal to inspect pricing or region availability, they may sign in read-only; do **not** provision anything yet (deployment starts Day 2).
- If your organization later implements this design for real, remember the course guardrails apply to the lab environment only: production sizing/cost decisions need a full TCO exercise, not the free-tier assumptions used in labs.

---

## Part A — Sample Requirements Brief (hand this to learners)

> **Project: Crude Oil Production Reporting Portal**
>
> The regulator needs a web portal where licensed upstream operators (oil & gas companies) submit monthly crude oil production and royalty data for review, validation, and audit. Field officers in Lagos, Port Harcourt, Warri and Kaduna also need to log inspection visit records against the same data.
>
> **Business requirements:**
> 1. **Users:** ~150 operator company users (external) + ~40 regulator staff (internal), submitting/reviewing data mainly in the first 10 business days of each month; usage is spiky, not constant.
> 2. **Availability:** Must be available during business hours nationwide; brief outages tolerable overnight but not during the monthly submission window.
> 3. **Data sensitivity:** Production volumes and royalty figures are commercially sensitive and regulated; some data supports government revenue calculations. Falls under the **Nigeria Data Protection Act (NDPA) 2023 / NDPR** obligations for any personal data of company contacts.
> 4. **Data residency:** Regulator policy prefers data to remain within Africa where a suitable Azure region exists; if not available, data must at minimum stay in a region with strong contractual data-protection guarantees, and residency decisions must be documented and justified.
> 5. **Team skills:** The regulator's IT team is small (4 people), skilled in Windows Server administration and SQL, with limited Linux/Kubernetes experience and no dedicated 24/7 ops team.
> 6. **Budget:** Constrained public-sector budget; strong preference for predictable, minimal-maintenance costs over raw performance headroom.
> 7. **Growth:** Expected to expand to cover downstream fuel distribution monitoring within 18 months, roughly doubling data volume and adding ~100 more external users.
> 8. **Integration:** Must eventually integrate with an existing on-prem licensing database (a future phase, not this phase).
> 9. **Audit:** All data changes must be traceable to a specific user and timestamp (regulatory audit trail requirement).
>
> **Your task:** Recommend (a) IaaS or PaaS for the web/app tier, (b) a specific Azure database service, (c) an Azure region, and (d) a high-level architecture sketch. Justify every choice against the numbered requirements above.

---

## Part B — Decision Matrix Template (learners fill in)

Copy this table into your own notes or the provided worksheet. Score each option **1 (poor fit) to 5 (excellent fit)** against each weighted criterion, then multiply score × weight and total the columns.

### Matrix 1 — Compute Model (IaaS vs. PaaS)

| Criterion | Weight | IaaS (Azure VMs) — Score | IaaS — Weighted | PaaS (Azure App Service) — Score | PaaS — Weighted |
|---|---|---|---|---|---|
| Matches small team's ops capacity (req. 5) | 25% | | | | |
| Cost predictability / minimal maintenance (req. 6) | 20% | | | | |
| Ability to handle spiky monthly load (req. 1) | 20% | | | | |
| Time-to-deploy for course/lab timeline | 15% | | | | |
| Room to scale for downstream-monitoring growth (req. 7) | 10% | | | | |
| Security patching burden (Day 4 topic tie-in) | 10% | | | | |
| **Total** | 100% | | **____** | | **____** |

### Matrix 2 — Database Service

| Criterion | Weight | Azure SQL Database (PaaS) | PostgreSQL Flexible Server (PaaS) | VM + Self-Managed SQL (IaaS) |
|---|---|---|---|---|
| Team's existing SQL Server skill fit (req. 5) | 25% | | | |
| Built-in backup/PITR/geo-replication (audit + BC, req. 9) | 20% | | | |
| Cost predictability at small scale (req. 6) | 20% | | | |
| Patching/maintenance burden | 15% | | | |
| Free-tier availability for training/lab reuse | 10% | | | |
| Growth headroom (req. 7) | 10% | | | |
| **Total** | 100% | **____** | **____** | **____** |

### Matrix 3 — Azure Region

| Criterion | Weight | Candidate Region A: ______ | Candidate Region B: ______ | Candidate Region C: ______ |
|---|---|---|---|---|
| Data residency / sovereignty fit (req. 3, 4) | 35% | | | |
| Latency to Nigerian users (Lagos/PHC/Warri/Kaduna) | 25% | | | |
| Service availability (Azure SQL, App Service, Key Vault all present) | 20% | | | |
| Disaster-recovery pairing option available | 10% | | | |
| Cost tier for region | 10% | | | |
| **Total** | 100% | **____** | **____** | **____** |

> Tip: check current region and service availability at [Azure global infrastructure — geographies](https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/) and [Azure products available by region](https://azure.microsoft.com/en-us/explore/global-infrastructure/products-by-region/) before scoring Matrix 3.

### Part B deliverable
Write a **one-paragraph justification** per matrix (3 paragraphs total) explaining your top-scoring choice, referencing the specific numbered requirement(s) it satisfies.

---

## Part C — Step-by-step: optional portal reconnaissance (no deployment)

If time and connectivity allow, have learners do this quick, safe, read-only walkthrough to ground the decision matrix in real portal facts (no resources are created):

1. Sign in to the [Azure portal](https://portal.azure.com).
2. In the search bar, type **"App Services"** and open the App Services overview blade (do not click Create). [Screenshot: App Services overview blade, no resources yet]
3. Note the pricing tier options visible if you click **Create > Web App** and reach the **Pricing plan** section — then **cancel out without creating anything**. [Screenshot: Web App Create — Pricing plan step, cancel before Review+Create]
4. Search **"Azure SQL"** and open the **Azure SQL** hub landing page (aka.ms/azuresqlhub) to see the free-offer callout. [Screenshot: Azure SQL hub free-offer banner]
5. Search **"Regions"** or browse the region list from the top-right globe icon in the portal to see which regions your subscription can deploy to. [Screenshot: Region picker dropdown]
6. Close without creating any resource.

## Expected results / checkpoints
- [ ] Requirements brief read and the 9 numbered requirements individually addressed at least once across the three matrices.
- [ ] All three decision matrices completed with scores, weights, and totals calculated.
- [ ] Top choice identified in each matrix with a numeric total.
- [ ] Three justification paragraphs written, each citing specific requirement numbers.
- [ ] (If Part C completed) No Azure resources were actually created — verify via **Resource groups** blade showing no new lab resource group yet.

## Troubleshooting tips
- **"I can't decide between App Service and VMs — both score similarly."** Re-read requirement 5 (team skills) and requirement 6 (budget/maintenance) — for a 4-person team with no 24/7 ops, PaaS should win decisively once maintenance burden is weighted honestly.
- **"No African Azure region seems to fully satisfy residency.**" This is intentional — there is deliberately no Azure region physically located in Nigeria today. The model answer discusses how to justify a regional choice using contractual/compliance controls when no local region exists. Document this reasoning explicitly; do not skip requirement 3/4.
- **Portal shows "You do not have permission to create resources"**: expected/fine for this lab — Part C is read-only reconnaissance only.

## PostgreSQL alternative note
If your organization's target production stack is PostgreSQL rather than SQL Server, redo Matrix 2 substituting **Azure Database for PostgreSQL Flexible Server** as the primary option and Azure SQL Database as the alternative. The same weighting logic applies; the free-tier facts for PostgreSQL Flexible Server (750 hours Burstable B1MS + 32 GB storage + 32 GB backup per month, free for 12 months) are in the Day 2 lab guide and should be factored into the cost-predictability criterion.

## What to submit for grading
1. Completed decision matrix (all three tables, filled in).
2. Three justification paragraphs (Part B deliverable).
3. Your final one-line recommendation: *"For the Crude Oil Production Reporting Portal, we recommend [PaaS/IaaS] compute, [database service], in [region], because ______."*
4. (Optional, if Part C done) A note confirming no resources were left provisioned.

---

## Instructor Model Answer (for grading reference — do not distribute to learners before the exercise)

**Compute model: PaaS — Azure App Service.**
The regulator's 4-person team has strong SQL/Windows admin skills but no dedicated 24/7 ops capacity and a constrained budget that favors predictable, minimal-maintenance costs (requirements 5, 6). App Service handles OS patching, scaling, and load balancing automatically, and its autoscale rules absorb the spiky first-10-days-of-month load pattern (requirement 1) without the team having to manage VM patch cycles or capacity planning by hand. IaaS (Azure VMs) would give more low-level control but directly conflicts with requirements 5 and 6, and increases the Day 4 security-patching burden the course itself warns about.

**Database service: Azure SQL Database.**
The team's existing SQL Server skills (requirement 5) transfer directly, keeping training cost low. Azure SQL Database provides automated backups with Point-in-Time Restore and (at higher tiers) active geo-replication/failover groups out of the box, satisfying the audit-trail and business-continuity requirement (requirement 9) without custom engineering. Its serverless free-offer tier (used throughout this course) also lets the regulator's team prototype and train on the exact same service they will run in production, and the built-in cost/compute predictability of serverless auto-pause suits requirement 6. PostgreSQL Flexible Server is a credible secondary choice if the team's skills were more Postgres-oriented, but that is not the case here.

**Region: a widely available Azure region with strong data-protection commitments, explicitly documented — e.g. an EU region such as West Europe, chosen and justified through Microsoft's contractual Data Protection Addendum and EU Data Boundary commitments �� rather than assuming an in-country region exists.**
As of this course, there is no Azure region physically located in Nigeria, so requirement 3/4 cannot be satisfied by picking an African region for compute — this is the key teaching point of this exercise: learners must recognize the absence of a local region and instead build a documented compliance justification (contractual safeguards, Microsoft's data protection terms, and NDPA/NDPR Article-style cross-border transfer justifications) rather than silently ignoring the requirement. Any reasonable, clearly-justified region choice paired with an explicit residency/compliance rationale should score well; the model answer rewards the *reasoning process*, not one "correct" region name. Learners should be encouraged to check current availability themselves at [Azure global infrastructure — geographies](https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/).

**Architecture sketch (high level):** Azure App Service (PaaS, autoscale) → Azure SQL Database (serverless, general purpose) → Key Vault for secrets → Microsoft Entra ID for operator/staff authentication with RBAC roles separating "external submitter" from "internal reviewer" → diagnostic logs to Log Analytics for the audit trail requirement. This maps directly into the Day 2–5 labs, where learners build exactly this database tier and then harden it.

**Common learner mistakes to watch for during debrief:**
- Choosing IaaS "for control" without weighing the team-skills/maintenance requirement — probe this in discussion.
- Picking a region purely on lowest listed price without addressing residency/compliance reasoning.
- Forgetting requirement 9 (audit trail) when comparing database services — this should favor managed services with built-in change tracking and backup history over self-managed VM databases.
