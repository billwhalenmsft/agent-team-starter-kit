# DevOps Specialist Team

This folder contains the **DevOps Specialist Team** — a set of discipline-specific developer agents that work under the direction of the DevOps PM agent to build complete, multi-technology solutions.

## How It Works

1. **DevOps PM** (`devops_pm_agent.py`) receives a scoped issue, writes a `project_plan.md`, and returns an ordered list of specialist disciplines needed.
2. **Specialists run in dependency order** — D365 entities first, then AI layer (grounded in real field names), then Python/integration, then Power Platform (CS topics reference D365 fields), then Analytics.
3. Each specialist receives `prior_artifacts` from previous specialists so their output is integrated, not siloed.
4. All artifact files are batch git-committed when the full build completes.

## Agents

| File | Specialist | Technologies |
|------|-----------|--------------|
| `devops_pm_agent.py` | DevOps PM | Project planning, discipline routing, dependency ordering |
| `d365_dev_agent.py` | D365 Developer | Dataverse entities, PowerShell provisioning, OData queries, solution configs |
| `ai_specialist_agent.py` | AI Specialist | Azure AI Foundry, Azure OpenAI, M365 Declarative Agents, Semantic Kernel, RAG/AI Search |
| `pp_dev_agent.py` | Power Platform Dev | Copilot Studio YAML (CAT team patterns), Power Automate flows (Skills kind), Canvas App stubs |
| `analytics_dev_agent.py` | Analytics Dev | D365 dashboards, Power BI, Excel analysis, Azure Monitor, CS Adaptive Cards — recommends the right tool per audience |

## Discipline Detection Keywords

The DevOps PM auto-detects which specialists are needed based on issue content:

| Specialist | Trigger Keywords |
|---|---|
| `d365_dev` | d365, dataverse, entity, crm, provision, odata, dynamics |
| `ai_specialist` | foundry, openai, gpt, rag, semantic kernel, declarative agent, ai search |
| `python_dev` | azure function, python, api, coe runner, github action, flask |
| `pp_dev` | copilot studio, power automate, flow, power apps, topic, canvas |
| `analytics_dev` | power bi, dashboard, kpi, excel, azure monitor, report, analytics |

If no keywords match, defaults to `["d365_dev", "pp_dev"]`.

## Wiring into the Orchestrator

```python
from agents.devops.devops_pm_agent import MfgCoEDevOpsPMAgent
from agents.devops.d365_dev_agent import MfgCoED365DevAgent
from agents.devops.pp_dev_agent import MfgCoEPPDevAgent
from agents.devops.ai_specialist_agent import MfgCoEAISpecialistAgent
from agents.devops.analytics_dev_agent import MfgCoEAnalyticsDevAgent

# In orchestrator __init__:
self.devops_pm = MfgCoEDevOpsPMAgent()
self.d365_dev = MfgCoED365DevAgent()
self.pp_dev = MfgCoEPPDevAgent()
self.ai_specialist = MfgCoEAISpecialistAgent()
self.analytics_dev = MfgCoEAnalyticsDevAgent()

SPECIALIST_MAP = {
    "d365_dev": self.d365_dev,
    "ai_specialist": self.ai_specialist,
    "python_dev": self.developer,   # existing Python developer agent
    "pp_dev": self.pp_dev,
    "analytics_dev": self.analytics_dev,
}
```

See `customers/mfg_coe/agents/mfg_coe_orchestrator_agent.py` for the full `_execute_build()` implementation.
