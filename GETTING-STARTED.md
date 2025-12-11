# Getting Started with Belgrade Analysis Research

## Quick Orientation (5 minutes)

You're working on an **analysis research project** that transforms Vietnamese household survey data into food security indicators for a thesis. The project is divided into **4 sequential sandboxes**, each with specific features.

```
Survey Understanding → Data Pipeline → Indicators → Analysis & Reporting
(Foundation)         (Infrastructure)   (Core Work)  (Outputs)
   S01 (4)              S02 (7)         S03 (12)     S04 (6)
```

**Right now:** Understand these three directories and you understand the entire project.

---

## Three Critical Directories Explained

### 1. `sandboxes/` → Where You Do Work

This is **your primary workspace**. It contains 4 isolated folders (01, 02, 03, 04), each focused on one phase of the project.

**What's in each sandbox:**
```
sandboxes/01-survey-understanding/
├── SANDBOX.md                   ← Read this first (purpose + features)
├── ai/
│   ├── feature_list.json       ← Your feature checklist
│   ├── progress.log            ← Work history
│   └── init.sh                 ← Bootstrap script
├── docs/                        ← Research area guides for THIS sandbox
├── scripts/                     ← R code templates
├── tests/                       ← Test files
└── output/                      ← Generated results
```

**Your workflow in any sandbox:**
1. `cd sandboxes/01-survey-understanding`
2. `cat SANDBOX.md` → Understand the sandbox purpose
3. `agent-foreman next` → See the next feature to work on
4. Build feature in `scripts/` and test it
5. `agent-foreman done <feature-id>` → Mark complete

### 2. `research-areas/` → Reference Documentation

This is **your knowledge library**. It has 10 research domains with guides, scripts, and best practices.

**Map of research areas:**

| # | Area | Covers What | Use When |
|---|------|------------|----------|
| **01** | Survey Context | Vietnamese context, food environment | Understanding survey design |
| **02** | R Workflow | R packages, survey analysis setup | Setting up the R project |
| **03** | KoboToolbox | XLSForm structure, data import | Parsing survey structure |
| **04** | Data Management | Cleaning, versions, missing data | Processing raw data |
| **05** | Food Security | HDDS, FCS, rCSI, FIES | Calculating indicators |
| **06** | Income/Expenditure | Economic indicators, poverty | Economic analysis |
| **07** | Likert Scales | Scale reliability, visualization | Attitudinal data |
| **08** | Documentation | Codebooks, data dictionaries | Creating thesis appendices |
| **09** | Geospatial | Maps, spatial analysis | Making choropleth maps |
| **10** | Reporting | Tables, Word export | Final thesis outputs |

**How to use research areas:**
- Each sandbox has a `/docs` folder with the relevant research area files
- When stuck on a concept, read the research area guide
- Copy script templates from the research area `/scripts`

### 3. `ai/` → Global Feature List

This is the **master inventory of all 29 features** across the entire project.

**Use this when:**
- You want to understand the ENTIRE project scope
- You're at the root directory and need global status
- You want to see which features are done/failing/blocked

**The hierarchy:**
- `ai/feature_list.json` (root) = all 29 features
- `sandboxes/01-survey-understanding/ai/feature_list.json` = only the 4 features in Sandbox 01
- Same for sandboxes 02, 03, 04

**Bottom line:** Work in the sandbox `ai/` folder, check root `ai/` for global progress.

---

## WHERE TO START: Step-by-Step Entry Points

### Entry Point A: "I'm brand new to this project"

**Do this (10 minutes):**

1. **Understand the architecture (2 min)**
   ```bash
   cd belgrade
   cat PIPELINE.md    # Read the visual overview
   ```
   Understanding: 4 sandboxes, sequential, one big parallel opportunity in Sandbox 03.

2. **Explore the first sandbox (3 min)**
   ```bash
   cd sandboxes/01-survey-understanding
   cat SANDBOX.md     # Purpose: Parse survey, generate codebook, map constructs
   ```
   Understanding: 4 features, all about understanding what we're measuring.

3. **See what to do (5 min)**
   ```bash
   agent-foreman status          # See all 4 features in this sandbox
   agent-foreman next            # See the FIRST feature (highest priority)
   ```
   Next step: Read the feature's acceptance criteria and start building.

### Entry Point B: "I'm continuing work from another session"

**Do this (5 minutes):**

1. **Check progress in your sandbox**
   ```bash
   cd sandboxes/02-data-pipeline    # (or whichever sandbox you're in)
   cat ai/progress.log              # See what was done last session
   agent-foreman status             # See where we are now
   ```

2. **Resume from the last stopping point**
   ```bash
   agent-foreman next               # Get the next feature
   ```

3. **Review the work context**
   ```bash
   git log --oneline -5             # See recent commits
   agent-foreman check <feature-id> # Verify current feature status without marking done
   ```

### Entry Point C: "I need to understand research areas"

**Do this (15 minutes):**

1. **See the research area index**
   ```bash
   cd research-areas
   cat 00-index.md                  # Overview of all 10 areas
   ```

2. **Read the area relevant to your sandbox**
   - In Sandbox 01? Read `research-areas/01-survey-context.md`
   - In Sandbox 02? Read `research-areas/02-r-workflow.md` and `research-areas/04-data-management.md`
   - In Sandbox 03? Read `research-areas/05-food-security-indicators.md`, etc.

3. **Use scripts from research areas**
   ```bash
   cd research-areas/05-food-security-indicators
   ls scripts/                      # See available templates
   cp scripts/calculate-hdds.R ~/my-project/  # Copy to your work
   ```

### Entry Point D: "I need to work on a specific feature"

**Do this (3 minutes):**

1. **Find which sandbox has that feature**
   Look in the feature ID. Example: `indicators.hdds.calculate` → Sandbox 03

2. **Go to that sandbox**
   ```bash
   cd sandboxes/03-indicators
   ```

3. **Work on that specific feature**
   ```bash
   agent-foreman next indicators.hdds.calculate
   ```

---

## WHAT TO DO: Concrete Workflows for Each Sandbox

### Sandbox 01: Survey Understanding (Foundation)

**Big Picture:** Before you can analyze data, you need to understand what the survey measures.

**Timeline:** Start here. These 4 features are prerequisites for everything else.

**Feature Workflow:**

| Feature | Acceptance Criteria | Scripts to Use |
|---------|-------------------|-----------------|
| **parse-structure** | XLSForm sheets (survey, choices, settings) are loaded and skip logic is captured. Codebook template completed with all variables. | `research-areas/03-kobo-xlsform/` has XLSForm parsing examples |
| **generate-codebook** | Variable codebook created with names, labels, types, response options. Document all transformations. | `research-areas/08-documentation-standards/templates/codebook-template.R` |
| **survey-modules** | Survey module table created for thesis appendix showing which questions measure what constructs. | `research-areas/01-survey-context/` has construct mapping guides |
| **construct-map** | Mapping complete showing HDDS questions, FIES questions, rCSI questions, Income questions, Likert items. | `research-areas/01-survey-context/templates/construct-mapping.md` |

**Success criteria for Sandbox 01:**
- ✓ Can open the XLSForm and describe what it measures
- ✓ Have a codebook with all survey variables documented
- ✓ Know which survey questions create which indicators
- ✓ Ready to start data pipeline

### Sandbox 02: Data Pipeline (Infrastructure)

**Big Picture:** Set up R environment, connect to data source, clean the data.

**Timeline:** Run second, after Sandbox 01. These 7 features prepare clean data for analysis.

**Module Workflow:**

**First: Project Foundation (Priority 10-11)**
```
1. project-setup
   → Create renv project
   → Set up folder structure
   → Confirm R is ready

2. package-dependencies
   → Install: survey, srvyr, robotoolbox, sf, gtsummary, flextable, likeRT
   → Verify all packages load
   → Ready for KoBo connection
```

**Second: KoBo Connection (Priority 12-13)**
```
3. api-connection
   → Connect to KoBo API with robotoolbox
   → Authenticate with credentials
   → List available submissions

4. download-submissions
   → Download full survey data
   → Handle select_multiple carefully (one row per selection)
   → Save as raw.rds
```

**Third: Data Cleaning (Priority 14-16)**
```
5. merge-ab
   → Load Version A and Version B
   → Align columns (A has no food waste, B does)
   → Create unified dataset
   → Classify missing (structural vs non-response)

6. process-multiselect
   → Convert select_multiple to binary columns
   → Keep respondents with partial responses
   → Respect skip logic

7. classify-missing
   → Mark structural missing (by design)
   → Mark non-response missing (chose not to answer)
   → Mark error missing (data quality issues)
   → Output: survey_clean.rds (ready for analysis)
```

**Success criteria for Sandbox 02:**
- ✓ R project set up with renv
- ✓ All required packages installed and loading
- ✓ Can connect to KoBo API and download data
- ✓ Data merged, cleaned, and ready (survey_clean.rds)
- ✓ Missing data classified appropriately
- ✓ Ready for indicator calculation

### Sandbox 03: Indicators (Core Analysis - Largest)

**Big Picture:** Calculate food security, economic, and attitudinal indicators.

**Timeline:** Run third. This sandbox has 12 features in 3 parallel modules.

**Module 1: Food Security (5 features) - Can start when S02 clean data ready**
```
Priority: HDDS first (simplest) → FCS → rCSI → FIES (Rasch model)

1. hdds-calculate
   Input: Clean data with food group questions
   → Score the 12 food groups
   → Sum to create HDDS (0-12)
   → Documentation: Use FAO methodology
   Output: hdds_score

2. hdds-categorize
   → Create categories: Low (0-3), Medium (4-8), High (9-12)
   → Label: "Dietary Diversity"
   Output: hdds_category

3. fcs-calculate
   → Use WFP food group weights
   → Apply severity thresholds
   Output: fcs_score, fcs_phase

4. rcsi-calculate
   → Severity weights from literature
   → IPC phase classification
   Output: rcsi_score, rcsi_phase

5. fies-rasch-model
   → Use RM.weights package
   → Rasch model for FIES items
   → Output: SDG 2.1.2 indicator
   Output: fies_score, fies_phase
```

**Module 2: Economics (4 features) - Can start when S02 clean data ready**
```
Priority: Income → Expenditure → Outliers → Vietnam Benchmarks

1. income-aggregate
   Input: Multiple income source questions
   → Sum all income sources
   → Handle VND currency
   → Check for outliers
   Output: total_income, income_sources_detail

2. expenditure-calculate-shares
   Input: Expenditure categories
   → Calculate food expenditure share (%)
   → Compare to total expenditure
   → Check reasonableness
   Output: food_expend_share, total_expend

3. outliers-detect-handle
   → Flag extreme values (>3SD from mean)
   → Winsorize or flag for review
   → Document decisions
   Output: outlier_flags

4. vietnam-benchmarks
   → Load Vietnam poverty lines
   → Compare household income to benchmarks
   → Create poverty indicator
   → Vietnam context: typical income levels, currency year
   Output: poverty_status, benchmark_comparison
```

**Module 3: Likert Scales (3 features) - Can start when S02 clean data ready**
```
Priority: Recode → Reliability → Visualization

1. recode-scales
   Input: Likert items (often 1-5 scale)
   → Identify reverse-coded items
   → Apply reverse coding
   → Standardize all to same direction
   Output: likert_items_recoded

2. cronbach-alpha
   → Use psych package
   → Calculate Cronbach's alpha per scale
   → Item-total correlations
   → Report reliability
   Output: cronbach_alpha_results

3. diverging-bars
   → Visualization: diverging stacked bars
   → Show distribution by response option
   → Use likert package
   → Publication-ready figure
   Output: diverging_bar_plot.png
```

**Key: Parallel Processing in Sandbox 03**

After Sandbox 02 clean data is ready, start ALL THREE modules at once:
- Agent 1: Food Security (HDDS, FCS, rCSI, FIES)
- Agent 2: Economics (Income, Expenditure, Outliers, Benchmarks)
- Agent 3: Likert (Recode, Alpha, Visualization)

All merge their outputs into `survey_with_indicators.rds`

**Success criteria for Sandbox 03:**
- ✓ All 5 food security indicators calculated
- ✓ All 4 economic indicators calculated
- ✓ All 3 Likert indicators calculated
- ✓ All calculated indicators validated
- ✓ Output: survey_with_indicators.rds (ready for reporting)
- ✓ Publication-ready diverging bar visualization

### Sandbox 04: Analysis & Reporting (Output)

**Big Picture:** Create geospatial maps and thesis-ready tables.

**Timeline:** Run fourth and final. These 6 features produce publication-ready outputs.

**Module 1: Geospatial (3 features)**
```
1. load-gadm
   → Load Vietnam administrative boundaries (GADM)
   → Province and district levels
   → Prepare for spatial analysis

2. choropleth-maps
   → Create maps showing indicator distribution
   → By province
   → One map per indicator (or faceted)
   → Include scale bar, legend, title
   Output: choropleth_maps.png

3. survey-weighted-aggregation
   → Apply survey weights
   → Aggregate by province
   → Calculate confidence intervals
   → Ready for mapping
   Output: province_summary_weighted.csv
```

**Module 2: Reporting (3 features)**
```
1. descriptive-summary
   → Table 1: Sample characteristics
   → Use gtsummary package
   → Show counts, percentages, means, SDs
   → Stratify by relevant groups
   Output: table1_sample.docx

2. indicator-results
   → Indicator summary table with CIs
   → Mean, SE, 95% CI for each indicator
   → By total sample and by strata
   → Publication format
   Output: table_indicators.docx

3. word-export
   → Export all tables to Word via flextable
   → Professional formatting
   → Ready for thesis appendix
   Output: thesis_tables.docx
```

**Success criteria for Sandbox 04:**
- ✓ Vietnam choropleth maps for all indicators
- ✓ Publication-ready Table 1 (sample characteristics)
- ✓ Publication-ready indicator results table
- ✓ All tables exported to thesis-ready Word document
- ✓ Complete and ready for thesis submission

---

## Key Context to Remember

### Survey Versions A and B
- **Version A:** No food waste questions (was collected first)
- **Version B:** Includes food waste questions (added later)
- **Key insight:** Missing food waste in Version A is **structural** (not collected by design), NOT non-response
- **Action:** Classify as missing="structural" during data cleaning

### Multi-Select Questions
- XLSForm exports select_multiple as multiple binary columns
- Example: "Which foods did your household eat?" becomes Q47_cereals, Q47_legumes, etc.
- **Don't** remove respondents with partial responses
- **Do** understand skip logic before interpreting missingness

### Vietnam Monetary Context
- Currency: Vietnamese Dong (VND)
- You'll need: Reference year, inflation adjustment factors, national poverty lines
- Typical patterns: Income sources (agriculture, wage labor, remittances), expenditure categories
- Check research-areas/06-income-expenditure for Vietnam-specific benchmarks

### Key Indicators You're Building
| Indicator | Module | Output |
|-----------|--------|--------|
| **HDDS** | Food Security | Dietary diversity score (0-12) |
| **FCS** | Food Security | Food consumption score with WFP weights |
| **rCSI** | Food Security | Coping strategies index with severity |
| **FIES** | Food Security | Food insecurity experience (Rasch) |
| **Income** | Economics | Aggregated household income (VND) |
| **Exp Share** | Economics | Food as % of total expenditure |
| **Likert** | Attitudinal | Reliability-tested scales with visualizations |

---

## Troubleshooting: When You Get Stuck

### "I don't understand what this feature is asking for"
1. Read the feature's acceptance criteria (`agent-foreman next` shows them)
2. Check the relevant research area (`research-areas/XX-topic/`)
3. Look for example scripts in `research-areas/XX-topic/scripts/`

### "I don't know if my implementation is correct"
1. Run `agent-foreman check <feature-id>` to verify without marking done
2. Check test files in `tests/` for expected behavior
3. Review outputs against acceptance criteria

### "I need to understand the survey better"
1. Check `sandboxes/01-survey-understanding/output/` for codebook and construct map
2. Read `research-areas/01-survey-context/` for Vietnamese context
3. Read `research-areas/03-kobo-xlsform/` for XLSForm structure

### "I'm working on Sandbox 03 and need Economics documentation"
1. Check `sandboxes/03-indicators/docs/` which has relevant research areas
2. Read `research-areas/06-income-expenditure/` for economic indicators
3. Copy script templates from `research-areas/06-income-expenditure/scripts/`

### "I want to see the overall project progress"
1. `cd belgrade` (project root)
2. `agent-foreman status` → Global view of all 29 features
3. `cd sandboxes/XX/` and `agent-foreman status` → Sandbox-specific view

---

## Command Quick Reference

### View Status
```bash
agent-foreman status              # Current sandbox status
agent-foreman next                # Next priority feature (includes acceptance criteria)
agent-foreman check <id>          # Verify feature (no marking)
```

### Mark Work Complete
```bash
agent-foreman done <id>           # Mark done + auto-commit
agent-foreman done <id> --no-commit  # Mark done without committing
```

### Bootstrap
```bash
./ai/init.sh bootstrap            # Initialize sandbox features
./ai/init.sh dev                  # Set up development environment
./ai/init.sh check                # Run verification
```

### View Project Documentation
```bash
cat readme.txt                    # Full project guide
cat PIPELINE.md                   # Visual architecture
cat VISUALIZATION-REFERENCE.md    # How to visualize the project
cat GETTING-STARTED.md            # This file!
```

---

## One More Thing: Your North Star

Every feature you complete brings you closer to one goal:

> **Publication-ready analysis of Vietnamese household food security, with validated indicators, spatial visualization, and thesis-quality documentation.**

When you're confused about why a feature matters, remember that goal. Every feature serves it.

---

*Last updated: 2025-12-11*
*For questions, see: readme.txt, PIPELINE.md, VISUALIZATION-REFERENCE.md*
