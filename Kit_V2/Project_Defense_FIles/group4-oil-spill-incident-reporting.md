# Day 5 Capstone — Group 4: Oil Spill & Environmental Incident Reporting

> Cloud, Database & Cybersecurity Essentials — Integrated IT Fundamentals Training
> Module: Day 5 — Integrated Capstone Project

## Scenario

Field officers and the general public can both report spills or environmental incidents, with photo upload and GPS location, alongside an internal investigation and review workflow.

## Business Requirements

| # | Requirement | Detail |
|---|---|---|
| 1 | Users | The general public (unlimited, unauthenticated submissions) plus ~20 internal reviewers and investigators. |
| 2 | Availability | True 24/7. Incidents and spills don't wait for business hours — downtime directly risks missed reports. |
| 3 | Data sensitivity | High. Some reports involve active investigations, potential litigation, and personal data (reporter contact details) under NDPA/NDPR. |
| 4 | Data residency | Same regulator policy applies. The public-facing nature of this system raises the compliance stakes further. |
| 5 | Team skills | The same small IT team — this is the most operationally critical system they will be asked to run. |
| 6 | Budget | More flexible than the other systems, given the regulatory and legal exposure of getting this one wrong. |
| 7 | Growth | Reporting volume is expected to grow as public awareness campaigns expand. |
| 8 | Integration | Needs to eventually integrate with a GIS/mapping system to plot incident locations. |
| 9 | Audit | Every report, status change, and investigator action must be fully traceable — this data may become legal evidence. |

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
