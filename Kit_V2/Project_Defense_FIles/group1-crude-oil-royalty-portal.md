# Day 5 Capstone — Group 1: Crude Oil Production & Royalty Reporting Portal

> Cloud, Database & Cybersecurity Essentials — Integrated IT Fundamentals Training
> Module: Day 5 — Integrated Capstone Project

## Scenario

Licensed upstream operators (oil & gas companies) submit monthly crude oil production and royalty data for regulator review, validation, and audit. Field officers in Lagos, Port Harcourt, Warri and Kaduna also log inspection visit records against the same data.

## Business Requirements

| # | Requirement | Detail |
|---|---|---|
| 1 | Users | ~150 external operator company users plus ~40 internal regulator staff. Usage is heavy in the first 10 business days of each month, spiky the rest of the time. |
| 2 | Availability | Must be available during business hours nationwide. Brief overnight outages are tolerable, but not during the monthly submission window. |
| 3 | Data sensitivity | Production volumes and royalty figures are commercially sensitive and feed directly into government revenue calculations. |
| 4 | Data residency | Regulator policy prefers data to stay within Africa. If no suitable Azure region exists, the choice must be documented and justified on compliance grounds. |
| 5 | Team skills | A small 4-person IT team, strong in Windows Server and SQL, with limited Linux/Kubernetes experience and no dedicated 24/7 operations team. |
| 6 | Budget | Constrained public-sector budget. Predictable, minimal-maintenance costs are preferred over raw performance headroom. |
| 7 | Growth | Expected to expand to cover downstream fuel distribution monitoring within 18 months, roughly doubling data volume and adding ~100 more external users. |
| 8 | Integration | Must eventually integrate with an existing on-prem licensing database (a future phase, not this one). |
| 9 | Audit | Every data change must be traceable to a specific user and timestamp — a regulatory audit trail requirement. |

## Your Task

For this scenario, decide and justify each of the following. One or two sentences per item is enough — the reasoning matters more than the length.

1. **Compute** — IaaS or PaaS? One sentence tying your choice to the team's skill level and how spiky or steady your usage pattern is.
2. **Database** — Azure SQL Database, Cosmos DB, or something else? One sentence on why, tied to whether your data is structured/relational or more flexible/high-volume.
3. **Region** — Pick a region and justify data residency in one sentence. There is no Azure region in Nigeria — state how you'd justify your choice anyway.
4. **Security control** — Name one Day 4 control you'd apply first (e.g. Conditional Access, sensitivity labels, PIM, Defender for Cloud) and why it matters most for this scenario.
5. **Architecture sketch** — A simple box-and-arrow diagram showing compute, database, and where your chosen security control sits. It doesn't need to be polished.

## Deliverable

- A short answer to each of the five task items above, each referencing at least one numbered requirement from the table.
- A one-line final recommendation, in this exact form:

  > For [your scenario], we recommend [compute] + [database] in [region], with [security control] as our first line of defense, because ______.

- Be ready to present for 5–7 minutes.

## Presentation Rubric

| Criterion | What we're looking for |
|---|---|
| Reasoning, not memorization | Can the group explain *why*, tied to their scenario's specific requirements — not just name a service. |
| Cross-day integration | Did they pull in something from cloud, data, and security — not just one day's material. |
| Residency reasoning | Did they engage with the "no Nigerian region" problem rather than skip it. |
| Presentation clarity | Is the sketch and explanation understandable to someone who didn't build it. |

---

*Part of the Cloud, Database & Cybersecurity Essentials 5-day training. See the other four group briefs in this repository for the full capstone set.*
