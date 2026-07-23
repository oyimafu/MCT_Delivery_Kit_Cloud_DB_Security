# Lab — Day 4: Security Hardening

**Course:** Cloud, Database & Cybersecurity Essentials — Integrated IT Fundamentals Training
**Module:** Day 4 — Cybersecurity Essentials
**Hands-on activity (brochure):** *Harden a simple application stack using security best practices and deliver a completed security checklist.*

## Objective
Learners will harden the Day 2 `PetroleumInventoryDB` Azure SQL Database and its application context end-to-end: confirm Transparent Data Encryption (TDE), enforce minimum TLS, restrict network access (firewall/Private Endpoint), configure Microsoft Entra authentication with least-privilege RBAC, enable Microsoft Defender for SQL and auditing, and complete the reusable security checklist used again at the Day 5 capstone.

## Estimated duration
3.5 hours (identity/MFA/RBAC: 45 min; encryption + TLS + network hardening: 60 min; Defender for SQL + auditing: 45 min; checklist completion + review: 40 min).

## Prerequisites
- Completion of Day 2 lab — an existing `PetroleumInventoryDB` Azure SQL Database on the free-offer serverless tier.
- Owner or Contributor access on your `rg-<initials>-course` resource group (needed for RBAC and Entra admin configuration steps).
- The template file `datasets/day4_security_checklist.md` from this kit.
- A Microsoft Entra ID user account to designate as the SQL Entra admin (can be your own course account).

## Cost-safety reminders
- Microsoft Defender for Cloud/Defender for SQL used in this lab should stay on the **Free tier** at subscription level, or use the short free trial window for Defender for SQL — do not enable paid protection plans on resources outside your course resource group.
- Continue using the free-offer serverless `PetroleumInventoryDB` — none of today's hardening steps require upgrading the service tier.
- Disconnect Azure Data Studio/SSMS Object Explorer at the end of the session so the database can auto-pause.
- At end of day, confirm no VMs or App Service plans were left running if you created any for testing — stop/deallocate them.
- Remember: the resource group `rg-<initials>-course` (tagged `course=cdcs`) will be deleted entirely at course end — don't build anything here you need to keep permanently.

---

## Part 1 — Microsoft Entra ID, MFA and least-privilege RBAC

1. In the [Azure portal](https://portal.azure.com), search **"Microsoft Entra ID"** and open the **Microsoft Entra admin center**.
2. Go to **Identity > Protection > Conditional Access** ([Conditional Access documentation](https://learn.microsoft.com/en-us/entra/identity/conditional-access/)). Review (do not necessarily enforce, if using a shared course tenant) a policy requiring MFA for all users. [Screenshot: Conditional Access — Policies list with a "Require MFA for all users" policy]
3. Note for your checklist: Microsoft requires MFA for **all** Azure portal access (including Global Admins) starting **October 1, 2026** ([Microsoft Entra ID security updates](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/microsoft-entra-id-security-updates-what-organizations-need-to-do-now/4522024)). Confirm your own sign-in already uses MFA.
4. Go to your `rg-<initials>-course` resource group > **Access control (IAM)** > **Role assignments**. [Screenshot: IAM — Role assignments tab listing current roles]
5. Select **Add > Add role assignment**. Choose a scoped role such as **SQL DB Contributor** (not **Owner** or **Contributor**) and assign it to a test/second account if available, to practice least-privilege assignment. [Screenshot: Add role assignment — Role = SQL DB Contributor]
6. Record in your checklist which roles are assigned at the resource-group scope and confirm no unnecessary **Owner** assignments exist beyond the course admin.

## Part 2 — Microsoft Entra authentication and database-level least privilege

1. Open your SQL logical server resource (`sql-<initials>-course`) in the portal.
2. In the left menu, select **Microsoft Entra ID** (under Settings). [Screenshot: SQL server — Microsoft Entra ID blade]
3. Select **Set admin**, choose your Entra user or group, and **Save**. This allows Entra-based sign-in to the server going forward, in addition to (or instead of) SQL authentication.
4. Connect to `PetroleumInventoryDB` in Azure Data Studio using **Microsoft Entra authentication** this time (change the Authentication type in the connection dialog). [Screenshot: Azure Data Studio New Connection — Authentication type = Azure Active Directory / Microsoft Entra]
5. In a query window, create a least-privilege application login/user instead of using the admin account for app connections:
   ```sql
   -- Run in the context of PetroleumInventoryDB
   CREATE USER [app_reporting_user] WITH PASSWORD = 'UseAStrongUniquePasswordHere!1';
   ALTER ROLE db_datareader ADD MEMBER [app_reporting_user];
   -- Grant write access only if the app genuinely needs it:
   -- ALTER ROLE db_datawriter ADD MEMBER [app_reporting_user];
   ```
6. Verify least privilege — this account should **not** be a member of `db_owner`:
   ```sql
   SELECT dp.name AS RoleName, mp.name AS MemberName
   FROM sys.database_role_members rm
   JOIN sys.database_principals dp ON dp.principal_id = rm.role_principal_id
   JOIN sys.database_principals mp ON mp.principal_id = rm.member_principal_id
   WHERE mp.name = 'app_reporting_user';
   ```

## Part 3 — Encryption at rest and in transit

1. On the `PetroleumInventoryDB` resource, go to **Transparent data encryption** (under Security, in the left menu). [Screenshot: Transparent data encryption blade showing "Data encryption = On"]
2. Confirm **Data encryption** is **On** — TDE is enabled by default on Azure SQL Database, so this step is a verification, not a configuration.
3. Go to the SQL **server** resource (not the database) > **Networking**. Under **Encryption in transit**, confirm/set **Minimum TLS version** to **TLS 1.2**. [Screenshot: Server Networking blade — Minimum TLS version dropdown set to 1.2]
4. Run a quick verification query to confirm your current session's encryption:
   ```sql
   SELECT session_id, encrypt_option
   FROM sys.dm_exec_connections
   WHERE session_id = @@SPID;
   -- encrypt_option should show "TRUE"
   ```

## Part 4 — Network hardening: firewall and Private Endpoint

1. On the SQL **server** resource, go to **Networking**.
2. Under **Firewall rules**, review your existing rule from Day 2 (your client IP). Remove any overly broad rule if one exists (e.g. `0.0.0.0`–`255.255.255.255`). [Screenshot: Networking — Firewall rules table showing scoped IP rule only]
3. Set **Allow Azure services and resources to access this server** to **No**, unless a specific in-Azure app tier genuinely needs it — document your decision either way.
4. Under **Private access**, review the **Private endpoint** option. Select **Add private endpoint** to see the configuration wizard (resource group, virtual network, subnet), then **cancel before completing** if you are not proceeding with a VNet in this lab — document as "reviewed, not implemented due to lab time/cost constraints" if so. [Screenshot: Add private endpoint wizard — Basics tab, cancel before Review+Create]
5. If your course has a lab VNet already available, complete the Private Endpoint creation and set **Deny public network access** to **Yes** afterward; otherwise, leave public access with the scoped firewall rule and note this clearly in your checklist.

## Part 5 — Microsoft Defender for SQL and auditing

1. On the `PetroleumInventoryDB` resource, go to **Microsoft Defender for Cloud** (under Security, left menu). [Screenshot: Defender for Cloud blade on the SQL database resource]
2. Select **Enable Microsoft Defender for SQL** (or confirm it is already enabled at the server level). Note the pricing tier shown — use Free tier or trial period per the cost-safety reminder.
3. Go to **Auditing** (under Security, left menu). Toggle **Azure SQL Auditing** to **On**. [Screenshot: Auditing blade toggled On]
4. Choose a destination for audit logs — select **Log Analytics** (or Storage account) and pick/create a workspace within your `rg-<initials>-course` resource group.
5. Save, then go to **Diagnostic settings** (under Monitoring, left menu) and confirm a diagnostic setting exists exporting `SQLSecurityAuditEvents` to your chosen destination. [Screenshot: Diagnostic settings — SQLSecurityAuditEvents category enabled]
6. Generate a test audit event by running a simple query (e.g. `SELECT TOP 5 * FROM dbo.Facilities;`), then after a few minutes, check the Log Analytics workspace **Logs** blade for the corresponding audit record.

## Part 6 — Azure Policy and patching posture

1. Go to your `rg-<initials>-course` resource group > **Policies** (under Governance, left menu).
2. Select **Assign policy**, browse the built-in policy definitions, and assign one relevant policy — e.g. search **"transparent data encryption"** or **"SQL server auditing"** and assign it scoped to your resource group. [Screenshot: Assign policy — policy search showing a TDE or auditing built-in definition]
3. Note in your checklist: because `PetroleumInventoryDB` is a PaaS service, **Microsoft manages the underlying OS/engine patching automatically** — there is no Update Manager task needed for the database itself. If your course also stood up any lab VM, confirm **Azure Update Manager** is enabled for it instead.

## Part 7 — Complete the security checklist

1. Open `datasets/day4_security_checklist.md` from this kit.
2. Go through all 24 controls, marking **Applies to / Implemented (Y/N) / Evidence-Notes** based on what you configured in Parts 1–6 above. Reference specific portal blades, query results, or screenshot filenames as evidence.
3. Sign off at the bottom of the checklist and note any items marked "N/A" or "Needs rework" with a one-line reason (e.g. "Private Endpoint skipped — no lab VNet available this session").

## Expected results / checkpoints
- [ ] Conditional Access / MFA policy reviewed and confirmed active on your own sign-in.
- [ ] Resource group IAM shows only least-privilege role assignments (no unnecessary Owner grants).
- [ ] SQL server has a Microsoft Entra admin configured; you connected successfully via Entra authentication at least once.
- [ ] `app_reporting_user` created in `PetroleumInventoryDB` with only `db_datareader` (and `db_datawriter` only if justified) — verified via the role-membership query.
- [ ] TDE confirmed On; minimum TLS version confirmed at 1.2; `encrypt_option = TRUE` verified for your session.
- [ ] Firewall rules scoped to specific IPs only; Private Endpoint reviewed (implemented or explicitly deferred with a documented reason).
- [ ] Microsoft Defender for SQL enabled; Auditing On with logs flowing to Log Analytics/Storage; a test audit event located in the logs.
- [ ] At least one Azure Policy assigned to the resource group.
- [ ] `day4_security_checklist.md` fully completed and signed off.

## Troubleshooting tips
- **"Set admin" for Microsoft Entra ID greyed out on the server** — you may need the **Global Administrator** or a role with `Microsoft.Sql/servers/administrators/write` permission at the subscription level; ask your instructor for elevated access if using an organizational tenant.
- **Entra authentication connection fails in Azure Data Studio** — ensure the Entra account you're signing in with has been granted access inside the database (`CREATE USER [user@domain.com] FROM EXTERNAL PROVIDER;`) or is the designated server admin.
- **Auditing logs not appearing in Log Analytics after several minutes** — confirm the diagnostic setting category `SQLSecurityAuditEvents` (not just `SQLInsights`) is checked, and that you generated qualifying activity (SELECT/DML) after enabling it, not before.
- **Defender for SQL shows "Not enabled" after you enabled it** — this can take a few minutes to propagate; refresh the blade, and confirm it was enabled at the **server** level, not just the database level.
- **Private Endpoint wizard requires a VNet you don't have** — this is expected in many lab environments; document it as deferred in the checklist rather than attempting to build a full VNet under time pressure.

## PostgreSQL alternative note
On **Azure Database for PostgreSQL Flexible Server**:
- Encryption at rest is enabled by default (Azure Storage encryption); there is no separate "TDE toggle" — verify under **Data encryption** on the server resource (customer-managed keys are optional).
- Enforce TLS via server parameter `require_secure_transport = ON` and `ssl_min_protocol_version`.
- Use **Microsoft Entra authentication for PostgreSQL** (supported on Flexible Server) in place of the SQL Entra-admin steps in Part 2.
- Firewall rules and Private Endpoint configuration follow the same pattern under the server's **Networking** blade.
- Defender for Cloud provides recommendations for PostgreSQL Flexible Server, though dedicated "Defender for SQL"-style advanced threat protection is SQL-specific — rely on Defender for Cloud's general database recommendations instead ([PostgreSQL Flexible Server free account guide](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/how-to-deploy-on-azure-free-account)).

## What to submit for grading
1. Completed and signed-off `day4_security_checklist.md`.
2. Screenshot evidence for: Conditional Access/MFA policy, IAM role assignments, Entra admin on SQL server, TDE status, minimum TLS setting, firewall rules, Defender for SQL status, and Auditing/diagnostic settings.
3. The `CREATE USER`/role-membership SQL you ran in Part 2, with the verification query output showing least privilege.
4. A short paragraph (3–5 sentences) explaining your Private Endpoint decision (implemented vs. deferred) and why, for the Day 5 capstone architecture discussion.
