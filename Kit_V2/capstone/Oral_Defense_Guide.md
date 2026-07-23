# Oral Defense Guide
## Cloud, Database & Cybersecurity Essentials — Day 5 Capstone

This guide covers how the oral defense is run, the question bank instructors draw from, and how to score the defense against `Capstone_Grading_Rubric.md` (Section 4, 25 points).

---

## 1. Format & Logistics

- **Duration:** ~10 minutes per learner or pair (7 minutes Q&A + 3 minutes buffer/feedback). Instructor manages the clock strictly to get through all learners in the scheduled window.
- **Setting:** Learner(s) share their screen with the live Azure portal open (not just static screenshots) so the instructor can spot-check at least one control live.
- **Participants:** All team members (if a pair) must answer at least 2 questions each — do not let one person answer everything.
- **Materials the instructor should have open:** the learner's three submitted deliverables and the scoring sheet from `Capstone_Grading_Rubric.md`.
- **Structure of the 10 minutes:**
  1. (1 min) Learner gives a 60-second summary: scenario chosen, what was built, one thing they're proud of.
  2. (5–6 min) Instructor asks 4–6 questions from the bank below, drawing at least one from each category (Cloud, Database, Security, Regulatory).
  3. (1 min) Instructor asks one unscripted follow-up/curveball based on something specific in their submission (e.g., "You said Private Endpoint was deferred — walk me through the actual risk that leaves open.").
  4. (1–2 min) Instructor gives immediate verbal feedback and notes the score.

## 2. What the Instructor Is Listening For (in general)

- **Ownership:** Can the learner explain *their own* build, not just recite the course material?
- **Rationale, not just recall:** Do they explain *why* they made a choice (cost, risk, time), not just *what* they did?
- **Regulatory fluency:** Do they connect technical choices to the regulator's real obligations (NDPA/NDPR, auditability, sovereignty, availability)?
- **Honesty about gaps:** Do they correctly identify what they deferred/did not implement and why, rather than overclaiming?

---

## 3. Question Bank (~15 questions across 4 categories)

### Category A — Cloud & Architecture

**A1.** "Walk me through your architecture diagram — what happens, step by step, from a depot officer opening the app to a record being saved in the database?"
*Good answer contains:* Correct sequence: HTTPS request to App Service → Entra ID authentication/token → app logic → encrypted connection through firewall/NSG to Azure SQL Database → TDE-encrypted storage → audit log entry.

**A2.** "Why did you choose Azure App Service instead of a virtual machine for the app tier?"
*Good answer contains:* PaaS vs. IaaS tradeoff — App Service offloads OS/runtime patching to Microsoft, faster to deploy, built-in scaling/HTTPS, appropriate for a small regulatory app; VM would add unnecessary patching/management burden for this workload.

**A3.** "If this system needed to support both fuel distribution monitoring and crude oil royalty reporting in the future, how would your current architecture need to change?"
*Good answer contains:* Awareness of scaling considerations — possibly separate databases/schemas, shared identity layer, cost impact of scaling beyond free tier, maybe splitting into services.

**A4.** "What Azure region did you deploy to, and why does that matter for a Nigerian regulator?"
*Good answer contains:* Names the actual region used; explains data residency/sovereignty concern — data may reside outside Nigeria, discusses what would be needed for production (data residency commitments, contractual clauses, or waiting for/using a local region if available) and ties to NDPA.

### Category B — Database

**B1.** "Is Transparent Data Encryption actually verified as ON for your database, and what does TDE protect against — and not against?"
*Good answer contains:* Confirms they checked (not assumed) TDE status in the portal; explains it protects data files/backups at rest from physical media theft, but does NOT protect against a compromised application-level credential or SQL injection — it's not a substitute for access control.

**B2.** "Explain the difference between your PITR restore and a geo-restore. When would you use each?"
*Good answer contains:* PITR = restore within the same region to any point in the retention window, for logical errors (bad update/delete) or corruption; geo-restore = restore from geo-redundant backup to a different region, for regional outage scenarios. Different RPO/RTO and different triggering scenario.

**B3.** "Your royalty/production figures are financially and legally significant. Would Always Encrypted change anything here, and why did you or didn't you implement it?"
*Good answer contains:* Always Encrypted protects specific sensitive columns end-to-end (even DBAs can't see plaintext); tradeoffs include app-side complexity and limited query support on encrypted columns; reasonable to defer for a POC but should be flagged as a production consideration.

**B4.** "What is your database's auto-pause behavior, and why does it matter for this course's cost guardrails?"
*Good answer contains:* Serverless auto-pause suspends compute after idle period, stopping vCore billing; matters because the course free offer has 100,000 vCore-seconds/month — auto-pause keeps usage inside the free tier and prevents accidental cost.

**B5.** "Show me — live — where in the portal you'd confirm your backup retention window."
*Good answer contains:* Navigates to SQL Database > Manage backups or Configure retention correctly, and can state the retention value currently configured.

### Category C — Security

**C1.** "Where are your database credentials or connection string actually stored, and who/what can access them?"
*Good answer contains:* Stored in Key Vault, accessed via the App Service's managed identity — not hardcoded, not in app config committed to source, not in plaintext environment variables visible to all admins.

**C2.** "You have two roles in your app — walk me through what happens if a depot officer tries to access the regulator analyst's summary view. What actually stops them?"
*Good answer contains:* Specific enforcement mechanism (RBAC check in app logic tied to Entra ID role/group claim), not just "we designed it that way" — should be able to point to actual code/config or portal role assignment.

**C3.** "Your security checklist lists Private Endpoint as [implemented/deferred] — defend that decision."
*Good answer contains:* If implemented: correct explanation of how it removes the database's public endpoint exposure. If deferred: honest acknowledgment of the residual risk (public endpoint still reachable, mitigated only by firewall rules) and what would change in production.

**C4.** "What does Microsoft Defender for Cloud/Defender for SQL actually do for you, and did it flag anything?"
*Good answer contains:* Explains it provides security posture recommendations and threat detection/alerts; should be able to state whether they reviewed the Secure Score or any specific finding, even if the answer is "no significant findings in the lab window."
*Red flag:* Learner enabled it but never actually looked at any output.

**C5.** "The MFA requirement for Azure portal access takes effect October 1, 2026. How does that affect your admin accounts, and is your setup already compliant?"
*Good answer contains:* Reference to the Entra ID MFA requirement for all Azure portal access (including Global Admins) and Conditional Access as the mechanism; states whether their own lab tenant/admin already has MFA enforced.

### Category D — Regulatory & Governance

**D1.** "You're a data controller under the NDPA. What in your system specifically supports someone auditing 'who submitted this record and when'?"
*Good answer contains:* Points to Azure SQL Auditing/diagnostic logs and Entra ID sign-in logs as the actual mechanism — not a vague "we log things" answer.

**D2.** "If this system went down for 6 hours during a period when depot officers needed to report a fuel shortage, what's the real-world impact — and does your RTO account for that?"
*Good answer contains:* Connects downtime to a concrete regulatory/operational consequence (delayed national supply visibility, potential hoarding/diversion going undetected) and shows their stated RTO was chosen with that in mind, not arbitrarily.

**D3.** "What would you tell the agency's Data Protection Officer about where this data physically resides, and what would need to happen before this went into production?"
*Good answer contains:* Names the region, acknowledges any cross-border residency implication, and identifies realistic next steps (formal data protection impact assessment, DPO/legal sign-off, possibly contractual data residency commitments with Microsoft, and NDPA compliance review) rather than claiming the POC is "already compliant."
*Red flag:* Learner claims the lab build is fully NDPA-compliant with no caveats.

**D4.** "Why does 'availability of critical systems' matter more for a regulator than for, say, an internal expense-reporting tool — and how does your backup/DR plan reflect that?"
*Good answer contains:* Ties to sector criticality — fuel supply monitoring and royalty/production data feed national energy security and revenue decisions; shows the RPO/RTO and geo-redundancy choices were sized to that stakes level, not treated as a generic IT system.

---

## 4. Guidance for Scoring the Defense (25 points)

Use this alongside the rubric table in `Capstone_Grading_Rubric.md`. Score holistically across the whole 10-minute session, not question-by-question.

| Band | Points | What you should have observed |
|---|---|---|
| Excellent | 22–25 | Learner answered at least 5 of the questions asked with specific, accurate detail tied to their own build; correctly handled the unscripted follow-up; proactively named at least one production gap without being asked; clear regulatory framing (NDPA/NDPR, sovereignty, auditability, availability) volunteered, not just extracted by direct questioning |
| Good | 17–21 | Most answers accurate and specific; 1–2 answers generic or required significant prompting; regulatory framing present but only when directly asked |
| Developing | 11–16 | Can describe what exists in the portal/diagram but struggles to explain reasoning; multiple answers are guesses or contradict the written deliverables; little to no regulatory framing offered even when prompted |
| Insufficient | 0–10 | Cannot explain their own architecture; answers are inconsistent with submitted deliverables (suggesting deliverables were not authored/understood by this learner); no regulatory awareness |

### Practical scoring tips
- If a pair/team is presenting, score the *team* but note individually if one member cannot answer anything — this should cap that learner's individual score even if their partner performs well (apply instructor judgment; consider a split score if the course allows individual grades within a team submission).
- Weight correctness over polish — a nervous but technically accurate answer beats a confident but wrong one.
- A learner who says "we didn't implement X because of the cost/time constraint, and here's the residual risk and what we'd do in production" should score as well as one who implemented X — the rubric rewards honest, reasoned tradeoffs, not just checkbox completion.
- Use the curveball/follow-up question (Section 1, step 3) as your primary signal for distinguishing "Good" from "Excellent" — anyone can rehearse answers to the core question bank in advance.

---
*This guide should be used together with `Capstone_Project_Brief.md` (scenario and requirements), `Capstone_Deliverable_Templates.md` (what the learner submitted), and `Capstone_Grading_Rubric.md` (overall scoring). Verified Azure facts referenced in the question bank: [Azure SQL Database free offer — Microsoft Learn](https://learn.microsoft.com/en-us/azure/azure-sql/database/free-offer); [Microsoft Entra MFA requirement for Azure portal access — Microsoft Tech Community](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/microsoft-entra-id-security-updates-what-organizations-need-to-do-now/4522024); [Conditional Access overview — Microsoft Learn](https://learn.microsoft.com/en-us/entra/identity/conditional-access/).*
