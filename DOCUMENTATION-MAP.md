# Belgrade Documentation Map

**Quick Navigation Guide for All Project Documentation**

---

## Your First 10 Minutes

Start with these three documents in this order:

### 1. **GETTING-STARTED.md** (5 min read)
**What it covers:** Entry points for different situations, three critical directories, step-by-step workflows for each sandbox

**Read this if:**
- You're new to the project
- You want to understand where things are
- You need step-by-step instructions for your specific situation
- You're unsure what to do next

**Key sections:**
- Three critical directories explained (sandboxes, research-areas, ai)
- Entry points A, B, C, D (different reasons you're here)
- WHAT TO DO for each sandbox (workflow, features, success criteria)
- Troubleshooting guide

### 2. **ARCHITECTURE-DIAGRAMS.md** (3 min read)
**What it covers:** Visual representations of the system, dependency flows, research area alignment, decision gates

**Read this if:**
- You want to SEE how the project fits together
- You need to understand dependencies
- You're planning parallel work
- You want to know what comes after each sandbox

**Key sections:**
- Complete project visualization (4-sandbox pipeline)
- Feature flow (detailed dependency graphs)
- Parallel processing opportunity in Sandbox 03
- Decision gates between stages
- Research areas alignment

### 3. **readme.txt** (2 min skim)
**What it covers:** Comprehensive project overview, all sandboxes, all research areas, context

**Read this if:**
- You need the full picture
- You want to understand research areas
- You're planning the entire project lifecycle
- You need Vietnam context or indicator definitions

**Key sections:**
- WHERE TO START (3-step orientation)
- WHAT TO DO (sandbox-by-sandbox guide with feature tables)
- Key directories explained
- Research areas deep dive
- Thesis checklist

---

## For Ongoing Reference

### **PIPELINE.md**
**Purpose:** System architecture with visual diagrams and dependency details

**Use when:**
- You need to understand feature dependencies
- You want to see how sandboxes connect
- You're planning work across multiple sandboxes
- You need to verify what comes after a feature

**Key content:**
- Multi-sandbox architecture overview
- Feature dependencies (Mermaid graphs)
- Hand-drawable versions for sketching
- Module dependency matrix
- Parallel processing opportunities
- Integration with research areas

### **VISUALIZATION-REFERENCE.md**
**Purpose:** Guide to using the `/visualize` command to generate project diagrams

**Use when:**
- You want to generate a specific visualization
- You're helping someone else understand the project visually
- You need examples of how to use `/visualize`
- You want to understand different diagram types

**Key content:**
- 6 example `/visualize` commands with expected outputs
- How to read different visualization types (system, mermaid, matrix, ASCII)
- Key insights about the architecture
- Using visualizations for planning
- Visualization purposes table

### **CLAUDE.md**
**Purpose:** Agent-foreman integration instructions (project-specific configuration)

**Use when:**
- You're learning how to use `agent-foreman` commands
- You need to understand feature status values
- You're configuring TDD mode
- You're adding new features

**Key commands:**
```bash
agent-foreman status              # See current status
agent-foreman next                # Get next feature
agent-foreman check <id>          # Verify implementation
agent-foreman done <id>           # Mark complete
```

---

## By Situation: Which Document to Read

### Situation: "I'm brand new here"
1. GETTING-STARTED.md (Entry Point A)
2. ARCHITECTURE-DIAGRAMS.md (Quick visual overview)
3. readme.txt (Full project understanding)
4. Pick a sandbox and start with SANDBOX.md

### Situation: "I'm continuing work"
1. GETTING-STARTED.md (Entry Point B)
2. `agent-foreman status` to see where you are
3. `agent-foreman next` to get your feature
4. Continue in your sandbox

### Situation: "I need to understand research areas"
1. GETTING-STARTED.md (Entry Point C)
2. research-areas/00-index.md
3. Read the specific research area you need
4. Use scripts from that research area

### Situation: "I need to work on a specific feature"
1. GETTING-STARTED.md (Entry Point D)
2. Go to the sandbox containing that feature
3. Read SANDBOX.md for that sandbox
4. `agent-foreman next <feature-id>`

### Situation: "I need to understand dependencies"
1. ARCHITECTURE-DIAGRAMS.md (Feature flow section)
2. PIPELINE.md (Dependency graphs)
3. readme.txt (Module dependency matrix)

### Situation: "I need to visualize the project"
1. VISUALIZATION-REFERENCE.md (Examples and guides)
2. Run `/visualize BELGRADE ARCHITECTURE` to generate diagrams

### Situation: "I want to understand the parallel opportunity"
1. ARCHITECTURE-DIAGRAMS.md (Parallel processing section)
2. PIPELINE.md (Parallel opportunities subsection)
3. GETTING-STARTED.md (Sandbox 03 workflow section)

### Situation: "I'm stuck and don't know what to do"
1. GETTING-STARTED.md (Troubleshooting section)
2. Read the relevant research area
3. Check ARCHITECTURE-DIAGRAMS.md (Decision gates)
4. Run `agent-foreman check <feature-id>` to diagnose

---

## Document Hierarchy

```
DOCUMENTATION HIERARCHY
═════════════════════════════════════════════════════════════

                        GETTING-STARTED.md
                        (Entry point for all users)
                                  │
                    ┌─────────────┼─────────────┐
                    │             │             │
                    ▼             ▼             ▼
            ARCHITECTURE-      PIPELINE.md    readme.txt
            DIAGRAMS.md         (Features)    (References)
                (Visuals)       (Flow)         (Comprehensive)
                    │             │             │
                    └─────────────┴─────────────┘
                                  │
                                  ▼
                         sandbox/*/SANDBOX.md
                         (Specific work)
                                  │
                    ┌─────────────┼─────────────┐
                    │             │             │
                    ▼             ▼             ▼
            research-areas/    ai/         scripts/
            (Knowledge)      (Tracking)    (Implementation)
```

---

## File Locations and Purposes

### Root Documentation (belgrade/)
| File | Purpose | When to Read |
|------|---------|---|
| **GETTING-STARTED.md** | Entry point, workflows, troubleshooting | First time, need directions |
| **ARCHITECTURE-DIAGRAMS.md** | Visual diagrams, dependencies, gates | Want to understand structure |
| **PIPELINE.md** | System architecture, feature dependencies | Understand the full flow |
| **VISUALIZATION-REFERENCE.md** | Guide to `/visualize` command | Generate diagrams |
| **readme.txt** | Comprehensive guide, all details | Full reference |
| **CLAUDE.md** | Agent-foreman configuration | Using agent-foreman |
| **CONTEXT.md** | Project overview and goals | Project context |
| **SPECIFICATION.md** | Detailed requirements | Implementation details |

### Per-Sandbox Documentation (sandboxes/*/
| File | Purpose | When to Read |
|------|---------|---|
| **SANDBOX.md** | Purpose, features, success criteria | Starting work in sandbox |
| **ai/feature_list.json** | Feature checklist, status, priority | Track sandbox progress |
| **ai/progress.log** | Work history, session notes | Understand what was done |
| **docs/** | Research area files for this sandbox | Need specific guidance |
| **scripts/** | R code templates and examples | Implementing features |
| **tests/** | Test files for validation | Verify implementations |
| **output/** | Generated results | Check feature outputs |

### Research Areas Documentation (research-areas/*/
| File | Purpose | When to Read |
|------|---------|---|
| **00-index.md** | Overview of all 10 research areas | Learn what areas cover |
| **XX-topic/index.md** | Guide for that research area | Deep learning about topic |
| **XX-topic/scripts/** | Code templates and examples | Copy templates for work |
| **XX-topic/templates/** | Document templates | Create new documents |

### Global Feature List (ai/
| File | Purpose | When to Read |
|------|---------|---|
| **feature_list.json** | All 29 features, global status | Overview of entire project |
| **progress.log** | All work history, global | Understand all past work |

---

## Documentation Maintenance

### Which Documents to Update When

**After completing a sandbox:**
- Update the sandbox's SANDBOX.md with completion notes
- Update ai/progress.log with session summary
- Update root ai/feature_list.json with status changes

**When adding new features:**
- Add to sandbox's ai/feature_list.json
- Update GETTING-STARTED.md if workflow changes
- Update root ai/feature_list.json

**When discovering new requirements:**
- Update the relevant research area documentation
- Update SPECIFICATION.md with requirements
- Update feature acceptance criteria

**When creating new documents:**
- Add entry to DOCUMENTATION-MAP.md
- Link from GETTING-STARTED.md if relevant
- Update file locations table

---

## Quick Command Reference

### View Documentation
```bash
cat GETTING-STARTED.md           # Start here
cat ARCHITECTURE-DIAGRAMS.md      # Visual overview
cat PIPELINE.md                   # Full system architecture
cat readme.txt                    # Comprehensive guide
```

### Check Your Progress
```bash
cd sandboxes/XX                   # Go to your sandbox
cat SANDBOX.md                    # Sandbox purpose and features
agent-foreman status              # Current status
agent-foreman next                # Next feature
```

### Generate Visualizations
```bash
/visualize BELGRADE ARCHITECTURE  # Full project diagram
/visualize SANDBOX 03             # Specific sandbox
/visualize PIPELINE               # Feature dependencies
```

### Find Information
```bash
grep -r "indicator" research-areas/     # Search all docs
find . -name "*.md" | head -20          # List all markdown docs
```

---

## Print-Friendly Reference

### The 3-Minute Overview
1. **You are here:** Belgrade - Vietnamese household food security analysis
2. **You're doing:** Transform survey data → indicators → thesis outputs
3. **You're working in:** 4 sandboxes sequentially (S01 → S02 → S03 → S04)
4. **You have:** 29 features total, distributed 4+7+12+6 across sandboxes
5. **Your advantage:** S03 has 3 parallel modules (can work simultaneously)
6. **Your resources:** 10 research areas with guides, scripts, templates
7. **Your next step:** Read GETTING-STARTED.md Entry Point (A, B, C, or D)

### The Sandbox Sequence
```
S01: Survey Understanding (4 features) → Foundation
     ↓
S02: Data Pipeline (7 features) → Infrastructure
     ↓
S03: Indicators (12 features, 3 parallel modules) → Core Analysis
     ↓
S04: Outputs & Reporting (6 features) → Thesis-Ready Results
```

### The Research Area Map
```
Areas 01-03: Understanding + Setup
Areas 04-07: Indicator Calculation
Areas 08-10: Output Generation
```

---

## Next Steps

1. **You are here:** DOCUMENTATION-MAP.md
2. **Go to:** GETTING-STARTED.md (pick your Entry Point)
3. **Then:** Go to your sandbox and read SANDBOX.md
4. **Finally:** Run `agent-foreman next` and start building!

---

*Last updated: 2025-12-11*
*This is your navigation guide. Bookmark this file.*
