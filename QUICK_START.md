# Agent Team Starter Kit — Quick Start

Get a fully-wired autonomous agent team running in under 30 minutes.

---

## Prerequisites

- Python 3.11+
- `gh` CLI authenticated (`gh auth status`)
- Azure Storage account + Azure OpenAI deployment
- A GitHub repo where the team will operate

---

## Step 1 — Copy the Template

```bash
# From the repo root
cp -r templates/agent-team customers/my_team_name
cd customers/my_team_name
```

Or keep it in `templates/agent-team/` and run the setup script — it writes output to a path you specify.

---

## Step 2 — Run Setup

**Interactive (recommended for first time):**
```bash
python templates/agent-team/setup_agent_team.py
```

**Config file (repeatable, CI-friendly):**
```bash
# Edit team_config.template.json, save as team_config.json
python templates/agent-team/setup_agent_team.py --config team_config.json
```

**Dry run (preview without writing):**
```bash
python templates/agent-team/setup_agent_team.py --dry-run
```

The script will:
- Create your team directory with agent stubs
- Generate GitHub Actions workflows
- Create all GitHub labels
- Write a `CHARTER.md` for your team
- Optionally set up the Command Center web UI

---

## Step 3 — Fill In Your Agent Logic

Each generated agent file has `TODO` placeholders:
```
customers/my_team/agents/
  my_team_orchestrator_agent.py   ← wire up routing here
  my_team_pm_agent.py             ← fill in PM logic
  my_team_developer_agent.py      ← fill in dev logic
  ...
```

See `customers/mfg_coe/agents/` for fully-implemented examples.

**Minimum to fill in per agent:**
1. Replace `TODO: describe the X role` in the metadata `description`
2. Implement at least one action method (e.g., `_define_use_case`)
3. Return a JSON string from `perform()`

---

## Step 4 — Wire the Orchestrator

In `my_team_orchestrator_agent.py`:

1. **Uncomment imports** near the top:
```python
# from customers.my_team.agents.my_team_pm_agent import MyTeamPmAgent
```
→
```python
from customers.my_team.agents.my_team_pm_agent import MyTeamPmAgent
```

2. **Uncomment agent instantiation** in `__init__`:
```python
# "pm": MyTeamPmAgent(),
```
→
```python
"pm": MyTeamPmAgent(),
```

3. **Add keywords to ROUTING_MAP:**
```python
ROUTING_MAP = {
    "pm": ["sprint", "backlog", "plan", "status"],
    "developer": ["code", "build", "implement", "scaffold"],
    ...
}
```

---

## Step 5 — Set GitHub Secrets

In your repo → Settings → Secrets → Actions:

| Secret | Description |
|--------|-------------|
| `AZURE_OPENAI_ENDPOINT` | Your Azure OpenAI endpoint URL |
| `AZURE_OPENAI_DEPLOYMENT_NAME` | Model deployment name (e.g. `gpt-4o`) |
| `AZURE_OPENAI_API_VERSION` | API version (e.g. `2024-08-01-preview`) |
| `AzureWebJobsStorage` | Azure Storage connection string |
| `AZURE_STORAGE_ACCOUNT_NAME` | Storage account name (without `.blob.core.windows.net`) |

Optional (for GitHub issue creation from agents):
| Secret | Description |
|--------|-------------|
| `GH_TOKEN` | GitHub PAT with `repo` scope (falls back to `GITHUB_TOKEN`) |

---

## Step 6 — Test It

```bash
# Trigger a health check (should return JSON with all agents listed)
gh workflow run "my-team-manual-run" \
  --repo owner/repo \
  -f action=health_check

# View results
gh run list --workflow "my-team-manual-run" --limit 3
gh run view <run_id> --log
```

---

## Step 7 — Create Your First Issue

1. Create a GitHub Issue in your repo describing a feature, problem, or idea
2. Add your team label (e.g. `my-team`) + `raw-idea`
3. When ready to hand off to agents, add `agent-task`
4. The issue handler workflow fires automatically

Watch the run:
```bash
gh run list --workflow "my-team-issue-handler" --limit 3
```

---

## Step 8 — Deploy the Command Center (Optional)

The setup script (Step 2) offers to generate a web dashboard for your team. If you skipped it, run:

```bash
python templates/agent-team/setup_agent_team.py --config team_config.json
# Answer Y when asked about the web UI
```

This creates `customers/my_team/web_ui/index.html` — a single-file SPA with:
- Agent status cards
- Chat to the Azure Functions backend
- GitHub Issues feed + `needs-you` alerts
- Outcomes panel

### Deploy Option A — GitHub Pages (Free, Easiest)

```bash
# The setup script generates .github/workflows/my_team_deploy_web.yml
# Enable Pages in Settings → Pages → Source: GitHub Actions
git add customers/my_team/web_ui/ .github/workflows/
git commit -m "feat: add team web UI"
git push
```

### Deploy Option B — Azure Static Web Apps (Free Tier)

```bash
az staticwebapp create \
  --name my-team-command-center \
  --resource-group myRG \
  --location "eastus2" \
  --sku Free \
  --source https://github.com/owner/repo \
  --branch main \
  --app-location "customers/my_team/web_ui" \
  --output-location "."

# Copy the deployment token → repo Settings → Secrets → AZURE_STATIC_WEB_APPS_API_TOKEN
```

### Deploy Option C — Azure Blob Static Website (~$0.01/month)

```bash
az storage blob service-properties update \
  --account-name mystorageaccount \
  --static-website \
  --index-document index.html

az storage blob upload \
  --account-name mystorageaccount \
  --container-name '$web' \
  --name index.html \
  --file customers/my_team/web_ui/index.html \
  --overwrite
```

See [`web_ui/DEPLOY.md`](web_ui/DEPLOY.md) for full comparison table, cost breakdown, and troubleshooting.

---

## Modes

### CoE Mode (default)
Full autonomous operation:
- Scheduled standup, wrap-up, and hourly pulse runs
- Agents process backlog, post updates, flag decisions
- Owner reviews `needs-you` issues and comments to unblock

### Project Mode
Lightweight, manual-trigger only:
- No scheduled runs
- `manual_run` + `issue_handler` workflows only
- Good for one-off projects or dev teams without scheduled automation

Set in `team_config.json`:
```json
{ "mode": "project" }
```

---

## Choosing Personas

| Use Case | Recommended Personas |
|----------|---------------------|
| Software product team | PM + Developer + Architect + UX Designer + QA + Security |
| Content / docs team | SME + Content Strategist + UX Designer + Intake |
| CoE (full) | All 14 personas |
| Lightweight solo project | PM + Developer + Intake + Outcome Validator |
| Research / analysis | SME + Data Analyst + Architect + Outcome Framer |

> 💡 Always include **Outcome Framer** and **Outcome Validator** — they enforce the outcome-first philosophy and prevent work from proceeding without a defined success metric.

See `PERSONAS.md` for detailed descriptions and examples.

---

## Directory Structure (Generated)

```
customers/my_team/
  agents/
    my_team_orchestrator_agent.py   ← L0 router
    my_team_pm_agent.py             ← One file per persona
    my_team_developer_agent.py
    ...
    runner.py                       ← GitHub Actions CLI entry point
    __init__.py
  knowledge_base/
    README.md                       ← Add context cards here
  outcomes/
    .gitkeep                        ← Outcome logs written here
  web_ui/
    index.html                      ← Command Center dashboard (generated)
    DEPLOY.md                       ← Hosting options guide
  CHARTER.md                        ← Team mission + pipeline
```

```
.github/workflows/
  my_team_manual_run.yml            ← Trigger any action manually
  my_team_issue_handler.yml         ← Fires on agent-task label / owner feedback
  my_team_scheduled_pulse.yml       ← Autonomous hourly/daily runs (CoE mode)
  my_team_deploy_web.yml            ← Web UI deployment (if enabled)
```

---

## Troubleshooting

**Workflow fails with `ModuleNotFoundError`:**
- Check that `__init__.py` exists in `agents/`
- Verify the import path in `runner.py` matches your output path

**Workflow fails with `NameError: name 'os' is not defined`:**
- Add `import os` near the top of your orchestrator (known gotcha)

**Labels not created:**
- Run `gh auth status` — must have `repo` scope
- Try creating manually: `gh label create "agent-task" --color 7057ff --repo owner/repo`

**Health check returns empty agent list:**
- Uncomment agent imports + instantiations in the orchestrator

**Web UI shows no agents / wrong team name:**
- Re-run `setup_agent_team.py` and answer Y to the web UI prompt
- Or manually replace `{{PLACEHOLDERS}}` in `web_ui/index_template.html`

---

## Reference

- Working example: `customers/mfg_coe/`
- Persona templates: `templates/agent-team/agents/`
- Workflow templates: `templates/agent-team/workflows/`
- Web UI template: `templates/agent-team/web_ui/index_template.html`
- Config reference: `templates/agent-team/team_config.template.json`
- Persona guide: `templates/agent-team/PERSONAS.md`
- Deployment guide: `templates/agent-team/web_ui/DEPLOY.md`
