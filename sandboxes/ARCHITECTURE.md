# Multi-Sandbox Architecture - Visual Overview

## Architecture Diagram

```
analysis-rsrch/
│
├── sandboxes/                          ← Multi-sandbox architecture
│   │
│   ├── 01-survey-understanding/        ← FOUNDATION (4 features)
│   │   ├── SANDBOX.md                  ← Entry point
│   │   ├── ai/
│   │   │   ├── feature_list.json       ← 4 features
│   │   │   ├── progress.log
│   │   │   └── init.sh
│   │   ├── docs/                       ← Research areas 01, 03, 08
│   │   │   ├── area-0-survey-context-understanding.md
│   │   │   ├── area-2-kobo-xlsform-structure.md
│   │   │   └── area-7-documentation-standards.md
│   │   ├── scripts/
│   │   ├── tests/
│   │   └── output/
│   │        └── codebook.csv           ← Output for downstream sandboxes
│   │
│   ├── 02-data-pipeline/               ← INFRASTRUCTURE (7 features)
│   │   ├── SANDBOX.md
│   │   ├── ai/
│   │   │   ├── feature_list.json       ← 7 features
│   │   │   ├── progress.log
│   │   │   └── init.sh
│   │   ├── docs/                       ← Research areas 02, 04
│   │   │   ├── area-1-r-workflow-survey-analysis.md
│   │   │   ├── area-3-raw-data-management.md
│   │   │   └── R-Survey-Analysis-Best-Practices.md
│   │   ├── scripts/
│   │   ├── tests/
│   │   └── output/
│   │        └── clean-data.rds         ← Output for downstream sandboxes
│   │
│   ├── 03-indicators/                  ← ANALYSIS (12 features)
│   │   ├── SANDBOX.md
│   │   ├── ai/
│   │   │   ├── feature_list.json       ← 12 features
│   │   │   ├── progress.log
│   │   │   └── init.sh
│   │   ├── docs/                       ← Research areas 05, 06, 07
│   │   │   ├── area-4-food-security-indicators.md
│   │   │   ├── area-5-income-expenditure-vietnam.md
│   │   │   └── area-6-likert-scales-psychometrics.md
│   │   ├── scripts/
│   │   ├── tests/
│   │   └── output/
│   │        └── indicators.rds         ← Output for downstream sandboxes
│   │
│   ├── 04-analysis-reporting/          ← OUTPUTS (6 features)
│   │   ├── SANDBOX.md
│   │   ├── ai/
│   │   │   ├── feature_list.json       ← 6 features
│   │   │   ├── progress.log
│   │   │   └── init.sh
│   │   ├── docs/                       ← Research areas 09, 10
│   │   │   ├── area-8-geospatial-analysis.md
│   │   │   └── area-9-descriptives-reporting.md
│   │   ├── scripts/
│   │   ├── tests/
│   │   └── output/
│   │        ├── maps/                  ← Thesis-ready outputs
│   │        └── tables/
│   │
│   └── README.md                       ← Master index
│
├── scripts/
│   ├── sandbox-status.sh               ← Check all sandboxes
│   └── sandbox-progress.sh             ← Combined progress logs
│
├── .migration-backup/                  ← Rollback capability
│   ├── ai/
│   └── research-areas/
│
└── MIGRATION-COMPLETE.md               ← Migration summary
```

## Dependency Flow

```
┌─────────────────────────────────────────────────────────────┐
│  01-survey-understanding (FOUNDATION)                       │
│  ─────────────────────────────────────────                  │
│  • Parse XLSForm structure                                  │
│  • Generate codebook                                        │
│  • Document survey modules                                  │
│  • Create construct mapping                                 │
│                                                              │
│  Output: codebook.csv, construct-mapping.csv                │
└──────────────────────────┬──────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  02-data-pipeline (INFRASTRUCTURE)                          │
│  ────────────────────────────────────                       │
│  • Initialize R project                                     │
│  • Connect to Kobo API                                      │
│  • Download submissions                                     │
│  • Merge versions A & B                                     │
│  • Process select_multiple                                  │
│  • Classify missing data                                    │
│                                                              │
│  Output: clean-data.rds                                     │
└──────────────────────────┬──────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  03-indicators (ANALYSIS)                                   │
│  ───────────────────────────                                │
│  • Calculate HDDS, FCS, rCSI, FIES                          │
│  • Aggregate income/expenditure                             │
│  • Detect outliers                                          │
│  • Compare to poverty lines                                 │
│  • Process Likert scales                                    │
│  • Calculate reliability                                    │
│                                                              │
│  Output: indicators.rds, reliability-stats.csv              │
└──────────────────────────┬──────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  04-analysis-reporting (OUTPUTS)                            │
│  ──────────────────────────────────                         │
│  • Load GADM boundaries                                     │
│  • Create choropleth maps                                   │
│  • Aggregate by province                                    │
│  • Generate Table 1                                         │
│  • Create indicator tables                                  │
│  • Export to Word                                           │
│                                                              │
│  Output: maps/*.png, tables/*.docx                          │
└─────────────────────────────────────────────────────────────┘
```

## Feature Distribution Map

```
Total: 29 features

01-survey-understanding (4)
├── data-import.xlsform.parse-structure
├── documentation.codebook.generate
├── documentation.appendix.survey-modules
└── documentation.construct-map.create

02-data-pipeline (7)
├── core.config.project-setup
├── core.config.package-dependencies
├── data-import.kobo.api-connection
├── data-import.kobo.download-submissions
├── data-cleaning.versions.merge-ab
├── data-cleaning.multiselect.process
└── data-cleaning.missing.classify

03-indicators (12)
├── indicators.hdds.calculate
├── indicators.hdds.categorize
├── indicators.fcs.calculate
├── indicators.rcsi.calculate
├── indicators.fies.rasch-model
├── economics.income.aggregate
├── economics.expenditure.calculate-shares
├── economics.outliers.detect-handle
├── economics.benchmarks.vietnam-poverty
├── likert.coding.recode-scales
├── likert.reliability.cronbach-alpha
└── likert.visualization.diverging-bars

04-analysis-reporting (6)
├── geospatial.data.load-gadm
├── geospatial.mapping.choropleth
├── geospatial.aggregation.survey-weighted
├── reporting.tables.descriptive-summary
├── reporting.tables.indicator-results
└── reporting.export.word-docx
```

## Workflow Patterns

### Sequential Development (Recommended)

```bash
# Phase 1: Foundation
cd sandboxes/01-survey-understanding
agent-foreman next
# ... complete all 4 features

# Phase 2: Infrastructure
cd ../02-data-pipeline
agent-foreman next
# ... complete all 7 features

# Phase 3: Analysis
cd ../03-indicators
agent-foreman next
# ... complete all 12 features

# Phase 4: Outputs
cd ../04-analysis-reporting
agent-foreman next
# ... complete all 6 features
```

### Parallel Development (Advanced)

```bash
# Terminal 1: Agent on survey understanding
cd sandboxes/01-survey-understanding
agent-foreman next

# Terminal 2: Agent on data pipeline (after sandbox 01 complete)
cd sandboxes/02-data-pipeline
agent-foreman next

# Terminal 3: Monitor overall progress
watch ./scripts/sandbox-status.sh
```

## Communication Between Sandboxes

Sandboxes communicate through the `/output` directory:

```bash
# Sandbox 01 produces codebook
sandboxes/01-survey-understanding/output/codebook.csv

# Sandbox 02 references it
cp ../01-survey-understanding/output/codebook.csv docs/reference/

# Sandbox 02 produces clean data
sandboxes/02-data-pipeline/output/clean-data.rds

# Sandbox 03 references it
cp ../02-data-pipeline/output/clean-data.rds data/
```

## Status Commands

```bash
# Individual sandbox status
cd sandboxes/01-survey-understanding && agent-foreman status

# All sandboxes overview
./scripts/sandbox-status.sh

# Combined progress logs
./scripts/sandbox-progress.sh
```

## Benefits Visualization

```
BEFORE: Monolithic
┌────────────────────────────────┐
│  feature_list.json             │
│  ────────────────────────       │
│  29 features (all mixed)       │
│  Hard to navigate              │
│  Unclear dependencies          │
│  Overwhelming scope            │
└────────────────────────────────┘

AFTER: Multi-Sandbox
┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
│ Sandbox  │  │ Sandbox  │  │ Sandbox  │  │ Sandbox  │
│    01    │→ │    02    │→ │    03    │→ │    04    │
├──────────┤  ├──────────┤  ├──────────┤  ├──────────┤
│ 4 focus  │  │ 7 focus  │  │ 12 focus │  │ 6 focus  │
│ features │  │ features │  │ features │  │ features │
│          │  │          │  │          │  │          │
│ Clear    │  │ Clear    │  │ Clear    │  │ Clear    │
│ purpose  │  │ purpose  │  │ purpose  │  │ purpose  │
└──────────┘  └──────────┘  └──────────┘  └──────────┘
```

---

**Architecture Type:** Multi-Sandbox with Sequential Dependencies
**Total Sandboxes:** 4
**Total Features:** 29
**Isolation Level:** Complete (independent agent-foreman per sandbox)
**Communication:** Output directory sharing
