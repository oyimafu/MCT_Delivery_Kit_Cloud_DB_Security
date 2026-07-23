# Azure Security Hardening Checklist — Petroleum Regulator Lab Environment

**Course:** Cloud, Database & Cybersecurity Essentials — Integrated IT Fundamentals Training
**Used in:** Lab Day 4 (Security Hardening) and Day 5 Capstone
**Participant name:** ______________________  **Resource group:** `rg-___-course`  **Date:** ______________

## Instructions
For each control below, mark whether it **applies** to your lab environment (the Day 2 Azure SQL Database + its app context), whether it is **Implemented (Y/N)**, and record **Evidence/Notes** — e.g. the Azure portal blade you configured, a CLI command output, a screenshot filename, or a reason it was skipped (e.g. "N/A — free-tier limitation"). This same template is reused for the Day 5 capstone submission, so keep your evidence notes precise and dated.

This checklist directly satisfies the brochure's required capstone deliverable: *"Security Checklist: Completed hardening checklist documenting all implemented security controls."*

| # | Control | Applies to | Implemented (Y/N) | Evidence/Notes |
|---|---------|------------|--------------------|-----------------|
| 1 | Microsoft Entra ID used as the identity provider for the Azure subscription (no on-prem AD dependency for lab) | Subscription / Tenant | | |
| 2 | Multi-Factor Authentication (MFA) enabled for all portal sign-ins (Security Defaults or Conditional Access) — required for all Azure portal access from Oct 1, 2026 ([Microsoft Entra blog](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/microsoft-entra-id-security-updates-what-organizations-need-to-do-now/4522024)) | Subscription / Tenant | | |
| 3 | Conditional Access policy configured (e.g. require MFA for all users, or block legacy authentication) via Microsoft Entra admin center ([Conditional Access docs](https://learn.microsoft.com/en-us/entra/identity/conditional-access/)) | Subscription / Tenant | | |
| 4 | Azure RBAC applied with least privilege — learner assigned only the roles needed (e.g. `SQL DB Contributor`, not `Owner`) at the resource-group scope | Resource group `rg-<initials>-course` | | |
| 5 | Microsoft Entra authentication configured on the Azure SQL logical server (Entra admin set); SQL authentication disabled or restricted where possible | Azure SQL logical server | | |
| 6 | Database-level least-privilege roles applied (e.g. app service account granted `db_datareader`/`db_datawriter` only, not `db_owner`) | `PetroleumInventoryDB` | | |
| 7 | Transparent Data Encryption (TDE) enabled (default in Azure SQL, verify status) — encrypts data at rest | `PetroleumInventoryDB` | | |
| 8 | TLS enforced for connections — minimum TLS version set to 1.2, "Deny public network access" reviewed | Azure SQL logical server | | |
| 9 | Server-level firewall rule scoped to specific learner/office IP (not `0.0.0.0–255.255.255.255`); "Allow Azure services" reviewed and disabled unless required | Azure SQL logical server | | |
| 10 | Private Endpoint evaluated/configured for the database (or documented as "public endpoint + firewall" for lab cost/time reasons) | Azure SQL logical server / VNet | | |
| 11 | Network Security Group (NSG) rules reviewed for any VM/App Service subnet in the lab (deny-by-default, allow only required ports) | VNet / Subnet | | |
| 12 | Secrets (connection strings, admin passwords) stored in Azure Key Vault, not in app config or source code | Key Vault | | |
| 13 | Key Vault access restricted via RBAC/access policies to only the app identity and named admins | Key Vault | | |
| 14 | Microsoft Defender for Cloud enabled at subscription level (Free tier acceptable for lab) | Subscription | | |
| 15 | Microsoft Defender for SQL enabled on the logical server (vulnerability assessment + advanced threat protection) | Azure SQL logical server | | |
| 16 | Auditing enabled on the Azure SQL database/server with logs sent to a storage account or Log Analytics workspace | Azure SQL logical server | | |
| 17 | Diagnostic settings configured to export resource logs (e.g. `SQLSecurityAuditEvents`) for the database | Azure SQL logical server | | |
| 18 | Azure Policy assigned to the resource group (e.g. built-in "Audit SQL server TDE" or a course tag-enforcement policy) | Resource group | | |
| 19 | Patching/update process reviewed — for PaaS (Azure SQL, App Service) confirm Microsoft-managed patching; for any lab VM, Azure Update Manager enabled | Resource group | | |
| 20 | Backups verified — automated backups visible, retention period noted, at least one Point-in-Time Restore test performed | `PetroleumInventoryDB` | | |
| 21 | Geo-redundancy / failover group evaluated for the database (configured or documented as "reviewed, not enabled due to free-tier limits") | Azure SQL logical server | | |
| 22 | Resource tagging applied (`course=cdcs`, owner initials) for cost tracking and cleanup | All lab resources | | |
| 23 | Cost-safety: idle SSMS/Azure Data Studio connections closed so serverless database can auto-pause | `PetroleumInventoryDB` | | |
| 24 | End-of-day cleanup: VMs/App Service plans stopped or deallocated; resource group scheduled for deletion at course end | Resource group | | |

## Sign-off

- Participant signature: ______________________
- Instructor review notes: ______________________
- Overall readiness for Day 5 capstone (circle one): **Ready / Needs rework**

## Sources referenced in this checklist
- MFA requirement for Azure portal access from Oct 1, 2026 — [Microsoft Entra ID security updates](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/microsoft-entra-id-security-updates-what-organizations-need-to-do-now/4522024)
- Conditional Access configuration — [Microsoft Entra Conditional Access documentation](https://learn.microsoft.com/en-us/entra/identity/conditional-access/)
