# Multi-Sandbox Analysis Architecture

## Overview

This diagram shows the restructured analysis-rsrch project with 4 independent sandboxes, each containing its own agent-foreman instance, features, and resources. Flow moves from foundation → infrastructure → analysis → output.

## Digital Diagram

```text
┌────────────────────────────────────────────────────────────────────────────┐
│                    ANALYSIS-RSRCH PROJECT ARCHITECTURE                     │
│                                                                            │
│  [ ROOT PROJECT LOBE ]                                                     │
│   CLAUDE.md, CONTEXT.md, SPECIFICATION.md                                 │
│                           |                                                │
│                           v                                                │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │  SANDBOX 01: SURVEY UNDERSTANDING (Foundation)                       │ │
│  │  ┌────────────────────────────────────────────────────────────┐      │ │
│  │  │ Features: 4                                                │      │ │
│  │  │ - XLSForm parsing      - Survey module stories            │      │ │
│  │  │ - Codebook generation  - Construct mapping                │      │ │
│  │  │ Decision: Survey structure documented?                     │      │ │
│  │  └────────────────────────────────────────────────────────────┘      │ │
│  │  Resources: areas 01, 03, 08 | ai/feature_list.json (local)          │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                           |                                                │
│                           v                                                │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │  SANDBOX 02: DATA PIPELINE (Infrastructure)                          │ │
│  │  ┌────────────────────────────────────────────────────────────┐      │ │
│  │  │ Features: 7                                                │      │ │
│  │  │ - R project setup      - KoBoToolbox API connection        │      │ │
│  │  │ - Package dependencies - Download submissions              │      │ │
│  │  │ - Merge versions A/B   - Process multi-select              │      │ │
│  │  │ - Classify missing data                                    │      │ │
│  │  │ Decision: Clean data ready?                                │      │ │
│  │  │ <- If validation fails, loop to cleaning                   │      │ │
│  │  └────────────────────────────────────────────────────────────┘      │ │
│  │  Resources: areas 02, 04 | ai/feature_list.json (local)              │ │
│  │  Output: data/processed/survey_clean.rds                             │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                           |                                                │
│                           v                                                │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │  SANDBOX 03: INDICATORS (Core Analysis) *** LARGEST ***              │ │
│  │  ┌────────────────────────────────────────────────────────────┐      │ │
│  │  │ Features: 12 (grouped into 3 modules)                      │      │ │
│  │  │                                                             │      │ │
│  │  │ [Food Security Module]                                     │      │ │
│  │  │ - HDDS calculate/categorize                                │      │ │
│  │  │ - FCS calculate         - rCSI calculate                   │      │ │
│  │  │ - FIES Rasch model                                         │      │ │
│  │  │                                                             │      │ │
│  │  │ [Economics Module]                                         │      │ │
│  │  │ - Income aggregation    - Expenditure shares               │      │ │
│  │  │ - Outlier detection     - Vietnam poverty benchmarks       │      │ │
│  │  │                                                             │      │ │
│  │  │ [Likert Module]                                            │      │ │
│  │  │ - Recode scales         - Cronbach's alpha                 │      │ │
│  │  │ - Diverging bar viz                                        │      │ │
│  │  │                                                             │      │ │
│  │  │ Decision: Indicators valid? <- If not, review methodology  │      │ │
│  │  └────────────────────────────────────────────────────────────┘      │ │
│  │  Resources: areas 05, 06, 07 | ai/feature_list.json (local)          │ │
│  │  Output: output/survey_with_indicators.rds                           │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                           |                                                │
│                           v                                                │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │  SANDBOX 04: ANALYSIS REPORTING (Output)                             │ │
│  │  ┌────────────────────────────────────────────────────────────┐      │ │
│  │  │ Features: 6                                                │      │ │
│  │  │                                                             │      │ │
│  │  │ [Geospatial Module]                                        │      │ │
│  │  │ - Load GADM Vietnam     - Choropleth mapping               │      │ │
│  │  │ - Survey-weighted aggregation                              │      │ │
│  │  │                                                             │      │ │
│  │  │ [Reporting Module]                                         │      │ │
│  │  │ - Descriptive Table 1   - Indicator results table          │      │ │
│  │  │ - Export to Word (.docx)                                   │      │ │
│  │  │                                                             │      │ │
│  │  │ Decision: Ready for thesis? <- If not, refine visuals      │      │ │
│  │  └────────────────────────────────────────────────────────────┘      │ │
│  │  Resources: areas 09, 10 | ai/feature_list.json (local)              │ │
│  │  Output: output/figures/, output/tables/                             │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                           |                                                │
│                           v                                                │
│  [ THESIS OUTPUT LOBE ]                                                   │
│   figures/ tables/ documentation/                                         │
│                                                                            │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │  HELPER SCRIPTS ORGAN                                                │ │
│  │  sandbox-status.sh  → Check all 4 sandboxes                          │ │
│  │  sandbox-progress.sh → Combined progress view                        │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                                                                            │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │  BACKUP SAFETY ORGAN                                                 │ │
│  │  .migration-backup/ → Original ai/ and research-areas/               │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────────────────────────┘
```

## Hand-Drawable Version

```text
ROOT PROJECT
   |
SANDBOX 01: SURVEY (4 features)
   | Foundation
   v
SANDBOX 02: DATA PIPELINE (7 features)
   | Infrastructure
   v
SANDBOX 03: INDICATORS (12 features)
   | Food Security + Economics + Likert
   v
SANDBOX 04: REPORTING (6 features)
   | Geospatial + Tables
   v
THESIS OUTPUT
```

## Legend

- **Box Organ**: Clearly defined sandbox with agent-foreman instance
- **Lobe Organ**: Fuzzy conceptual areas (root, output)
- **| Arrow**: Sequential dependency flow
- **<- Curved Arrow**: Feedback loop or decision point
- **[ Brackets ]**: Entry/exit zones or conceptual pools

## Key Insights

- **29 features distributed** across 4 independent sandboxes (4+7+12+6)
- **Each sandbox self-contained**: own ai/feature_list.json, progress.log, resources
- **Sequential dependencies**: 01 → 02 → 03 → 04 (but 03 and 04 can work in parallel after 02)
- **Decision gates at each tier**: Prevents proceeding with invalid data/indicators
- **Sandbox 03 is largest**: 12 features spanning 3 analysis modules (indicators, economics, likert)
- **Helper scripts bridge sandboxes**: Global status view while maintaining isolation

## How to Use This

1. **Study the digital diagram** to understand the full dependency chain and decision gates.
2. **Sketch the hand-drawable version** in your notebook to internalize the flow.
3. **Reference when starting work**: Navigate to correct sandbox based on where you are in the pipeline.
4. **Use for explaining to collaborators**: Shows both technical structure and conceptual flow.
5. **Keep both versions** in your documentation for different audiences (detailed vs. overview).

## Quick Navigation

```bash
# View all sandboxes
cd sandboxes && ls

# Check status of all sandboxes
./scripts/sandbox-status.sh

# Work on a specific sandbox
cd sandboxes/01-survey-understanding && agent-foreman next
cd sandboxes/02-data-pipeline && agent-foreman next
cd sandboxes/03-indicators && agent-foreman next
cd sandboxes/04-analysis-reporting && agent-foreman next
```

## Recommended Workflow

1. **Start with foundation**: Complete all features in `01-survey-understanding`
2. **Build infrastructure**: Complete all features in `02-data-pipeline`
3. **Analyze independently**: Work on `03-indicators` modules in any order
4. **Generate outputs**: Complete `04-analysis-reporting` when indicators ready
5. **Check progress anytime**: Run `./scripts/sandbox-status.sh`

---

*Architecture diagram generated: 2025-12-10*
*System: Multi-Sandbox Analysis Architecture*
