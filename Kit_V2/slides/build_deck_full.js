const PptxGenJS = require("pptxgenjs");
const pptx = new PptxGenJS();
pptx.defineLayout({ name: "W", width: 13.333, height: 7.5 });
pptx.layout = "W";

// ---- Palette (petroleum / energy-regulator theme) ----
const INK = "13312F", INK2 = "0E2523", TEAL = "01696F", TEALD = "0C4E54";
const GOLD = "C68A19", BG = "F7F6F2", SURF = "FBFBF9", SURF2 = "F1EFE9";
const BORD = "D4D1CA", TX = "28251D", MUT = "6B6A64", WHITE = "FFFFFF";
const FADE = "9FB7B4", GREEN = "437A22", RED = "A13544", CHIP = "EAF1F1";
const HFONT = "Trebuchet MS", BFONT = "Calibri";
let SLIDE = 0;

// ---------- shared chrome ----------
function footer(slide, dark) {
  const c = dark ? FADE : MUT;
  slide.addText("Cloud, Database & Cybersecurity Essentials  ·  Integrated IT Fundamentals", { x: 0.5, y: 7.04, w: 8.6, h: 0.3, fontFace: BFONT, fontSize: 8.5, color: c });
  slide.addText(String(SLIDE), { x: 12.35, y: 7.04, w: 0.5, h: 0.3, fontFace: BFONT, fontSize: 8.5, color: c, align: "right" });
}
function head(slide, kicker, title) {
  slide.background = { color: BG };
  slide.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: 13.333, h: 1.5, fill: { color: INK } });
  slide.addShape(pptx.ShapeType.rect, { x: 0, y: 1.5, w: 13.333, h: 0.06, fill: { color: GOLD } });
  slide.addText(kicker.toUpperCase(), { x: 0.6, y: 0.24, w: 12, h: 0.3, fontFace: BFONT, fontSize: 11.5, bold: true, color: GOLD, charSpacing: 2 });
  slide.addText(title, { x: 0.6, y: 0.55, w: 12.1, h: 0.85, fontFace: HFONT, fontSize: 27, bold: true, color: WHITE, valign: "middle" });
}
function newContent(kicker, title) { SLIDE++; const s = pptx.addSlide(); head(s, kicker, title); return s; }

// ---------- title ----------
function titleSlide() {
  SLIDE++; const s = pptx.addSlide(); s.background = { color: INK };
  s.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: 0.35, h: 7.5, fill: { color: TEAL } });
  s.addShape(pptx.ShapeType.rect, { x: 0.35, y: 0, w: 0.12, h: 7.5, fill: { color: GOLD } });
  s.addText("INTEGRATED IT FUNDAMENTALS  ·  5-DAY INSTRUCTOR-LED COURSE", { x: 1.0, y: 1.35, w: 11.5, h: 0.4, fontFace: BFONT, fontSize: 14, bold: true, color: GOLD, charSpacing: 2 });
  s.addText("Cloud, Database &\nCybersecurity Essentials", { x: 1.0, y: 1.85, w: 11.7, h: 2.0, fontFace: HFONT, fontSize: 46, bold: true, color: WHITE, lineSpacingMultiple: 1.0 });
  s.addText("A hands-on Azure curriculum for a petroleum regulatory environment — cloud architecture, relational databases, and layered security, taught as one integrated skillset.", { x: 1.02, y: 4.05, w: 10.8, h: 1.0, fontFace: BFONT, fontSize: 16.5, color: FADE });
  s.addShape(pptx.ShapeType.line, { x: 1.02, y: 5.25, w: 6.2, h: 0, line: { color: TEAL, width: 1.5 } });
  s.addText([{ text: "40 hours", options: { bold: true, color: WHITE } }, { text: "   5 modules   ·   9 hands-on demos   ·   graded capstone", options: { color: FADE } }], { x: 1.0, y: 5.45, w: 11.5, h: 0.4, fontFace: BFONT, fontSize: 15 });
  s.addText("Facilitator course deck  ·  Microsoft Certified Trainer edition", { x: 1.0, y: 6.55, w: 11, h: 0.4, fontFace: BFONT, fontSize: 12, italic: true, color: FADE });
}

// ---------- section / module divider ----------
function divider(moduleLabel, title, subtitle) {
  SLIDE++; const s = pptx.addSlide(); s.background = { color: INK };
  s.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: 0.35, h: 7.5, fill: { color: GOLD } });
  s.addText(moduleLabel.toUpperCase(), { x: 1.0, y: 2.2, w: 11, h: 0.5, fontFace: BFONT, fontSize: 15, bold: true, color: GOLD, charSpacing: 3 });
  s.addText(title, { x: 1.0, y: 2.75, w: 11.6, h: 1.3, fontFace: HFONT, fontSize: 38, bold: true, color: WHITE });
  s.addText(subtitle, { x: 1.02, y: 4.15, w: 10.7, h: 1.0, fontFace: BFONT, fontSize: 16.5, color: FADE });
  s.addText(moduleLabel.replace(/[^0-9]/g, "").padStart(2, "0"), { x: 11.4, y: 6.2, w: 1.6, h: 0.8, fontFace: HFONT, fontSize: 44, bold: true, color: TEALD, align: "right" });
  return s;
}

// ---------- "in this module" agenda ----------
function moduleAgenda(kicker, title, items) {
  const s = newContent(kicker, title);
  let y = 1.95;
  items.forEach((it, i) => {
    s.addShape(pptx.ShapeType.rect, { x: 0.6, y: y, w: 12.13, h: 0.72, fill: { color: SURF }, line: { color: BORD, width: 1 } });
    s.addShape(pptx.ShapeType.rect, { x: 0.6, y: y, w: 0.72, h: 0.72, fill: { color: TEAL } });
    s.addText(String(i + 1), { x: 0.6, y: y, w: 0.72, h: 0.72, fontFace: HFONT, fontSize: 18, bold: true, color: WHITE, align: "center", valign: "middle" });
    s.addText(it[0], { x: 1.55, y: y + 0.06, w: 8.4, h: 0.62, fontFace: HFONT, fontSize: 15, bold: true, color: TX, valign: "middle" });
    s.addText(it[1], { x: 10.0, y: y, w: 2.6, h: 0.72, fontFace: BFONT, fontSize: 11, italic: true, color: MUT, align: "right", valign: "middle" });
    y += 0.82;
  });
  footer(s, false);
  return s;
}

// ---------- concept slide: lead statement + supporting bullets ----------
function concept(kicker, title, lead, bullets, regNote) {
  const s = newContent(kicker, title);
  s.addShape(pptx.ShapeType.rect, { x: 0.6, y: 1.85, w: 12.13, h: 1.05, fill: { color: TEALD } });
  s.addText(lead, { x: 0.9, y: 1.85, w: 11.5, h: 1.05, fontFace: BFONT, fontSize: 16, italic: true, color: WHITE, valign: "middle" });
  s.addText(bullets.map(t => ({ text: t, options: { bullet: { indent: 16 }, paraSpaceAfter: 10 } })), { x: 0.75, y: 3.15, w: 11.8, h: regNote ? 2.6 : 3.4, fontFace: BFONT, fontSize: 15, color: TX, valign: "top", lineSpacingMultiple: 1.08 });
  if (regNote) {
    s.addShape(pptx.ShapeType.rect, { x: 0.6, y: 6.1, w: 12.13, h: 0.75, fill: { color: CHIP }, line: { color: TEAL, width: 1 } });
    s.addText([{ text: "Regulator lens   ", options: { bold: true, color: TEALD } }, { text: regNote, options: { color: TX } }], { x: 0.9, y: 6.1, w: 11.5, h: 0.75, fontFace: BFONT, fontSize: 12.5, valign: "middle" });
  }
  footer(s, false);
  return s;
}

// ---------- two column compare ----------
function twoCol(kicker, title, L, R) {
  const s = newContent(kicker, title);
  [[L, 0.6, TEAL], [R, 6.87, GOLD]].forEach(([col, x, clr]) => {
    s.addShape(pptx.ShapeType.rect, { x: x, y: 1.85, w: 5.86, h: 4.95, fill: { color: SURF }, line: { color: BORD, width: 1 } });
    s.addShape(pptx.ShapeType.rect, { x: x, y: 1.85, w: 5.86, h: 0.68, fill: { color: clr } });
    s.addText(col.head, { x: x + 0.3, y: 1.85, w: 5.3, h: 0.68, fontFace: HFONT, fontSize: 17, bold: true, color: WHITE, valign: "middle" });
    s.addText(col.items.map(t => ({ text: t, options: { bullet: { indent: 14 }, paraSpaceAfter: 9 } })), { x: x + 0.32, y: 2.72, w: 5.25, h: 3.9, fontFace: BFONT, fontSize: 13.5, color: TX, valign: "top", lineSpacingMultiple: 1.05 });
  });
  footer(s, false);
  return s;
}

// ---------- table slide ----------
function tableSlide(kicker, title, headers, rows, note, colW) {
  const s = newContent(kicker, title);
  const widths = colW || headers.map(() => 12.13 / headers.length);
  const th = headers.map(h => ({ text: h, options: { fill: INK, color: WHITE, bold: true, fontSize: 12.5, align: "left", valign: "middle" } }));
  const trows = rows.map((r, ri) => r.map(c => ({ text: c, options: { fill: ri % 2 ? SURF2 : SURF, color: TX, fontSize: 11.5, valign: "middle" } })));
  s.addTable([th, ...trows], { x: 0.6, y: 1.9, w: 12.13, colW: widths, border: { type: "solid", color: BORD, pt: 1 }, rowH: (note ? 0.42 : 0.46), autoPage: false, fontFace: BFONT });
  if (note) {
    s.addShape(pptx.ShapeType.rect, { x: 0.6, y: 6.15, w: 12.13, h: 0.72, fill: { color: CHIP }, line: { color: TEAL, width: 1 } });
    s.addText([{ text: "Key point   ", options: { bold: true, color: TEALD } }, { text: note, options: { color: TX } }], { x: 0.9, y: 6.15, w: 11.5, h: 0.72, fontFace: BFONT, fontSize: 12.5, valign: "middle" });
  }
  footer(s, false);
  return s;
}

// ---------- demo intro ----------
function demo(kicker, title, objective, steps, result) {
  const s = newContent(kicker, title);
  s.addShape(pptx.ShapeType.rect, { x: 0.6, y: 1.85, w: 3.0, h: 4.95, fill: { color: INK } });
  s.addText("DEMO", { x: 0.6, y: 2.2, w: 3.0, h: 0.5, fontFace: HFONT, fontSize: 22, bold: true, color: GOLD, align: "center" });
  s.addShape(pptx.ShapeType.rect, { x: 0.85, y: 2.9, w: 2.5, h: 0.02, fill: { color: TEAL } });
  s.addText("Hands-on", { x: 0.6, y: 3.0, w: 3.0, h: 0.4, fontFace: BFONT, fontSize: 13, color: FADE, align: "center" });
  s.addText([{ text: "Objective\n", options: { bold: true, color: WHITE, fontSize: 12 } }, { text: objective, options: { color: FADE, fontSize: 12.5 } }], { x: 0.85, y: 3.7, w: 2.55, h: 2.9, fontFace: BFONT, valign: "top", lineSpacingMultiple: 1.05 });
  s.addText("Walkthrough", { x: 3.95, y: 2.0, w: 8, h: 0.4, fontFace: HFONT, fontSize: 16, bold: true, color: TEALD });
  s.addText(steps.map((t, i) => ({ text: t, options: { bullet: { type: "number", numberStartAt: i + 1 }, paraSpaceAfter: 8 } })), { x: 3.95, y: 2.5, w: 8.7, h: 3.5, fontFace: BFONT, fontSize: 13, color: TX, valign: "top", lineSpacingMultiple: 1.05 });
  s.addShape(pptx.ShapeType.rect, { x: 3.95, y: 6.15, w: 8.78, h: 0.72, fill: { color: SURF }, line: { color: BORD, width: 1 } });
  s.addText([{ text: "Expected result   ", options: { bold: true, color: GREEN } }, { text: result, options: { color: TX } }], { x: 4.2, y: 6.15, w: 8.3, h: 0.72, fontFace: BFONT, fontSize: 12, valign: "middle" });
  footer(s, false);
  return s;
}

// ---------- code slide ----------
function codeSlide(kicker, title, caption, code, explain) {
  const s = newContent(kicker, title);
  if (caption) s.addText(caption, { x: 0.7, y: 1.75, w: 12, h: 0.35, fontFace: BFONT, fontSize: 13, italic: true, color: MUT });
  const codeH = explain ? 3.0 : 4.5;
  s.addShape(pptx.ShapeType.rect, { x: 0.6, y: 2.15, w: 12.13, h: codeH, fill: { color: INK2 } });
  s.addText(code, { x: 0.85, y: 2.32, w: 11.6, h: codeH - 0.3, fontFace: "Consolas", fontSize: 12.5, color: "D7E7E5", valign: "top", lineSpacingMultiple: 1.12 });
  if (explain) {
    s.addText(explain.map(t => ({ text: t, options: { bullet: { indent: 14 }, paraSpaceAfter: 7 } })), { x: 0.75, y: 5.35, w: 11.8, h: 1.5, fontFace: BFONT, fontSize: 13, color: TX, valign: "top" });
  }
  footer(s, false);
  return s;
}

// ---------- knowledge check ----------
function knowledgeCheck(kicker, qs) {
  const s = newContent(kicker, "Knowledge check");
  let y = 1.95;
  qs.forEach((q, i) => {
    s.addShape(pptx.ShapeType.rect, { x: 0.6, y: y, w: 12.13, h: 1.45, fill: { color: SURF }, line: { color: BORD, width: 1 } });
    s.addShape(pptx.ShapeType.rect, { x: 0.6, y: y, w: 0.55, h: 1.45, fill: { color: GOLD } });
    s.addText("Q" + (i + 1), { x: 0.6, y: y + 0.1, w: 0.55, h: 0.4, fontFace: HFONT, fontSize: 12, bold: true, color: WHITE, align: "center" });
    s.addText(q[0], { x: 1.35, y: y + 0.12, w: 11.1, h: 0.55, fontFace: HFONT, fontSize: 14, bold: true, color: TX });
    s.addText([{ text: "Answer:  ", options: { bold: true, color: TEALD } }, { text: q[1], options: { color: MUT } }], { x: 1.35, y: y + 0.72, w: 11.1, h: 0.65, fontFace: BFONT, fontSize: 12.5, valign: "top" });
    y += 1.6;
  });
  footer(s, false);
  return s;
}

// ---------- summary ----------
function summary(kicker, title, takeaways) {
  const s = newContent(kicker, title);
  s.addText("Key takeaways", { x: 0.75, y: 1.8, w: 11, h: 0.5, fontFace: HFONT, fontSize: 18, bold: true, color: TEALD });
  s.addText(takeaways.map(t => ({ text: t, options: { bullet: { characterCode: "2713", indent: 20 }, paraSpaceAfter: 12, color: TX } })), { x: 0.85, y: 2.4, w: 11.7, h: 4.3, fontFace: BFONT, fontSize: 15.5, valign: "top", lineSpacingMultiple: 1.1 });
  footer(s, false);
  return s;
}

function srcFooter(slide, arr) {
  const parts = [{ text: "Source: ", options: { color: MUT, fontSize: 9 } }];
  arr.forEach((a, i) => { parts.push({ text: a[0], options: { hyperlink: { url: a[1] }, color: TEAL, fontSize: 9 } }); if (i < arr.length - 1) parts.push({ text: "  ·  ", options: { color: MUT, fontSize: 9 } }); });
  slide.addText(parts, { x: 0.5, y: 6.72, w: 11.5, h: 0.28, fontFace: BFONT });
}

// =========================================================
// BUILD
// =========================================================
titleSlide();

// ---- Course overview ----
moduleAgenda("Course roadmap", "What this course covers", [
  ["Module 1 — Cloud Fundamentals Recap", "Day 1"],
  ["Module 2 — Database Fundamentals", "Day 2"],
  ["Module 3 — Database Administration & Performance", "Day 3"],
  ["Module 4 — Cybersecurity Essentials", "Day 4"],
  ["Module 5 — Integrated Lab & Capstone", "Day 5"],
]);
concept("Course overview", "How the five days fit together",
  "One running example — a petroleum regulator's asset and reporting system — carries you from cloud choice to a secure, backed-up deployment.",
  [
    "Day 1 decides WHERE and on WHAT the system runs (cloud service selection).",
    "Day 2 builds the DATA layer (a normalized inventory database) and queries it.",
    "Day 3 makes the data layer FAST and RESILIENT (indexing, backups, replication).",
    "Day 4 makes it SECURE (identity, encryption, network isolation, monitoring).",
    "Day 5 INTEGRATES all of it into one deployed, defended, recoverable application.",
  ],
  "Everything maps to a regulator duty: data sovereignty, auditability, least privilege, and availability of critical national systems.");
tableSlide("Course overview", "Learning outcomes mapped to modules",
  ["Learning outcome (brochure)", "Where it is delivered", "Evidence"],
  [
    ["Grasp cloud & RDBMS fundamentals", "Modules 1–2", "Day 1 matrix, Day 2 schema"],
    ["Design schemas & do admin (backup/recovery)", "Modules 2–3", "CRUD, index, PITR labs"],
    ["Identify threats & apply mitigations", "Module 4", "Hardening checklist"],
    ["Integrate cloud + DB + security end to end", "Module 5", "Capstone + oral defense"],
  ], "Daily labs are not throwaway exercises — each produces an artifact the learner reuses in the Day 5 capstone.",
  [6.0, 3.6, 2.53]);
tableSlide("Course setup", "The Azure environment you will use",
  ["Purpose", "Azure service", "Why / cost note"],
  [
    ["Managed database (all labs)", "Azure SQL Database — free offer", "10 free serverless DBs; 100k vCore-sec/mo"],
    ["Alternative DB track", "Azure Database for PostgreSQL Flexible Server", "750 B1MS hrs/mo free (12 months)"],
    ["Application tier (capstone)", "Azure App Service (PaaS)", "Contrast with Azure VMs (IaaS)"],
    ["Identity & access", "Microsoft Entra ID", "RBAC, MFA, Conditional Access"],
    ["Secrets & keys", "Azure Key Vault", "No secrets in code or config"],
    ["Threat protection & audit", "Microsoft Defender for SQL + Auditing", "Alerts + evidence trail"],
  ], null, [4.0, 4.6, 3.53]);
{ const s = pptx.slides[pptx.slides.length - 1]; srcFooter(s, [["Azure SQL free offer", "https://learn.microsoft.com/en-us/azure/azure-sql/database/free-offer"], ["PostgreSQL free", "https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/how-to-deploy-on-azure-free-account"]]); }

// =========================================================
// MODULE 1 — CLOUD
// =========================================================
divider("Module 1", "Cloud Fundamentals Recap", "IaaS and PaaS, service-selection frameworks, and deployment patterns — grounded in Azure.");
moduleAgenda("Module 1", "In this module", [
  ["The shared responsibility model", "concept"],
  ["IaaS vs PaaS vs SaaS — who manages what", "compare"],
  ["A service-selection decision framework", "framework"],
  ["Common deployment patterns on Azure", "patterns"],
  ["Demo — cloud service selection case study", "hands-on"],
]);
concept("Module 1 · Concept", "The shared responsibility model",
  "Moving to the cloud shifts operational burden to Microsoft — but never removes the customer's accountability for data, identity, and configuration.",
  [
    "The provider always secures the physical datacentre, hardware, and hypervisor.",
    "As you move IaaS → PaaS → SaaS, more of the stack (OS, patching, runtime) shifts to Microsoft.",
    "Data classification, identity, and access configuration ALWAYS remain the customer's job.",
    "Misconfiguration — not provider failure — is the leading cause of cloud incidents.",
  ],
  "For a regulator, PaaS shrinks the audit surface: fewer components the agency must patch and evidence.");
twoCol("Module 1 · Compare", "IaaS vs PaaS — who manages what",
  { head: "IaaS  ·  Azure Virtual Machines", items: [
    "You manage: OS, patching, runtime, DB engine, backups",
    "Azure manages: compute, storage, network, hypervisor",
    "Most control, most operational effort",
    "Good for: lift-and-shift, legacy apps, custom stacks",
    "Regulator cost: more staff time for patching & hardening",
  ] },
  { head: "PaaS  ·  Azure SQL Database / App Service", items: [
    "You manage: your app, your data, access policy",
    "Azure manages: OS, patching, HA, automated backups",
    "Less control, far less operational effort",
    "Good for: new apps, managed databases, faster delivery",
    "Regulator benefit: built-in HA, backups, and compliance",
  ] });
tableSlide("Module 1 · Framework", "A repeatable service-selection framework",
  ["Decision", "Question to ask", "Typical regulator answer"],
  [
    ["Compute model", "Do we need OS-level control?", "No → PaaS (App Service / Azure SQL)"],
    ["Region", "Where must the data legally reside?", "An approved region for data sovereignty"],
    ["Availability", "What downtime is tolerable?", "Zone-redundant for critical registries"],
    ["Recovery", "What RPO / RTO do we need?", "Minutes RPO via PITR + geo-replication"],
    ["Cost model", "Steady or bursty workload?", "Serverless for bursty lab / low usage"],
    ["Security", "What compliance applies?", "NDPR/NDPA, least privilege, auditing"],
  ], null, [2.6, 4.8, 4.73]);
tableSlide("Module 1 · Patterns", "Common deployment patterns on Azure",
  ["Pattern", "Shape", "Use it when"],
  [
    ["Single-region PaaS web app", "App Service → Azure SQL → Key Vault", "Most internal regulator portals"],
    ["Zone-redundant", "Same, spread across availability zones", "Availability of critical systems matters"],
    ["Hub-and-spoke + Private Endpoint", "Isolated network, no public DB endpoint", "Sensitive data, strict network control"],
    ["Hybrid (migration)", "On-prem ↔ Azure during transition", "Cloud migration projects"],
  ], "Start simple (single-region N-tier) and add zone redundancy / private networking as the risk assessment demands.",
  [3.4, 5.2, 3.53]);
demo("Module 1 · Demo", "Demo — cloud service selection case study",
  "Given a regulator business brief, recommend Azure services and justify each choice.",
  [
    "Read the 'Crude Oil Production Reporting Portal' requirements brief.",
    "Fill the decision matrix: compute (IaaS vs PaaS), database service, and region.",
    "Justify the region choice on data-residency / sovereignty grounds.",
    "Sketch a reference architecture: App Service → Azure SQL Database → Key Vault.",
    "Defend the recommendation in a 2-minute pitch to the group.",
  ],
  "A completed decision matrix + a one-paragraph, defensible architecture justification.");
knowledgeCheck("Module 1 · Review", [
  ["In PaaS, who is responsible for patching the database engine?", "Microsoft (Azure) — but the customer still owns access control and data classification."],
  ["Why does region choice matter for a regulator before anything else?", "Data residency / sovereignty — regulated data may be legally required to stay in-country."],
  ["Name one reason to prefer zone-redundant deployment.", "Higher availability for critical systems — survives a single datacentre/zone failure."],
]);
summary("Module 1 · Summary", "Module 1 — key takeaways", [
  "The shared responsibility model shifts effort to Azure but never removes customer accountability.",
  "IaaS = control + effort; PaaS = speed + built-in HA/backups. Regulators usually favour PaaS.",
  "Use a consistent framework: compute, region, availability, recovery, cost, security.",
  "Pick the simplest deployment pattern that meets the risk assessment — then harden.",
]);

// =========================================================
// MODULE 2 — DATABASE FUNDAMENTALS
// =========================================================
divider("Module 2", "Database Fundamentals", "Relational concepts, normalization, indexing basics, and CRUD — on a live Azure SQL Database.");
moduleAgenda("Module 2", "In this module", [
  ["Relational building blocks (tables, keys)", "concept"],
  ["Normalization: 1NF → 3NF", "concept"],
  ["Indexing fundamentals", "concept"],
  ["The petroleum inventory schema", "walkthrough"],
  ["Demo — create Azure SQL DB & deploy schema", "hands-on"],
  ["Demo — CRUD operations", "hands-on"],
]);
concept("Module 2 · Concept", "Relational building blocks",
  "A relational database stores data in tables of rows and columns, and uses keys to keep those tables consistent and connected.",
  [
    "Primary key (PK): uniquely identifies each row — e.g. FacilityID, StockItemID.",
    "Foreign key (FK): a column that references another table's PK, enforcing valid relationships.",
    "Constraints (UNIQUE, CHECK, NOT NULL) push data-quality rules into the database itself.",
    "The engine guarantees integrity so applications don't have to re-implement it everywhere.",
  ],
  "Our schema models real regulator assets: depots/terminals holding valves, pumps, meters, PPE and spares.");
tableSlide("Module 2 · Concept", "Normalization — removing redundancy step by step",
  ["Form", "Rule (plain language)", "Fixes"],
  [
    ["1NF", "Atomic values; no repeating groups", "Comma-lists, multi-value cells"],
    ["2NF", "No partial dependency on part of a composite key", "Duplicated data tied to one key part"],
    ["3NF", "No column depends on a non-key column", "Supplier phone repeated on every movement"],
  ], "Normalize to protect data quality; selectively denormalize later only for proven read-performance needs.",
  [1.6, 6.4, 4.13]);
concept("Module 2 · Concept", "Indexing fundamentals",
  "An index is like the index at the back of a book — it lets the engine jump straight to matching rows instead of scanning every page.",
  [
    "Clustered index = the physical order of the table (usually the primary key).",
    "Non-clustered index = a separate sorted structure pointing back to rows.",
    "Indexes speed up reads (SELECT/JOIN/WHERE) but add a small cost to writes and storage.",
    "Index the columns you filter and join on — not every column.",
  ],
  "Production-reporting queries filtering by facility or date are exactly what a well-chosen index accelerates.");
tableSlide("Module 2 · Walkthrough", "The petroleum inventory schema (5 tables, 3NF)",
  ["Table", "Role", "Key relationships"],
  [
    ["Facilities", "Depots / terminals / field offices", "PK FacilityID"],
    ["Suppliers", "Approved vendors", "PK SupplierID"],
    ["Equipment", "Regulator-owned monitored assets", "FK → Facilities"],
    ["StockItems", "Catalogue of spares / PPE (item master)", "FK → Suppliers"],
    ["StockMovements", "Ledger of receipts / issues / transfers (fact)", "FK → StockItems, Facilities, Equipment"],
  ], "Quantity-on-hand is DERIVED from StockMovements — never stored redundantly. That's 3NF in action.",
  [2.6, 5.2, 4.33]);
demo("Module 2 · Demo", "Demo — create the database & deploy the schema",
  "Provision a free Azure SQL Database and deploy the normalized inventory schema.",
  [
    "Go to aka.ms/azuresqlhub and choose Start free.",
    "Basics: resource group rg-<initials>-course, DB name PetroleumInventoryDB, new server.",
    "Compute: General Purpose — Serverless (confirm the free-offer banner).",
    "Networking: add your current client IP; connect with Azure Data Studio.",
    "Open and run petroleum_inventory_schema.sql (5 tables, 2 indexes, ~74 seed rows).",
    "Verify with the COUNT sanity checks (10 / 8 / 14 / 12 / 30).",
  ],
  "Five tables visible in Azure Data Studio with the free-offer usage badge in the portal.");
codeSlide("Module 2 · Demo", "CRUD — Read: current stock on hand at Warri depot", "Aggregating the movement ledger to derive quantity on hand (never stored directly):",
`SELECT si.SKU, si.ItemName, SUM(sm.Quantity) AS QtyOnHand
FROM   dbo.StockMovements sm
JOIN   dbo.StockItems si  ON si.StockItemID = sm.StockItemID
JOIN   dbo.Facilities  f  ON f.FacilityID   = sm.FacilityID
WHERE  f.FacilityCode = 'FAC-WAR-01'
GROUP BY si.SKU, si.ItemName
ORDER BY si.SKU;`,
  [
    "RECEIPT rows are positive, ISSUE rows negative — SUM gives net on-hand.",
    "This is why the ledger design (3NF) keeps the data honest and auditable.",
  ]);
concept("Module 2 · Concept", "DELETE responsibly in a regulated environment",
  "In a regulator, deleting transactional history is rarely acceptable — auditors expect a complete, tamper-evident trail.",
  [
    "Prefer an ADJUSTMENT movement over deleting a historical row.",
    "Reserve hard DELETE for genuine data-entry errors, and log who did it and why.",
    "The schema already models ADJUSTMENT as a movement type for exactly this reason.",
    "Discuss the audit trade-off with learners — it foreshadows Day 4's auditing controls.",
  ],
  "Auditability is a compliance requirement, not a nice-to-have — this habit starts on Day 2.");
knowledgeCheck("Module 2 · Review", [
  ["What problem does 3NF fix in the flat StockMovementFlat table?", "Update/insertion anomalies — e.g. a supplier's phone repeated on every movement row."],
  ["Why is QtyOnHand not stored as a column?", "It's derivable from the movement ledger; storing it would risk it drifting out of sync (redundancy)."],
  ["When does an index hurt rather than help?", "On write-heavy columns you rarely filter on — it adds write cost with little read benefit."],
]);
summary("Module 2 · Summary", "Module 2 — key takeaways", [
  "Keys and constraints let the database enforce integrity for you.",
  "Normalize to 3NF to eliminate redundancy and anomalies; denormalize only with evidence.",
  "Indexes turn scans into seeks — index what you filter and join on.",
  "In regulated data, prefer adjustments over deletes to preserve the audit trail.",
]);

// =========================================================
// MODULE 3 — DBA & PERFORMANCE
// =========================================================
divider("Module 3", "Database Administration & Performance", "Execution plans, indexing strategy, backups, point-in-time restore, and replication.");
moduleAgenda("Module 3", "In this module", [
  ["Reading a query execution plan", "concept"],
  ["Scan vs seek — the core performance idea", "concept"],
  ["Designing the right index (covering/composite)", "concept"],
  ["Backups & point-in-time restore (PITR)", "concept"],
  ["Replication, geo-restore & failover groups", "concept"],
  ["Demo — diagnose and fix a slow query", "hands-on"],
]);
concept("Module 3 · Concept", "Reading a query execution plan",
  "The execution plan is the engine's step-by-step recipe for a query — it tells you exactly where the time goes.",
  [
    "Turn on 'Include Actual Execution Plan' in Azure Data Studio / SSMS, then run the query.",
    "Each operator shows a relative cost (%) — hunt for the highest-cost one.",
    "Thick arrows = many rows flowing; thin arrows = few. Fat arrows early are a warning.",
    "Hover an operator to see its Predicate (the WHERE clause it is evaluating).",
  ]);
twoCol("Module 3 · Concept", "Scan vs seek — the idea that unlocks performance",
  { head: "Table / Index SCAN  (slow)", items: [
    "Reads EVERY row and tests the WHERE clause",
    "Cost grows with table size — 12,000 rows, 12,000 reads",
    "Shows as 'Clustered Index Scan' at ~100% cost",
    "Symptom: query slows as data grows",
  ] },
  { head: "Index SEEK  (fast)", items: [
    "Jumps DIRECTLY to matching rows via an index",
    "Cost stays low as the table grows",
    "Requires an index on the filtered column(s)",
    "The fix: create the right non-clustered index",
  ] });
codeSlide("Module 3 · Concept", "Designing the right index", "A covering, composite index for a facility + risk + date query:",
`CREATE NONCLUSTERED INDEX IX_InspectionEvents_Facility_Risk_Date
ON dbo.InspectionEvents (FacilityCode, RiskLevel, EventDate)
INCLUDE (InspectorName, FindingSummary);`,
  [
    "Key columns (FacilityCode, RiskLevel, EventDate) support the WHERE and ORDER BY.",
    "INCLUDE carries the SELECT-list columns so the query is 'covered' — no key lookups.",
    "Result: the plan flips from a Clustered Index Scan to an Index Seek.",
  ]);
tableSlide("Module 3 · Concept", "Backups, recovery, and continuity on Azure SQL",
  ["Capability", "What it does", "Regulator use"],
  [
    ["Automated backups", "Continuous, managed by Azure", "No manual backup jobs to miss"],
    ["Point-in-time restore (PITR)", "Restore to any second in the window", "Undo bad data change / ransomware"],
    ["Geo-restore", "Restore from geo-redundant backup", "Recover from a regional outage"],
    ["Active geo-replication", "Readable secondary in another region", "Read scale-out + DR"],
    ["Failover groups", "Automatic/managed failover of the endpoint", "Availability of critical systems"],
  ], "Define RPO (how much data you can lose) and RTO (how fast you must recover) BEFORE you pick these.",
  [3.2, 5.0, 3.93]);
demo("Module 3 · Demo", "Demo — diagnose and fix a slow query",
  "Use an execution plan to find a scan, add an index, and prove the improvement.",
  [
    "Run day3_performance_lab.sql to build a ~12,000-row InspectionEvents table.",
    "Enable Actual Execution Plan; run the facility filter query.",
    "Identify the Clustered Index Scan at ~100% cost (the bottleneck).",
    "Create IX_InspectionEvents_Facility_Risk_Date (covering index).",
    "Re-run; confirm the plan now shows an Index Seek and fewer logical reads.",
    "Then walk through a PITR restore and a geo-replication setup.",
  ],
  "Before/after plans: Scan → Seek, with a visible drop in logical reads.");
knowledgeCheck("Module 3 · Review", [
  ["What operator in a plan usually signals a performance problem on a big table?", "A Clustered/Table Index Scan at high cost — it reads every row."],
  ["What is the difference between RPO and RTO?", "RPO = acceptable data loss (time); RTO = acceptable time to recover service."],
  ["Why add INCLUDE columns to an index?", "To 'cover' the query so it needs no key lookups back to the table — faster reads."],
]);
summary("Module 3 · Summary", "Module 3 — key takeaways", [
  "The execution plan shows exactly where a query spends its time.",
  "Turning a scan into a seek — via the right index — is the highest-leverage fix.",
  "Covering/composite indexes eliminate key lookups for common query shapes.",
  "Azure SQL gives you PITR, geo-restore, geo-replication and failover — driven by RPO/RTO.",
]);

// =========================================================
// MODULE 4 — SECURITY
// =========================================================
divider("Module 4", "Cybersecurity Essentials", "Threats, encryption, identity, secure configuration, and patching — the regulator's defensive core.");
moduleAgenda("Module 4", "In this module", [
  ["Threats & attack vectors", "concept"],
  ["Encryption at rest (TDE) & in transit (TLS)", "concept"],
  ["Identity & access: Entra ID, RBAC, MFA, CA", "concept"],
  ["Secure configuration & network isolation", "concept"],
  ["Patching & vulnerability management", "concept"],
  ["Demo — harden the database & app stack", "hands-on"],
]);
tableSlide("Module 4 · Concept", "Common threats and how we counter them",
  ["Threat", "How it happens", "Primary Azure control"],
  [
    ["Credential theft / phishing", "Stolen or reused passwords", "MFA + Conditional Access"],
    ["SQL injection", "Untrusted input in queries", "Parameterised queries + Defender for SQL"],
    ["Misconfiguration", "Public endpoints, over-broad access", "Azure Policy + Defender for Cloud"],
    ["Unpatched systems", "Known CVEs left open", "PaaS auto-patching + Update Manager"],
    ["Insider / excess privilege", "Too-broad roles", "RBAC least privilege + auditing"],
  ], null, [3.0, 4.6, 4.53]);
twoCol("Module 4 · Concept", "Encryption — at rest and in transit",
  { head: "At rest  ·  data on disk", items: [
    "Transparent Data Encryption (TDE) is ON by default for Azure SQL",
    "Protects data files, backups and logs if media is stolen",
    "Always Encrypted protects specific sensitive columns even from admins",
    "Keys can be managed in Azure Key Vault",
  ] },
  { head: "In transit  ·  data on the wire", items: [
    "Enforce a minimum TLS version (1.2+) on the SQL server",
    "All client connections then use encrypted channels",
    "Prevents eavesdropping on data moving between app and DB",
    "Reject older, weak protocol versions outright",
  ] });
concept("Module 4 · Concept", "Identity & access — the new perimeter",
  "In the cloud, identity is the primary security boundary — get least privilege and strong authentication right and most attacks fail at the door.",
  [
    "Microsoft Entra ID authenticates users and services centrally.",
    "RBAC grants the least privilege needed — not blanket Owner/Admin.",
    "MFA stops the majority of credential-based attacks.",
    "Conditional Access enforces context rules (location, device, risk) at sign-in.",
  ],
  "From 1 Oct 2026 Microsoft requires MFA for all Azure portal access — align the agency's admin accounts now.");
{ const s = pptx.slides[pptx.slides.length - 1]; srcFooter(s, [["Microsoft Entra MFA mandate", "https://techcommunity.microsoft.com/blog/microsoft-entra-blog/microsoft-entra-id-security-updates-what-organizations-need-to-do-now/4522024"], ["Conditional Access", "https://learn.microsoft.com/en-us/entra/identity/conditional-access/"]]); }
tableSlide("Module 4 · Concept", "Secure configuration & network isolation",
  ["Control", "What it does", "Why it matters"],
  [
    ["Server firewall rules", "Allow only known client IPs", "Removes open public exposure"],
    ["Private Endpoint", "DB reachable only on a private network", "No public internet path to data"],
    ["Disable public network access", "Turns off the public endpoint", "Strongest network posture"],
    ["Azure Policy", "Enforces config rules at scale", "Prevents drift & bad defaults"],
  ], "Defence in depth: identity + encryption + network isolation + monitoring — no single control is enough.",
  [3.2, 4.8, 4.13]);
demo("Module 4 · Demo", "Demo — harden the database & app stack",
  "Apply layered security controls to the Day 2 database and complete the hardening checklist.",
  [
    "Confirm TDE is enabled; set a minimum TLS version on the SQL server.",
    "Restrict access: tighten firewall rules and/or add a Private Endpoint.",
    "Configure Microsoft Entra authentication; assign least-privilege RBAC roles.",
    "Enable Microsoft Defender for SQL for threat alerts.",
    "Turn on Auditing / diagnostic logs and confirm events are captured.",
    "Complete day4_security_checklist.md with evidence for each control.",
  ],
  "A completed 24-control checklist with evidence — the capstone's security artifact, started here.");
knowledgeCheck("Module 4 · Review", [
  ["Is TDE something you must switch on for a new Azure SQL Database?", "It is ON by default — verify it and document it; add Always Encrypted for sensitive columns."],
  ["Why is identity called 'the new perimeter'?", "In the cloud there's no network wall — strong auth + least privilege is the primary boundary."],
  ["Name two controls that reduce network exposure of the database.", "Firewall rules limited to known IPs, and a Private Endpoint (or disabling public access)."],
]);
summary("Module 4 · Summary", "Module 4 — key takeaways", [
  "Most incidents are misconfiguration and credential theft — controls target exactly those.",
  "Encrypt at rest (TDE / Always Encrypted) and in transit (enforce TLS 1.2+).",
  "Identity is the perimeter: Entra ID + least-privilege RBAC + MFA + Conditional Access.",
  "Layer network isolation and turn on Defender + auditing for detection and evidence.",
]);

// =========================================================
// MODULE 5 — CAPSTONE
// =========================================================
divider("Module 5", "Integrated Lab & Capstone", "Bring cloud, database, and security together in one end-to-end secure deployment.");
moduleAgenda("Module 5", "In this module", [
  ["The capstone scenario", "brief"],
  ["The three required deliverables", "deliverables"],
  ["Mapping the solution to Azure services", "mapping"],
  ["The day's timeline & submission", "logistics"],
  ["The oral defense & how it's graded", "assessment"],
]);
concept("Module 5 · Brief", "The capstone scenario",
  "Deploy a small but real regulator application — Downstream Fuel Distribution Monitoring — to Azure, with a managed database and comprehensive security.",
  [
    "A simple web app (Azure App Service) backed by an Azure SQL Database.",
    "Comprehensive security controls applied end to end (the Module 4 checklist).",
    "Backup & disaster-recovery configured with defined RPO/RTO.",
    "Everything stays within free/low-cost tiers and an approved region for sovereignty.",
  ],
  "The scenario mirrors a live regulatory duty: monitor fuel distribution with auditable, available, protected data.");
{ const s = pptx.slides[pptx.slides.length - 1];
  SLIDE++; const s2 = pptx.addSlide(); head(s2, "Module 5 · Deliverables", "The three required deliverables");
  const deliv = [
    ["Architecture diagram", "Cloud resources, database configuration, and clearly marked security boundaries."],
    ["Security checklist", "Every implemented control documented with evidence (the Day 4 checklist, completed)."],
    ["Backup & DR plan", "RPO/RTO table, backup schedule, and step-by-step recovery procedures."],
  ];
  let dx = 0.6;
  deliv.forEach(d => {
    s2.addShape(pptx.ShapeType.rect, { x: dx, y: 2.0, w: 3.9, h: 3.4, fill: { color: SURF }, line: { color: BORD, width: 1 } });
    s2.addShape(pptx.ShapeType.rect, { x: dx, y: 2.0, w: 3.9, h: 0.75, fill: { color: TEAL } });
    s2.addText(d[0], { x: dx + 0.25, y: 2.0, w: 3.4, h: 0.75, fontFace: HFONT, fontSize: 16, bold: true, color: WHITE, valign: "middle" });
    s2.addText(d[1], { x: dx + 0.25, y: 2.95, w: 3.4, h: 2.3, fontFace: BFONT, fontSize: 14, color: TX, valign: "top" });
    dx += 4.07;
  });
  s2.addShape(pptx.ShapeType.rect, { x: 0.6, y: 5.65, w: 12.13, h: 0.85, fill: { color: INK } });
  s2.addText([{ text: "Plus an oral defense:  ", options: { bold: true, color: GOLD } }, { text: "a short presentation explaining the architectural, database, and security decisions.", options: { color: WHITE } }], { x: 0.9, y: 5.65, w: 11.5, h: 0.85, fontFace: BFONT, fontSize: 14, valign: "middle" });
  footer(s2, false);
}
tableSlide("Module 5 · Mapping", "Mapping the solution to Azure services",
  ["Requirement", "Azure service", "Ties back to"],
  [
    ["Application tier", "Azure App Service (PaaS)", "Module 1"],
    ["Managed database", "Azure SQL Database (free offer)", "Module 2"],
    ["Performance & recovery", "Indexes + PITR + geo-replication", "Module 3"],
    ["Identity & access", "Entra ID + least-privilege RBAC + MFA", "Module 4"],
    ["Secrets & encryption", "Key Vault + TDE + TLS", "Module 4"],
    ["Detection & evidence", "Defender for SQL + Auditing", "Module 4"],
  ], "The capstone is deliberately an assembly of the four prior modules — nothing new, everything integrated.",
  [3.4, 5.2, 3.53]);
tableSlide("Module 5 · Assessment", "How the capstone is graded (100 points)",
  ["Criterion", "Weight", "What earns top marks"],
  [
    ["Architecture diagram", "20", "Correct services + clear security boundaries"],
    ["Security checklist", "30", "Full control coverage with real evidence"],
    ["Backup & DR plan", "25", "Defined RPO/RTO + tested recovery steps"],
    ["Oral defense", "25", "Clear, correct rationale under questioning"],
  ], "Pass threshold is 70 points with per-section minimums — see Capstone_Grading_Rubric.md.",
  [4.2, 1.6, 6.33]);
summary("Module 5 · Summary", "Module 5 — key takeaways", [
  "The capstone integrates all four modules into one deployed, secure, recoverable app.",
  "Three artifacts: architecture diagram, completed security checklist, backup & DR plan.",
  "Every requirement maps to an Azure service the learner already used in a lab.",
  "The oral defense tests whether learners can justify their decisions, not just build.",
]);

// ---- closing ----
SLIDE++; { const s = pptx.addSlide(); s.background = { color: INK };
  s.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: 0.35, h: 7.5, fill: { color: TEAL } });
  s.addShape(pptx.ShapeType.rect, { x: 0.35, y: 0, w: 0.12, h: 7.5, fill: { color: GOLD } });
  s.addText("WHAT PARTICIPANTS LEAVE WITH", { x: 1.0, y: 1.5, w: 11, h: 0.4, fontFace: BFONT, fontSize: 14, bold: true, color: GOLD, charSpacing: 2 });
  s.addText("Integrated IT expertise across\nthree critical domains", { x: 1.0, y: 1.95, w: 11.6, h: 1.5, fontFace: HFONT, fontSize: 32, bold: true, color: WHITE, lineSpacingMultiple: 1.0 });
  s.addText([
    "A unified understanding of how cloud, database and security work together",
    "Practical, agency-ready checklists they can apply immediately",
    "Hands-on experience deploying a secure cloud app with a managed database",
    "A completed capstone demonstrating integrated IT operations competency",
  ].map(t => ({ text: t, options: { bullet: { characterCode: "2713", indent: 18 }, paraSpaceAfter: 11, color: FADE } })), { x: 1.02, y: 3.7, w: 10.9, h: 2.6, fontFace: BFONT, fontSize: 16 });
}

pptx.writeFile({ fileName: "/home/user/workspace/kit/slides/Cloud_DB_Security_Essentials_Course_Deck.pptx" }).then(() => console.log("WROTE — slides:", SLIDE));
