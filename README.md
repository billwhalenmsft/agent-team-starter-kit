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
| **Developer** | Code gen, scaffolding, implementation |
| **Architect** | Solution design, stack recommendations |
| **+8 optional personas** | UX, QA, Security, Data Analyst, Content, and more |
| **GitHub Actions** | 3 workflows — manual run, issue handler, scheduled pulse |
| **Outcome Validator** | Nothing closes without verified outcomes |

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

---

## 📁 Files

```
agent-team-starter-kit/
  setup_agent_team.py          # Interactive setup script
  team_config.template.json    # Configuration template
  install.sh                   # Mac/Linux one-liner installer
  install.ps1                  # Windows one-liner installer
  QUICK_START.md               # Step-by-step guide
  PERSONAS.md                  # Persona reference + use-case combos
  CHARTER_TEMPLATE.md          # Fill-in-the-blank team charter
  agents/
    _base_persona_template.py  # Persona scaffold
    orchestrator_template.py   # Orchestrator with full pipeline
  workflows/
    manual_run_template.yml    # Trigger any action manually
    issue_handler_template.yml # Fires on agent-task label
    scheduled_pulse_template.yml  # Autonomous cron schedules
```

---

## 🏭 Real-World Example

This system powers the **Discrete Manufacturing Agentic CoE** — a fully autonomous agent team for Microsoft's manufacturing practice. See the full implementation at:

> [`billwhalenmsft/CommunityRAPP-BillWhalen`](https://github.com/billwhalenmsft/CommunityRAPP-BillWhalen) → `customers/mfg_coe/`

---

## 🧩 Persona Combos

| Use Case | Recommended Personas |
|----------|---------------------|
| **Autonomous CoE** | All 14 personas |
| **Software dev team** | PM + Developer + Architect + QA + Security + Intake + Outcome Validator |
| **Content / docs** | SME + Content Strategist + UX + Intake + Outcome Validator |
| **Lightweight project** | PM + Developer + Intake + Outcome Validator |

> ⚠️ Always include **Outcome Framer** + **Outcome Validator** — they enforce that work starts with a defined outcome and ends with verified delivery.

See [`PERSONAS.md`](PERSONAS.md) for full details.

---

## 🔗 Related

- [RAPP Pipeline](https://github.com/kody-w/CommunityRAPP) — the underlying framework
- [AIBAST Agents Library](https://github.com/microsoft/aibast-agents-library) — pre-built agent library
- [RAR Registry](https://kody-w.github.io/RAR/) — community agent store
- [RAPP Installer](https://microsoft.github.io/aibast-agents-library/docs/installer.html) — full deployment guide

---

## 📄 License

MIT — use freely, contribute back.
