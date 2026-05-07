# Connect Hooks — Principal Promotion Evidence

> **CRM-validated April 14, 2026.** All financial claims cross-referenced against live Dynamics 365 data. Attribution confirmed via `crm_whoami` (Jin Lee, SE). Numbers marked with ✅ are CRM-verified; projections marked with 📊.

---

## Pillar 1: Field Platform IP — Building for the Organization, Not Just Customers

### Hook 1: MCAPS IQ — Agentic Field Enablement Platform

- Date: 2025-10 through 2026-04 (ongoing)
- Impact Area(s): Culture & Collaboration, Business Impact
- Hook: Designed, built, and shipped MCAPS IQ — a production-grade agentic platform that gives any MSX account team member (SE, CSA, CSAM, Specialist) AI-orchestrated CRM operations, M365 context synthesis, and role-aware workflow automation through a single interface. Demonstrated to a ~198-person field audience on March 18, 2026. Led the 18-member v-team bi-weekly driving adoption and roadmap. 5 human contributors actively committing code. This is not a demo — it is the architecture pattern for how the field will work.
- Evidence: 281 commits since Oct 2025 across the platform. 5 active human contributors (Jin Lee: primary architect/291 commits, Len Volk: 117 commits, Johanson Sandrasagra: 11, Andrea Welker: 10, Joe Karasha: 8). ~198-person field demo (March 18). 18-attendee v-team bi-weekly (March 26). Richard diZerega (April 8 demo) — reacted positively, potential for broader ISV evangelism and platform narrative. Bill Inacio (FSI, March 16) validated trust model and positioning as next evolution of FSI's existing Milestone Copilot pattern. Len Volk direct quotes: "you changed my life man", "my SSPs love how I've transformed", "like really i can be SSP now". Security review actively in progress — threat model submitted, ServiceTree registration coordinated.
- Source: Repo JinLee794/MCAPS-IQ (git history); vault Projects/MCAPS Copilot Tools; Daily 2026-04-08 (diZerega demo); Weekly 2026-W12 (198-person demo); Weekly 2026-W13 (v-team bi-weekly)
- Next step: Complete security review and MSFT tenant deployment; track post-demo adoption metrics; expand v-team scope.

---

### Hook 2: ART Voice Agent Accelerator — Cross-Industry Open-Source IP

- Date: 2025-Q2 through 2026-04 (ongoing)
- Impact Area(s): Customer Impact, Culture & Collaboration
- Hook: Created and published the ART Voice Agent Accelerator as an official Azure Sample (github.com/Azure-Samples/art-voice-agent-accelerator) — a production-grade, multi-industry voice AI reference architecture covering ACS telephony, Azure OpenAI, Speech Services, APIM, and Redis. Built healthcare (Stryker voice translation), banking, and insurance variants with multi-agent handoff and synthetic persona generator. Leading the Americas v-team (8 members across GBBs, SEs, and CSAs) to drive field adoption and Foundry Agents v2 integration.
- Evidence: 890+ commits by Jin (primary author) across the repo. Published under Azure-Samples (Microsoft official public sample). Multi-contributor: Pablo Salvador (302 commits), Joe Karasha, Stephen Mann, Mike Olivieri. Americas v-team sync (April 2 — 8 attendees: Sergey Chernykh, Faris Ali Akbar, Julie Morin, Aurora Santiago-Moore, David Barkol, Anna Quincy, Will Owens). Stryker Orpheus voice translation pipeline directly derived from this accelerator. Banking/insurance variant with synthetic persona generator for customers lacking test data. 15-theme POC scoping checklist created for field reuse across any voice-to-voice/CCaaS engagement.
- Source: Repo Azure-Samples/art-voice-agent-accelerator (git history); vault Meetings/2026-04-02 ART Agent v-team Sync Americas; Promo Guide § Moving Boldly
- Next step: Integrate Foundry Agents v2 (Mike Olivieri changes); track field adoption metrics across engagements.

---

### Hook 3: KATE — Personalized Agent Scaffolding for the Field

- Date: 2025-Q4 through 2026-04 (ongoing)
- Impact Area(s): Culture & Collaboration
- Hook: Built KATE (Knowledge-Augmented Technical Engine) — a scaffolding system that lets any SE or CSA create a personalized, role-aware agent from MCAPS IQ patterns without writing code. Includes onboarding prompts, industry selection, PBI pipeline hygiene integration, and MCP server security guidance. Designed so the field can adopt agentic workflows at their own pace with guardrails built in.
- Evidence: 68 commits since Oct 2025 (Jin: primary author, Joel Borellis: contributor). Includes bootstrap scripts, role configuration, industry-specific prompt files, PBI integration for pipeline hygiene. MCP server security guidance skill added after identifying configuration risks during field adoption.
- Source: Repo microsoft/KATE (git history); vault Projects/MCAPS Copilot Tools
- Next step: Expand industry templates; track adoption through MCAPS-IQ Personalized Agent Sync sessions.

---

## Pillar 2: V-Team Leadership & Cross-Org Orchestration

### Hook 4: Leading Multi-Team Alignment Across the Agentic Wave

- Date: 2026-02 through 2026-04 (ongoing)
- Impact Area(s): Culture & Collaboration, Business Impact
- Hook: Initiated and lead multiple concurrent v-teams orchestrating the agentic AI wave across organizations: MCAPS-IQ v-team bi-weekly (18 attendees), ART Agent Americas v-team (8 members), MCP Server architecture discussions (10 attendees with Ian Santillan), personalized agent sync sessions, and cross-team security review coordination. Proactively engaged GBB Speech Core Team for Stryker escalation, bridged MSFT and GitHub at BD, and escalated Ask vs Agent mode architectural question to GitHub (Steve Lange).
- Evidence: V-team bi-weekly March 26 — 18 attendees. ART Americas sync April 2 — 8 attendees. MCP Server for MSX/MSXI discussion March 26 — 10 attendees. Personalized Agent Sync March 25 — 3 attendees. GBB Speech Core Team engagement for Stryker (direct escalation, not routed). GitHub Copilot agent mode direction escalated to Steve Lange. Stryker AI onsite (May 21-22) — proactively identified Fabric, Power Platform, and enterprise integration expertise gaps and initiated cross-team coverage.
- Source: Vault Projects/MCAPS Copilot Tools (meeting log); Daily notes 2026-04-08, 2026-04-13; Weekly ROB 2026-03-31
- Next step: Formalize v-team charter and adoption tracking; expand to include CSU participants.

---

## Pillar 3: Security & Governance as First-Class Architecture

### Hook 5: Security-First Approach to Agentic Systems

- Date: 2026-02 through 2026-04 (ongoing)
- Impact Area(s): Customer Impact, Culture & Collaboration
- Hook: Integrated security and governance as architectural first principles across every agentic system — not as a compliance afterthought. Designed the human-approval guardrail pattern in MCAPS IQ (agent stages change → user sees diff → user approves). Led Cencora's Agent 365 governance COE design (Entra RBAC, Conditional Access per agent, registry model) for their enterprise deployment. Built MCP server security guidance skill into KATE. Currently driving threat model review and ServiceTree registration to enable MSFT tenant deployment of MCAPS IQ.
- Evidence: MCAPS IQ staged-write trust model validated by Bill Inacio (FSI). Cencora Agent 365 governance deep-dive (Feb 24) shaped their enterprise COE — Entra app registration, Conditional Access, Defender/Purview integration. Asurion ad-hoc: delivered structured guidance on prompt injection, RAG guardrails, document-level RBAC. VaultWhisper production audit: 7 issues (3 P0) including race conditions and Swift concurrency violations. Threat model review in progress (April 13) — ServiceTree ID mismatch identified and being resolved.
- Source: Daily 2026-04-13 (security review); vault Meetings/2026-02-24 Cencora Monthly Gen AI Connect; Promo Guide § Security and Governance; KATE repo security guidance skill
- Next step: Complete threat model review; publish security guidance patterns for field MCP server deployments.

---

## Pillar 4: Cross-Industry Customer Technical Outcomes

### Hook 6: Cencora — Enterprise AI Platform Architecture

- Date: 2026-02-24 through 2026-02-25
- Impact Area(s): Customer Impact, Business Impact
- Hook: Led architecture deep-dives at Cencora (region's highest-priority healthcare account) that established APIM + AI Gateway converging to a single Foundry control plane as a durable, repeatable platform north star — not a point fix. Designed enterprise agent governance patterns (Entra RBAC, Conditional Access, registry model) for Cencora's Agent 365 deployment. This architecture pattern is reusable for any enterprise AI platform customer.
- Evidence: Production-critical BYO Model Gateway + Azure AI Foundry integration unblocked through JWT auth policy, OBO/MFA flow analysis, and endpoint discovery guidance. Agent 365 governance positioned as enterprise control plane — Cencora endorsed active preview pilot. Architecture designed as "repeatable platform north star" (not customer-specific fix).
- Source: Vault meeting notes — 2026-02-24 Cencora Monthly Gen AI Connect; 2026-02-25 Cencora Azure Pipe Review; 2026-02-25 Cencora Bi-Monthly Innovation Sync
- Next step: Track Foundry BYO gateway GA timing; validate enterprise pattern adoption across other accounts.

---

### Hook 7: Stryker — From Voice Translation POC to Enterprise AI Strategy

- Date: 2026-02-24 through 2026-04-07
- Impact Area(s): Customer Impact, Business Impact
- Hook: Built a sustained technical engagement at Stryker that expanded from a single voice translation POC (Project Orpheus) to an enterprise-wide AI strategy — culminating in Stryker leadership inviting Microsoft to a 2-day AI ideation onsite (May 21-22, Kalamazoo). PBI Agent POC success was the catalyst; scope expanded to Salesforce, Oracle CPQ, ServiceMax, and Highspot integration. Proactively identified and surfaced a critical disaster recovery gap (all infrastructure in Boulder, zero failover) and reframed the stalled DC migration conversation toward Azure ARC as a higher-value entry point. ✅ Vocera Badge Modernization: 16 milestones at $172.6K/mo.
- Evidence: Customer champion described Jin as "the brains behind our current PowerBI agent" (Teams, April 7). 4 Stryker leaders now in onsite planning thread (David Trombley, Erika Norton, Eric Hudson, Skyler). ✅ CRM-verified: Vocera Badge Mod = 16 milestones/$172.6K/mo. Boulder DC Exit Infra = $100K/mo (3 milestones). DR gap with zero failover surfaced during Azure bi-weekly. GBB Speech Core Team directly engaged for live translation performance escalation.
- Source: Teams chats 2026-04-07; vault meeting notes 2026-02-24 Stryker Orpheus Sprint Demo; 2026-03-02 Int SYK Azure Bi-weekly; Stryker May 2026 AI Ideation Onsite project note
- Next step: Confirm Microsoft attendee roster for May onsite; track pipeline expansion from ideation session; validate ARC DR proposal with Jawaid Tariq (CSA).

---

### Hook 8: R1 RCM / Phare Health — AI-Scale Architecture & Revenue Discovery

- Date: 2026-02-27
- Impact Area(s): Customer Impact, Business Impact
- Hook: Led technical architecture assessment for R1 RCM / Phare Health Azure OpenAI scale-up — validated cost projections and designed a staged milestone approach (10% initial target) that unblocked UATs without overcommitting. Proactively surfaced the full expansion signal including AWS→Azure migration across ~30 customer orgs.
- Evidence: ✅ CRM-verified current: Phare Health Solution - OpenAI at $271K/mo MU (Empower & Achieve stage). 📊 Projected full-scale: gpt-5-mini ~$1M/mo, gpt-5.2 ~$4M/mo. Staged 10% milestone approach accepted by account team. AWS→Azure migration signal confirmed across ~30 customer orgs with 90-120 day window.
- Source: Vault meeting note — 2026-02-27 R1 RCM / Phare Health – Azure OpenAI Capacity & Strategy Review
- Next step: Technical architecture + consumption review with Phare Health for token-reduction optimization.

---

### Hook 9: Epic — PTU Strategy & Multi-Model Architecture

- Date: 2026-02-25, 2026-02-26
- Impact Area(s): Customer Impact, Business Impact
- Hook: Led Epic AI strategy discussions covering PTU consolidation across 3 regions (East US, North Central US, South Central US), GPT-Realtime-1.5 pricing impact analysis (~90% cached input cost reduction), and multi-model strategy evaluation (Anthropic Claude via Azure Foundry with HIPAA constraints). Identified and connected GBB SMEs to address blocked regional availability milestones, ensuring the right expertise is driving resolution.
- Evidence: ✅ CRM-verified: OpenAI for Epic at $916.7K/mo consumed (Realize Value stage), 29 milestones (21 completed, 3 blocked on GPT 4.1 regional availability in Canada/Australia/Singapore, 2 on track). Forecast comments authored by "JL" — attribution confirmed. PTU consolidation plan received from Epic.
- Source: Vault meeting notes — 2026-02-25 Epic Referrals and Auths Gen AI Monthly; 2026-02-26 Epic AI Internal Weekly
- Next step: Track GPT 4.1 regional availability resolution; follow up on PTU consolidation working session.

---

### Hook 10: BlueKC — Hands-on-Keyboard Deployment Unblocking

- Date: 2026-02-24, 2026-03-03
- Impact Area(s): Customer Impact
- Hook: Led BlueKC Prior Authorization deployment through multi-session hands-on-keyboard working sessions — diagnosed Container App Environment private endpoint Bicep deployment failures (timeout on deployment; works via Portal) and delivered modified IaC templates to unblock production deployment. This is direct technical execution at the code level, not advisory.
- Evidence: Two working sessions Feb 24 (deployment review + debugging). Mar 3 follow-up: identified Bicep issue with Container App Environment + private endpoints; provided modified Bicep referencing portal-created resources plus env var update script. Function App delivery and IaC upskilling sessions documented in vault.
- Source: Vault meeting notes — 2026-02-24 BlueKC PA Deployment; Daily 2026-03-03; BlueKC vault Connect Hooks section
- Next step: Validate modified Bicep deployment; confirm customer completed production deployment.

---

## Pillar 5: Thought Leadership & Published Content

### Hook 11: Agentic Transformation — Published Thought Leadership

- Date: 2026-03 (ongoing)
- Impact Area(s): Culture & Collaboration
- Hook: Published two field-facing blog posts on agentic transformation patterns — "Welcome to the Agentic Era" and "What Agentic Transformation Actually Looks Like Inside the Enterprise" (March 2026). Produced reusable field artifact library: ARTAgent Omnichannel AI Agents deck (voice-to-voice architecture), Azure Real-Time Pricing workbook (ACS/Redis/Voice Live cost modeling), Agent 365 Governance positioning, and Claude/Anthropic GA talking points. These are patterns, not point solutions — designed so any SE on the team can apply them.
- Evidence: Two blog posts published March 2026. Artifact library documented in Promo Guide § Field Enablement. Azure Real-Time Pricing workbook addresses cost modeling gap that would slow every voice engagement. 15-theme POC scoping checklist for voice-to-voice/CCaaS engagements created for field reuse.
- Source: Published blog posts; Promo Guide § Field Enablement & Capability Building; ART repo artifacts
- Next step: Track artifact adoption; measure field reuse across engagements.

---

> **What was removed and why:**
> - **SAP R6 references** — not Jin's primary work; new specialist owns this area
> - **Stryker DR Gap dollar figures** — previous hook had 3 numerical errors (CRM audit: $60K was $35K, $221K was $172.6K, 18 milestones was 16). DR gap narrative preserved and corrected in Hook 7.
> - **Epic "driving blocked milestones"** framing — Jin identified SMEs and connected GBBs but is not the primary driver; new specialist joined. Reframed as PTU strategy and SME orchestration in Hook 9.
> - **Cencora Model Gateway milestone** — milestone now Cancelled in CRM. Governance architecture work preserved in Hook 6.
> - **ACS Retirement standalone hook** — March 18 date has passed; intelligence-gathering was valid but the standalone hook is low-impact. ACS context preserved where relevant.
> - **Cencora "34,200 M365 Copilot users"** — unverifiable in CRM (likely from customer statement or PBI). Removed until source is confirmed.
