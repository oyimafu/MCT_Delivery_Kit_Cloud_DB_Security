# Day 5 Capstone — Group 2: Pipeline & Facility Sensor Monitoring

> Cloud, Database & Cybersecurity Essentials — Integrated IT Fundamentals Training
> Module: Day 5 — Integrated Capstone Project

## Scenario

Pressure, flow, and temperature sensors across pipeline stations in Port Harcourt, Warri, and Kaduna stream readings every few seconds. Engineers need near-real-time dashboards and historical trend analysis to catch equipment failures early.

## Business Requirements

| # | Requirement | Detail |
|---|---|---|
| 1 | Users | ~25 internal engineering and operations staff monitoring dashboards. No external users. |
| 2 | Availability | Near-24/7. Pipeline safety monitoring cannot tolerate extended outages, including overnight. |
| 3 | Data sensitivity | Operational telemetry (pressure, flow, temperature). Not personally identifiable, but commercially sensitive with respect to throughput volumes. |
| 4 | Data residency | Same regulator policy applies: prefer an Africa-based region, and document a compliance justification if none is available. |
| 5 | Team skills | The same small 4-person IT team, with some exposure to IoT/telemetry ingestion but no dedicated data-engineering staff. |
| 6 | Budget | Constrained overall, but the regulator is willing to spend more on this system than the others given its safety criticality. |
| 7 | Growth | Sensor count is expected to double as more pipeline segments and pumping stations are instrumented. |
| 8 | Integration | Needs to eventually feed alerts into a control-room, SCADA-adjacent alerting system (a future phase). |
| 9 | Audit | Sensor readings and any manual overrides must be timestamped and traceable for incident investigations. |

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
