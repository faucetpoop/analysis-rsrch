# Processing Workflow: Vietnam Food Security Survey Analysis

A step-by-step workflow from raw data to thesis-ready outputs.

---

## Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           PROCESSING WORKFLOW                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  PHASE 1: FOUNDATION          PHASE 2: DATA PREP         PHASE 3: ANALYSIS │
│  ┌─────────────────┐          ┌─────────────────┐        ┌───────────────┐ │
│  │ 01 Survey       │          │ 03 KoboToolbox  │        │ 05 Food       │ │
│  │    Context      │───────▶  │    Import       │───────▶│    Security   │ │
│  └─────────────────┘          └─────────────────┘        └───────────────┘ │
│          │                            │                          │         │
│          ▼                            ▼                          ▼         │
│  ┌─────────────────┐          ┌─────────────────┐        ┌───────────────┐ │
│  │ 02 R Workflow   │          │ 04 Data         │        │ 06 Income/    │ │
│  │    Setup        │───────▶  │    Management   │───────▶│    Expenditure│ │
│  └─────────────────┘          └─────────────────┘        └───────────────┘ │
│                                       │                          │         │
│                                       │                          ▼         │
│                                       │                  ┌───────────────┐ │
│                                       │                  │ 07 Likert     │ │
│                                       │                  │    Scales     │ │
│                                       │                  └───────────────┘ │
│                                       │                          │         │
│                                       ▼                          ▼         │
│  PHASE 4: OUTPUTS            ┌─────────────────┐        ┌───────────────┐ │
│  ┌─────────────────┐         │ 08 Documentation│◀───────│ 09 Geospatial │ │
│  │ 10 Reporting    │◀────────│    Standards    │        │    Analysis   │ │
│  │    & Tables     │         └─────────────────┘        └───────────────┘ │
│  └─────────────────┘                                                       │
│          │                                                                 │
│          ▼                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │                        THESIS DELIVERABLES                          │  │
│  │  • Table 1: Sample characteristics    • Codebook & data dictionary  │  │
│  │  • Table 2: Food security indicators  • Methods appendix            │  │
│  │  • Table 3: Regression results        • Maps (study area, results)  │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Phase 1: Foundation (Week 1)

### Step 1.1: Survey Context Understanding
**Area:** [01-survey-context](01-survey-context/)
**Time:** 2-3 days
**Output:** Context documentation

```
┌──────────────────────────────────────────────────────────────┐
│ INPUT                                                        │
│ • XLSForm questionnaire                                      │
│ • Survey design documentation                                │
│ • Vietnam food security literature                           │
└──────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────┐
│ PROCESS                                                      │
│ 1. Complete survey-review-checklist.md                       │
│ 2. Write "story" for each survey module                      │
│ 3. Document skip logic patterns                              │
│ 4. Research Vietnam context (diets, poverty, food waste)     │
│ 5. Create construct-question mapping table                   │
│ 6. List interpretation guardrails                            │
└──────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────┐
│ OUTPUT                                                       │
│ • construct-mapping.md (completed)                           │
│ • vietnam-context-notes.md                                   │
│ • interpretation-guardrails.md                               │
│ • Checked survey-review-checklist.md                         │
└──────────────────────────────────────────────────────────────┘
```

**Checklist:**
- [ ] XLSForm reviewed question-by-question
- [ ] All modules documented with purpose
- [ ] Skip logic patterns mapped
- [ ] Vietnam context notes written
- [ ] Construct mapping table complete

---

### Step 1.2: R Environment Setup
**Area:** [02-r-workflow](02-r-workflow/)
**Time:** 1 day
**Output:** Working R project

```bash
# Terminal commands
cd ~/projects/vietnam-food-security
```

```r
# R commands
source("research-areas/02-r-workflow/scripts/setup-packages.R")
renv::init()
renv::snapshot()
```

**Checklist:**
- [ ] RStudio project created
- [ ] All packages installed (run `setup-packages.R`)
- [ ] renv initialized and snapshot taken
- [ ] Can load survey, srvyr, tidyverse without errors

---

## Phase 2: Data Preparation (Week 2)

### Step 2.1: Data Import from KoboToolbox
**Area:** [03-kobo-xlsform](03-kobo-xlsform/)
**Time:** 1 day
**Output:** Raw data files

```r
# scripts/01-data-import.R

library(robotoolbox)

# Setup connection (token in .Renviron)
kobo_setup(url = "https://kf.kobotoolbox.org",
           token = Sys.getenv("KOBOTOOLBOX_TOKEN"))

# List and download
assets <- kobo_asset_list()
data_raw <- kobo_data(asset_id = "YOUR_ASSET_ID",
                      select_multiple_sep = "/")

# Save raw data (READ-ONLY after this point)
saveRDS(data_raw, "data/raw/survey_raw.rds")
```

**Checklist:**
- [ ] API connection working
- [ ] Data downloaded successfully
- [ ] Raw data saved to `data/raw/` (never modify)
- [ ] Repeat groups handled if present
- [ ] Select_multiple format understood

---

### Step 2.2: Data Cleaning & Version Merging
**Area:** [04-data-management](04-data-management/)
**Time:** 2-3 days
**Output:** Clean analysis dataset

```r
# scripts/02-data-cleaning.R

library(tidyverse)
library(naniar)

# Load raw data
data_a <- readRDS("data/raw/survey_version_a.rds")
data_b <- readRDS("data/raw/survey_version_b.rds")

# Compare structures
setdiff(names(data_b), names(data_a))  # Version B only columns

# Merge with version indicator
data_combined <- bind_rows(
  data_a %>% mutate(survey_version = "A"),
  data_b %>% mutate(survey_version = "B")
)

# Create structural NA flags
data_combined <- data_combined %>%
  mutate(
    fw_not_collected = survey_version == "A",
    # Add other skip logic flags from construct mapping
  )

# Recode user-defined missing
data_clean <- data_combined %>%
  mutate(across(where(is.numeric),
    ~case_when(. == -77 ~ NA_real_,  # Refused
               . == -88 ~ NA_real_,  # Don't know
               TRUE ~ .)))

# Document missingness
miss_var_summary(data_clean) %>%
  write_csv("output/data-quality/missingness-summary.csv")

# Save clean data
saveRDS(data_clean, "data/processed/survey_clean.rds")
```

**Checklist:**
- [ ] Version A and B structures compared
- [ ] Versions merged with indicator column
- [ ] Structural NA flags created
- [ ] User-defined missing values recoded
- [ ] Missingness summary generated
- [ ] Clean data saved to `data/processed/`

---

### Step 2.3: Create Survey Design Object
**Area:** [02-r-workflow](02-r-workflow/)
**Time:** 0.5 days
**Output:** Survey design object

```r
# scripts/03-survey-design.R

library(survey)
library(srvyr)

# CRITICAL: Set lonely PSU handling FIRST
options(survey.lonely.psu = "adjust")

# Load clean data
survey_data <- readRDS("data/processed/survey_clean.rds")

# Create design object
design <- survey_data %>%
  as_survey_design(
    ids = psu,           # Primary sampling unit variable
    strata = strata,     # Stratification variable
    weights = weight,    # Sampling weight variable
    nest = TRUE
  )

# Verify
print(design)

# Save design object
saveRDS(design, "data/processed/survey_design.rds")
```

**Checklist:**
- [ ] PSU, strata, weight variables identified
- [ ] Lonely PSU handling configured
- [ ] Design object created successfully
- [ ] Design object saved

---

## Phase 3: Analysis (Weeks 3-4)

### Step 3.1: Calculate Food Security Indicators
**Area:** [05-food-security-indicators](05-food-security-indicators/)
**Time:** 2 days
**Output:** Indicator variables added to dataset

```r
# scripts/04-calculate-indicators.R

# Load scripts
source("research-areas/05-food-security-indicators/scripts/calculate-hdds.R")
source("research-areas/05-food-security-indicators/scripts/calculate-fcs.R")
source("research-areas/05-food-security-indicators/scripts/calculate-rcsi.R")

# Load data
survey_data <- readRDS("data/processed/survey_clean.rds")

# Calculate indicators (adjust variable names to your data)
survey_data <- survey_data %>%
  calculate_hdds(hdds_variables) %>%
  calculate_fcs() %>%
  calculate_rcsi()

# Quality checks
check_hdds(survey_data)
check_fcs(survey_data)
check_rcsi(survey_data)

# Save updated data
saveRDS(survey_data, "data/processed/survey_with_indicators.rds")
```

**Checklist:**
- [ ] Food groups mapped to HDDS (12 groups)
- [ ] HDDS calculated and categorized
- [ ] FCS calculated with correct weights
- [ ] rCSI calculated if coping questions available
- [ ] All quality checks passed
- [ ] Indicator correlations examined

---

### Step 3.2: Calculate Economic Indicators
**Area:** [06-income-expenditure](06-income-expenditure/)
**Time:** 1-2 days
**Output:** Economic variables added

```r
# scripts/05-economic-indicators.R

library(DescTools)

survey_data <- readRDS("data/processed/survey_with_indicators.rds")

# Outlier handling
survey_data <- survey_data %>%
  mutate(
    income_winsor = Winsorize(income, probs = c(0.01, 0.99)),
    expenditure_winsor = Winsorize(expenditure, probs = c(0.01, 0.99))
  )

# Per capita values
survey_data <- survey_data %>%
  mutate(
    income_pc = income_winsor / household_size,
    expenditure_pc = expenditure_winsor / household_size
  )

# Poverty status
poverty_line_rural <- 1000000  # VND - UPDATE WITH CORRECT VALUE
poverty_line_urban <- 1300000

survey_data <- survey_data %>%
  mutate(
    poverty_line = if_else(urban == 1, poverty_line_urban, poverty_line_rural),
    poor = expenditure_pc < poverty_line,
    food_exp_share = (food_expenditure / total_expenditure) * 100
  )

saveRDS(survey_data, "data/processed/survey_with_economics.rds")
```

**Checklist:**
- [ ] Monetary values converted to numeric
- [ ] Outliers identified and handled (winsorize)
- [ ] Per capita values calculated
- [ ] Poverty status calculated
- [ ] Food expenditure share calculated

---

### Step 3.3: Analyze Likert Scales (if applicable)
**Area:** [07-likert-psychometrics](07-likert-psychometrics/)
**Time:** 1 day
**Output:** Validated scales, reliability documented

```r
# scripts/06-likert-analysis.R

source("research-areas/07-likert-psychometrics/scripts/reliability-analysis.R")

survey_data <- readRDS("data/processed/survey_with_economics.rds")

# Define scale items
fsp_items <- c("fsp_1", "fsp_2", "fsp_3", "fsp_4",
               "fsp_5", "fsp_6", "fsp_7", "fsp_8")
reverse_items <- c("fsp_3", "fsp_5", "fsp_7")

# Prepare and analyze
prepared <- prepare_scale(survey_data, fsp_items, reverse_items, max_value = 5)
alpha_result <- run_reliability_analysis(prepared$scale_items,
                                         "Food Security Perception Scale")

# Calculate scale score
survey_data <- calculate_scale_score(prepared$data, prepared$item_vars, min_items = 6)

saveRDS(survey_data, "data/processed/survey_analysis_ready.rds")
```

**Checklist:**
- [ ] Items needing reverse coding identified
- [ ] Reverse coding applied
- [ ] Cronbach's alpha calculated (target ≥ 0.70)
- [ ] Problematic items reviewed
- [ ] Scale scores calculated

---

## Phase 4: Outputs (Week 5)

### Step 4.1: Create Maps
**Area:** [09-geospatial](09-geospatial/)
**Time:** 1 day
**Output:** Thesis-ready maps

```r
# scripts/07-create-maps.R

source("research-areas/09-geospatial/scripts/choropleth-map-template.R")

# Load data
survey_data <- readRDS("data/processed/survey_analysis_ready.rds")

# Prepare map data
map_data <- prepare_map_data(survey_data, vietnam_provinces,
                             province_var = "province",
                             indicator_var = "hdds_score")

# Create study area map
study_map <- create_study_area_map(vietnam_provinces,
                                   c("Hanoi", "Ho Chi Minh", "Da Nang"))
ggsave("output/figures/fig1_study_area.png", study_map,
       width = 6, height = 8, dpi = 300)

# Create indicator map
hdds_map <- create_ggmap(map_data, fill_var = "mean_value",
                         title = "Household Dietary Diversity by Province",
                         legend_title = "Mean HDDS")
ggsave("output/figures/fig2_hdds_map.png", hdds_map,
       width = 8, height = 6, dpi = 300)
```

**Checklist:**
- [ ] Vietnam boundaries loaded
- [ ] Study area map created (Methods figure)
- [ ] HDDS choropleth map created
- [ ] Other indicator maps as needed
- [ ] All maps have scale bars and legends

---

### Step 4.2: Generate Tables
**Area:** [10-reporting](10-reporting/)
**Time:** 2 days
**Output:** Word documents with thesis tables

```r
# scripts/08-create-tables.R

source("research-areas/10-reporting/templates/gtsummary-table-template.R")

# Load design object
design <- readRDS("data/processed/survey_design.rds") %>%
  # Update with new variables
  update(., survey_analysis_ready)

# Table 1: Sample characteristics
table1 <- create_table1(design)
export_to_word(table1, "output/tables/table1_characteristics.docx")

# Table 1 by food security status
table1_compare <- create_table1(design, by_var = food_secure)
export_to_word(table1_compare, "output/tables/table1_by_food_security.docx")

# Table 2: Indicators
table2 <- create_indicator_table(design)
export_to_word(table2, "output/tables/table2_indicators.docx")

# Table 3: Regression
model <- design %>%
  svyglm(food_secure ~ age + gender + education + income_pc + urban,
         family = quasibinomial())
table3 <- create_regression_table(model)
export_to_word(table3, "output/tables/table3_regression.docx")
```

**Checklist:**
- [ ] Table 1 (sample characteristics) created
- [ ] Comparison table by outcome created
- [ ] Indicator summary table created
- [ ] Regression results table created
- [ ] All tables exported to Word

---

### Step 4.3: Create Documentation
**Area:** [08-documentation-standards](08-documentation-standards/)
**Time:** 1-2 days
**Output:** Codebook and appendix materials

```r
# scripts/09-create-documentation.R

library(codebook)
library(labelled)

survey_data <- readRDS("data/processed/survey_analysis_ready.rds")

# Add labels (should have been done earlier, but verify)
survey_data <- survey_data %>%
  set_variable_labels(
    hdds_score = "Household Dietary Diversity Score (0-12)",
    fcs_score = "Food Consumption Score",
    income_pc = "Per capita income (VND/month)",
    # ... add all variables
  )

# Generate codebook
codebook_output <- codebook(survey_data)

# Export codebook
rmarkdown::render(codebook_output,
                  output_file = "output/documentation/codebook.html")
```

**Checklist:**
- [ ] All variables have labels
- [ ] Value labels added to categorical variables
- [ ] Codebook generated
- [ ] Survey module appendix table created
- [ ] Variable definitions table created

---

## Final Checklist

### Before Submitting Thesis

**Data Quality:**
- [ ] All analyses use survey weights (tbl_svysummary, not tbl_summary)
- [ ] Missingness documented and appropriate handling justified
- [ ] Outlier handling documented in methods
- [ ] Data cleaning decisions logged

**Reproducibility:**
- [ ] renv.lock file captures all package versions
- [ ] Scripts numbered in execution order (01-, 02-, etc.)
- [ ] Raw data untouched in `data/raw/`
- [ ] All transformations documented

**Tables:**
- [ ] Consistent decimal places throughout
- [ ] Proper captions and footnotes
- [ ] Statistical significance properly indicated
- [ ] All exported to Word via flextable

**Figures:**
- [ ] Maps include scale bar, north arrow, legend
- [ ] Appropriate color palettes (colorblind-friendly)
- [ ] High resolution (300 dpi minimum)
- [ ] Privacy considerations addressed

**Documentation:**
- [ ] Codebook complete
- [ ] Methods section documents all transformations
- [ ] Limitations acknowledge survey design constraints
- [ ] All external resources properly cited

---

## Directory Structure After Processing

```
vietnam-food-security/
├── data/
│   ├── raw/                          # NEVER MODIFY
│   │   ├── survey_version_a.rds
│   │   └── survey_version_b.rds
│   ├── processed/
│   │   ├── survey_clean.rds
│   │   ├── survey_with_indicators.rds
│   │   ├── survey_with_economics.rds
│   │   ├── survey_analysis_ready.rds
│   │   └── survey_design.rds
│   └── external/
│       └── vietnam_admin1.gpkg
├── scripts/
│   ├── 01-data-import.R
│   ├── 02-data-cleaning.R
│   ├── 03-survey-design.R
│   ├── 04-calculate-indicators.R
│   ├── 05-economic-indicators.R
│   ├── 06-likert-analysis.R
│   ├── 07-create-maps.R
│   ├── 08-create-tables.R
│   └── 09-create-documentation.R
├── output/
│   ├── tables/
│   │   ├── table1_characteristics.docx
│   │   ├── table1_by_food_security.docx
│   │   ├── table2_indicators.docx
│   │   └── table3_regression.docx
│   ├── figures/
│   │   ├── fig1_study_area.png
│   │   └── fig2_hdds_map.png
│   ├── documentation/
│   │   └── codebook.html
│   └── data-quality/
│       └── missingness-summary.csv
├── research-areas/                   # Reference documentation
├── renv/
├── renv.lock
└── vietnam-food-security.Rproj
```

---

## Quick Reference: Which Area for What?

| Task | Go To |
|------|-------|
| "What does this survey question mean?" | 01-survey-context |
| "How do I install packages?" | 02-r-workflow |
| "How do I download from KoboToolbox?" | 03-kobo-xlsform |
| "How do I handle missing data?" | 04-data-management |
| "How do I calculate HDDS?" | 05-food-security-indicators |
| "How do I handle outliers in income?" | 06-income-expenditure |
| "How do I check scale reliability?" | 07-likert-psychometrics |
| "How do I create a codebook?" | 08-documentation-standards |
| "How do I make a map?" | 09-geospatial |
| "How do I export tables to Word?" | 10-reporting |

---

*Last updated: 2025-12-10*
