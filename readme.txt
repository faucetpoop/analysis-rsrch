# Analysis Research - Vietnamese Household Food Security Survey

## Project Overview

R-based statistical analysis of KoBo survey data for a thesis on Vietnamese household food security, dietary diversity, and food waste. The project involves multiple measurement instruments (HDDS, FIES, FCS, rCSI, income/expenditure, Likert scales) and geocoded household locations.

**Goal:** End-to-end analysis producing publication-ready descriptive statistics, validated indicators, spatial visualizations, and documented methods for thesis appendices.

---

## Project Structure Overview

```
belgrade/
├── CLAUDE.md              # Agent-foreman integration instructions
├── CONTEXT.md             # Project overview and goals
├── SPECIFICATION.md       # Detailed requirements
├── ARCHITECTURE.md        # Multi-sandbox architecture diagram
│
├── sandboxes/             # ACTIVE: Isolated workspaces (start here!)
│   ├── 01-survey-understanding/
│   ├── 02-data-pipeline/
│   ├── 03-indicators/
│   └── 04-analysis-reporting/
│
├── research-areas/        # Reference documentation (10 research domains)
│   └── 00-index.md        # Navigation hub
│
├── ai/                    # ROOT feature list (mirrors all 29 features)
│   └── feature_list.json
│
├── .migration-backup/     # Pre-migration backup (safety net)
│   ├── ai/                # Original monolithic feature list
│   └── research-areas/    # Original research area docs
│
└── plans/                 # Migration and feature planning docs
```

---

## WHERE TO START

### Step 1: Understand the Architecture

This project uses a **multi-sandbox architecture** where 29 features are distributed across 4 isolated workspaces. Each sandbox:
- Has its own `ai/feature_list.json` and `SANDBOX.md`
- Contains relevant research area documentation in `/docs`
- Can be worked on independently

**Flow:** `01-survey-understanding` → `02-data-pipeline` → `03-indicators` → `04-analysis-reporting`

### Step 2: Navigate to the First Sandbox

```bash
cd sandboxes/01-survey-understanding
cat SANDBOX.md                    # Read purpose and features
agent-foreman status              # Check current state
agent-foreman next                # Start working on next feature
```

### Step 3: Work Through Features Sequentially

1. Complete all 4 features in `01-survey-understanding` (foundation)
2. Move to `02-data-pipeline` (7 features)
3. Move to `03-indicators` (12 features - largest sandbox)
4. Finish with `04-analysis-reporting` (6 features)

---

## WHAT TO DO: Sandbox-by-Sandbox Guide

### Sandbox 01: Survey Understanding (Foundation)
**Features:** 4 | **Priority:** Run first

**Purpose:** Parse XLSForm, generate codebook, document survey modules before any data processing.

| Feature ID | What to Do |
|------------|-----------|
| `data-import.xlsform.parse-structure` | Parse XLSForm sheets (survey, choices, settings) and capture skip logic |
| `documentation.codebook.generate` | Create variable codebook with names, labels, types, response options |
| `documentation.appendix.survey-modules` | Build survey module table for thesis appendix |
| `documentation.construct-map.create` | Map constructs (HDDS, FIES, etc.) to survey questions |

**Research Areas:** 01-survey-context, 03-kobo-xlsform, 08-documentation-standards

**Output:** Codebook, construct mapping, module documentation → used by all downstream sandboxes

---

### Sandbox 02: Data Pipeline (Infrastructure)
**Features:** 7 | **Priority:** Run second

**Purpose:** R project setup, KoBo API connection, data cleaning and merging.

| Feature ID | What to Do |
|------------|-----------|
| `core.config.project-setup` | Initialize R project with renv, folder structure |
| `core.config.package-dependencies` | Install survey, srvyr, robotoolbox, sf, gtsummary, etc. |
| `data-import.kobo.api-connection` | Connect to KoBo API with robotoolbox |
| `data-import.kobo.download-submissions` | Download survey data with select_multiple handling |
| `data-cleaning.versions.merge-ab` | Merge version A (no food waste) and B (with food waste) |
| `data-cleaning.multiselect.process` | Convert select_multiple to binary indicators |
| `data-cleaning.missing.classify` | Classify missing: structural vs non-response vs error |

**Research Areas:** 02-r-workflow, 04-data-management

**Output:** `data/processed/survey_clean.rds` → clean analysis-ready dataset

---

### Sandbox 03: Indicators (Core Analysis)
**Features:** 12 | **Priority:** Run third (largest sandbox)

**Purpose:** Calculate food security, economic, and Likert scale indicators.

**Food Security Module:**
| Feature ID | What to Do |
|------------|-----------|
| `indicators.hdds.calculate` | HDDS from 12 food groups (FAO methodology) |
| `indicators.hdds.categorize` | Classify into low/medium/high diversity |
| `indicators.fcs.calculate` | FCS with WFP food group weights |
| `indicators.rcsi.calculate` | rCSI with severity weights and IPC thresholds |
| `indicators.fies.rasch-model` | FIES Rasch model (RM.weights package, SDG 2.1.2) |

**Economics Module:**
| Feature ID | What to Do |
|------------|-----------|
| `economics.income.aggregate` | Aggregate income sources with VND handling |
| `economics.expenditure.calculate-shares` | Food expenditure share calculation |
| `economics.outliers.detect-handle` | Outlier detection (winsorization/flagging) |
| `economics.benchmarks.vietnam-poverty` | Compare to Vietnam poverty lines |

**Likert Module:**
| Feature ID | What to Do |
|------------|-----------|
| `likert.coding.recode-scales` | Numeric recoding with reverse coding |
| `likert.reliability.cronbach-alpha` | Cronbach's alpha using psych package |
| `likert.visualization.diverging-bars` | Diverging stacked bar charts |

**Research Areas:** 05-food-security-indicators, 06-income-expenditure, 07-likert-psychometrics

**Output:** `output/survey_with_indicators.rds` → dataset with all calculated indicators

---

### Sandbox 04: Analysis & Reporting (Output)
**Features:** 6 | **Priority:** Run fourth (final)

**Purpose:** Geospatial analysis and thesis-ready outputs.

**Geospatial Module:**
| Feature ID | What to Do |
|------------|-----------|
| `geospatial.data.load-gadm` | Load Vietnam admin boundaries (province/district) |
| `geospatial.mapping.choropleth` | Choropleth maps of indicators using tmap |
| `geospatial.aggregation.survey-weighted` | Survey-weighted aggregation by province |

**Reporting Module:**
| Feature ID | What to Do |
|------------|-----------|
| `reporting.tables.descriptive-summary` | Table 1 sample characteristics (gtsummary) |
| `reporting.tables.indicator-results` | Indicator summary with CIs |
| `reporting.export.word-docx` | Export to Word via flextable |

**Research Areas:** 09-geospatial, 10-reporting

**Output:** `output/figures/`, `output/tables/` → thesis-ready artifacts

---

## Key Directories Explained

### `research-areas/` (Reference Documentation)

Contains 10 research domain guides with best practices, scripts, and templates:

| # | Area | Purpose | Scripts/Templates |
|---|------|---------|-------------------|
| 01 | Survey Context | Survey understanding & Vietnam context | templates/construct-mapping |
| 02 | R Workflow | R packages & survey analysis setup | scripts/setup-packages.R |
| 03 | KoboToolbox | XLSForm structure & data import | — |
| 04 | Data Management | Cleaning, versions, missingness | — |
| 05 | Food Security | HDDS, FIES, FCS, rCSI calculation | scripts/calculate-*.R |
| 06 | Income/Expenditure | Economic indicators, poverty | — |
| 07 | Likert/Psychometrics | Scale reliability, visualization | scripts/reliability-analysis.R |
| 08 | Documentation | Codebooks, data dictionaries | templates/codebook-template |
| 09 | Geospatial | Maps, spatial analysis | scripts/choropleth-map-template.R |
| 10 | Reporting | Tables, Word export | templates/gtsummary-table-template.R |

**Use for:** Reference while working on sandbox features. Each sandbox's `/docs` contains the relevant research area files.

---

### `sandboxes/` (Active Workspaces)

The **primary working environment**. Each sandbox is self-contained:

```
sandboxes/01-survey-understanding/
├── SANDBOX.md              # Entry point: purpose, features, success criteria
├── ai/
│   ├── feature_list.json   # Sandbox-specific features only
│   ├── progress.log        # Work history
│   └── init.sh
├── docs/                   # Relevant research area documentation
├── scripts/                # Reference R scripts
├── tests/                  # Test files
└── output/                 # Generated artifacts
```

**Commands (run from within a sandbox):**
```bash
agent-foreman status          # Check sandbox status
agent-foreman next            # Get next priority feature
agent-foreman check <id>      # Verify feature implementation
agent-foreman done <id>       # Mark complete + commit
```

---

### `.migration-backup/` (Safety Net)

**DO NOT MODIFY** - Contains pre-migration backup from 2025-12-10.

| Path | Contents |
|------|----------|
| `.migration-backup/ai/` | Original monolithic `feature_list.json` with all 29 features |
| `.migration-backup/research-areas/` | Original research area documentation before distribution to sandboxes |

**Use for:** Recovery if sandbox architecture needs rollback:
```bash
# Emergency recovery (destroys current sandbox work)
rm -rf sandboxes/
cp -r .migration-backup/ai ai/
cp -r .migration-backup/research-areas research-areas/
```

---

### `ai/` (Root Feature List)

The root-level `ai/feature_list.json` mirrors all 29 features across sandboxes. This is useful for:
- Getting a global view of all features
- Running `agent-foreman status` from project root
- Understanding overall project scope

**Note:** For actual work, navigate to the specific sandbox directory.

---

## Agent-Foreman Commands Reference

### Per-Sandbox Commands (most common)
```bash
cd sandboxes/<sandbox-name>
agent-foreman status              # Check current status
agent-foreman next                # Work on next priority feature
agent-foreman next <feature_id>   # Work on specific feature
agent-foreman check <feature_id>  # Verify without marking done
agent-foreman done <feature_id>   # Mark complete + commit
```

### Global Commands (from project root)
```bash
agent-foreman status              # Status using root feature list
./scripts/sandbox-status.sh       # Status of all sandboxes (if created)
```

### Options
```bash
agent-foreman done <id> --skip-e2e        # Skip E2E tests
agent-foreman done <id> --no-commit       # Skip auto-commit
agent-foreman done <id> --full            # Full verification mode
```

---

## Critical Context for Analysis

### Survey Versions A & B
- **Version A:** Without food waste questions
- **Version B:** With food waste questions
- **Key insight:** Missing food waste data in A is **structural** (not collected), NOT non-response
- Handle with proper NA classification during data cleaning

### Multi-Select Questions
- `select_multiple` becomes multiple binary columns in export
- Don't remove rows with partial responses
- Understand skip logic before interpreting missingness

### Vietnam Monetary Context
Required for income/expenditure analysis:
- Currency: Vietnamese Dong (VND)
- Reference year and inflation adjustment
- National poverty lines for benchmarking
- Typical income/expenditure patterns

### Key Indicators to Generate
| Indicator | Description | Module |
|-----------|-------------|--------|
| HDDS | Household Dietary Diversity Score (12 food groups) | indicators |
| FCS | Food Consumption Score (WFP methodology) | indicators |
| rCSI | Reduced Coping Strategies Index | indicators |
| FIES | Food Insecurity Experience Scale (Rasch model) | indicators |
| Income | Aggregated household income | economics |
| Expenditure Share | Food as % of total expenditure | economics |

---

## Research Areas Deep Dive (Area 0-9)

### Area 0: Deep Understanding of Survey & Context (Foundation)

**Goal:** Understand what your survey means before crunching numbers.

**0.1. Survey Intent & Conceptual Backbone**
- What research questions was survey designed to answer?
- Which modules serve which research questions?
- Concepts: food insecurity dimensions, dietary diversity meaning, food waste behaviours

**0.2. Question-Level Reading**
- For each XLSForm question: What is it measuring? What assumptions?
- Focus on: screeners, frequency questions, recall periods, Likert items
- Document: "concept: perceived food insecurity", "risk: recall bias"

**0.3. Vietnam Context**
- Food environment: typical diets, staples, seasonality
- Food waste: cultural attitudes, local practices
- Economic: income sources, expenditure categories, how people talk about money

**0.4. Construct Mapping**
- Map each construct (HDDS, FIES, etc.) to specific survey questions
- Note transformations: sums, indices, categories
- Output: construct-to-question mapping table

**0.5. Interpretation Limits**
- Social desirability bias, gender dynamics, literacy issues
- What survey cannot tell you: causality, unmeasured aspects
- Create "interpretation guardrails" list

---

### Areas 1-9: Quick Reference

| Area | Goal | Key Tasks |
|------|------|-----------|
| 1 - R Workflow | R fluency for full analysis | tidyverse, survey/srvyr, project structure |
| 2 - KoBo/XLSForm | Survey → dataset understanding | XLSForm sheets, skip logic, select_multiple |
| 3 - Data Management | Clean, trustworthy dataset | Merge A/B, multi-select handling, NA strategy |
| 4 - Food Security | Compute outcome variables | HDDS, FCS, rCSI, FIES implementation |
| 5 - Income/Expenditure | Economic indicators | Aggregation, outliers, Vietnam benchmarks |
| 6 - Likert Scales | Attitudinal data | Recoding, reliability, visualization |
| 7 - Documentation | Thesis support materials | Codebook, appendix tables, alignment |
| 8 - Geospatial | Spatial enrichment | sf objects, choropleth maps, aggregation |
| 9 - Reporting | Thesis-ready outputs | gtsummary, flextable, narrative style |

---

## Recommended Workflow Sequence

### Phase 1: Foundation (Sandbox 01)
1. Parse XLSForm structure
2. Generate codebook
3. Document survey modules
4. Create construct mapping

### Phase 2: Infrastructure (Sandbox 02)
1. Set up R project with renv
2. Install required packages
3. Connect to KoBo API
4. Download and clean data
5. Merge versions A & B
6. Process multi-selects
7. Classify missing data

### Phase 3: Analysis (Sandbox 03)
1. Calculate food security indicators (HDDS, FCS, rCSI, FIES)
2. Process economic data (income, expenditure, outliers)
3. Analyze Likert scales (recode, reliability, visualize)

### Phase 4: Output (Sandbox 04)
1. Load Vietnam admin boundaries
2. Create choropleth maps
3. Generate descriptive tables
4. Export to Word for thesis

---

## Key Resources

### Primary Reference
- [Tidy Survey Book](https://tidy-survey-r.github.io/tidy-survey-book/)

### Food Security Indicators
- [FANTA HDDS Guide](https://www.fantaproject.org/monitoring-and-evaluation/household-dietary-diversity-score)
- [FAO FIES Documentation](https://www.fao.org/measuring-hunger/)
- [WFP FCS Metadata](https://www.wfp.org/publications/meta-data-food-consumption-score-fcs-indicator)
- [FSCluster Handbook](https://fscluster.org/handbook/)

### Vietnam Context
- [GSO VHLSS 2022](https://www.gso.gov.vn/en/default/2024/04/results-of-the-viet-nam-household-living-standards-survey-2022/)
- [UNU-WIDER VARHS Data](https://www.wider.unu.edu/database/viet-nam-data)
- [World Bank Vietnam Poverty](https://documents.worldbank.org/curated/en/923881468303855779/)

### R Packages
- [gtsummary](https://www.danieldsjoberg.com/gtsummary/) - Tables
- [srvyr](https://github.com/gergness/srvyr) - Tidyverse survey analysis
- [sf](https://r-spatial.github.io/sf/) - Spatial data
- [robotoolbox](https://dickoa.gitlab.io/robotoolbox/) - KoboToolbox API

---

## Thesis Checklist (Before Submission)

- [ ] All analyses use survey weights
- [ ] Codebook complete with all variables
- [ ] Tables exported via flextable to Word
- [ ] Maps include scale bar and legend
- [ ] Methods section documents all transformations
- [ ] Construct mapping table in appendix
- [ ] Missing data strategy documented
- [ ] Vietnam monetary context referenced
- [ ] Interpretation limitations acknowledged

---

*Last updated: 2025-12-11*
*Architecture: Multi-sandbox with agent-foreman*
*Total Features: 29 across 4 sandboxes*