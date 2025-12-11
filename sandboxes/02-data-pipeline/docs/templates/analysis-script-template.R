# ==============================================================================
# [SCRIPT NAME]
# ==============================================================================
# Purpose: [One-line description of what this script does]
# Author: [Your name]
# Date: [Date created]
# Last Modified: [Date last modified]
#
# Input:  data/processed/[input_file].rds
# Output: output/tables/[output_file].docx
#         output/figures/[output_file].png
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SETUP
# ------------------------------------------------------------------------------

# Load packages
library(tidyverse)
library(survey)
library(srvyr)
library(gtsummary)

# Set options
options(survey.lonely.psu = "adjust")

# Load data
survey_data <- readRDS("data/processed/survey_clean.rds")

# ------------------------------------------------------------------------------
# 2. CREATE SURVEY DESIGN
# ------------------------------------------------------------------------------
# IMPORTANT: Create design object BEFORE any filtering

design <- survey_data %>%
  as_survey_design(
    ids = psu,           # Primary sampling unit
    strata = strata,     # Stratification variable
    weights = weight,    # Sampling weights
    nest = TRUE          # PSUs nested within strata
  )

# ------------------------------------------------------------------------------
# 3. DATA PREPARATION
# ------------------------------------------------------------------------------
# Any filtering should happen AFTER design creation

# Example: Filter to subset
# design_subset <- design %>%
#   filter(province == "Hanoi")

# ------------------------------------------------------------------------------
# 4. ANALYSIS
# ------------------------------------------------------------------------------

# Example: Weighted descriptive statistics
results <- design %>%
  group_by(food_secure) %>%
  summarize(
    mean_hdds = survey_mean(hdds_score, na.rm = TRUE),
    mean_income = survey_mean(income_pc, na.rm = TRUE),
    n = survey_total()
  )

print(results)

# ------------------------------------------------------------------------------
# 5. CREATE TABLES
# ------------------------------------------------------------------------------

# Example: Summary table
table1 <- design %>%
  tbl_svysummary(
    by = food_secure,
    include = c(age, gender, education, hdds_score),
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    )
  ) %>%
  add_p() %>%
  add_overall()

# ------------------------------------------------------------------------------
# 6. EXPORT RESULTS
# ------------------------------------------------------------------------------

# Export to Word
table1 %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = "output/tables/table1.docx")

# Save R objects for later use
# saveRDS(results, "output/models/analysis_results.rds")

# ------------------------------------------------------------------------------
# SESSION INFO
# ------------------------------------------------------------------------------
# Document package versions for reproducibility
sessionInfo()
