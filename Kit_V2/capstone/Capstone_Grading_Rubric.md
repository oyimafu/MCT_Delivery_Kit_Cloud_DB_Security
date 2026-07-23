# Capstone Grading Rubric
## Cloud, Database & Cybersecurity Essentials — Day 5 Final Assessment

**Total: 100 points**
**Pass threshold: 70 / 100**, with a minimum of 60% of the points available in **each** of the four graded sections (Architecture Diagram, Security Checklist, Backup/DR Plan, Oral Defense). A learner who scores below 60% in any single section fails the capstone regardless of total score, and must remediate that section.

| Deliverable | Points |
|---|---|
| 1. Architecture Diagram | 20 |
| 2. Security Checklist | 30 |
| 3. Backup & DR Plan | 25 |
| 4. Oral Defense | 25 |
| **Total** | **100** |

---

## 1. Architecture Diagram — 20 points

### 1.1 Architecture correctness & completeness (10 points)
| Level | Points | Description |
|---|---|---|
| Excellent | 9–10 | All required components present (App Service, Azure SQL Database, Entra ID, Key Vault, network control, Defender for Cloud, audit/logging) with correct relationships and data flow direction; matches what was actually built |
| Good | 7–8 | All major components present with mostly correct relationships; 1–2 minor omissions or inaccuracies (e.g., missing Key Vault link) |
| Developing | 4–6 | Diagram present but missing 2–3 components or shows incorrect data flow (e.g., app talking directly to DB with no auth path shown) |
| Insufficient | 0–3 | Diagram missing, incomprehensible, or fundamentally misrepresents the architecture |

### 1.2 Database configuration clarity (5 points)
| Level | Points | Description |
|---|---|---|
| Excellent | 5 | Tier/SKU, encryption status (TDE), TLS enforcement, and region are all explicitly labeled on or alongside the diagram |
| Good | 4 | Most of the above present; one item missing or unclear |
| Developing | 2–3 | Only tier/SKU shown; encryption/region not documented |
| Insufficient | 0–1 | No database configuration detail provided |

### 1.3 Security boundaries shown (5 points)
| Level | Points | Description |
|---|---|---|
| Excellent | 5 | Identity, network, data, and monitoring boundaries all clearly delineated and labeled; matches the actual controls implemented |
| Good | 4 | 3 of 4 boundary types clearly shown |
| Developing | 2–3 | 1–2 boundary types shown; boundaries vaguely indicated |
| Insufficient | 0–1 | No boundaries indicated; diagram is a flat/unstructured list of resources |

---

## 2. Security Checklist — 30 points

### 2.1 Identity & Access Management coverage (7 points)
| Level | Points | Description |
|---|---|---|
| Excellent | 6–7 | Entra ID sign-in, role separation, least-privilege RBAC scoping, MFA/Conditional Access posture, and Managed Identity usage all addressed with concrete implementation detail and evidence |
| Good | 5 | Most controls addressed with evidence; 1 control missing detail or evidence |
| Developing | 3–4 | Only basic sign-in addressed; role separation or least privilege superficial or missing |
| Insufficient | 0–2 | Identity section largely blank or generic ("we use Entra ID" with no detail) |

### 2.2 Network security coverage (6 points)
| Level | Points | Description |
|---|---|---|
| Excellent | 6 | Firewall rules/NSG/Private Endpoint decision explicitly justified; "Allow Azure services" setting reviewed; HTTPS Only confirmed; evidence attached |
| Good | 4–5 | Firewall rules documented; one item (e.g., HTTPS Only or "Allow Azure services") missing |
| Developing | 2–3 | Vague statement that "network security is configured" without specifics |
| Insufficient | 0–1 | Network section blank or default settings left unreviewed and unmentioned |

### 2.3 Data protection coverage (7 points)
| Level | Points | Description |
|---|---|---|
| Excellent | 6–7 | TDE confirmed, TLS enforcement confirmed, Key Vault used correctly for secrets, data minimization discussed, residency explicitly documented with NDPA framing |
| Good | 5 | TDE/TLS/Key Vault confirmed; residency or data minimization discussion thin |
| Developing | 3–4 | Encryption mentioned generically; no residency/NDPA discussion |
| Insufficient | 0–2 | Data protection section largely missing or factually wrong (e.g., claims TDE was "enabled" when it is on by default and not actually verified) |

### 2.4 Monitoring & threat detection coverage (5 points)
| Level | Points | Description |
|---|---|---|
| Excellent | 5 | Defender for Cloud/SQL enabled and findings reviewed; auditing enabled to a real destination; at least one alert configured and tested/described |
| Good | 4 | Defender and auditing enabled; alerting described but not demonstrated |
| Developing | 2–3 | Only one of Defender/auditing addressed |
| Insufficient | 0–1 | Monitoring section blank or purely theoretical |

### 2.5 Patching & secure configuration (5 points)
| Level | Points | Description |
|---|---|---|
| Excellent | 5 | Correctly explains PaaS shared-responsibility split (Microsoft patches platform; agency patches app/dependencies); confirms no default creds/open debug endpoints |
| Good | 4 | Responsibility split explained; secure configuration check less rigorous |
| Developing | 2–3 | Vague acknowledgment that "Azure handles patching" with no ownership clarity |
| Insufficient | 0–1 | Section missing or shows misunderstanding of PaaS vs. IaaS patching responsibility |

---

## 3. Backup & DR Plan — 25 points

### 3.1 RPO/RTO realism and justification (6 points)
| Level | Points | Description |
|---|---|---|
| Excellent | 6 | RPO/RTO values are realistic for Azure SQL Database capabilities (e.g., PITR-level RPO) and explicitly justified against regulatory/operational impact (audit trail integrity, reporting deadlines) |
| Good | 4–5 | Values reasonable; justification present but generic |
| Developing | 2–3 | Values given with no justification, or unrealistic (e.g., RPO = 0 with no mechanism to support it) |
| Insufficient | 0–1 | RPO/RTO section missing |

### 3.2 Backup schedule accuracy (5 points)
| Level | Points | Description |
|---|---|---|
| Excellent | 5 | Correctly describes Azure SQL Database's automatic full/differential/transaction-log backup cadence and retention window configured; redundancy tier (LRS/ZRS/GRS) stated and justified |
| Good | 4 | Backup cadence mostly correct; redundancy tier stated without justification |
| Developing | 2–3 | Generic statement ("backups are enabled") without describing Azure's actual mechanism |
| Insufficient | 0–1 | Backup schedule section missing or factually incorrect |

### 3.3 PITR / geo-restore / failover-group procedure detail (7 points)
| Level | Points | Description |
|---|---|---|
| Excellent | 6–7 | Step-by-step PITR procedure correct; at least one of geo-restore/active geo-replication/failover groups correctly explained and appropriately chosen (or appropriately deferred with reasoning) for this workload |
| Good | 5 | PITR procedure correct; geo-level protection mentioned but thin on detail |
| Developing | 3–4 | PITR procedure vague or partially incorrect (e.g., implies in-place restore) |
| Insufficient | 0–2 | Procedures missing or fundamentally incorrect |

### 3.4 Test-restore evidence (4 points)
| Level | Points | Description |
|---|---|---|
| Excellent | 4 | Test-restore actually performed; record complete with validation method, result, and time-to-restore compared to RTO |
| Good | 3 | Test-restore attempted; record mostly complete, one field missing |
| Developing | 1–2 | Test-restore described only in theory, not attempted |
| Insufficient | 0 | No test-restore evidence or record |

### 3.5 Roles, responsibilities & communication plan (3 points)
| Level | Points | Description |
|---|---|---|
| Excellent | 3 | All roles assigned to named people/functions including a DPO/regulatory liaison role; communication/sign-off plan present |
| Good | 2 | Roles assigned; communication plan thin or missing |
| Developing | 1 | Only one or two roles named |
| Insufficient | 0 | Roles/responsibilities section missing |

---

## 4. Oral Defense — 25 points
*(Scored using `Oral_Defense_Guide.md`; summarized here for the scoring sheet.)*

| Level | Points | Description |
|---|---|---|
| Excellent | 22–25 | Answers demonstrate deep understanding of own architecture, security tradeoffs, and regulatory implications; handles at least one follow-up/curveball question correctly; can explain what they would change for production |
| Good | 17–21 | Solid answers on most questions; 1–2 answers shallow or partially incorrect; recovers well when prompted |
| Developing | 11–16 | Can describe what was built but struggles to explain why (design rationale) or regulatory relevance; several answers need heavy prompting |
| Insufficient | 0–10 | Cannot explain own architecture or controls; answers contradict submitted deliverables; no regulatory awareness demonstrated |

---

## Instructor Scoring Sheet

**Learner/Team name:** ______________________  **Scenario (A/B):** _____  **Date:** __________

| Section | Criterion | Max | Score | Notes |
|---|---|---|---|---|
| 1. Architecture Diagram | 1.1 Architecture correctness & completeness | 10 | | |
| | 1.2 Database configuration clarity | 5 | | |
| | 1.3 Security boundaries shown | 5 | | |
| | **Subtotal** | **20** | | |
| 2. Security Checklist | 2.1 Identity & Access Management | 7 | | |
| | 2.2 Network security | 6 | | |
| | 2.3 Data protection | 7 | | |
| | 2.4 Monitoring & threat detection | 5 | | |
| | 2.5 Patching & secure configuration | 5 | | |
| | **Subtotal** | **30** | | |
| 3. Backup & DR Plan | 3.1 RPO/RTO realism & justification | 6 | | |
| | 3.2 Backup schedule accuracy | 5 | | |
| | 3.3 PITR/geo-restore/failover-group detail | 7 | | |
| | 3.4 Test-restore evidence | 4 | | |
| | 3.5 Roles, responsibilities & communication | 3 | | |
| | **Subtotal** | **25** | | |
| 4. Oral Defense | Overall defense quality (see guide) | 25 | | |
| | **Subtotal** | **25** | | |
| | **TOTAL** | **100** | | |

**Section minimums met (≥60% each)?**  Architecture [ Y / N ]  Checklist [ Y / N ]  Backup/DR [ Y / N ]  Oral Defense [ Y / N ]

**Overall result:**  ☐ PASS (≥70 total AND all section minimums met)  ☐ REMEDIATION REQUIRED (specify section): ______________

**Instructor comments:**
_______________________________________________________________
_______________________________________________________________

**Instructor signature:** ______________________  **Date:** __________

---

## Cross-Cutting Grading Themes (apply across all sections)

- **Cost-awareness:** Deduct up to 3 points overall (apply proportionally in Section 1 or 3) if the learner selected tiers beyond the Free/Basic ceiling without justification, or shows no awareness of cost implications of their choices (e.g., does not mention auto-pause, does not discuss geo-replication cost tradeoffs).
- **Regulatory alignment:** Award full marks in data protection (2.3) and RPO/RTO justification (3.1) only when NDPR/NDPA, data sovereignty, auditability, or availability-of-critical-systems framing is explicit and specific to the oil & gas regulator scenario — generic "GDPR-style" answers without the Nigerian regulatory framing should be capped at "Good," not "Excellent."
- **Evidence over assertion:** Any control claimed as "Implemented" without a corresponding screenshot/evidence reference should be scored as if it were "Partial," not "Implemented," in that criterion's level.
