# Agent Team Personas — Reference Guide

Each persona is a specialized AI agent with a defined role, keyword routing triggers, and a set of actions. Choose the combination that fits your team's mission.

---

## Core Personas (always recommended)

### 🎯 Outcome Framer
**File:** `{team_slug}_outcome_framer_agent.py`
**Purpose:** Ensures every issue has a defined outcome before any build work begins. The CoE's "why-first" gate.

**When invoked:** Any issue without a defined success metric. Also triggered when a work item is first created.

**Key actions:** `frame_outcome`, `define_kpi`, `validate_feasibility`, `output_outcome_statement`

**Why it matters:** Without defined outcomes, agents can build the wrong thing. This persona asks: *What does success look like? Who measures it? How will we know when we're done?*

---

### 📋 Intake / Logger
**File:** `{team_slug}_intake_agent.py`
**Purpose:** Captures raw ideas, logs agent-generated solutions, and escalates to the human owner when needed.

**When invoked:** New raw ideas, solution logging, `needs-bill` escalations.

**Key actions:** `log_idea`, `log_solution`, `flag_for_owner`, `get_backlog`

---

### ✅ Outcome Validator
**File:** `{team_slug}_outcome_validator_agent.py`
**Purpose:** Before closing any issue, validates that the stated outcome was actually delivered and documented.

**When invoked:** Issues labeled `outcome-validated` or near-completion pipeline items.

**Key actions:** `validate_outcome`, `check_kpi_met`, `request_sign_off`, `archive_outcome`

---

## Planning Personas

### 🗂️ Project Manager (PM)
**File:** `{team_slug}_pm_agent.py`
**Purpose:** Sprint planning, backlog prioritization, status reporting, conflict detection.

**When invoked:** Keywords: `sprint`, `backlog`, `plan`, `status`, `prioritize`, `assign`, `roadmap`

---

## 🏗️ DevOps Specialist Team (NEW)

A sub-team that handles multi-technology builds. The DevOps PM scopes issues and routes in dependency order. Each specialist receives prior artifacts from earlier specialists.

**Folder:** `agents/devops/` — see `agents/devops/README.md` for wiring instructions.

### 🧭 DevOps PM
**File:** `agents/devops/devops_pm_agent.py`
**Purpose:** Scopes issues into structured project plans, detects specialist disciplines needed, orders deliverables by dependency.

**Key actions:** `scope_issue`, `create_project_plan`, `assign_specialists`, `track_progress`

### ⚙️ D365 Developer
**File:** `agents/devops/d365_dev_agent.py`
**Purpose:** Generates Dynamics 365 / Dataverse artifacts — entity schemas, PowerShell provisioning scripts, OData queries, solution configs.

**Runs first** — entity schemas passed as `prior_artifacts` to AI Specialist and PP Dev.

### 🤖 AI Specialist
**File:** `agents/devops/ai_specialist_agent.py`
**Purpose:** Azure AI Foundry configs, Azure OpenAI system prompts, M365 Declarative Agent manifests, Semantic Kernel orchestration, RAG / AI Search pipelines.

### 🔌 Power Platform Developer
**File:** `agents/devops/pp_dev_agent.py`
**Purpose:** Copilot Studio topic YAML (CAT team patterns embedded), Power Automate flows (Skills kind), Canvas App stubs.

**CAT patterns baked in:** `allowInterruption: true`, `kind: Skills`, `string()` cast warnings.

### 📊 Analytics Developer
**File:** `agents/devops/analytics_dev_agent.py`
**Purpose:** Generalist — recommends right reporting tool per audience (D365 dashboard, Power BI, Excel, Azure Monitor, CS Adaptive Card).

| Audience | Tool |
|---|---|
| D365 daily ops users | D365 Dashboard |
| Execs / broad reach | Power BI |
| Finance / ad-hoc | Excel |
| DevOps / health | Azure Monitor |
| Bot users in CS | Adaptive Card |

---

## Domain Expertise Personas

### 🏭 Subject Matter Expert (SME)
**File:** `{team_slug}_sme_agent.py`
**Key actions:** `generate_sop`, `document_process`, `define_use_case`, `review_sop`, `update_knowledge_base`

### 👤 Customer Persona Simulator
**File:** `{team_slug}_customer_persona_agent.py`
**Key actions:** `simulate_user`, `generate_test_conversation`, `validate_user_experience`, `identify_friction_points`

---

## Technical Personas

### 🧑‍💻 Developer (Python / Azure Functions)
**File:** `{team_slug}_developer_agent.py`
**Key actions:** `scaffold_agent`, `generate_config`, `create_artifact`, `code_review`, `write_tests`

> For multi-technology builds, DevOps PM routes to discipline specialists. This agent handles Python/Azure-specific tasks.

### 🏗️ Architect
**File:** `{team_slug}_architect_agent.py`
**Key actions:** `design_solution`, `evaluate_pattern`, `create_architecture_doc`, `recommend_stack`, `assess_technical_debt`

---

## Quality & Compliance Personas

### 🔒 Security Reviewer
**File:** `{team_slug}_security_reviewer_agent.py`
**Key actions:** `review_security`, `check_compliance`, `assess_risk`, `validate_no_secrets`, `generate_security_report`

### 🧪 QA Engineer
**File:** `{team_slug}_qa_engineer_agent.py`
**Key actions:** `design_test_cases`, `write_regression_tests`, `validate_acceptance_criteria`, `identify_edge_cases`, `generate_test_report`

---

## Content & Communication Personas

### 🎨 UX Designer
**File:** `{team_slug}_ux_designer_agent.py`
**Key actions:** `design_user_flow`, `create_wireframe`, `review_accessibility`, `map_user_journey`, `suggest_ux_improvements`

### ✍️ Content Strategist
**File:** `{team_slug}_content_strategist_agent.py`
**Key actions:** `plan_content_strategy`, `review_documentation`, `create_content_outline`, `enforce_style_guide`, `audit_content_gaps`

### 📊 Data Analyst
**File:** `{team_slug}_data_analyst_agent.py`
**Key actions:** `analyze_trends`, `generate_kpi_report`, `identify_patterns`, `recommend_improvements`, `create_data_summary`

---

## Persona Combinations by Use Case

| Scenario | Personas |
|----------|---------|
| **Autonomous CoE (full)** | All core + DevOps team + all domain/technical/quality personas |
| **Microsoft stack build** | Outcome Framer + PM + DevOps PM + D365 Dev + AI Specialist + PP Dev + Analytics Dev + Intake + Outcome Validator |
| **Software dev team** | Outcome Framer + PM + Developer + Architect + QA + Security + Intake + Outcome Validator |
| **Content / docs team** | Outcome Framer + SME + Content Strategist + UX Designer + Intake + Outcome Validator |
| **Research / analysis** | Outcome Framer + SME + Data Analyst + Architect + Intake + Outcome Validator |
| **Lightweight project** | Outcome Framer + PM + Developer + Intake + Outcome Validator |
| **Consulting engagement** | Outcome Framer + PM + SME + Architect + Developer + Customer Persona + Outcome Validator |

> **Rule of thumb:** Always include Outcome Framer + Intake + Outcome Validator.

---

## Adding a Custom Persona

1. Copy `agents/_base_persona_template.py`
2. Replace `{{PLACEHOLDER}}` values
3. Implement `perform()` with your actions
4. Import and wire into orchestrator `__init__` and `ROUTING_MAP`
5. Add a `persona:your-persona` GitHub label

See `customers/mfg_coe/agents/mfg_coe_data_analyst_agent.py` for a complete example.