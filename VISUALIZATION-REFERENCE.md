# Project Visualization Reference

This file demonstrates using the `/visualize` command to understand different aspects of the analysis-rsrch project.

## Command Examples

### 1. Multi-Sandbox Architecture Overview
```
/visualize BELGRADE ARCHITECTURE
/visualize MULTI-SANDBOX mode:system focus:sandboxes
```

Expected output: All 4 sandboxes (S01-S04) with 29 features distributed, showing:
- Sequential dependencies (S01→S02→S03→S04)
- Feature count per sandbox (4, 7, 12, 6)
- Research area alignment
- Decision gates between stages

### 2. Parallel Opportunities in Sandbox 03
```
/visualize INDICATORS mode:ascii focus:parallel
/visualize SANDBOX 03 mode:mermaid focus:parallel
```

Expected output: Three parallel modules:
- Food Security (5 features: HDDS, FCS, rCSI, FIES, categorize)
- Economics (4 features: income, expenditure, outliers, poverty)
- Likert (3 features: recode, cronbach-alpha, diverging-bars)
With sync points where all three converge

### 3. All Features and Dependencies
```
/visualize PIPELINE mode:mermaid focus:dependencies depth:full
/visualize FEATURES mode:matrix focus:dependencies
```

Expected output:
- All 29 features with their IDs
- Upstream/downstream dependencies
- Critical path analysis
- Bottleneck identification

### 4. Research Area Connections
```
/visualize RESEARCH AREAS mode:cards
/visualize SANDBOXES mode:matrix focus:links
```

Expected output:
- How 10 research areas map to features
- Which areas feed into which sandboxes
- Cross-area dependencies

### 5. Data Flow Through Pipeline
```
/visualize DATA FLOW mode:ascii focus:flows
/visualize FOOD SECURITY ANALYSIS mode:system focus:sandboxes depth:full
```

Expected output:
- Raw data → Clean data → Indicators → Outputs
- Transformation steps
- Artifacts at each stage

### 6. Quick Hand-Drawable Overview
```
/visualize QUICK OVERVIEW style:hand-drawable
/visualize BELGRADE mode:ascii focus:parallel style:hand-drawable
```

Expected output: Simplified 5-minute sketch showing:
- 4 sandbox boxes stacked vertically
- Feature counts marked
- Parallel modules in Sandbox 03
- Decision gates

## How to Read Each Visualization

### System Diagrams (mode:system)
- **Top section:** Foundation/Framework
- **Middle section:** Core work layers with parallel tracks
- **Bottom section:** Outputs and artifacts

### Mermaid Flowcharts (mode:mermaid)
- **Solid arrows (→):** Required dependencies
- **Dotted arrows (-.->):** Optional or weak dependencies
- **Subgraphs:** Grouped components (sandboxes, modules)
- **Sync points:** Where parallel streams converge

### Matrix Tables (mode:matrix)
- **✓ symbol:** Depends on (upstream dependency)
- **← symbol:** Depended by (downstream dependent)
- **○ symbol:** No direct relationship
- **- symbol:** Self reference

### ASCII Diagrams (mode:ascii)
- **┌──┘ boxes:** Defined components
- **[ ] brackets:** Fuzzy/conceptual areas
- **→ arrows:** Flow direction
- **═══ lines:** Layer boundaries

## Key Insights from Visualizations

### Sequential Path
**S01 (Foundation) → S02 (Infrastructure) → S03 (Analysis) → S04 (Output)**

This is the main critical path. Nothing can begin in the next sandbox until the previous one is validated.

### Parallel Opportunity
**Within Sandbox 03:**
After clean data is ready from S02, three agents could simultaneously:
1. Build Food Security indicators (5 features)
2. Build Economics indicators (4 features)
3. Build Likert indicators (3 features)

Then all three merge their outputs for Sandbox 04.

### Research Areas Bridge
**10 reference documentation areas** support all 4 sandboxes:
- Areas 01-03: Support Sandbox 01 & 02 (understanding + setup)
- Areas 04-07: Support Sandbox 03 (indicator calculation)
- Areas 08-10: Support Sandbox 04 (output generation)

### Decision Gates
Visualizations highlight validation points:
- **Gate 1:** Survey structure documented? (End S01)
- **Gate 2:** Clean data validated? (End S02)
- **Gate 3:** Indicators valid? (End S03)
- **Gate 4:** Thesis-ready? (End S04)

## Using Visualizations for Planning

1. **New team member?** Start with `/visualize BELGRADE ARCHITECTURE` to understand the full scope
2. **Starting a sandbox?** Use `/visualize SANDBOX XX mode:ascii` to see features in that sandbox
3. **Planning parallel work?** Use `/visualize SANDBOX 03 mode:mermaid focus:parallel`
4. **Tracking dependencies?** Use `/visualize FEATURES mode:matrix focus:dependencies`
5. **Quick reference?** Use `/visualize QUICK OVERVIEW style:hand-drawable`

## Visualization Purposes

| Goal | Command | Mode | Focus |
|------|---------|------|-------|
| Understand full architecture | BELGRADE ARCHITECTURE | system | sandboxes |
| Plan parallel work | SANDBOX 03 | mermaid | parallel |
| Track all dependencies | PIPELINE | mermaid | dependencies |
| See data flow | DATA FLOW | ascii | flows |
| Quick overview | QUICK OVERVIEW | ascii | hand-drawable |
| Audit research areas | RESEARCH AREAS | cards | links |
| Feature distribution | FEATURES | matrix | dependencies |

---

*Reference Guide for `/visualize` command*
*Last updated: 2025-12-11*
