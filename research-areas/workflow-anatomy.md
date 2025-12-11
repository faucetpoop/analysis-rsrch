# Vietnam Food Security Analysis Workflow Anatomy

## Overview

This diagram maps the complete data analysis pipeline from raw KoboToolbox survey data through thesis-ready deliverables, showing the 4 phases, 9 steps, decision gates, and data transformation checkpoints.

## Digital Diagram

```text
┌──────────────────────────────────────────────────────────────────────────────────────┐
│                    VIETNAM FOOD SECURITY ANALYSIS ANATOMY                            │
│                         (Raw Data → Thesis Deliverables)                             │
├──────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                      │
│  [ EXTERNAL INPUTS LOBE ]                                                            │
│   • XLSForm questionnaire                                                            │
│   • KoboToolbox API                                                                  │
│   • Vietnam literature                                                               │
│   • GADM boundaries                                                                  │
│                    │                                                                 │
│                    ▼                                                                 │
│  ╔══════════════════════════════════════════════════════════════════════════════╗   │
│  ║  PHASE 1: FOUNDATION ORGAN                                     [Week 1]      ║   │
│  ║  ┌────────────────────────────┐    ┌────────────────────────────┐            ║   │
│  ║  │  01 SURVEY CONTEXT         │    │  02 R ENVIRONMENT          │            ║   │
│  ║  │  ─────────────────────     │    │  ─────────────────────     │            ║   │
│  ║  │  • Review XLSForm          │───▶│  • Install packages        │            ║   │
│  ║  │  • Map constructs          │    │  • Initialize renv         │            ║   │
│  ║  │  • Document skip logic     │    │  • Create project          │            ║   │
│  ║  │  • Vietnam context notes   │    │                            │            ║   │
│  ║  │                            │    │  Decision: Packages load?  │            ║   │
│  ║  │  Decision: Understood?     │    │  ← If error, debug         │            ║   │
│  ║  │  ← If unclear, research    │    └────────────────────────────┘            ║   │
│  ║  └────────────────────────────┘                 │                            ║   │
│  ╚═════════════════════════════════════════════════│════════════════════════════╝   │
│                                                    │                                 │
│                                                    ▼                                 │
│  ╔══════════════════════════════════════════════════════════════════════════════╗   │
│  ║  PHASE 2: DATA PREPARATION ORGAN                               [Week 2]      ║   │
│  ║  ┌────────────────────────────┐    ┌────────────────────────────┐            ║   │
│  ║  │  03 KOBO IMPORT            │    │  04 DATA MANAGEMENT        │            ║   │
│  ║  │  ─────────────────────     │    │  ─────────────────────     │            ║   │
│  ║  │  • API connection          │───▶│  • Merge versions A/B      │            ║   │
│  ║  │  • Download submissions    │    │  • Flag structural NAs     │            ║   │
│  ║  │  • Handle repeats          │    │  • Recode missing codes    │            ║   │
│  ║  │  • Parse select_multiple   │    │  • Document missingness    │            ║   │
│  ║  │                            │    │                            │            ║   │
│  ║  │  Output: data/raw/*.rds    │    │  Decision: Data clean?     │            ║   │
│  ║  │  [IMMUTABLE - NEVER EDIT]  │    │  ← If issues, investigate  │            ║   │
│  ║  └────────────────────────────┘    └─────────────┬──────────────┘            ║   │
│  ║                                                  │                            ║   │
│  ║                                                  ▼                            ║   │
│  ║                                    ┌────────────────────────────┐            ║   │
│  ║                                    │  SURVEY DESIGN OBJECT      │            ║   │
│  ║                                    │  ─────────────────────     │            ║   │
│  ║                                    │  • Set lonely PSU option   │            ║   │
│  ║                                    │  • Define ids/strata/wts   │            ║   │
│  ║                                    │  • Create srvyr design     │            ║   │
│  ║                                    │                            │            ║   │
│  ║                                    │  Output: survey_design.rds │            ║   │
│  ║                                    └─────────────┬──────────────┘            ║   │
│  ╚══════════════════════════════════════════════════│════════════════════════════╝   │
│                                                     │                                │
│                    ┌────────────────────────────────┼────────────────────────────┐   │
│                    │                                │                            │   │
│                    ▼                                ▼                            ▼   │
│  ╔══════════════════════════════════════════════════════════════════════════════╗   │
│  ║  PHASE 3: ANALYSIS ORGAN                                    [Weeks 3-4]      ║   │
│  ║  ┌────────────────────────┐  ┌────────────────────────┐  ┌────────────────┐  ║   │
│  ║  │  05 FOOD SECURITY      │  │  06 ECONOMICS          │  │  07 LIKERT     │  ║   │
│  ║  │  ──────────────────    │  │  ──────────────────    │  │  ──────────    │  ║   │
│  ║  │  • Calculate HDDS      │  │  • Winsorize outliers  │  │  • Reverse     │  ║   │
│  ║  │  • Calculate FCS       │  │  • Per capita values   │  │    code items  │  ║   │
│  ║  │  • Calculate rCSI      │  │  • Poverty status      │  │  • Cronbach α  │  ║   │
│  ║  │  • Categorize levels   │  │  • Food exp share      │  │  • Scale score │  ║   │
│  ║  │                        │  │                        │  │                │  ║   │
│  ║  │  Decision: Valid?      │  │  Decision: Outliers?   │  │  Decision:     │  ║   │
│  ║  │  ← Check ranges        │  │  ← Review extremes     │  │  α ≥ 0.70?     │  ║   │
│  ║  └───────────┬────────────┘  └───────────┬────────────┘  └───────┬────────┘  ║   │
│  ║              │                           │                       │           ║   │
│  ║              └───────────────┬───────────┴───────────────────────┘           ║   │
│  ║                              │                                               ║   │
│  ║                              ▼                                               ║   │
│  ║              ┌───────────────────────────────────┐                           ║   │
│  ║              │  ANALYSIS-READY DATASET           │                           ║   │
│  ║              │  survey_analysis_ready.rds        │                           ║   │
│  ║              │  • All indicators calculated      │                           ║   │
│  ║              │  • All transformations applied    │                           ║   │
│  ║              │  • Ready for weighted analysis    │                           ║   │
│  ║              └───────────────┬───────────────────┘                           ║   │
│  ╚══════════════════════════════│════════════════════════════════════════════════╝   │
│                                 │                                                    │
│           ┌─────────────────────┼─────────────────────┐                              │
│           │                     │                     │                              │
│           ▼                     ▼                     ▼                              │
│  ╔══════════════════════════════════════════════════════════════════════════════╗   │
│  ║  PHASE 4: OUTPUTS ORGAN                                        [Week 5]      ║   │
│  ║  ┌────────────────────┐  ┌────────────────────┐  ┌────────────────────────┐  ║   │
│  ║  │  09 GEOSPATIAL     │  │  10 REPORTING      │  │  08 DOCUMENTATION      │  ║   │
│  ║  │  ──────────────    │  │  ──────────────    │  │  ──────────────────    │  ║   │
│  ║  │  • Load GADM       │  │  • Table 1: Demo   │  │  • Add var labels      │  ║   │
│  ║  │  • Aggregate stats │  │  • Table 2: Indic  │  │  • Generate codebook   │  ║   │
│  ║  │  • Study area map  │  │  • Table 3: Regr   │  │  • Survey appendix     │  ║   │
│  ║  │  • Choropleth maps │  │  • Export to Word  │  │  • Methods docs        │  ║   │
│  ║  │                    │  │                    │  │                        │  ║   │
│  ║  │  Output:           │  │  Output:           │  │  Output:               │  ║   │
│  ║  │  figures/*.png     │  │  tables/*.docx     │  │  codebook.html         │  ║   │
│  ║  └─────────┬──────────┘  └─────────┬──────────┘  └───────────┬────────────┘  ║   │
│  ║            │                       │                         │               ║   │
│  ║            └───────────────────────┴─────────────────────────┘               ║   │
│  ║                                    │                                         ║   │
│  ╚════════════════════════════════════│══════════════════════════════════════════╝   │
│                                       │                                              │
│                                       ▼                                              │
│  ┌──────────────────────────────────────────────────────────────────────────────┐   │
│  │                        THESIS DELIVERABLES ARCHIVE                           │   │
│  │  ═══════════════════════════════════════════════════════════════════════════ │   │
│  │                                                                              │   │
│  │  TABLES (Word)              FIGURES (PNG)           DOCUMENTATION            │   │
│  │  ──────────────             ─────────────           ─────────────            │   │
│  │  • Table 1: Sample          • Study area map        • Codebook               │   │
│  │  • Table 2: Indicators      • HDDS by province      • Data dictionary        │   │
│  │  • Table 3: Regression      • Other choropleths     • Methods appendix       │   │
│  │  • Comparison tables                                • Missingness report     │   │
│  │                                                                              │   │
│  └──────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                      │
│  [ FEEDBACK LOOPS ]                                                                  │
│   ◄─── Decision gates return to earlier steps if validation fails                   │
│   ◄─── Raw data is IMMUTABLE - cleaning creates new files                           │
│   ◄─── Each phase produces checkpoint saves for recovery                            │
│                                                                                      │
└──────────────────────────────────────────────────────────────────────────────────────┘
```

## Data Flow Anatomy

```text
┌──────────────────────────────────────────────────────────────────────────────────────┐
│                           DATA TRANSFORMATION PIPELINE                               │
├──────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                      │
│  data/raw/                    data/processed/                     output/            │
│  ═════════                    ═══════════════                     ═══════            │
│                                                                                      │
│  ┌─────────────┐              ┌─────────────────┐                                    │
│  │ survey_     │    CLEAN     │ survey_clean    │                                    │
│  │ version_a   │─────────────▶│ .rds            │                                    │
│  │ .rds        │              │                 │                                    │
│  └─────────────┘              │ + version flag  │                                    │
│        +                      │ + structural NA │                                    │
│  ┌─────────────┐              │ + recoded miss  │                                    │
│  │ survey_     │              └────────┬────────┘                                    │
│  │ version_b   │                       │                                             │
│  │ .rds        │                       │ ADD INDICATORS                              │
│  └─────────────┘                       ▼                                             │
│                               ┌─────────────────┐                                    │
│  [IMMUTABLE]                  │ survey_with_    │                                    │
│  Never modify                 │ indicators.rds  │                                    │
│  these files                  │                 │                                    │
│                               │ + hdds_score    │                                    │
│                               │ + fcs_score     │                                    │
│                               │ + rcsi_score    │                                    │
│                               └────────┬────────┘                                    │
│                                        │                                             │
│                                        │ ADD ECONOMICS                               │
│                                        ▼                                             │
│                               ┌─────────────────┐                                    │
│                               │ survey_with_    │                                    │
│                               │ economics.rds   │                                    │
│                               │                 │                                    │
│                               │ + income_pc     │                                    │
│                               │ + poverty_status│                                    │
│                               │ + food_exp_share│                                    │
│                               └────────┬────────┘                                    │
│                                        │                                             │
│                                        │ ADD SCALES                                  │
│                                        ▼                                             │
│                               ┌─────────────────┐      ┌─────────────────────────┐   │
│                               │ survey_analysis │      │  output/tables/         │   │
│                               │ _ready.rds      │─────▶│  *.docx                 │   │
│                               │                 │      └─────────────────────────┘   │
│                               │ FINAL DATASET   │                                    │
│                               │ All vars ready  │      ┌─────────────────────────┐   │
│                               └────────┬────────┘─────▶│  output/figures/        │   │
│                                        │               │  *.png                  │   │
│                                        │               └─────────────────────────┘   │
│                               ┌────────▼────────┐                                    │
│                               │ survey_design   │      ┌─────────────────────────┐   │
│                               │ .rds            │─────▶│  output/documentation/  │   │
│                               │                 │      │  codebook.html          │   │
│                               │ srvyr object    │      └─────────────────────────┘   │
│                               │ with weights    │                                    │
│                               └─────────────────┘                                    │
│                                                                                      │
└──────────────────────────────────────────────────────────────────────────────────────┘
```

## Hand-Drawable Version

For sketching quickly on paper or in your notebook:

```text
FOUNDATION (Week 1)
─────────────────────
Survey Context ──▶ R Setup
     │                │
     ▼                ▼
DATA PREP (Week 2)
─────────────────────
Kobo Import ──▶ Clean/Merge ──▶ Survey Design
     │              │                │
     │         [raw/ folder]    [design.rds]
     │              │                │
     ▼              ▼                ▼
ANALYSIS (Weeks 3-4)
─────────────────────
     ┌──────────┬──────────┐
     │          │          │
Food Sec    Economics   Likert
  HDDS       Poverty      α
  FCS        Income      Score
  rCSI       Outliers
     │          │          │
     └────┬─────┴──────────┘
          │
          ▼
   [analysis_ready.rds]
          │
OUTPUTS (Week 5)
─────────────────────
     ┌──────────┬──────────┐
     │          │          │
   Maps     Tables      Docs
  .png      .docx     codebook
     │          │          │
     └────┬─────┴──────────┘
          │
          ▼
    THESIS READY
```

## Script Execution Sequence

```text
┌──────────────────────────────────────────────────────────────────┐
│                    SCRIPT EXECUTION ORDER                        │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│   01-data-import.R                                               │
│        │                                                         │
│        ▼                                                         │
│   02-data-cleaning.R                                             │
│        │                                                         │
│        ▼                                                         │
│   03-survey-design.R                                             │
│        │                                                         │
│        ├──────────────────┬──────────────────┐                   │
│        ▼                  ▼                  ▼                   │
│   04-calculate-      05-economic-       06-likert-               │
│   indicators.R       indicators.R       analysis.R               │
│        │                  │                  │                   │
│        └──────────────────┴──────────────────┘                   │
│                           │                                      │
│        ┌──────────────────┼──────────────────┐                   │
│        ▼                  ▼                  ▼                   │
│   07-create-maps.R   08-create-tables.R  09-create-              │
│                                          documentation.R         │
│        │                  │                  │                   │
│        └──────────────────┴──────────────────┘                   │
│                           │                                      │
│                           ▼                                      │
│                    THESIS COMPLETE                               │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

## Legend

| Symbol | Meaning |
|--------|---------|
| `┌─┐` Box | Clearly defined process or component |
| `[ ]` Brackets | Fuzzy conceptual area or pool |
| `║` Double line | Phase boundary |
| `│` `▼` Arrow | Data flow or transformation |
| `←` Curved | Feedback loop / decision return |
| `═══` Double | Section divider |
| `.rds` | R data checkpoint file |
| `.docx` `.png` | Final output formats |

## Key Insights

- **Immutable raw data**: The `data/raw/` folder is never modified after initial import - all cleaning creates new files in `data/processed/`

- **Checkpoint saves**: Each major transformation creates a new `.rds` file, allowing recovery from any point without re-running earlier steps

- **Decision gates**: Every analysis step includes validation checks that loop back if data doesn't meet quality thresholds

- **Parallel analysis**: Phase 3 (Food Security, Economics, Likert) can run in parallel once clean data exists

- **Survey weights flow through**: The `survey_design.rds` object carries weights through all analysis, ensuring all statistics are properly weighted

## Critical Decision Points

| Step | Question | If No |
|------|----------|-------|
| 01 Survey Context | Do I understand what each question measures? | Research more, consult documentation |
| 02 R Setup | Do all packages load without error? | Debug installation, check versions |
| 04 Data Clean | Are missingness patterns as expected? | Investigate anomalies, check skip logic |
| 05 Indicators | Are indicator ranges valid (HDDS 0-12)? | Check food group mapping |
| 06 Economics | Are outliers real or data errors? | Review extremes, decide winsorize vs exclude |
| 07 Likert | Is Cronbach's α ≥ 0.70? | Consider removing problematic items |

## How to Use This

1. **Planning**: Use the digital diagram to understand dependencies before starting
2. **Execution**: Follow script numbers (01-09) in order
3. **Recovery**: If something breaks, identify which checkpoint to restart from
4. **Notebook**: Sketch the hand-drawable version to track your progress
5. **Reference**: Keep this diagram open while working for quick navigation

---

*Generated: 2025-12-10*
*Source: research-areas/WORKFLOW.md*
