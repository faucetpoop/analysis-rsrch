# R Survey Data Analysis Best Practices Guide
## Food Security, Dietary Diversity, and Expenditure Analysis in Vietnam

**Version:** 1.0
**Date:** 2025-12-10
**Status:** Reference Document
**Purpose:** Comprehensive best practices for thesis-quality survey data analysis
in R

---

## Table of Contents

1. [R Workflow for Survey Analysis](#1-r-workflow-for-survey-analysis)
2. [XLSForm/KoboToolbox Data Processing](#2-xlsformkobotoolbox-data-processing)
3. [Missing Data Strategy](#3-missing-data-strategy)
4. [Food Security & Dietary Diversity Indicators](#4-food-security--dietary-diversity-indicators)
5. [Income & Expenditure Analysis](#5-income--expenditure-analysis)
6. [Likert Scale Analysis](#6-likert-scale-analysis)
7. [Documentation Standards](#7-documentation-standards)
8. [Geospatial Analysis](#8-geospatial-analysis)
9. [Descriptive Statistics Reporting](#9-descriptive-statistics-reporting)
10. [Project Structure & Organization](#10-project-structure--organization)

---

## 1. R Workflow for Survey Analysis

### Essential Packages

**Core Tidyverse:**
```r
library(tidyverse)    # Data manipulation and visualization
library(readxl)       # Excel file import
library(readr)        # CSV file import
library(dplyr)        # Data manipulation
library(tidyr)        # Data tidying
```

**Survey-Specific:**
```r
library(survey)       # Complex survey design analysis
library(srvyr)        # Tidyverse-compatible survey analysis
library(srvyrexploR)  # Survey exploration tools
```

**Additional Tools:**
```r
library(haven)        # SPSS/Stata data import with labels
library(labelled)     # Working with labelled data
library(broom)        # Tidy model outputs
library(gt)           # Table formatting
library(gtsummary)    # Summary tables for surveys
```

### Best Practices for Tidyverse Workflow

#### Data Import

```r
# Excel files from KoboToolbox
data <- read_excel("kobotoolbox_export.xlsx")

# CSV with proper encoding for Vietnamese text
data <- read_csv("survey_data.csv",
                 locale = locale(encoding = "UTF-8"))

# SPSS files with value labels preserved
data <- haven::read_sav("survey_data.sav") %>%
  haven::as_factor()  # Convert labelled to factors
```

#### Workflow Order Matters

The order of operations is critical in survey analysis:

1. **Create survey design object FIRST**
2. **Then filter/subset data** (never filter before creating design)
3. **Then calculate statistics**

```r
# Correct order
design <- svydesign(id = ~psu,
                    strata = ~strata,
                    weights = ~weight,
                    data = survey_data)

# Filter AFTER design creation
design_subset <- design %>%
  filter(province == "Hanoi")

# Calculate statistics
design_subset %>%
  summarize(mean_income = survey_mean(income))
```

### Complex Survey Design with survey and srvyr

#### Understanding Survey Design Components

**Primary Sampling Units (PSUs):** The first units sampled in the design (e.g.,
communes, villages)

**Strata:** Mutually exclusive groups used to reduce variance (e.g., urban/rural,
regions)

**Weights:** Adjustment factors for probability of selection and non-response

#### Creating Survey Design Objects

```r
# Using survey package
design_obj <- svydesign(
  id = ~psu,                    # Primary sampling unit
  strata = ~strata,             # Stratification variable
  weights = ~weight,            # Sampling weights
  nest = TRUE,                  # PSUs nested within strata
  survey.lonely.psu = "adjust", # Handle strata with single PSU
  data = survey_data
)

# Using srvyr for tidyverse syntax
design_srvyr <- survey_data %>%
  as_survey_design(
    ids = psu,
    strata = strata,
    weights = weight,
    nest = TRUE
  )
```

#### Handling Lonely PSUs

When a stratum contains only one PSU, variance cannot be estimated. Options:

- `"fail"` - Default, throws error
- `"adjust"` - Center at population mean (recommended)
- `"remove"` - Ignore PSU for variance computation
- `"average"` - Use average variance across strata

```r
# Set globally
options(survey.lonely.psu = "adjust")

# Or in svydesign call
design <- svydesign(..., survey.lonely.psu = "adjust")
```

### Efficient Data Manipulation

#### Using dplyr with Survey Data

```r
# Group by and summarize with survey weights
design_srvyr %>%
  group_by(province) %>%
  summarize(
    mean_income = survey_mean(income, na.rm = TRUE),
    median_income = survey_median(income, na.rm = TRUE),
    total_hh = survey_total()
  )
```

#### Variables Specification in summarize()

You can calculate:
- **Means:** `survey_mean()`
- **Totals:** `survey_total()`
- **Proportions:** `survey_prop()`
- **Quantiles:** `survey_quantile()`
- **Medians:** `survey_median()`

### Limitations to Note

The `srvyr` package does **not** fully incorporate modeling capabilities from
`survey`. For regression and hypothesis testing, use the `survey` package
directly (but you can still use the pipe operator):

```r
# Regression with survey package
model <- design_obj %>%
  svyglm(food_secure ~ income + education + household_size,
         design = .,
         family = quasibinomial())
```

### Resources

- **Primary Guide:** [Exploring Complex Survey Data Analysis Using R](https://tidy-survey-r.github.io/tidy-survey-book/)
  by Zimmer et al. (2025) - comprehensive, tidyverse-focused
- **Pew Research:** [Using tidyverse tools with survey data](https://www.pewresearch.org/decoded/2019/06/12/using-tidy-verse-tools-with-pew-research-center-survey-data-in-r/)
- **UCLA Statistical Consulting:** [Survey Data Analysis with R](https://stats.oarc.ucla.edu/r/seminars/survey-data-analysis-with-r/)

---

## 2. XLSForm/KoboToolbox Data Processing

### Understanding KoboToolbox Data Structure

#### Choice Names and Lists

- **Choice names must be unique** within a choice list
- Same choice name can be reused across different lists
- Example: `yes_no` and `yes_no_maybe` lists can both have `yes` and `no`

#### KoboToolbox Export Formats

KoboToolbox exports include:
- Main survey data
- Repeat groups (separate sheets/files)
- Attachments metadata
- Select_multiple expanded columns

### R Packages for KoboToolbox

#### robotoolbox Package (Recommended)

```r
library(robotoolbox)

# Authenticate to KoboToolbox
kobo_setup(url = "https://kf.kobotoolbox.org",
           token = "your_api_token")

# List available assets
assets <- kobo_asset_list()

# Download data
data <- kobo_data(asset_id = "your_asset_id")

# Handle repeat groups
repeat_data <- kobo_data(asset_id = "your_asset_id",
                         select_multiple_sep = "/")
```

**Key Features:**
- Direct API access to KoboToolbox
- Preserves labelled data using the `labelled` package
- Handles repeat groups efficiently
- Works with formr integration

#### koboloadeR Package (Workflow Automation)

The `koboloadeR` package is a **metapackage** that brings together specialized
packages in an organized workflow for data collected through KoboToolbox, ODK,
ONA, or any xlsform-compliant platform.

**Key Concept:** Implement analysis plan directly in the XLSForm Excel file by
adding configuration columns. This allows end users to generate reports without
coding in R.

```r
library(koboloadeR)

# Generate reports from XLSForm configuration
kobo_load_data("path/to/xlsform.xlsx")
kobo_generate_analysis()
```

### Processing select_multiple Questions

#### The Challenge

Select_multiple questions in ODK/KoboToolbox export as:
1. **Single concatenated column** (options separated by spaces/commas)
2. **Multiple binary columns** (one per option)

#### Approach 1: Using tidyr::separate_rows()

For concatenated format:

```r
# Data looks like: "option1 option2 option3"
data_expanded <- data %>%
  separate_rows(food_sources, sep = " ") %>%
  mutate(selected = 1)
```

#### Approach 2: Creating Binary/Dummy Variables

Using `fastDummies` package:

```r
library(fastDummies)

# Create binary columns for each option
data_dummies <- data %>%
  dummy_cols(
    select_columns = "food_sources",
    split = " ",                    # Separator in concatenated data
    remove_selected_columns = FALSE # Keep original
  )
```

Manual approach with `str_detect()`:

```r
# Create binary indicators
data <- data %>%
  mutate(
    source_market = if_else(str_detect(food_sources, "market"), 1, 0),
    source_garden = if_else(str_detect(food_sources, "garden"), 1, 0),
    source_forest = if_else(str_detect(food_sources, "forest"), 1, 0)
  )
```

#### Approach 3: Using model.matrix()

Faster for multiple categories:

```r
# Create all dummy variables at once
# -1 removes intercept column
dummy_matrix <- model.matrix(~ food_sources - 1, data = data)
data <- cbind(data, dummy_matrix)
```

### Handling Repeat Groups

Repeat groups create parent-child relationships:

```r
# Using robotoolbox with dm package (data models)
library(dm)

# Data comes as relational structure
main_data <- kobo_data(asset_id = "xxx")
repeat_data <- kobo_submissions(asset_id = "xxx",
                                 form = "repeat_group_name")

# Merge using left join
combined <- main_data %>%
  left_join(repeat_data, by = c("_uuid" = "_parent_uuid"))

# Or use dm for relational structure
survey_dm <- dm(
  main = main_data,
  repeats = repeat_data
) %>%
  dm_add_fk(repeats, _parent_uuid, main, _uuid)
```

### Best Practices for Multiple-Select Analysis

#### Calculate N-Sizes Correctly

For multiple-select questions, N should be the number of respondents **asked**
the question, not the number of responses given:

```r
# Correct approach for multiple-select
n_respondents <- data %>%
  filter(!is.na(food_sources)) %>%  # Asked the question
  nrow()

# Calculate percentages based on respondents, not responses
data %>%
  summarize(
    pct_market = sum(source_market == 1) / n_respondents * 100,
    pct_garden = sum(source_garden == 1) / n_respondents * 100
  )
```

### Skip Logic and Relevant Fields

KoboToolbox exports include structural NAs from skip logic. Use the XLSForm's
`relevant` column to identify which NAs are structural:

```r
# Document skip patterns
# If Q2 is only shown when Q1 == "yes"
# Then Q2 NAs when Q1 != "yes" are structural, not missing
```

### Resources

- **robotoolbox Documentation:** [robotoolbox package](https://dickoa.gitlab.io/robotoolbox/)
- **koboloadeR:** [UNHCR koboloadeR](https://unhcr.github.io/koboloadeR/docs/)
- **KoboToolbox XLSForm Guide:**
  [Getting started with XLSForm](https://support.kobotoolbox.org/getting_started_xlsform.html)
- **Community Forum:** [KoboToolbox Community](https://community.kobotoolbox.org/)
- **Handling select_all questions:**
  [R for the Rest of Us tutorial](https://rfortherestofus.com/2022/05/select-all/)

---

## 3. Missing Data Strategy

### Types of Missingness in Survey Data

#### 1. Structural Missingness (Missing by Design)

**Definition:** Data that is intentionally missing due to skip logic or logical
structure.

**Examples:**
- "Age of youngest child" for respondents without children
- "Heating behavior" questions for households without heating equipment
- Response-contingent questions properly skipped

**Handling:**
- **Do NOT impute** - this is not a flaw
- Filter data appropriately before analysis
- Document skip patterns in codebook
- Use `filter()` to exclude from specific analyses

```r
# Example: Analyze child nutrition only for households with children
data %>%
  filter(!is.na(youngest_child_age)) %>%  # Excludes structural NAs
  analyze_child_nutrition()
```

#### 2. Non-Response Missingness

**Definition:** Data that should exist but is missing due to respondent
refusal, don't know, or data collection error.

**Types:**
- Item non-response (specific questions skipped)
- Unit non-response (entire survey not completed)
- Partial response (survey started but not finished)

#### 3. User-Defined Missing Values

Track **why** items are missing using coded values:

```r
# Haven/SPSS style missing value codes
data <- data %>%
  mutate(
    income_clean = case_when(
      income == -77 ~ NA_real_,  # Refused
      income == -88 ~ NA_real_,  # Don't know
      income == -99 ~ NA_real_,  # Not applicable
      TRUE ~ income
    ),
    income_missing_reason = case_when(
      income == -77 ~ "refused",
      income == -88 ~ "dont_know",
      income == -99 ~ "not_applicable",
      is.na(income) ~ "no_response",
      TRUE ~ "valid"
    )
  )
```

Using `haven::labelled_spss()` for SPSS-style missing:

```r
library(haven)

# Define variable with user-defined missing values
income_labelled <- labelled_spss(
  x = income_raw,
  labels = c(
    "Refused" = -77,
    "Don't know" = -88,
    "Not applicable" = -99
  ),
  na_values = c(-77, -88, -99)  # Mark as missing
)
```

### Analyzing Missingness Patterns

#### Missingness Summary

```r
# Overall missingness
library(naniar)

data %>%
  miss_var_summary()  # Missingness by variable

data %>%
  miss_case_summary()  # Missingness by case

# Visualize patterns
vis_miss(data)

# By group
data %>%
  group_by(province) %>%
  miss_var_summary()
```

#### Distinguish Structural from Non-Response

```r
# Create flags for different types of missingness
data <- data %>%
  mutate(
    # Structural: skipped due to logic
    heating_structural_na = is.na(heating_behavior) & no_heating == 1,

    # True missing: should have answered but didn't
    heating_nonresponse = is.na(heating_behavior) & no_heating == 0
  )

# Report missingness by type
data %>%
  summarize(
    n_structural = sum(heating_structural_na),
    n_nonresponse = sum(heating_nonresponse),
    pct_nonresponse = mean(heating_nonresponse) * 100
  )
```

### When to Impute vs. Exclude

#### Do NOT Impute:
- Structural missingness (skip logic)
- Missing Not At Random (MNAR) when mechanism unknown
- High missingness (>40-50%) on key variables
- When missing pattern indicates data quality issues

#### Consider Imputation When:
- Missing Completely At Random (MCAR) or Missing At Random (MAR)
- Low to moderate missingness (<20%)
- Variable is important predictor in models
- Multiple variables with correlated missingness

### Modern Imputation Methods in R (2025)

#### Multiple Imputation by Chained Equations (MICE)

```r
library(mice)

# Impute missing values
imputed_data <- mice(
  data = survey_data,
  m = 5,                    # Number of imputations
  method = "pmm",           # Predictive mean matching
  maxit = 50,               # Iterations
  seed = 123
)

# Analyze each imputed dataset
models <- with(imputed_data,
               lm(food_security ~ income + education))

# Pool results
pooled_results <- pool(models)
summary(pooled_results)
```

#### Random Forest Imputation (missForest)

```r
library(missForest)

# Impute using random forest
imputed <- missForest(
  xmis = survey_data,
  maxiter = 10,
  ntree = 100
)

# Get imputed data
data_complete <- imputed$ximp

# Check imputation error
imputed$OOBerror  # Out-of-bag error
```

### Survey-Specific Considerations

#### Weights and Missingness

When using survey weights, missing data can affect:
1. **Weight adjustment** - may need to re-weight
2. **Variance estimation** - affects standard errors
3. **Bias** - if missingness related to outcome

```r
# Calculate missingness rates by strata
design %>%
  group_by(strata) %>%
  summarize(
    missing_rate = survey_mean(is.na(income)),
    n_missing = survey_total(is.na(income))
  )
```

### Documentation Requirements

Always document:
1. **Missingness rates** for all variables
2. **Patterns** of missingness (correlations)
3. **Reasons** for missingness (when coded)
4. **Decisions** made (impute vs. exclude)
5. **Methods** used for imputation
6. **Sensitivity analyses** comparing complete-case vs. imputed

```r
# Create missingness summary table
missing_summary <- data %>%
  summarize(across(
    everything(),
    list(
      n_missing = ~sum(is.na(.)),
      pct_missing = ~mean(is.na(.)) * 100,
      n_structural = ~sum(structural_na_flag),
      n_nonresponse = ~sum(is.na(.) & !structural_na_flag)
    )
  ))
```

### Resources

- **Survey Missing Data:**
  [Exploring Complex Survey Data - Missing Data Chapter](https://tidy-survey-r.github.io/tidy-survey-book/c11-missing-data.html)
- **Structured Missingness:**
  [The Turing Way](https://book.the-turing-way.org/project-design/missing-data/missing-data-structured-missingness/)
- **2025 Imputation Guide:**
  [Missing Data in R - Complete Guide](https://dev.to/dipti_m_2e7ba36c478d1a48a/missing-data-in-r-complete-2025-guide-to-imputation-techniques-53g8)
- **Princeton Guide:**
  [Missing Data Tutorial](https://libguides.princeton.edu/R-Missingdata)

---

## 4. Food Security & Dietary Diversity Indicators

### Household Dietary Diversity Score (HDDS)

#### Overview

**Purpose:** Qualitative measure of food consumption reflecting household
economic ability to access diverse foods

**Recall Period:** 24 hours

**Food Groups:** 12 groups (compared to 7-9 for Individual Dietary Diversity
Score)

**Use:** Proxy for household food access, not nutritional quality of individual
diet

#### Calculation Method

```r
# HDDS food groups (12 total):
# 1. Cereals
# 2. Root and tubers
# 3. Vegetables
# 4. Fruits
# 5. Meat, poultry, offal
# 6. Eggs
# 7. Fish and seafood
# 8. Pulses/legumes/nuts
# 9. Milk and milk products
# 10. Oil/fats
# 11. Sugar/honey
# 12. Miscellaneous

# Calculate HDDS
data <- data %>%
  mutate(
    hdds_score = rowSums(select(., cereals:miscellaneous), na.rm = TRUE),

    # Categorize food security
    food_security_hdds = case_when(
      hdds_score <= 3 ~ "Severely food insecure",
      hdds_score <= 5 ~ "Moderately food insecure",
      hdds_score >= 6 ~ "Food secure / Mildly food insecure"
    )
  )

# Summary statistics
mean_hdds <- data %>%
  summarize(
    mean_hdds = mean(hdds_score, na.rm = TRUE),
    sd_hdds = sd(hdds_score, na.rm = TRUE),
    median_hdds = median(hdds_score, na.rm = TRUE)
  )
```

#### Important Considerations

- **Timing matters:** Collect baseline and endline at same time of year for
  comparability
- **Avoid fasting periods:** Don't collect during Ramadan, pre-Easter, etc.
- **24-hour recall:** May not capture usual consumption patterns

### Food Insecurity Experience Scale (FIES)

#### Overview

**Developer:** FAO, collected through Gallup World Poll

**Questions:** 8 items capturing severity of food insecurity

**Recall Period:** 1 month or 12 months (specify based on research priorities)

**Response Format:** Yes/No for each question

**Related Scales:** Part of family including HFIAS, HHS, ELCSA

#### Statistical Methodology

FIES uses **Item Response Theory (IRT)** - specifically the **Rasch model** -
for scale construction and validation.

**R Implementation:**

```r
# FAO provides R statistical module using RM.weights package
library(RM.weights)

# FIES questions (yes/no coding: 1 = yes, 0 = no)
fies_items <- c(
  "fies_worried",      # Worried about food
  "fies_healthy",      # Unable to eat healthy
  "fies_fewfoods",     # Ate only few kinds of foods
  "fies_skipped",      # Had to skip a meal
  "fies_ateless",      # Ate less than should
  "fies_ranout",       # Ran out of food
  "fies_hungry",       # Were hungry but didn't eat
  "fies_wholeday"      # Went whole day without eating
)

# Calculate raw score (0-8)
data <- data %>%
  mutate(
    fies_raw_score = rowSums(select(., all_of(fies_items)), na.rm = TRUE)
  )

# Rasch model analysis for validation
# (Requires FAO's statistical module - check VoH website)
```

#### Validation Checks

Statistical validation tests for:
- Items that don't perform well
- Cases with erratic response patterns
- Redundant item pairs
- Proportion of variance explained by model

### Household Food Insecurity Access Scale (HFIAS)

#### Overview

**Developer:** USAID FANTA (2001-2006)

**Questions:** 9 questions with frequency (0-3 scale)

**Scoring:** Sum of frequencies, range 0-27

**Foundation for:** Household Hunger Scale (HHS)

#### Calculation

```r
# HFIAS frequency coding:
# 0 = Never (did not occur)
# 1 = Rarely (1-2 times in past 4 weeks)
# 2 = Sometimes (3-10 times)
# 3 = Often (>10 times)

hfias_items <- c(
  "hfias_q1",  # Worry about food
  "hfias_q2",  # Unable to eat preferred foods
  "hfias_q3",  # Eat limited variety
  "hfias_q4",  # Eat unwanted foods
  "hfias_q5",  # Eat smaller meals
  "hfias_q6",  # Eat fewer meals
  "hfias_q7",  # No food in house
  "hfias_q8",  # Go to bed hungry
  "hfias_q9"   # Go whole day without eating
)

# Calculate HFIAS score
data <- data %>%
  mutate(
    hfias_score = rowSums(select(., all_of(hfias_items)), na.rm = TRUE),

    # Categorize (requires additional algorithm - see FANTA guide)
    hfias_category = case_when(
      # Food Secure: specific pattern of responses
      # Mildly Food Insecure Access: ...
      # Moderately Food Insecure Access: ...
      # Severely Food Insecure Access: ...
    )
  )
```

### Food Consumption Score (FCS)

#### Overview

**Developer:** WFP (World Food Programme)

**Recall Period:** 7 days

**Method:** Frequency-weighted dietary diversity

#### Standard Calculation

```r
# Food groups with weights
# Starches: 2
# Pulses: 3
# Vegetables: 1
# Fruits: 1
# Meat/Fish: 4
# Milk: 4
# Sugar: 0.5
# Oil: 0.5

data <- data %>%
  mutate(
    fcs_score =
      (starches_days * 2) +
      (pulses_days * 3) +
      (vegetables_days * 1) +
      (fruits_days * 1) +
      (meat_fish_days * 4) +
      (milk_days * 4) +
      (sugar_days * 0.5) +
      (oil_days * 0.5),

    # Standard cutoffs
    fcs_category = case_when(
      fcs_score <= 21 ~ "Poor",
      fcs_score <= 35 ~ "Borderline",
      fcs_score > 35 ~ "Acceptable"
    ),

    # Adjusted cutoffs for sugar/oil-rich diets
    # (if sugar AND oil consumed daily, add 7 to thresholds)
    sugar_oil_daily = (sugar_days == 7 & oil_days == 7),

    fcs_category_adj = case_when(
      !sugar_oil_daily ~ fcs_category,
      sugar_oil_daily & fcs_score <= 28 ~ "Poor",
      sugar_oil_daily & fcs_score <= 42 ~ "Borderline",
      sugar_oil_daily & fcs_score > 42 ~ "Acceptable"
    )
  )
```

### Reduced Coping Strategies Index (rCSI)

#### Overview

**Questions:** 5 questions about food consumption coping strategies

**Recall Period:** Past 7 days

**Method:** Frequency-weighted sum of strategies

#### Calculation

```r
# Standard rCSI questions with severity weights:
# 1. Rely on less preferred foods (weight: 1)
# 2. Borrow food or rely on help (weight: 2)
# 3. Limit portion size (weight: 1)
# 4. Restrict adult consumption for children (weight: 3)
# 5. Reduce number of meals (weight: 1)

data <- data %>%
  mutate(
    rcsi_score =
      (less_preferred_days * 1) +
      (borrow_food_days * 2) +
      (limit_portion_days * 1) +
      (restrict_adult_days * 3) +
      (reduce_meals_days * 1),

    # IPC Phase classification
    rcsi_category = case_when(
      rcsi_score <= 3 ~ "IPC Phase 1 (Minimal)",
      rcsi_score <= 18 ~ "IPC Phase 2 (Stressed)",
      rcsi_score >= 19 ~ "IPC Phase 3+ (Crisis or worse)"
    )
  )
```

### Correlations Between Indicators

Research shows:
- **High correlations:** CSI, rCSI, and HFIAS (all measure coping/experience)
- **Moderate correlations:** FCS with HFIAS/CSI (FCS measures dietary diversity)
- **Use complementary indicators** for comprehensive assessment

```r
# Correlation analysis
library(corrplot)

indicators <- data %>%
  select(hdds_score, fies_raw_score, hfias_score,
         fcs_score, rcsi_score)

cor_matrix <- cor(indicators, use = "pairwise.complete.obs")
corrplot(cor_matrix, method = "number")
```

### Resources

- **HDDS:** [FAO Guidelines for Measuring Household and Individual Dietary
  Diversity](https://www.fao.org/4/i1983e/i1983e00.pdf)
- **HDDS Calculator:** [INDDEX Project](https://inddex.nutrition.tufts.edu/data4diets/indicator/household-dietary-diversity-score-hdds)
- **FIES:** [FAO FIES About Page](https://www.fao.org/measuring-hunger/access-to-food/about-the-food-insecurity-experience-scale-(fies)/en)
- **HFIAS:** [FANTA HFIAS Guide](https://www.fantaproject.org/monitoring-and-evaluation/household-dietary-diversity-score)
- **FCS:** [FSCluster Handbook](https://fscluster.org/handbook/)
- **Validation Research:** Maxwell et al. comparison studies

---

## 5. Income & Expenditure Analysis

### Vietnam-Specific Context

#### Primary Data Source

**Vietnam Household Living Standards Survey (VHLSS):**
- Expenditure collected every 2 years
- Income collected annually
- Main source for poverty monitoring

#### Poverty Measurement Approaches

Vietnam uses **two main approaches:**

1. **Income-based** (Government of Vietnam)
   - Multi-dimensional approach
   - 10 non-monetary dimensions + 1 monetary (income)
   - Separate thresholds for urban/rural

2. **Expenditure-based** (World Bank)
   - Based on household expenditure per capita
   - International poverty lines (PPP-adjusted)

#### Poverty Lines

**Historical trend:**
- 2010: 12.3 million poor
- 2020: 5 million poor
- Based on $3.65/day (2017 PPP) lower-middle income country line

### Data Cleaning Best Practices

#### Initial Exploration

```r
# Summary statistics
summary(data$income)
summary(data$expenditure)

# Visualize distributions
library(ggplot2)

# Histogram
ggplot(data, aes(x = income)) +
  geom_histogram(bins = 50) +
  scale_x_continuous(labels = scales::comma) +
  labs(title = "Income Distribution")

# Box plot to identify outliers
ggplot(data, aes(y = income)) +
  geom_boxplot() +
  scale_y_continuous(labels = scales::comma)

# Scatter plot: expenditure vs income
ggplot(data, aes(x = income, y = expenditure)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = TRUE, color = "red") +
  scale_x_continuous(labels = scales::comma) +
  scale_y_continuous(labels = scales::comma)
```

#### Identifying Outliers

```r
# Statistical outlier detection
library(outliers)

# Z-score method (>3 or <-3 standard deviations)
data <- data %>%
  mutate(
    income_z = (income - mean(income, na.rm = TRUE)) / sd(income, na.rm = TRUE),
    income_outlier_z = abs(income_z) > 3
  )

# IQR method (1.5 * IQR rule)
income_q1 <- quantile(data$income, 0.25, na.rm = TRUE)
income_q3 <- quantile(data$income, 0.75, na.rm = TRUE)
income_iqr <- income_q3 - income_q1

data <- data %>%
  mutate(
    income_outlier_iqr = income < (income_q1 - 1.5 * income_iqr) |
                         income > (income_q3 + 1.5 * income_iqr)
  )

# Flag extreme values for review
data %>%
  filter(income_outlier_iqr) %>%
  select(household_id, income, province, household_size) %>%
  arrange(desc(income))
```

### Outlier Handling Strategies

#### 1. Winsorizing (Recommended for Income/Expenditure)

Replace extreme values at specified percentiles:

```r
library(DescTools)

# Winsorize at 1st and 99th percentiles
data <- data %>%
  mutate(
    income_winsor = Winsorize(income,
                              probs = c(0.01, 0.99),
                              na.rm = TRUE),

    expenditure_winsor = Winsorize(expenditure,
                                   probs = c(0.01, 0.99),
                                   na.rm = TRUE)
  )

# Alternative: manual winsorization
p01 <- quantile(data$income, 0.01, na.rm = TRUE)
p99 <- quantile(data$income, 0.99, na.rm = TRUE)

data <- data %>%
  mutate(
    income_winsor = case_when(
      income < p01 ~ p01,
      income > p99 ~ p99,
      TRUE ~ income
    )
  )
```

#### 2. Log Transformation

For right-skewed distributions:

```r
# Log transformation (add 1 to handle zeros)
data <- data %>%
  mutate(
    log_income = log(income + 1),
    log_expenditure = log(expenditure + 1)
  )

# Visualize transformed data
ggplot(data, aes(x = log_income)) +
  geom_histogram(bins = 50) +
  labs(title = "Log-Transformed Income Distribution")
```

#### 3. Per Capita and Equivalence Scales

```r
# Simple per capita
data <- data %>%
  mutate(
    income_pc = income / household_size,
    expenditure_pc = expenditure / household_size
  )

# OECD equivalence scale
# First adult: 1.0
# Additional adults: 0.7
# Children (<14): 0.5
data <- data %>%
  mutate(
    equivalence_scale = 1 +
      (adults - 1) * 0.7 +
      children * 0.5,

    income_equiv = income / equivalence_scale,
    expenditure_equiv = expenditure / equivalence_scale
  )
```

### Poverty Analysis

#### Poverty Lines

```r
# Define poverty lines (example values - use official Vietnam lines)
poverty_line_rural <- 1000000  # VND per month per capita
poverty_line_urban <- 1300000  # VND per month per capita

# International poverty line (convert from USD PPP)
intl_poverty_line <- 3.65 * exchange_rate * ppp_conversion

# Calculate poverty status
data <- data %>%
  mutate(
    poverty_line = if_else(urban == 1,
                          poverty_line_urban,
                          poverty_line_rural),

    poor = expenditure_pc < poverty_line,

    # Poverty gap (depth of poverty)
    poverty_gap = pmax(0, poverty_line - expenditure_pc),
    poverty_gap_ratio = poverty_gap / poverty_line,

    # Squared poverty gap (severity)
    poverty_gap_squared = (poverty_gap_ratio)^2
  )

# Aggregate poverty measures
poverty_stats <- data %>%
  summarize(
    # Headcount ratio (FGT0)
    poverty_rate = mean(poor, na.rm = TRUE) * 100,

    # Poverty gap index (FGT1)
    poverty_gap_index = mean(poverty_gap_ratio, na.rm = TRUE) * 100,

    # Poverty severity index (FGT2)
    poverty_severity = mean(poverty_gap_squared, na.rm = TRUE) * 100,

    n_poor = sum(poor, na.rm = TRUE),
    n_total = n()
  )
```

### Food Expenditure Share

Important indicator for food security:

```r
# Calculate food expenditure share
data <- data %>%
  mutate(
    food_exp_share = (food_expenditure / total_expenditure) * 100,

    # Engel's Law: higher share indicates lower welfare
    food_poor = food_exp_share > 60  # Example threshold
  )

# Summary by group
data %>%
  group_by(province) %>%
  summarize(
    mean_food_share = mean(food_exp_share, na.rm = TRUE),
    median_food_share = median(food_exp_share, na.rm = TRUE),
    sd_food_share = sd(food_exp_share, na.rm = TRUE)
  )
```

### Aggregating Expenditure Categories

```r
# Sum expenditure components
data <- data %>%
  mutate(
    # Food categories
    total_food_exp = rowSums(select(.,
                                    food_cereals,
                                    food_meat,
                                    food_fish,
                                    food_dairy,
                                    food_vegetables,
                                    food_fruits,
                                    food_other),
                            na.rm = TRUE),

    # Non-food categories
    total_nonfood_exp = rowSums(select(.,
                                       housing,
                                       utilities,
                                       transport,
                                       education,
                                       health,
                                       clothing),
                               na.rm = TRUE),

    # Check against reported total
    calculated_total = total_food_exp + total_nonfood_exp,

    # Flag discrepancies
    exp_mismatch = abs(calculated_total - total_expenditure) > 100
  )

# Investigate mismatches
data %>%
  filter(exp_mismatch) %>%
  select(household_id, total_expenditure, calculated_total)
```

### Inequality Measures

```r
library(ineq)

# Gini coefficient
gini_income <- Gini(data$income, na.rm = TRUE)
gini_expenditure <- Gini(data$expenditure, na.rm = TRUE)

# By group
data %>%
  group_by(province) %>%
  summarize(
    gini = Gini(income, na.rm = TRUE),
    mean_income = mean(income, na.rm = TRUE),
    median_income = median(income, na.rm = TRUE)
  )

# Quintile analysis
data <- data %>%
  mutate(
    income_quintile = cut(income,
                         breaks = quantile(income,
                                          probs = seq(0, 1, 0.2),
                                          na.rm = TRUE),
                         labels = c("Q1", "Q2", "Q3", "Q4", "Q5"),
                         include.lowest = TRUE)
  )
```

### Resources

- **World Bank Vietnam Poverty:**
  [Demystifying poverty measurement in Vietnam](https://documents.worldbank.org/curated/en/923881468303855779/Demystifying-poverty-measurement-in-Vietnam)
- **World Bank Handbook:** [Handbook on Poverty and Inequality](https://documents1.worldbank.org/curated/en/488081468157174849/pdf/483380PUB0Pove101OFFICIAL0USE0ONLY1.pdf)
- **Vietnam Poverty Data:** [CEIC Vietnam Poverty Statistics](https://www.ceicdata.com/en/vietnam/poverty)

---

## 6. Likert Scale Analysis

### Scale Design Best Practices

#### Balanced Scale Design

Provide equal options for positive and negative responses:

```r
# 5-point Likert example
# 1 = Strongly Disagree
# 2 = Disagree
# 3 = Neutral
# 4 = Agree
# 5 = Strongly Agree

# Avoid unbalanced scales (e.g., 4 positive, 2 negative options)
```

#### Clear Anchors

Define what each point represents:

```r
# Label in your data dictionary
likert_labels <- c(
  "1" = "Strongly Disagree",
  "2" = "Disagree",
  "3" = "Neither Agree nor Disagree",
  "4" = "Agree",
  "5" = "Strongly Agree"
)
```

### Coding and Recoding

#### Reverse Coding

Some items need to be reversed to ensure consistent direction:

```r
# Reverse code items (for 5-point scale)
data <- data %>%
  mutate(
    # Original: higher = more agreement
    # Reversed: higher = less agreement (for negatively-worded items)
    item_3_rev = 6 - item_3,  # For 5-point: 6 - x
    item_5_rev = 6 - item_5,
    item_7_rev = 6 - item_7
  )

# Function for flexibility
reverse_code <- function(x, max_value) {
  (max_value + 1) - x
}

data <- data %>%
  mutate(across(
    c(item_3, item_5, item_7),
    ~reverse_code(., max_value = 5),
    .names = "{.col}_rev"
  ))
```

### Scale Construction

#### Sum vs. Average

```r
# Sum method
data <- data %>%
  mutate(
    food_security_perception_sum = rowSums(select(.,
                                                  fsp_1:fsp_8),
                                          na.rm = FALSE)
  )

# Average method (preferred for scales with missing items)
data <- data %>%
  mutate(
    food_security_perception_mean = rowMeans(select(.,
                                                    fsp_1:fsp_8),
                                            na.rm = TRUE)
  )

# Require minimum number of items
data <- data %>%
  rowwise() %>%
  mutate(
    n_items_answered = sum(!is.na(c_across(fsp_1:fsp_8))),

    # Only calculate if at least 6 of 8 items answered
    fsp_mean = if_else(
      n_items_answered >= 6,
      mean(c_across(fsp_1:fsp_8), na.rm = TRUE),
      NA_real_
    )
  ) %>%
  ungroup()
```

### Reliability Analysis - Cronbach's Alpha

#### Purpose

Assess **internal consistency** - do items measure the same construct?

**Acceptable values:**
- α ≥ 0.70: Acceptable
- α ≥ 0.80: Good (target for most research)
- α ≥ 0.90: Excellent
- α < 0.70: Questionable - consider removing items

#### Calculation in R

```r
library(psych)

# Select scale items (include reversed items)
scale_items <- data %>%
  select(fsp_1, fsp_2, fsp_3_rev, fsp_4,
         fsp_5_rev, fsp_6, fsp_7_rev, fsp_8)

# Calculate Cronbach's alpha
alpha_result <- alpha(scale_items)

# View results
print(alpha_result)

# Extract key statistics
alpha_result$total$raw_alpha        # Overall alpha
alpha_result$alpha.drop             # Alpha if item dropped
alpha_result$item.stats             # Item-total correlations
```

#### Interpreting Output

```r
# "Reliability if an item is dropped" table shows:
# - raw_alpha: What alpha would be if you removed this item
# - If alpha increases substantially, consider removing that item

# Item-total correlation (r.drop):
# - Should be > 0.30
# - Low correlations suggest item doesn't fit the scale
```

#### Improving Reliability

```r
# Identify problematic items
problematic <- alpha_result$alpha.drop %>%
  filter(raw_alpha > alpha_result$total$raw_alpha + 0.05)

# Remove item and recalculate
scale_items_revised <- scale_items %>%
  select(-problematic_item_name)

alpha_revised <- alpha(scale_items_revised)

# Compare
cat("Original alpha:", alpha_result$total$raw_alpha, "\n")
cat("Revised alpha:", alpha_revised$total$raw_alpha, "\n")
```

### Sample Size for Cronbach's Alpha

**Minimum recommendations:**
- Small sample (<30): Unreliable estimates
- Target: n ≥ 100 for stable estimates
- Desired alpha = 0.70: Can achieve with n < 30
- Desired alpha ≥ 0.80: Requires larger samples

### Visualization Best Practices

#### Stacked Bar Charts

```r
library(likert)

# Prepare data for likert package
likert_data <- data %>%
  select(fsp_1:fsp_8) %>%
  mutate(across(everything(),
                ~factor(., levels = 1:5,
                       labels = c("Strongly Disagree", "Disagree",
                                 "Neutral", "Agree", "Strongly Agree"))))

# Create likert object
likert_obj <- likert(as.data.frame(likert_data))

# Plot
plot(likert_obj,
     type = "bar",
     centered = TRUE,  # Diverging bar chart
     plot.percent.low = FALSE,
     plot.percent.high = FALSE)
```

#### Using ggplot2

```r
# Calculate percentages
likert_summary <- data %>%
  select(fsp_1:fsp_8) %>%
  pivot_longer(everything(),
               names_to = "item",
               values_to = "response") %>%
  count(item, response) %>%
  group_by(item) %>%
  mutate(percentage = n / sum(n) * 100)

# Diverging stacked bar chart
ggplot(likert_summary,
       aes(x = item, y = percentage, fill = factor(response))) +
  geom_bar(stat = "identity", position = "stack") +
  coord_flip() +
  scale_fill_brewer(palette = "RdBu",
                    labels = c("Strongly Disagree", "Disagree",
                              "Neutral", "Agree", "Strongly Agree")) +
  labs(title = "Food Security Perception Scale Responses",
       x = "Item",
       y = "Percentage",
       fill = "Response") +
  theme_minimal()
```

### Reporting Likert Data

#### Descriptive Statistics

```r
# Item-level summaries
item_summary <- data %>%
  select(fsp_1:fsp_8) %>%
  pivot_longer(everything(),
               names_to = "item",
               values_to = "response") %>%
  group_by(item) %>%
  summarize(
    n = sum(!is.na(response)),
    mean = mean(response, na.rm = TRUE),
    sd = sd(response, na.rm = TRUE),
    median = median(response, na.rm = TRUE),
    mode = as.numeric(names(sort(table(response),
                                 decreasing = TRUE)[1]))
  )

# Scale-level summary
scale_summary <- data %>%
  summarize(
    n = sum(!is.na(fsp_mean)),
    mean = mean(fsp_mean, na.rm = TRUE),
    sd = sd(fsp_mean, na.rm = TRUE),
    median = median(fsp_mean, na.rm = TRUE),
    min = min(fsp_mean, na.rm = TRUE),
    max = max(fsp_mean, na.rm = TRUE),
    cronbach_alpha = alpha_result$total$raw_alpha
  )
```

### Resources

- **Cronbach's Alpha Guide:**
  [7 Steps to Master Survey Reliability](https://www.numberanalytics.com/blog/cronbachs-alpha-explained-7-survey-steps)
- **R Implementation:**
  [Cronbach's Alpha in R for HR](https://rforhr.com/cronbachsalpha.html)
- **Sample Size:**
  [Review on Sample Size Determination](https://pmc.ncbi.nlm.nih.gov/articles/PMC6422571/)
- **Interpretation:**
  [Statistics by Jim - Cronbach's Alpha](https://statisticsbyjim.com/basics/cronbachs-alpha/)

---

## 7. Documentation Standards

### The Importance of Codebooks

**Codebooks** (data dictionaries) are essential for:
- Understanding variable meanings
- Proper interpretation by external researchers
- Reproducibility
- Long-term data preservation
- Facilitating meta-analysis

**Key principle:** A codebook should make data **self-explanatory** to someone
outside your research group.

### What to Include in a Codebook

#### Essential Elements

1. **Variable name:** Unique identifier (e.g., Q1, income_total, hdds_score)
2. **Variable label:** Human-readable description
3. **Variable type:** Numeric, character, factor, date
4. **Value labels:** Meanings of coded values
5. **Missing data codes:** Why data is missing
6. **Units:** For numeric variables (VND, kg, days, etc.)
7. **Valid range:** Minimum and maximum acceptable values
8. **Skip patterns:** When variables should be NA
9. **Source question:** Original survey question text
10. **Notes:** Special considerations or data quality issues

### R Packages for Codebook Creation

#### 1. codebook Package (Recommended)

**Features:**
- Automatic generation from data frames
- Integrates with RMarkdown
- HTML, PDF, Word output
- JSON-LD for search engine indexing
- Reliability analysis for scales
- Works with labelled data

```r
library(codebook)

# Add metadata to variables
data <- data %>%
  mutate(
    income_total = income_total %>%
      labelled::set_variable_labels(
        "Total household income in past month (VND)"
      ) %>%
      labelled::add_value_labels(
        .list = c("Refused" = -77, "Don't know" = -88)
      ),

    province = province %>%
      labelled::set_variable_labels("Province of residence") %>%
      labelled::add_value_labels(
        "Hanoi" = 1,
        "Ho Chi Minh City" = 2,
        "Da Nang" = 3
      )
  )

# Generate codebook
codebook_data <- codebook(data)

# Or create RMarkdown report
codebook::codebook_table(data)
```

**Generate HTML codebook:**

```r
# Create RMarkdown file
library(rmarkdown)

# Knit to HTML
rmarkdown::render(
  input = "codebook.Rmd",
  output_format = "html_document",
  output_file = "survey_codebook.html"
)
```

#### 2. codebookr Package

**Features:**
- Creates Word documents
- Uses flextable and officer packages
- Table-based layout

```r
library(codebookr)

# Create basic codebook
cb <- codebook(
  df = data,
  title = "Vietnam Food Security Survey Codebook",
  subtitle = "Household Survey 2024",
  description = "This codebook documents variables from..."
)

# Add custom attributes
cb_detailed <- cb %>%
  cb_add_col_attributes(
    name = c("income_total", "hdds_score"),
    description = c(
      "Total household income from all sources in past month",
      "Household Dietary Diversity Score (0-12 food groups)"
    ),
    source = c(
      "Question H1: What was your total household income...",
      "Calculated from 24-hour dietary recall (Questions D1-D12)"
    )
  )

# Export to Word
print(cb_detailed, "survey_codebook.docx")
```

### Survey Data Documentation Best Practices

#### Variable Naming Conventions

```r
# Good practices:
# - Use question numbers: Q1, Q2a, Q2b
# - Or descriptive names: income_total, hdds_score
# - Be consistent throughout dataset
# - Use lowercase with underscores
# - Avoid spaces and special characters

# Poor practices to avoid:
# - VAR001, VAR002 (not meaningful)
# - IncomeTotal (mixed case)
# - income-total (hyphens can cause issues)
# - income total (spaces)
```

#### Missing Data Documentation

```r
# Create missing data summary
missing_report <- data %>%
  summarize(across(
    everything(),
    list(
      n_missing = ~sum(is.na(.)),
      pct_missing = ~mean(is.na(.)) * 100,
      missing_reason = ~{
        reasons <- case_when(
          is.na(.) & skip_logic_applies ~ "Skip logic",
          is.na(.) & . == -77 ~ "Refused",
          is.na(.) & . == -88 ~ "Don't know",
          is.na(.) ~ "No response",
          TRUE ~ "Valid response"
        )
        paste(unique(reasons), collapse = "; ")
      }
    )
  )) %>%
  pivot_longer(everything(),
               names_to = c("variable", ".value"),
               names_pattern = "(.+)_(.+)")

# Export missing data report
write_csv(missing_report, "missing_data_summary.csv")
```

### Survey Appendix Table Formats

#### Table A1: Survey Design Summary

```r
library(gt)

survey_design_table <- tibble(
  Component = c("Sample frame", "Sampling method", "Sample size",
                "Response rate", "Survey period", "Survey mode"),
  Description = c(
    "Households in 3 provinces (Hanoi, Da Nang, HCMC)",
    "Stratified random sampling by province and urban/rural",
    "1,200 households (400 per province)",
    "87.5% (1,050 completed surveys)",
    "March - May 2024",
    "Face-to-face interviews with household head"
  )
) %>%
  gt() %>%
  tab_header(
    title = "Table A1. Survey Design Characteristics",
    subtitle = "Vietnam Food Security Household Survey 2024"
  ) %>%
  cols_width(
    Component ~ px(200),
    Description ~ px(400)
  )

# Save
gtsave(survey_design_table, "table_a1_survey_design.html")
```

#### Table A2: Variable Definitions

```r
variable_definitions <- tibble(
  Variable = c("hdds_score", "fies_raw", "income_pc", "poverty_status"),
  Definition = c(
    "Household Dietary Diversity Score: count of 12 food groups consumed in past 24 hours",
    "Food Insecurity Experience Scale: sum of 8 yes/no items (range 0-8)",
    "Per capita household income: total income divided by household size (VND/month)",
    "Poverty status: 1 if expenditure per capita below poverty line, 0 otherwise"
  ),
  `Valid Range` = c("0-12", "0-8", "0-50,000,000", "0-1"),
  Source = c(
    "FAO HDDS guidelines",
    "FAO FIES module",
    "Calculated from Q.H1 and Q.H2",
    "Vietnam poverty line 2024"
  )
) %>%
  gt() %>%
  tab_header(title = "Table A2. Variable Definitions") %>%
  tab_footnote(
    footnote = "VND = Vietnamese Dong",
    locations = cells_body(columns = `Valid Range`, rows = 3)
  )
```

### Importing Existing Data Dictionaries

If you have a spreadsheet codebook:

```r
# Read existing data dictionary
data_dict <- read_excel("data_dictionary.xlsx")

# Apply labels to data
library(labelled)

for(i in 1:nrow(data_dict)) {
  var_name <- data_dict$variable[i]
  var_label <- data_dict$label[i]

  if(var_name %in% names(data)) {
    var_label(data[[var_name]]) <- var_label
  }
}

# Add value labels
value_labels <- read_excel("value_labels.xlsx")

for(i in 1:nrow(value_labels)) {
  var_name <- value_labels$variable[i]

  if(var_name %in% names(data)) {
    labels_list <- setNames(
      value_labels$value[value_labels$variable == var_name],
      value_labels$label[value_labels$variable == var_name]
    )

    val_labels(data[[var_name]]) <- labels_list
  }
}
```

### Questionnaire Documentation

Include in appendix:
1. **Full questionnaire text**
2. **Skip logic flow diagrams**
3. **Enumerator instructions**
4. **Translations** (if multilingual)
5. **Pre-test results and revisions**

### Resources

- **codebook Package:**
  [How to Automatically Document Data](https://journals.sagepub.com/doi/full/10.1177/2515245919838783)
- **codebook Tutorial:**
  [CRAN Vignette](https://cran.r-project.org/web/packages/codebook/vignettes/codebook_tutorial.html)
- **codebookr Package:** [codebookr Documentation](https://brad-cannell.github.io/codebookr/)
- **Survey Documentation:**
  [Exploring Complex Survey Data - Documentation Chapter](https://tidy-survey-r.github.io/tidy-survey-book/c03-survey-data-documentation.html)
- **Penn Libraries Guide:**
  [Codebooks & Data Dictionaries](https://guides.library.upenn.edu/c.php?g=564157&p=9554907)

---

## 8. Geospatial Analysis

### Vietnam Administrative Boundaries

#### Data Sources

**1. Open Development Mekong Datahub**
- Polylines of administrative boundaries
- Published by Department of Survey and Mapping
- Multiple administrative levels

**2. Humanitarian Data Exchange (HDX)**
- OCHA Common Operational Datasets
- Vietnamese labels
- Multiple formats: ESRI, WMS, KML

**3. IGISMAP**
- Shapefile format
- **CRS: EPSG:4326 (WGS84)** - Standard GPS coordinates
- Free download for Vietnam boundaries

**4. GIST Data Repository (UN-SPIDER)**
- Level 2 boundaries
- Coordinate System: GCS_WGS_1984
- ESRI Shapefile format

**5. LeadDog Consulting (Commercial)**
- Four administrative levels:
  - Level 1: Country
  - Level 2: Province/City (5 cities + 58 provinces)
  - Level 3: District/Town (548 districts + 137 towns)
  - Level 4: Commune/Ward (9,103 communes + 1,897 wards)

#### Administrative Levels URLs

- **Open Development Mekong:**
  https://data.opendevelopmentmekong.net/dataset/a-gii-hnh-chnh-vit-nam
- **HDX Vietnam Boundaries:**
  https://data.humdata.org/dataset/cod-ab-vnm
- **IGISMAP Vietnam Shapefiles:**
  https://www.igismap.com/vietnam-shapefile-download-country-boundaryline-polygon/

### Coordinate Reference Systems (CRS) for Vietnam

#### Common CRS Options

**WGS84 (EPSG:4326)** - Most common for GPS data
- Geographic coordinate system
- Latitude/Longitude in decimal degrees
- Used by most data sources
- **Use for:** Initial data loading, GPS points

**VN-2000 (EPSG:9205-9218)** - Vietnam National Grid
- Projected coordinate system
- Multiple zones for different regions
- Meters as units
- **Use for:** Accurate area/distance calculations in Vietnam

**UTM Zones for Vietnam:**
- UTM Zone 48N (EPSG:32648) - Western Vietnam
- UTM Zone 49N (EPSG:32649) - Eastern Vietnam
- **Use for:** Regional analysis, distance calculations

```r
library(sf)

# Check current CRS
st_crs(vietnam_boundaries)

# Transform to different CRS
# To UTM Zone 48N for distance calculations
vietnam_utm <- st_transform(vietnam_boundaries, crs = 32648)

# Back to WGS84 for mapping
vietnam_wgs84 <- st_transform(vietnam_utm, crs = 4326)
```

### sf Package Best Practices

#### Loading Spatial Data

```r
library(sf)

# Read shapefile
vietnam_provinces <- st_read("vietnam_admin1.shp")

# Read from geopackage
vietnam_provinces <- st_read("vietnam_boundaries.gpkg",
                             layer = "provinces")

# From geojson
vietnam_provinces <- st_read("vietnam_provinces.geojson")

# Check geometry type and CRS
st_geometry_type(vietnam_provinces)
st_crs(vietnam_provinces)
```

#### Downloading with R Packages

```r
library(rnaturalearth)

# Download country boundary
vietnam_country <- ne_countries(
  country = "Vietnam",
  scale = "medium",
  returnclass = "sf"
)

# Download states/provinces
vietnam_admin <- ne_states(
  country = "Vietnam",
  returnclass = "sf"
)
```

#### Joining Survey Data to Spatial Data

```r
# Survey data with province names
survey_data <- tibble(
  household_id = 1:100,
  province = c("Hanoi", "Da Nang", "Ho Chi Minh City", ...),
  hdds_score = c(8, 9, 7, ...)
)

# Join to spatial data
# First, ensure matching names
vietnam_provinces <- vietnam_provinces %>%
  mutate(province_clean = str_trim(name_1))  # Adjust field name

# Join
survey_spatial <- vietnam_provinces %>%
  left_join(survey_data, by = c("province_clean" = "province"))
```

#### Geocoded Point Data

```r
# Convert survey data with coordinates to sf object
survey_sf <- survey_data %>%
  filter(!is.na(longitude) & !is.na(latitude)) %>%
  st_as_sf(
    coords = c("longitude", "latitude"),
    crs = 4326,  # WGS84
    remove = FALSE  # Keep original columns
  )

# Spatial join with boundaries
survey_with_admin <- st_join(
  survey_sf,
  vietnam_provinces,
  join = st_within
)
```

### Thematic Mapping for Thesis

#### Choropleth Maps

```r
library(ggplot2)
library(viridis)

# Calculate mean HDDS by province
province_summary <- survey_spatial %>%
  group_by(province_clean) %>%
  summarize(
    mean_hdds = mean(hdds_score, na.rm = TRUE),
    n_households = n()
  )

# Create choropleth map
ggplot(province_summary) +
  geom_sf(aes(fill = mean_hdds)) +
  scale_fill_viridis(
    option = "viridis",
    name = "Mean HDDS",
    direction = -1
  ) +
  labs(
    title = "Household Dietary Diversity Score by Province",
    subtitle = "Vietnam Food Security Survey 2024",
    caption = "Source: Author's survey data"
  ) +
  theme_minimal() +
  theme(
    legend.position = "right",
    axis.text = element_blank(),
    axis.ticks = element_blank()
  )

# Save for thesis
ggsave("figures/hdds_by_province_map.png",
       width = 8, height = 6, dpi = 300)
```

#### Point Maps with Base Layer

```r
# Base map with provinces
ggplot() +
  # Province boundaries
  geom_sf(data = vietnam_provinces,
          fill = "grey95", color = "grey70") +
  # Survey points colored by food security
  geom_sf(data = survey_sf,
          aes(color = food_secure),
          size = 2, alpha = 0.6) +
  scale_color_manual(
    values = c("0" = "#d73027", "1" = "#1a9850"),
    labels = c("Food insecure", "Food secure"),
    name = ""
  ) +
  labs(title = "Household Food Security Status") +
  theme_void()
```

#### Inset Maps

```r
library(cowplot)

# Main map
main_map <- ggplot(vietnam_provinces) +
  geom_sf(aes(fill = mean_hdds)) +
  scale_fill_viridis_c() +
  theme_void()

# Inset showing Vietnam in Southeast Asia
inset <- ggplot(se_asia_countries) +
  geom_sf(fill = "grey90") +
  geom_sf(data = vietnam_provinces, fill = "red") +
  theme_void() +
  theme(panel.border = element_rect(color = "black", fill = NA))

# Combine
ggdraw() +
  draw_plot(main_map) +
  draw_plot(inset, x = 0.65, y = 0.65, width = 0.3, height = 0.3)
```

### Distance and Buffer Calculations

```r
# Calculate distance to nearest market
markets_sf <- st_as_sf(markets_data,
                       coords = c("longitude", "latitude"),
                       crs = 4326)

# Transform to projected CRS for accurate distances
households_utm <- st_transform(survey_sf, crs = 32648)
markets_utm <- st_transform(markets_sf, crs = 32648)

# Calculate nearest distance
survey_data$dist_to_market <- st_distance(
  households_utm,
  markets_utm,
  by_element = FALSE
) %>%
  apply(1, min) / 1000  # Convert meters to kilometers

# Create buffer zones
# 5km buffer around markets
market_buffers <- st_buffer(markets_utm, dist = 5000)  # 5000 meters

# Identify households within buffer
survey_data$within_5km_market <- st_intersects(
  households_utm,
  market_buffers,
  sparse = FALSE
) %>%
  apply(1, any)
```

### Interactive Maps

```r
library(leaflet)
library(htmlwidgets)

# Create interactive map
map <- leaflet(survey_sf) %>%
  addTiles() %>%  # OpenStreetMap base layer
  addCircleMarkers(
    radius = 5,
    color = ~ifelse(food_secure == 1, "green", "red"),
    fillOpacity = 0.6,
    popup = ~paste0(
      "<b>Household ID:</b> ", household_id, "<br>",
      "<b>HDDS:</b> ", hdds_score, "<br>",
      "<b>Food Secure:</b> ", ifelse(food_secure == 1, "Yes", "No")
    )
  ) %>%
  addLegend(
    position = "bottomright",
    colors = c("green", "red"),
    labels = c("Food secure", "Food insecure")
  )

# Save
saveWidget(map, "survey_map_interactive.html")
```

### Resources

- **sf Package Guide:**
  [Geospatial vector data in R](https://ourcodingclub.github.io/tutorials/spatial-vector-sf/)
- **CRS Reference:**
  [Geographic Data Science - CRS Chapter](https://bookdown.org/mcwimberly/gdswr-book/coordinate-reference-systems.html)
- **R Spatial Packages:**
  [Chapter 6 - Spatial Statistics for Data Science](https://www.paulamoraga.com/book-spatial/r-packages-to-download-open-spatial-data.html)
- **Vietnam Spatial Data:**
  [UN-SPIDER GIST Repository](https://www.un-spider.org/story/gist-data-sets-vietnam)

---

## 9. Descriptive Statistics Reporting

### gtsummary Package for Survey Research

#### Why gtsummary?

The `{gtsummary}` package provides:
- **Publication-ready tables** with minimal code
- **Survey-specific function:** `tbl_svysummary()` for weighted data
- **Automatic variable detection:** Continuous, categorical, dichotomous
- **Missing data reporting** included by default
- **Customizable output:** HTML, LaTeX, Word, Excel
- **Reproducible workflow** - no manual table editing needed

#### Installation and Setup

```r
library(gtsummary)
library(gt)
library(survey)
library(srvyr)

# Set theme for consistent styling
theme_gtsummary_compact()

# Or journal-specific theme
theme_gtsummary_journal("jama")  # JAMA style
```

### Table 1: Baseline Characteristics

#### Basic Table 1

```r
# Create basic descriptive table
table1 <- survey_data %>%
  select(
    age, gender, education, household_size,
    income_pc, expenditure_pc,
    hdds_score, food_secure
  ) %>%
  tbl_summary(
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    digits = list(
      all_continuous() ~ 1,
      all_categorical() ~ c(0, 1)
    ),
    label = list(
      age ~ "Age (years)",
      gender ~ "Gender",
      education ~ "Education level",
      household_size ~ "Household size",
      income_pc ~ "Per capita income (VND/month)",
      expenditure_pc ~ "Per capita expenditure (VND/month)",
      hdds_score ~ "Dietary diversity score",
      food_secure ~ "Food secure"
    ),
    missing = "no"  # or "ifany" to show missing
  ) %>%
  modify_caption("**Table 1. Baseline Household Characteristics**") %>%
  bold_labels()

# Display
table1

# Export
table1 %>%
  as_gt() %>%
  gt::gtsave("table1_baseline.docx")
```

#### Table 1 with Group Comparison

```r
# Compare characteristics by food security status
table1_compare <- survey_data %>%
  select(
    age, gender, education, household_size,
    income_pc, urban, province,
    hdds_score, fies_raw,
    food_secure
  ) %>%
  tbl_summary(
    by = food_secure,
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    label = list(
      age ~ "Age of household head (years)",
      gender ~ "Gender of household head",
      education ~ "Education level",
      household_size ~ "Household size (persons)",
      income_pc ~ "Per capita income (1000 VND/month)",
      urban ~ "Urban residence",
      province ~ "Province",
      hdds_score ~ "Dietary diversity score (0-12)",
      fies_raw ~ "Food insecurity experience score (0-8)"
    )
  ) %>%
  add_n() %>%  # Add total N column
  add_p() %>%  # Add p-values
  modify_header(label = "**Characteristic**") %>%
  modify_spanning_header(c("stat_1", "stat_2") ~
                         "**Food Security Status**") %>%
  modify_caption("**Table 1. Household Characteristics by Food Security
                 Status**") %>%
  bold_labels() %>%
  bold_p(t = 0.05)  # Bold p-values < 0.05

table1_compare
```

### Table 1 for Survey Data with Weights

```r
# Create survey design object
design <- survey_data %>%
  as_survey_design(
    ids = psu,
    strata = strata,
    weights = weight
  )

# Weighted Table 1
table1_weighted <- design %>%
  tbl_svysummary(
    by = food_secure,
    include = c(age, gender, education, household_size,
                income_pc, urban, province, hdds_score),
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    label = list(
      age ~ "Age (years)",
      gender ~ "Gender",
      education ~ "Education level",
      household_size ~ "Household size",
      income_pc ~ "Per capita income (1000 VND)",
      urban ~ "Urban residence",
      province ~ "Province",
      hdds_score ~ "Dietary diversity score"
    )
  ) %>%
  add_n() %>%
  add_p() %>%
  add_overall() %>%  # Add overall column
  modify_caption("**Table 1. Weighted Household Characteristics**") %>%
  modify_footnote(
    all_stat_cols() ~ "Estimates account for survey design (weights,
                      clustering, stratification)"
  )

table1_weighted
```

### Customizing Statistics Displayed

```r
# Different statistics for different variable types
table_custom <- survey_data %>%
  tbl_summary(
    statistic = list(
      # Continuous: mean, SD, median, IQR
      age ~ "{mean} ({sd}) | {median} ({p25}, {p75})",
      income_pc ~ "{median} ({p25}, {p75})",

      # Binary: n and %
      food_secure ~ "{n} / {N} ({p}%)",

      # Categorical: n and %
      all_categorical() ~ "{n} ({p}%)"
    ),
    digits = list(
      age ~ c(1, 1, 1, 1, 1),
      income_pc ~ c(0, 0, 0)
    )
  )
```

### Regression Results Tables

```r
# Logistic regression model
model <- design %>%
  svyglm(
    food_secure ~ age + gender + education + household_size +
                 income_pc + urban + province,
    design = .,
    family = quasibinomial()
  )

# Create regression table
tbl_regression(
  model,
  exponentiate = TRUE,  # Show odds ratios
  label = list(
    age ~ "Age (years)",
    gender ~ "Gender (ref: Male)",
    education ~ "Education level",
    household_size ~ "Household size",
    income_pc ~ "Per capita income (1000 VND)",
    urban ~ "Urban residence (ref: Rural)",
    province ~ "Province (ref: Hanoi)"
  )
) %>%
  add_global_p() %>%  # Add overall p-value for categorical vars
  bold_p(t = 0.05) %>%
  bold_labels() %>%
  modify_caption("**Table 3. Logistic Regression: Determinants of Food
                 Security**") %>%
  modify_footnote(
    c(estimate, ci) ~ "OR = Odds Ratio, CI = Confidence Interval"
  )
```

### Combining Multiple Tables

```r
library(gt)

# Merge regression models
tbl_merge(
  tbls = list(
    model1 %>% tbl_regression(label = labels_list),
    model2 %>% tbl_regression(label = labels_list),
    model3 %>% tbl_regression(label = labels_list)
  ),
  tab_spanner = c("**Model 1**", "**Model 2**", "**Model 3**")
) %>%
  modify_caption("**Table 4. Progressive Model Comparison**")

# Stack tables
tbl_stack(
  tbls = list(table1_food_secure, table1_diet_diverse),
  group_header = c("Food Security", "Dietary Diversity")
)
```

### Export Options

```r
# To Word
table1 %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = "table1.docx")

# To LaTeX
table1 %>%
  as_kable_extra(format = "latex") %>%
  kableExtra::save_kable("table1.tex")

# To HTML
table1 %>%
  as_gt() %>%
  gt::gtsave("table1.html")

# To Excel
table1 %>%
  as_tibble() %>%
  writexl::write_xlsx("table1.xlsx")
```

### Best Practices for Thesis Tables

#### Table Numbering and Captions

```r
# Use consistent numbering
modify_caption("**Table 1.** Baseline Household Characteristics (N = 1,050)")
modify_caption("**Table 2.** Food Security Indicators by Province")
modify_caption("**Table 3.** Logistic Regression Results: Food Security
               Determinants")
```

#### Footnotes

```r
table1 %>%
  modify_footnote(
    update = list(
      all_stat_cols() ~ "Values are mean (SD) for continuous variables and
                        n (%) for categorical variables.",
      p.value ~ "P-values from chi-square test for categorical variables and
                t-test for continuous variables."
    )
  )
```

#### Formatting Numbers

```r
# Custom formatting function
tbl_summary(
  statistic = list(
    income_pc ~ "{mean}",
    all_categorical() ~ "{p}%"
  ),
  digits = list(
    income_pc ~ function(x) style_number(x, digits = 0, scale = 1/1000,
                                        suffix = "K"),
    all_categorical() ~ 1
  )
)
```

### Citation

When using gtsummary in publications:

```r
citation("gtsummary")

# Cite as:
# Sjoberg DD, Whiting K, Curry M, Lavery JA, Larmarange J. Reproducible
# summary tables with the gtsummary package. The R Journal 2021;13:570-80.
# https://doi.org/10.32614/RJ-2021-053
```

### Resources

- **gtsummary Website:**
  [Presentation-Ready Summary Tables](https://www.danieldsjoberg.com/gtsummary/)
- **tbl_summary Tutorial:**
  [Complete Guide](https://www.danieldsjoberg.com/gtsummary/articles/tbl_summary.html)
- **Survey Tables:**
  [tbl_svysummary Reference](https://www.danieldsjoberg.com/gtsummary/reference/tbl_svysummary.html)
- **RStudio Education:**
  [gtsummary Introduction](https://education.rstudio.com/blog/2020/07/gtsummary/)
- **Publication:**
  [R Journal Article](https://journal.r-project.org/archive/2021/RJ-2021-053/RJ-2021-053.pdf)

---

## 10. Project Structure & Organization

### Recommended Folder Structure

```
vietnam-food-security/
├── README.md                 # Project overview
├── .Rproj.user/              # RStudio project files (gitignored)
├── vietnam-food-security.Rproj  # RStudio project
├── renv/                     # Package management (renv)
├── renv.lock                 # Locked package versions
│
├── data/                     # TREAT AS READ-ONLY
│   ├── raw/                  # Original data files
│   │   ├── kobotoolbox_export.xlsx
│   │   ├── admin_boundaries.shp
│   │   └── README.md         # Data provenance documentation
│   ├── processed/            # Cleaned data (generated by scripts)
│   │   ├── survey_clean.rds
│   │   └── survey_weighted.rds
│   └── external/             # Reference data
│       ├── poverty_lines_2024.csv
│       └── vietnam_provinces.geojson
│
├── scripts/                  # Analysis code
│   ├── 01-data-import.R      # Import and initial cleaning
│   ├── 02-data-cleaning.R    # Advanced cleaning and validation
│   ├── 03-variable-creation.R # Create derived variables
│   ├── 04-survey-design.R    # Set up survey weights
│   ├── 05-descriptive-stats.R # Descriptive analysis
│   ├── 06-food-security.R    # Food security indicators
│   ├── 07-regression-models.R # Statistical models
│   ├── 08-spatial-analysis.R # Geospatial analysis
│   └── 09-visualization.R    # Create figures
│
├── functions/                # Custom functions
│   ├── data_cleaning_fns.R
│   ├── indicator_calculation_fns.R
│   └── plotting_fns.R
│
├── output/                   # Generated files
│   ├── figures/              # Plots and maps
│   │   ├── figure1_hdds_distribution.png
│   │   ├── figure2_food_security_map.png
│   │   └── README.md         # Figure descriptions
│   ├── tables/               # Summary tables
│   │   ├── table1_descriptives.docx
│   │   ├── table2_correlations.csv
│   │   └── README.md
│   └── models/               # Saved model objects
│       └── logistic_model.rds
│
├── docs/                     # Documentation
│   ├── codebook.html         # Data dictionary
│   ├── analysis_plan.md      # Pre-registered analysis plan
│   ├── meeting_notes/        # Research meetings
│   └── questionnaire.pdf     # Survey instrument
│
├── reports/                  # RMarkdown reports
│   ├── 01-data-quality-report.Rmd
│   ├── 02-descriptive-analysis.Rmd
│   ├── 03-regression-results.Rmd
│   └── thesis-chapter-4.Rmd
│
└── archive/                  # Old versions (timestamped)
    └── 2024-03-15_old_analysis/
```

### File Naming Conventions

**Best practices:**
```r
# Use numbers for order
01-data-import.R
02-data-cleaning.R

# Use dates for versions
2024-12-10_survey_data.csv
2024-12-10_analysis_results.xlsx

# Use descriptive names
hdds_by_province.png        # Good
figure1.png                 # Poor

# Separate words with hyphens or underscores
food-security-analysis.R    # Good
FoodSecurityAnalysis.R      # Poor (hard to read)
food security analysis.R    # Bad (spaces cause issues)
```

### RStudio Projects

#### Why Use Projects?

- **Reproducibility:** Code runs consistently regardless of when/where executed
- **Portability:** Easy to share entire project
- **Organization:** All files together
- **Working directory:** Automatically set to project root

#### Creating a Project

```r
# In RStudio: File > New Project > New Directory > New Project

# Or via code
usethis::create_project("vietnam-food-security")
```

#### Always Use Relative Paths

```r
# GOOD - Relative paths
data <- read_csv("data/raw/survey_data.csv")
source("scripts/01-data-import.R")

# BAD - Absolute paths
data <- read_csv("/Users/yourname/Documents/survey_data.csv")
data <- read_csv("C:/Users/yourname/Documents/survey_data.csv")

# BAD - setwd()
setwd("/Users/yourname/vietnam-food-security")  # Don't use!
```

### Package Management with renv

#### Why Use renv?

- **Reproducibility:** Lock package versions
- **Isolation:** Project-specific package libraries
- **Collaboration:** Share exact package versions
- **Time machine:** Revert to working versions

#### Setup renv

```r
# Install renv
install.packages("renv")

# Initialize in project
renv::init()

# This creates:
# - renv/ folder
# - renv.lock file
# - .Rprofile (loads renv automatically)
```

#### Using renv Workflow

```r
# Install packages as normal
install.packages("tidyverse")
install.packages("gtsummary")

# After installing new packages, snapshot
renv::snapshot()

# Restore packages (e.g., after cloning project)
renv::restore()

# Update packages
renv::update()

# Check for issues
renv::status()
```

### Modular Code Organization

#### Using source() for Modular Scripts

```r
# Main analysis script
# main_analysis.R

# Load packages and functions
source("scripts/00-setup.R")
source("functions/data_cleaning_fns.R")
source("functions/indicator_calculation_fns.R")

# Run analysis steps
source("scripts/01-data-import.R")
source("scripts/02-data-cleaning.R")
source("scripts/03-variable-creation.R")

# Analysis
source("scripts/05-descriptive-stats.R")
```

#### Creating Reusable Functions

```r
# functions/indicator_calculation_fns.R

#' Calculate Household Dietary Diversity Score
#'
#' @param data Data frame with binary food group variables
#' @param food_groups Character vector of food group column names
#' @return Numeric vector of HDDS scores (0-12)
calculate_hdds <- function(data, food_groups) {
  data %>%
    mutate(
      hdds_score = rowSums(select(., all_of(food_groups)), na.rm = FALSE)
    ) %>%
    pull(hdds_score)
}

#' Categorize HDDS into food security levels
#'
#' @param hdds_score Numeric vector of HDDS scores
#' @return Factor with levels: Severely, Moderately, Mildly/Secure
categorize_hdds <- function(hdds_score) {
  cut(
    hdds_score,
    breaks = c(-Inf, 3, 5, Inf),
    labels = c("Severely food insecure",
              "Moderately food insecure",
              "Food secure / Mildly food insecure"),
    right = TRUE
  )
}
```

### Data Management

#### Raw Data is Sacred

**Rules:**
1. **Never edit raw data files**
2. **All changes done in code**
3. **Document data provenance**
4. **Keep backups**

```r
# data/raw/README.md

# Raw Data Documentation

## survey_data_2024.csv
- Source: KoboToolbox export
- Date collected: March-May 2024
- Date downloaded: 2024-06-01
- Downloaded by: [Your name]
- Original filename: vietnam_food_security_latest.csv
- N observations: 1,050
- N variables: 247

## Changes from original:
- None - this is the original file
```

#### Saving Processed Data

```r
# Save intermediate results as .rds (preserves R object types)
saveRDS(survey_clean, "data/processed/survey_clean.rds")

# Load back
survey_clean <- readRDS("data/processed/survey_clean.rds")

# Or use save() for multiple objects
save(survey_clean, design_obj, file = "data/processed/analysis_data.RData")
load("data/processed/analysis_data.RData")
```

### Pipeline Tools for Reproducibility

#### Using targets Package

```r
# _targets.R

library(targets)
library(tarchetypes)

# Source functions
source("functions/data_cleaning_fns.R")
source("functions/indicator_calculation_fns.R")

# Define pipeline
list(
  # Raw data
  tar_target(
    raw_data,
    read_csv("data/raw/survey_data.csv")
  ),

  # Cleaning
  tar_target(
    clean_data,
    clean_survey_data(raw_data)
  ),

  # Create variables
  tar_target(
    data_with_indicators,
    calculate_all_indicators(clean_data)
  ),

  # Survey design
  tar_target(
    survey_design,
    create_survey_design(data_with_indicators)
  ),

  # Analysis
  tar_target(
    descriptive_stats,
    calculate_descriptives(survey_design)
  ),

  tar_target(
    regression_models,
    run_regressions(survey_design)
  ),

  # Outputs
  tar_target(
    table1,
    create_table1(descriptive_stats),
    format = "file",
    path = "output/tables/table1.docx"
  )
)

# Run pipeline
tar_make()

# Visualize pipeline
tar_visnetwork()

# Check what's out of date
tar_outdated()
```

### Version Control with Git

#### Initialize Git Repository

```r
# Use usethis helper
usethis::use_git()

# Create .gitignore
usethis::use_git_ignore(c(
  "data/raw/*.csv",        # Don't commit raw data
  "data/raw/*.xlsx",
  ".Rproj.user",
  ".Rhistory",
  ".RData",
  "*.html",                # Don't commit rendered reports
  "renv/library/"          # Don't commit installed packages
))
```

#### Commit Workflow

```r
# Check status
usethis::git_sitrep()

# Stage and commit
# (Use RStudio Git pane or command line)

# In terminal:
git add scripts/01-data-import.R
git commit -m "Add data import script with KoboToolbox processing"

git add scripts/02-data-cleaning.R
git commit -m "Add data cleaning with outlier handling and validation"
```

### Documentation Best Practices

#### README.md Template

```markdown
# Vietnam Food Security Survey Analysis

## Project Overview
This project analyzes household food security, dietary diversity, and
expenditure patterns in Vietnam using data from 1,050 households across
three provinces.

## Data Sources
- Household survey data (KoboToolbox, March-May 2024)
- Vietnam administrative boundaries (HDX)
- Poverty lines (General Statistics Office Vietnam)

## Repository Structure
See `docs/folder_structure.md` for detailed description

## Setup Instructions

### 1. Clone repository
git clone https://github.com/yourusername/vietnam-food-security.git

### 2. Open R project
Open `vietnam-food-security.Rproj` in RStudio

### 3. Restore packages
renv::restore()

### 4. Run analysis
source("scripts/main_analysis.R")

## Key Files
- `scripts/01-data-import.R` - Import and initial processing
- `scripts/05-descriptive-stats.R` - Main descriptive analysis
- `reports/thesis-chapter-4.Rmd` - Thesis results chapter

## Contact
[Your Name]
[Your Email]
[University]

## License
This research project is for academic purposes. Data cannot be shared without
permission.
```

### Resources

- **R Best Practices:** [Best Practices Guide](https://kdestasio.github.io/post/r_best_practices/)
- **Project Structure:**
  [Structuring a project](https://bookdown.org/arnold_c/repro-research/2-2-structuring-a-project.html)
- **RStudio Projects:**
  [Reproducible Projects in RStudio](https://uic-library.github.io/Reproducibility-RStudio/01-good-project/index.html)
- **targets Package:** [targets Documentation](https://docs.ropensci.org/targets/)
- **renv Package:** [renv Documentation](https://rstudio.github.io/renv/)
- **Research Compendium:**
  [Packaging Your Analysis](https://thomasleeper.com/2016/11/analysis-as-package/)

---

## Additional Resources

### R Packages Summary

**Data Import/Export:**
- `readr` - CSV files
- `readxl` - Excel files
- `haven` - SPSS/Stata/SAS files
- `writexl` - Write Excel files

**Data Manipulation:**
- `dplyr` - Data wrangling
- `tidyr` - Reshaping data
- `labelled` - Working with labelled data
- `fastDummies` - Creating dummy variables

**Survey Analysis:**
- `survey` - Complex survey design
- `srvyr` - Tidyverse-compatible survey functions
- `srvyrexploR` - Survey exploration

**Geospatial:**
- `sf` - Simple features for spatial data
- `rnaturalearth` - World map data
- `leaflet` - Interactive maps

**Tables and Reporting:**
- `gtsummary` - Summary tables
- `gt` - Grammar of tables
- `kableExtra` - Enhanced tables
- `flextable` - Word/PowerPoint tables

**Documentation:**
- `codebook` - Automatic codebooks
- `codebookr` - Word codebooks

**Visualization:**
- `ggplot2` - Static graphics
- `viridis` - Color scales
- `likert` - Likert scale plots
- `corrplot` - Correlation matrices

**Missing Data:**
- `naniar` - Missing data visualization
- `mice` - Multiple imputation
- `missForest` - Random forest imputation

**Reproducibility:**
- `renv` - Package management
- `targets` - Pipeline automation
- `usethis` - Project setup helpers

### Online Communities

- **RStudio Community:** https://forum.posit.co/
- **Stack Overflow:** Tag your questions with [r], [survey], [gtsummary]
- **KoboToolbox Community:** https://community.kobotoolbox.org/
- **R for Data Science Community:** https://www.rfordatasci.com/

### Learning Resources

- **R for Data Science (2e):** https://r4ds.hadley.nz/
- **Tidy Survey Analysis Book:** https://tidy-survey-r.github.io/tidy-survey-book/
- **Geocomputation with R:** https://r.geocompx.org/
- **Survey Weights Guide (NHANES):**
  https://cran.r-project.org/web/packages/nhanesA/vignettes/UsingSurveyWeights.html

---

## Document Metadata

**Author:** Research compiled from authoritative sources
**Purpose:** Best practices reference for Vietnam food security thesis analysis
**Scope:** Survey data analysis, food security indicators, R workflows
**Maintained by:** [Your name/institution]
**Last updated:** 2025-12-10
**Version:** 1.0

---

## Acknowledgments

This guide synthesizes best practices from:
- FAO (Food and Agriculture Organization)
- FANTA (Food and Nutrition Technical Assistance)
- WFP (World Food Programme)
- World Bank
- Tidyverse/RStudio development teams
- Open-source R package developers

## Citation

If using this guide, please cite key sources referenced in each section and
acknowledge the R packages used in your analysis.

---

**End of Guide**
