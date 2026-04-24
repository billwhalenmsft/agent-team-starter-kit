# 🤖 Agent Team Starter Kit

**An autonomous AI agent team, in a box.**

Deploy a team of specialized AI personas that run autonomously via GitHub Actions, use GitHub Issues as a work queue, and collaborate through an outcome-first delivery pipeline — all wired to Azure Functions + OpenAI.

Built on the [RAPP pipeline](https://github.com/kody-w/CommunityRAPP) framework by [Kody Wildfeuer](https://github.com/kody-w).

---

## ⚡ Quick Install

**Mac / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/billwhalenmsft/agent-team-starter-kit/main/install.sh | bash
```

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/billwhalenmsft/agent-team-starter-kit/main/install.ps1 | iex
```

Or clone and run manually:
```bash
git clone https://github.com/billwhalenmsft/agent-team-starter-kit.git
cd agent-team-starter-kit
python setup_agent_team.py
```

---

## 🎯 What You Get

| Component | Description |
|-----------|-------------|
| **Orchestrator** | L0 router — assigns work, manages pipeline |
| **Outcome Framer** | Gates all work on defined success metrics |
| **PM** | Sprint planning, backlog, status reporting |
| **SME** | SOPs, processes, domain documentation |
| **Developer** | Code gen, scaffolding, implementation (Python / Azure) |
| **Architect** | Solution design, stack recommendations |
| **DevOps Specialist Team** | PM + 4 discipline devs for Microsoft-stack builds (D365, AI, Power Platform, Analytics) |
| **+8 optional personas** | UX, QA, Security, Data Analyst, Content, and more |
| **GitHub Actions** | 3 workflows — manual run, issue handler, scheduled pulse |
| **Outcome Validator** | Nothing closes without verified outcomes |
| **Command Center** | Web UI dashboard — chat, agent status, outcomes, GitHub feed |

---

## 🗺️ How It Works

```
You create a GitHub Issue
       ↓
Add label: agent-task
       ↓
Issue Handler workflow fires
       ↓
Orchestrator routes to right persona
       ↓
Outcome Framer asks: what's the success metric?
       ↓
Agents collaborate through the pipeline:
  SME → Architect → Developer → Outcome Validator

  — or for Microsoft-stack builds —

  DevOps PM scopes + orders →
    D365 Dev → AI Specialist → PP Dev → Analytics Dev
       ↓
If agents need input: label needs-you → you comment → work resumes
       ↓
Outcome Validator signs off → issue closes with evidence
```

---

## 🚀 Setup (5 minutes)

### 1. Install
```bash
git clone https://github.com/billwhalenmsft/agent-team-starter-kit.git
cd agent-team-starter-kit
python setup_agent_team.py
```

The interactive setup will ask you:
- **Team name** (e.g. "Customer Success CoE")
- **GitHub repo** where the team will operate
- **Your GitHub username** (for the feedback loop)
- **Which personas** to include
- **Mode**: `coe` (scheduled, autonomous) or `project` (manual only)
- **Web UI**: whether to set up the Command Center dashboard

### 2. Set GitHub Secrets

In your repo → Settings → Secrets → Actions:

| Secret | Description |
|--------|-------------|
| `AZURE_OPENAI_ENDPOINT` | Your Azure OpenAI endpoint |
| `AZURE_OPENAI_DEPLOYMENT_NAME` | Model deployment (e.g. `gpt-4o`) |
| `AZURE_OPENAI_API_VERSION` | API version (e.g. `2024-08-01-preview`) |
| `AzureWebJobsStorage` | Azure Storage connection string |
| `AZURE_STORAGE_ACCOUNT_NAME` | Storage account name |

### 3. Test It
```bash
gh workflow run "my-team-manual-run" --repo owner/repo -f action=health_check
```

### 4. Create Your First Issue
1. Create a GitHub Issue describing a problem, idea, or use case
2. Add your team label + `raw-idea`
3. When ready: add `agent-task` → automation fires

### 5. Deploy the Command Center (Optional)
The setup script generates a single-file web dashboard at `web_ui/index.html`. Three free hosting options:

| Option | Cost | Steps |
|--------|------|-------|
| **GitHub Pages** | Free | Settings → Pages → Source: GitHub Actions |
| **Azure Static Web Apps** | Free tier | `az staticwebapp create` + add deploy token secret |
| **Azure Blob Storage** | ~$0.01/mo | `az storage blob service-properties update --static-website` |

See [`web_ui/DEPLOY.md`](web_ui/DEPLOY.md) for full instructions.

---

## 🏗️ DevOps Specialist Team

For multi-technology builds (D365 + AI + Power Platform + Analytics), the starter kit ships a pre-wired DevOps sub-team in `agents/devops/`.

```
DevOps PM
    ↓ scopes issue → detects disciplines → sets dependency order
D365 Developer          (runs first — entity schemas flow forward)
    ↓ prior_artifacts
AI Specialist           (Azure Foundry, OpenAI, M365 Declarative Agents)
    ↓ prior_artifacts
Power Platform Dev      (Copilot Studio topics, Power Automate flows, Canvas Apps)
    ↓ prior_artifacts
Analytics Developer     (picks right tool: D365 dashboard / Power BI / Excel / Azure Monitor)
```

The DevOps PM auto-detects which specialists are needed based on issue keywords (`d365`, `dataverse`, `copilot studio`, `power automate`, `ai`, `openai`, `report`, etc.) so you only pay for the work that's actually relevant.

See [`agents/devops/README.md`](agents/devops/README.md) for wiring instructions.

---

## 📁 Files

```
agent-team-starter-kit/
  setup_agent_team.py                     # Interactive setup script
  team_config.template.json               # Configuration template
  install.sh                              # Mac/Linux one-liner installer
  install.ps1                             # Windows one-liner installer
  QUICK_START.md                          # Step-by-step guide
  PERSONAS.md                             # Persona reference + use-case combos
  CHARTER_TEMPLATE.md                     # Fill-in-the-blank team charter
  agents/
    _base_persona_template.py             # Persona scaffold
    orchestrator_template.py              # Orchestrator with full pipeline
    devops/                               # DevOps Specialist Team (NEW)
      devops_pm_agent.py                  # Scope → detect disciplines → order
      d365_dev_agent.py                   # Dynamics 365 / Dataverse
      ai_specialist_agent.py             # Azure AI / OpenAI / M365
      pp_dev_agent.py                     # Power Platform / Copilot Studio
      analytics_dev_agent.py             # Analytics generalist
      README.md                           # Wiring guide
  workflows/
    manual_run_template.yml               # Trigger any action manually
    issue_handler_template.yml            # Fires on agent-task label
    scheduled_pulse_template.yml          # Autonomous cron schedules
    deploy_web_github_pages_template.yml  # GitHub Pages deployment
    deploy_web_azure_swa_template.yml     # Azure Static Web Apps deployment
  web_ui/
    index_template.html                   # Command Center SPA (config-driven)
    DEPLOY.md                             # Hosting guide — 3 options
```

---

## 🖥️ Command Center Web UI

The included web dashboard gives your team a visual hub:

- **Agent roster** — live status cards for each persona
- **Chat** — natural language to the Azure Functions backend
- **GitHub feed** — open issues, `needs-you` alerts, recent activity
- **Outcomes panel** — track KPIs and validated deliverables
- **Knowledge base** — quick access to SOPs and context cards

The setup script injects your team config (repo, team name, endpoint URL, agent list) into the template automatically. All values are driven from `{{PLACEHOLDER}}` tokens — nothing is hardcoded.

---

## 🏭 Real-World Example

This system powers the **Discrete Manufacturing Agentic CoE** — a fully autonomous agent team for Microsoft's manufacturing practice. See the full implementation at:

> [`billwhalenmsft/CommunityRAPP-BillWhalen`](https://github.com/billwhalenmsft/CommunityRAPP-BillWhalen) → `customers/mfg_coe/`

---

## 🧩 Persona Combos

| Use Case | Recommended Personas |
|----------|---------------------|
| **Autonomous CoE (full)** | All 14 personas + DevOps team |
| **Microsoft stack build** | Outcome Framer + PM + DevOps PM + D365 Dev + AI Specialist + PP Dev + Analytics Dev + Intake + Outcome Validator |
| **Software dev team** | PM + Developer + Architect + QA + Security + Intake + Outcome Validator |
| **Content / docs** | SME + Content Strategist + UX + Intake + Outcome Validator |
| **Lightweight project** | PM + Developer + Intake + Outcome Validator |
| **Consulting engagement** | PM + SME + Architect + Developer + Customer Persona + Outcome Validator |

> ⚠️ Always include **Outcome Framer** + **Outcome Validator** — they enforce that work starts with a defined outcome and ends with verified delivery.

See [`PERSONAS.md`](PERSONAS.md) for full details on every persona.

---

## 🔗 Related

- [RAPP Pipeline](https://github.com/kody-w/CommunityRAPP) — the underlying framework
- [AIBAST Agents Library](https://github.com/microsoft/aibast-agents-library) — pre-built agent library
- [RAR Registry](https://kody-w.github.io/RAR/) — community agent store
- [RAPP Installer](https://microsoft.github.io/aibast-agents-library/docs/installer.html) — full deployment guide

---

## 📄 License

MIT — use freely, contribute back.