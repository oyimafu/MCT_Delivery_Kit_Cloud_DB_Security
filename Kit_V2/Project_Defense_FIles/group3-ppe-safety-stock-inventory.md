# Day 5 Capstone — Group 3: PPE & Safety Stock Inventory Management

> Cloud, Database & Cybersecurity Essentials — Integrated IT Fundamentals Training
> Module: Day 5 — Integrated Capstone Project

## Scenario

An organization-wide extension of the inventory system built earlier this week — now covering every regulator facility, with low-stock alerts and supplier reorder workflows.

## Business Requirements

| # | Requirement | Detail |
|---|---|---|
| 1 | Users | ~30 internal facility managers and store officers across all regulator facilities. No external users. |
| 2 | Availability | Needed during normal working hours only. A few hours of overnight downtime is acceptable. |
| 3 | Data sensitivity | Stock levels and supplier details. Low sensitivity — no personal or regulated financial data involved. |
| 4 | Data residency | Same regulator policy applies. This is the lowest-stakes system for residency — worth deciding as a group whether it deserves the same weight as Group 1's. |
| 5 | Team skills | The same 4-person IT team. This system is the closest to what they already manage day-to-day. |
| 6 | Budget | The most budget-constrained of all five systems — treated as a lower-priority internal tool. |
| 7 | Growth | Expected to scale from 4 facilities today to all ~15 regulator facilities within a year. |
| 8 | Integration | Should eventually integrate with the procurement/finance system for automatic reordering. |
| 9 | Audit | Stock movements must be traceable to a specific staff member — a loss-prevention requirement. |

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
