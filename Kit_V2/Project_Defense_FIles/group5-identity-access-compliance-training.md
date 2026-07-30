# Day 5 Capstone — Group 5: Contractor & Staff Identity, Access & Compliance Training

> Cloud, Database & Cybersecurity Essentials — Integrated IT Fundamentals Training
> Module: Day 5 — Integrated Capstone Project

## Scenario

Tracks which contractors and staff have completed mandatory safety and security training, and manages who can access which facility systems — including the other four systems in this capstone.

## Business Requirements

| # | Requirement | Detail |
|---|---|---|
| 1 | Users | ~40 internal staff plus ~200 contractors across all facilities. This system controls who can access every other system in the capstone. |
| 2 | Availability | Needed during business hours. Brief downtime is tolerable, but it blocks access to everything else while it's down. |
| 3 | Data sensitivity | High. Personal data — identity verification, training records — falls directly under NDPA/NDPR. |
| 4 | Data residency | Same regulator policy applies. The personal-data element adds extra weight to the residency/compliance justification for this system specifically. |
| 5 | Team skills | The same 4-person IT team. This system requires the deepest identity and security expertise of any group's system. |
| 6 | Budget | Constrained, but treated as foundational infrastructure the other four systems depend on. |
| 7 | Growth | Contractor headcount is expected to grow significantly as field operations expand. |
| 8 | Integration | Must eventually integrate with the HR system for automatic onboarding and offboarding. |
| 9 | Audit | Every access grant, revocation, and training completion must be traceable — this is the audit trail for the audit trail. |

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
