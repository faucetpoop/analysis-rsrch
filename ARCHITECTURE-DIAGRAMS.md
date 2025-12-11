# Belgrade Architecture Diagrams

## Complete Project Visualization

### System Overview: 4-Sandbox Pipeline

```
                    FOOD SECURITY SURVEY ANALYSIS PIPELINE
                    (Vietnamese Household Data → Thesis)

┌──────────────────────────────────────────────────────────────────────────┐
│                          STAGE 1: FOUNDATION                    [4 FEATURES]│
│                    Understand What You're Measuring                       │
├──────────────────────────────────────────────────────────────────────────┤
│  • Parse XLSForm structure (survey, choices, settings)                   │
│  • Generate variable codebook with labels and value codes                │
│  • Document survey modules (which questions measure what constructs)     │
│  • Create construct mapping (HDDS→Q47-58, FIES→Q1-8, etc.)             │
│                                                                          │
│  INPUTS:  XLSForm file + Research areas 01, 03, 08                      │
│  OUTPUTS: codebook.csv + construct_map.md                               │
│  DECISION: "Do we understand what we're measuring?"                      │
└──────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                          STAGE 2: INFRASTRUCTURE                [7 FEATURES]│
│                   Set Up R Environment, Download & Clean Data             │
├──────────────────────────────────────────────────────────────────────────┤
│  • Set up R project with renv and folder structure                       │
│  • Install required packages (survey, srvyr, robotoolbox, sf, etc.)     │
│  • Connect to KoBo API and authenticate                                  │
│  • Download all survey submissions from KoBo                             │
│  • Merge Version A (no food waste) + Version B (with food waste)        │
│  • Process multi-select questions (convert to binary indicators)         │
│  • Classify missing data (structural vs non-response vs error)           │
│                                                                          │
│  INPUTS:  KoBo API credentials + XLSForm structure                      │
│  OUTPUTS: survey_clean.rds (analysis-ready dataset)                      │
│  DECISION: "Is our data clean and ready for analysis?"                   │
└──────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                   STAGE 3: CORE ANALYSIS [12 FEATURES]                   │
│              *** PARALLEL PROCESSING OPPORTUNITY ***                     │
│            After Clean Data Ready: 3 Agents Work Simultaneously          │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌─────────────────────────────┐  ┌────────────────────────────┐       │
│  │   MODULE 1: FOOD SECURITY   │  │   MODULE 2: ECONOMICS      │       │
│  │        [5 features]         │  │      [4 features]          │       │
│  ├─────────────────────────────┤  ├────────────────────────────┤       │
│  │ • HDDS (12 food groups)     │  │ • Income aggregation       │       │
│  │ • HDDS categories (L/M/H)   │  │ • Expenditure shares (%)   │       │
│  │ • FCS (WFP weights)         │  │ • Outlier detection        │       │
│  │ • rCSI (severity weights)   │  │ • Vietnam poverty lines    │       │
│  │ • FIES (Rasch model)        │  │                            │       │
│  └─────────────────────────────┘  └────────────────────────────┘       │
│                                                                          │
│  ┌────────────────────────────────┐                                     │
│  │    MODULE 3: LIKERT SCALES     │                                     │
│  │       [3 features]             │                                     │
│  ├────────────────────────────────┤                                     │
│  │ • Recode scales (reverse)      │                                     │
│  │ • Cronbach's alpha reliability │                                     │
│  │ • Diverging bar visualization  │                                     │
│  └────────────────────────────────┘                                     │
│                                                                          │
│  INPUTS:  survey_clean.rds + Research areas 05, 06, 07                  │
│  OUTPUTS: survey_with_indicators.rds (all indicators calculated)         │
│  DECISION: "Are our indicators valid and reliable?"                      │
└──────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                  STAGE 4: OUTPUTS & REPORTING  [6 FEATURES]              │
│         Create Geospatial Maps and Publication-Ready Tables              │
├──────────────────────────────────────────────────────────────────────────┤
│  • Load Vietnam administrative boundaries (GADM)                         │
│  • Create choropleth maps for all indicators (by province)               │
│  • Survey-weighted aggregation by geography                              │
│  • Generate Table 1 (descriptive sample characteristics)                 │
│  • Generate indicator results table (mean, SE, 95% CI)                   │
│  • Export all tables to thesis-ready Word documents                      │
│                                                                          │
│  INPUTS:  survey_with_indicators.rds + Vietnam spatial data             │
│  OUTPUTS: thesis_tables.docx + choropleth_maps.png                       │
│  DECISION: "Is this thesis-ready?"                                       │
└──────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
                           ┌──────────────────┐
                           │  THESIS CHAPTER  │
                           │  Publication!    │
                           └──────────────────┘
```

---

## Feature Flow: Detailed Dependency Graph

```
SANDBOX 01: SURVEY UNDERSTANDING (Foundation)
═════════════════════════════════════════════

    ┌─────────────────┐
    │ parse-structure │  (Priority 1)
    │ Load XLSForm    │
    └────────┬────────┘
             │
             ▼
    ┌──────────────────────┐
    │ generate-codebook    │  (Priority 2)
    │ All variables + labs │
    └────────┬─────────────┘
             │
             ├────────────────────┐
             │                    │
             ▼                    ▼
    ┌─────────────────┐  ┌──────────────────┐
    │survey-modules   │  │construct-mapping │  (Priority 3, 4)
    │Module tables    │  │Q→Indicator map   │
    └────────┬────────┘  └────────┬─────────┘
             │                    │
             └────────────────────┘
                     │
                     ▼
            [S01 Complete: Ready for S02]


SANDBOX 02: DATA PIPELINE (Infrastructure)
═════════════════════════════════════════════

    ┌──────────────────┐
    │ project-setup    │  (Priority 10)
    │ renv, folders    │
    └────────┬─────────┘
             │
             ▼
    ┌───────────────────────┐
    │ package-dependencies  │  (Priority 11)
    │ survey, srvyr, etc.   │
    └────────┬──────────────┘
             │
             ├──────────────┬────────────────┐
             │              │                │
             ▼              ▼                ▼
    ┌──────────────────┐   ┌──────────────┐
    │api-connection    │   │parse-xlsform │  (Priority 12, 13)
    │KoBo auth         │   │Understand    │
    └────────┬─────────┘   └──────────────┘
             │                    │
             ▼                    │
    ┌──────────────────────┐     │
    │download-submissions  │◄────┘  (Priority 14)
    │Raw data from KoBo    │
    └────────┬─────────────┘
             │
             ▼
    ┌────────────────┐
    │ merge-ab       │  (Priority 15)
    │ A + B versions │
    └────────┬───────┘
             │
             ▼
    ┌──────────────────────┐
    │process-multiselect   │  (Priority 16)
    │Binary indicators     │
    └────────┬─────────────┘
             │
             ▼
    ┌──────────────────────┐
    │ classify-missing     │  (Priority 17)
    │ Structural/nonresp   │
    └────────┬─────────────┘
             │
             ▼
      [survey_clean.rds]
      [S02 Complete: Ready for S03]


SANDBOX 03: INDICATORS (Core Analysis - PARALLEL)
═════════════════════════════════════════════════════════════════════════

[survey_clean.rds arrives]
             │
    ┌────────┼────────┐
    │        │        │
    ▼        ▼        ▼

MODULE 1: FOOD SECURITY        MODULE 2: ECONOMICS          MODULE 3: LIKERT
┌──────────────────┐           ┌──────────────────┐        ┌──────────────────┐
│ hdds-calculate   │ (Priority  │ income-aggregate │ (Pr.   │ recode-scales    │ (Pr.
│ 12 food groups   │    18)     │ Sum sources      │   22)  │ Reverse coding   │  28)
└────────┬─────────┘           └────────┬─────────┘        └────────┬─────────┘
         │                              │                          │
         ▼                              ▼                          ▼
┌──────────────────┐           ┌──────────────────┐        ┌──────────────────┐
│ hdds-categorize  │ (Priority  │expenditure-shares│ (Pr.   │cronbach-alpha    │ (Pr.
│ L/M/H categories │    19)     │ Food % total     │   23)  │ Reliability      │  29)
└────────┬─────────┘           └────────┬─────────┘        └────────┬─────────┘
         │                              │                          │
         ▼                              ▼                          ▼
┌──────────────────┐           ┌──────────────────┐        ┌──────────────────┐
│ fcs-calculate    │ (Priority  │outliers-detect   │ (Pr.   │diverging-bars    │ (Pr.
│ WFP weights      │    20)     │ Winsorization    │   24)  │ Visualization    │  30)
└────────┬─────────┘           └────────┬─────────┘        └────────┬─────────┘
         │                              │                          │
         ▼                              ▼
┌──────────────────┐           ┌──────────────────┐
│ rcsi-calculate   │ (Priority  │benchmarks-vietnam│ (Pr.
│ Severity weights │    21)     │ Poverty lines    │   25)
└────────┬─────────┘           └────────┬─────────┘
         │                              │
         ▼                              │
┌──────────────────┐                  │
│ fies-rasch-model │ (Priority 26)      │
│ SDG 2.1.2        │                    │
└────────┬─────────┘                    │
         │                              │
         └──────────────┬───────────────┘
                        │
                        ▼
              [survey_with_indicators.rds]
              [S03 Complete: Ready for S04]


SANDBOX 04: OUTPUTS & REPORTING
════════════════════════════════════════

[survey_with_indicators.rds arrives]
             │
    ┌────────┼────────┐
    │        │        │
    ▼        ▼        ▼

┌──────────────────┐           ┌──────────────────┐
│ load-gadm        │ (Priority  │descriptive-table │ (Pr.
│ Vietnam bounds   │    31)     │ Table 1          │   33)
└────────┬─────────┘           └────────┬─────────┘
         │                              │
         ▼                              ▼
┌──────────────────┐           ┌──────────────────┐
│choropleth-maps   │ (Priority  │indicator-results │ (Pr.
│Province level    │    32)     │ Results table    │   34)
└────────┬─────────┘           └────────┬─────────┘
         │                              │
         └──────────────┬───────────────┘
                        │
                        ▼
                 ┌──────────────┐
                 │word-export   │  (Priority 35)
                 │ .docx files  │
                 └──────┬───────┘
                        │
                        ▼
                 [thesis_tables.docx]
                 [COMPLETE!]
```

---

## Research Areas Alignment: How Guides Map to Work

```
RESEARCH AREAS (10 Domains) Map to Sandboxes

Research Area 01: Survey Context
├─ Covers: Vietnam context, food environment, dietary patterns
├─ Used by: Sandbox 01 (understanding survey design)
├─ Reference when: Interpreting survey questions, understanding food groups
└─ Output: construct_map.md

Research Area 02: R Workflow
├─ Covers: R packages, tidyverse, survey analysis setup
├─ Used by: Sandbox 02 (setting up analysis environment)
├─ Reference when: Installing packages, understanding tidyverse functions
└─ Output: R project structure

Research Area 03: KoboToolbox & XLSForm
├─ Covers: XLSForm structure, skip logic, data export
├─ Used by: Sandbox 01 (parsing survey) and Sandbox 02 (downloading)
├─ Reference when: Understanding form structure, handling multi-select
└─ Output: Parsing scripts

Research Area 04: Data Management
├─ Covers: Data cleaning, version merging, missing data handling
├─ Used by: Sandbox 02 (infrastructure work)
├─ Reference when: Cleaning data, classifying missingness
└─ Output: Clean dataset (survey_clean.rds)

Research Area 05: Food Security Indicators
├─ Covers: HDDS, FCS, rCSI, FIES methodology
├─ Used by: Sandbox 03 Module 1 (food security calculations)
├─ Reference when: Implementing HDDS, FCS, rCSI, FIES
└─ Output: Indicator calculation scripts

Research Area 06: Income & Expenditure
├─ Covers: Economic indicators, poverty benchmarks, Vietnam context
├─ Used by: Sandbox 03 Module 2 (economics module)
├─ Reference when: Aggregating income, calculating shares, using Vietnam data
└─ Output: Economic indicator scripts

Research Area 07: Likert Scales & Psychometrics
├─ Covers: Scale recoding, reliability testing, visualization
├─ Used by: Sandbox 03 Module 3 (likert scales)
├─ Reference when: Recoding, testing reliability, visualizing distributions
└─ Output: Scale analysis scripts

Research Area 08: Documentation Standards
├─ Covers: Codebook creation, variable labeling, data dictionary format
├─ Used by: Sandbox 01 (generating codebook)
├─ Reference when: Creating codebook, documenting variables
└─ Output: codebook.csv

Research Area 09: Geospatial Analysis
├─ Covers: Loading GADM, choropleth mapping, spatial aggregation
├─ Used by: Sandbox 04 Module 1 (geospatial)
├─ Reference when: Loading boundaries, creating maps
└─ Output: Choropleth maps

Research Area 10: Reporting & Tables
├─ Covers: gtsummary, flextable, Word export, publication formatting
├─ Used by: Sandbox 04 Module 2 (reporting)
├─ Reference when: Creating Table 1, indicator tables, Word export
└─ Output: thesis_tables.docx
```

---

## Directory Structure Across Sandboxes

```
belgrade/
│
├── GETTING-STARTED.md              ← You are here! Entry points + workflows
├── PIPELINE.md                      ← System architecture overview
├── VISUALIZATION-REFERENCE.md       ← How to use /visualize command
├── readme.txt                       ← Comprehensive project guide
│
├── sandboxes/
│   │
│   ├── 01-survey-understanding/    [Foundation]
│   │   ├── SANDBOX.md              ← Purpose + features for S01
│   │   ├── ai/
│   │   │   ├── feature_list.json   ← 4 features (parse, codebook, modules, map)
│   │   │   ├── progress.log        ← Work history
│   │   │   └── init.sh
│   │   ├── docs/                   ← Research areas 01, 03, 08
│   │   ├── scripts/
│   │   │   ├── parse-xlsform.R
│   │   │   ├── generate-codebook.R
│   │   │   └── construct-mapping.R
│   │   ├── tests/
│   │   └── output/
│   │       ├── codebook.csv
│   │       └── construct_map.md
│   │
│   ├── 02-data-pipeline/           [Infrastructure]
│   │   ├── SANDBOX.md              ← Purpose + features for S02
│   │   ├── ai/
│   │   │   ├── feature_list.json   ← 7 features (setup, API, clean, merge)
│   │   │   ├── progress.log
│   │   │   └── init.sh
│   │   ├── docs/                   ← Research areas 02, 03, 04
│   │   ├── scripts/
│   │   │   ├── project-setup.R
│   │   │   ├── kobo-api-connection.R
│   │   │   ├── download-submissions.R
│   │   │   ├── merge-versions.R
│   │   │   └── classify-missing.R
│   │   ├── tests/
│   │   └── output/
│   │       ├── survey_clean.rds
│   │       └── data_quality_report.html
│   │
│   ├── 03-indicators/              [Core Analysis]
│   │   ├── SANDBOX.md              ← Purpose + features for S03
│   │   ├── ai/
│   │   │   ├── feature_list.json   ← 12 features (3 modules, parallel)
│   │   │   ├── progress.log
│   │   │   └── init.sh
│   │   ├── docs/                   ← Research areas 05, 06, 07
│   │   │   ├── 05-food-security/
│   │   │   ├── 06-income-expenditure/
│   │   │   └── 07-likert-scales/
│   │   ├── scripts/
│   │   │   ├── food-security/
│   │   │   │   ├── calculate-hdds.R
│   │   │   │   ├── calculate-fcs.R
│   │   │   │   ├── calculate-rcsi.R
│   │   │   │   └── calculate-fies.R
│   │   │   ├── economics/
│   │   │   │   ├── calculate-income.R
│   │   │   │   ├── calculate-expenditure.R
│   │   │   │   └── detect-outliers.R
│   │   │   └── likert/
│   │   │       ├── recode-scales.R
│   │   │       ├── cronbach-alpha.R
│   │   │       └── diverging-bars.R
│   │   ├── tests/
│   │   └── output/
│   │       ├── survey_with_indicators.rds
│   │       ├── indicators_summary.csv
│   │       └── diverging_bars.png
│   │
│   └── 04-analysis-reporting/     [Output]
│       ├── SANDBOX.md              ← Purpose + features for S04
│       ├── ai/
│       │   ├── feature_list.json   ← 6 features (geospatial + reporting)
│       │   ├── progress.log
│       │   └── init.sh
│       ├── docs/                   ← Research areas 09, 10
│       ├── scripts/
│       │   ├── geospatial/
│       │   │   ├── load-gadm.R
│       │   │   └── choropleth-maps.R
│       │   └── reporting/
│       │       ├── table1-sample.R
│       │       ├── table-indicators.R
│       │       └── word-export.R
│       ├── tests/
│       └── output/
│           ├── figures/
│           │   ├── choropleth_hdds.png
│           │   ├── choropleth_fcs.png
│           │   └── ...
│           ├── tables/
│           │   └── thesis_tables.docx
│           └── reports/
│
├── research-areas/                 [Reference Documentation]
│   ├── 00-index.md
│   ├── 01-survey-context/
│   │   ├── index.md
│   │   ├── templates/
│   │   └── scripts/
│   ├── 02-r-workflow/
│   ├── 03-kobo-xlsform/
│   ├── 04-data-management/
│   ├── 05-food-security-indicators/
│   ├── 06-income-expenditure/
│   ├── 07-likert-psychometrics/
│   ├── 08-documentation-standards/
│   ├── 09-geospatial/
│   └── 10-reporting/
│
├── ai/                             [Global Feature List]
│   ├── feature_list.json           ← All 29 features (summary view)
│   ├── progress.log                ← All work history
│   └── init.sh
│
└── .migration-backup/              [Safety Net]
    ├── ai/                         ← Original feature list (pre-migration)
    └── research-areas/             ← Original research docs (pre-migration)
```

---

## Parallel Processing Opportunity in Sandbox 03

```
Timeline View: When 3 Agents Can Work Simultaneously

t=0: survey_clean.rds arrives
     │
     ▼
────────────────────────────────────────────────────────────────► Time

  Agent 1: Food Security Module     Agent 2: Economics Module    Agent 3: Likert Module
  ┌──────────────────────────────┐  ┌─────────────────────────┐ ┌──────────────────┐
  │ ╔════════════════════════════╗  │ ╔═══════════════════════╗ │ ╔════════════════╗ │
  │ ║  hdds-calculate (Pr. 18)    ║  │ ║ income-aggregate (Pr.  ║ │ ║ recode-scales  ║ │
  │ ║  ~2 hours                   ║  │ ║ 22) ~1.5 hours        ║ │ ║ (Pr. 28) ~1 h  ║ │
  │ ╚════════════════════════════╝  │ ╚═══════════════════════╝ │ ╚════════════════╝ │
  │ ╔════════════════════════════╗  │ ╔═══════════════════════╗ │ ╔════════════════╗ │
  │ ║  hdds-categorize (Pr. 19)   ║  │ ║ expenditure-shares     ║ │ ║ cronbach-alpha ║ │
  │ ║  ~1 hour                    ║  │ ║ (Pr. 23) ~1 hour      ║ │ ║ (Pr. 29) ~1 h  ║ │
  │ ╚════════════════════════════╝  │ ╚═══════════════════════╝ │ ╚════════════════╝ │
  │ ╔════════════════════════════╗  │ ╔═══════════════════════╗ │ ╔════════════════╗ │
  │ ║  fcs-calculate (Pr. 20)      ║  │ ║ outliers-detect        ║ │ ║ diverging-bars ║ │
  │ ║  ~2.5 hours                 ║  │ ║ (Pr. 24) ~1.5 hours   ║ │ ║ (Pr. 30) ~1 h  ║ │
  │ ╚════════════════════════════╝  │ ╚═══════════════════════╝ │ ╚════════════════╝ │
  │ ╔════════════════════════════╗  │ ╔═══════════════════════╗ │                    │
  │ ║  rcsi-calculate (Pr. 21)    ║  │ ║ benchmarks-vietnam     ║ │                    │
  │ ║  ~2 hours                   ║  │ ║ (Pr. 25) ~1 hour      ║ │                    │
  │ ╚════════════════════════════╝  │ ╚═══════════════════════╝ │                    │
  │ ╔════════════════════════════╗  │                           │                    │
  │ ║  fies-rasch-model (Pr. 26)  ║  │                           │                    │
  │ ║  ~3 hours                   ║  │                           │                    │
  │ ╚════════════════════════════╝  │                           │                    │
  │ (Total: ~11 hours)              │ (Total: ~4 hours)        │ (Total: ~3 hours) │
  └──────────────────────────────────┘─────────────────────────┴──────────────────┘
                                    │                    │
                                    └────────────────────┘
                                    Sync Point:
                          Merge all outputs into
                      survey_with_indicators.rds


Without parallelization: 11 + 4 + 3 = 18 hours sequential
With parallelization (3 agents): ~11 hours (longest module)
Speedup: 1.6x faster with concurrent agents
```

---

## Decision Gates: Quality Checkpoints Between Stages

```
After each sandbox completes, there's a decision gate:

┌─────────────────────────────────────────────┐
│         SANDBOX 01 COMPLETION GATE          │
├─────────────────────────────────────────────┤
│ Question: "Do we understand what we're     │
│ measuring?"                                  │
│                                             │
│ Success Criteria:                           │
│  ✓ Codebook created with all variables     │
│  ✓ Construct mapping complete              │
│  ✓ Survey module structure documented      │
│  ✓ All research areas 01, 03, 08 reviewed  │
│                                             │
│ Decision: PROCEED ──→ S02 OR REVISE ──→ S01│
└─────────────────────────────────────────────┘
                    │
                    ▼ (if PROCEED)
┌─────────────────────────────────────────────┐
│         SANDBOX 02 COMPLETION GATE          │
├─────────────────────────────────────────────┤
│ Question: "Is our data clean and ready     │
│ for analysis?"                              │
│                                             │
│ Success Criteria:                           │
│  ✓ R project set up with renv              │
│  ✓ All packages installed and loading      │
│  ✓ KoBo API connection successful          │
│  ✓ Data downloaded and merged              │
│  ✓ survey_clean.rds created                │
│  ✓ Data quality report generated           │
│  ✓ Missing data classified                 │
│                                             │
│ Decision: PROCEED ──→ S03 OR REVISE ──→ S02│
└─────────────────────────────────────────────┘
                    │
                    ▼ (if PROCEED)
┌─────────────────────────────────────────────┐
│         SANDBOX 03 COMPLETION GATE          │
├─────────────────────────────────────────────┤
│ Question: "Are our indicators valid and   │
│ reliable?"                                  │
│                                             │
│ Success Criteria:                           │
│  ✓ All food security indicators validated  │
│  ✓ All economic indicators validated       │
│  ✓ All Likert scales reliable              │
│  ✓ survey_with_indicators.rds created      │
│  ✓ Indicator distributions checked         │
│  ✓ Cronbach's alpha acceptable (>0.70)    │
│                                             │
│ Decision: PROCEED ──→ S04 OR REVISE ──→ S03│
└─────────────────────────────────────────────┘
                    │
                    ▼ (if PROCEED)
┌─────────────────────────────────────────────┐
│         SANDBOX 04 COMPLETION GATE          │
├─────────────────────────────────────────────┤
│ Question: "Is this thesis-ready?"          │
│                                             │
│ Success Criteria:                           │
│  ✓ Choropleth maps created for indicators  │
│  ✓ Table 1 (sample characteristics)        │
│  ✓ Indicator results table with CIs        │
│  ✓ All tables exported to Word             │
│  ✓ Maps include scale, legend, title       │
│  ✓ Formatting publication-ready            │
│                                             │
│ Decision: ✓ COMPLETE ──→ THESIS SUBMISSION│
└─────────────────────────────────────────────┘
```

---

## Quick Reference: Which Sandbox for What

| If you need to... | Go to... | Research Area |
|------------------|----------|---|
| Parse the survey structure | Sandbox 01 | 01, 03 |
| Create a codebook | Sandbox 01 | 08 |
| Set up R project | Sandbox 02 | 02 |
| Download data from KoBo | Sandbox 02 | 03 |
| Clean the data | Sandbox 02 | 04 |
| Calculate HDDS | Sandbox 03 Module 1 | 05 |
| Calculate FCS or rCSI | Sandbox 03 Module 1 | 05 |
| Calculate income indicators | Sandbox 03 Module 2 | 06 |
| Handle outliers | Sandbox 03 Module 2 | 06 |
| Test scale reliability | Sandbox 03 Module 3 | 07 |
| Create choropleth maps | Sandbox 04 Module 1 | 09 |
| Generate Table 1 | Sandbox 04 Module 2 | 10 |
| Export to Word | Sandbox 04 Module 2 | 10 |

---

## North Star

Every diagram, every feature, every research area points toward one goal:

> **Transform Vietnamese household survey data into validated food security indicators, geospatial visualizations, and publication-ready thesis documentation.**

---

*Last updated: 2025-12-11*
*See also: GETTING-STARTED.md, PIPELINE.md, readme.txt*
