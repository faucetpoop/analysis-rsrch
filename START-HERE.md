# START HERE - Belgrade Documentation Index

Welcome to the **Analysis Research** project on Vietnamese household food security.

This is your **single entry point** to all project documentation.

---

## In 30 Seconds

You're building an **analysis pipeline** that transforms survey data into food security indicators for a thesis.

- **4 sandboxes** (sequential work environments)
- **29 features** (things to build)
- **10 research areas** (knowledge library)
- **Goal:** Publication-ready analysis with maps, tables, and documentation

---

## For You Right Now

### If you have 5 minutes
👉 Read **GETTING-STARTED.md**
- Quick orientation + entry points for your situation
- Step-by-step workflows

### If you have 10 minutes
👉 Read **GETTING-STARTED.md** + **ARCHITECTURE-DIAGRAMS.md**
- Understand the structure visually
- See how sandboxes connect

### If you have 15 minutes
👉 Read **DOCUMENTATION-MAP.md** + **GETTING-STARTED.md**
- Complete navigation guide
- Know where everything is
- Pick your entry point

### If you want full context
👉 Read in this order:
1. DOCUMENTATION-MAP.md (navigation)
2. GETTING-STARTED.md (entry point + workflows)
3. ARCHITECTURE-DIAGRAMS.md (visual structure)
4. readme.txt (comprehensive reference)

---

## Documentation Map

### Entry Point Files (Start Here)
- **DOCUMENTATION-MAP.md** ← Navigation guide for all docs
- **GETTING-STARTED.md** ← 4 entry points (new, continuing, research, specific feature)
- **ARCHITECTURE-DIAGRAMS.md** ← Visual structure + dependencies

### Comprehensive References
- **readme.txt** ← Full project guide with all details
- **PIPELINE.md** ← System architecture + feature flow
- **VISUALIZATION-REFERENCE.md** ← `/visualize` command guide

### Configuration & Context
- **CLAUDE.md** ← Agent-foreman setup
- **CONTEXT.md** ← Project overview
- **SPECIFICATION.md** ← Detailed requirements

---

## The Quick Tour

### You Are Here
```
Belgrade = Vietnamese household food security analysis project
```

### The Work Path
```
Survey Understanding → Data Pipeline → Indicators → Outputs
    (S01, 4 feat)     (S02, 7 feat)   (S03, 12 feat)  (S04, 6 feat)
```

### The Knowledge Library
```
Research Areas 01-10 provide guides for each phase
```

### The Parallel Opportunity
```
In Sandbox 03: After data is clean, 3 agents work simultaneously
- Agent 1: Food Security indicators (5 features)
- Agent 2: Economics indicators (4 features)
- Agent 3: Likert scales (3 features)
```

---

## Pick Your Situation

### I'm brand new
1. Read **GETTING-STARTED.md** (Entry Point A)
2. Look at **ARCHITECTURE-DIAGRAMS.md**
3. Go to `sandboxes/01-survey-understanding/SANDBOX.md`
4. Run `agent-foreman next`

### I'm continuing from another session
1. Go to your sandbox: `cd sandboxes/XX/`
2. Run `agent-foreman status`
3. Run `agent-foreman next`
4. Check the research area guides if stuck

### I need to understand research areas
1. Read **GETTING-STARTED.md** (Entry Point C)
2. Go to `research-areas/00-index.md`
3. Pick the area you need
4. Use the scripts and templates

### I need to work on a specific feature
1. Find which sandbox has it
2. Run `agent-foreman next <feature-id>`
3. Check the research area for guidance

### I'm stuck and need help
1. Check **GETTING-STARTED.md** (Troubleshooting)
2. Read the relevant research area
3. Check **ARCHITECTURE-DIAGRAMS.md** for context
4. Run `agent-foreman check <feature-id>`

---

## One Click Away

| What You Need | Go To |
|---|---|
| Quick orientation | **GETTING-STARTED.md** |
| Visual structure | **ARCHITECTURE-DIAGRAMS.md** |
| Find information | **DOCUMENTATION-MAP.md** |
| Full reference | **readme.txt** |
| Feature dependencies | **PIPELINE.md** |
| Generate diagrams | **VISUALIZATION-REFERENCE.md** |
| Current status | `agent-foreman status` |
| Next feature | `agent-foreman next` |

---

## The Three Critical Things to Understand

### 1. Sandboxes (`sandboxes/` folder)
Where you **do the work**. Four isolated environments:
- **01-survey-understanding** (4 features) - Parse survey, create codebook
- **02-data-pipeline** (7 features) - Set up R, download, clean data
- **03-indicators** (12 features) - Calculate all indicators (3 parallel modules)
- **04-analysis-reporting** (6 features) - Create maps and tables

### 2. Research Areas (`research-areas/` folder)
Your **knowledge library**. Ten reference domains:
- **01-03:** Foundation (survey context, R, KoBo)
- **04-07:** Indicators (food security, income, Likert)
- **08-10:** Output (documentation, geospatial, reporting)

### 3. Features (`ai/` folder)
**What you're tracking**. 29 total features across all sandboxes.
- Global view: `ai/feature_list.json`
- Per-sandbox: `sandboxes/XX/ai/feature_list.json`
- Status: `failing`, `passing`, `blocked`, `needs_review`

---

## Commands You'll Use Most

```bash
# Check where you are
agent-foreman status

# Get your next feature
agent-foreman next

# Verify your work (without marking done)
agent-foreman check <feature-id>

# Mark work complete
agent-foreman done <feature-id>
```

---

## The Goal

Every feature brings you closer to:

> **Thesis-ready analysis of Vietnamese household food security with:**
> - **Validated indicators** (HDDS, FCS, rCSI, FIES)
> - **Spatial visualizations** (choropleth maps by province)
> - **Publication tables** (Table 1, indicator results)
> - **Complete documentation** (codebook, methods, appendices)

---

## Right Now

Pick your entry point in **GETTING-STARTED.md**:
- **Entry Point A** (brand new)
- **Entry Point B** (continuing)
- **Entry Point C** (need research areas)
- **Entry Point D** (specific feature)

Then get started!

---

*Last updated: 2025-12-11*
*Your complete documentation is ready. Everything you need is here.*
