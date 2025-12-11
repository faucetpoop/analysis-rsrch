# ==============================================================================
# gtsummary Table Templates
# ==============================================================================
# Purpose: Standard table templates for thesis reporting
# ==============================================================================

library(tidyverse)
library(survey)
library(srvyr)
library(gtsummary)
library(flextable)

# Set consistent theme
theme_gtsummary_compact()

# ------------------------------------------------------------------------------
# 1. TABLE 1: SAMPLE CHARACTERISTICS
# ------------------------------------------------------------------------------

create_table1 <- function(design, by_var = NULL) {
  vars_to_include <- c("age", "gender", "education", "household_size",
                       "income_pc", "urban", "province")

  tbl <- design %>%
    tbl_svysummary(
      by = {{ by_var }},
      include = all_of(vars_to_include),
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
        income_pc ~ "Per capita income (million VND/month)",
        urban ~ "Urban residence",
        province ~ "Province"
      )
    ) %>%
    modify_caption("**Table 1. Sample Characteristics**") %>%
    bold_labels()

  # Add comparison if grouping variable provided
  if (!is.null(by_var)) {
    tbl <- tbl %>%
      add_n() %>%
      add_p() %>%
      add_overall() %>%
      bold_p(t = 0.05)
  }

  return(tbl)
}

# Usage:
# table1 <- create_table1(design)
# table1_compare <- create_table1(design, by_var = food_secure)

# ------------------------------------------------------------------------------
# 2. TABLE 2: FOOD SECURITY INDICATORS
# ------------------------------------------------------------------------------

create_indicator_table <- function(design) {
  design %>%
    tbl_svysummary(
      include = c(hdds_score, hdds_category, fies_raw, fcs_score,
                  fcs_category, rcsi_score, rcsi_ipc_phase),
      statistic = list(
        all_continuous() ~ "{mean} ({sd}); Median: {median}",
        all_categorical() ~ "{n} ({p}%)"
      ),
      label = list(
        hdds_score ~ "HDDS (0-12)",
        hdds_category ~ "HDDS Category",
        fies_raw ~ "FIES Raw Score (0-8)",
        fcs_score ~ "FCS Score",
        fcs_category ~ "FCS Category",
        rcsi_score ~ "rCSI Score",
        rcsi_ipc_phase ~ "IPC Phase"
      )
    ) %>%
    modify_caption("**Table 2. Food Security Indicators**") %>%
    bold_labels() %>%
    modify_footnote(
      all_stat_cols() ~ "Weighted estimates. SD = standard deviation."
    )
}

# Usage:
# table2 <- create_indicator_table(design)

# ------------------------------------------------------------------------------
# 3. TABLE 3: REGRESSION RESULTS
# ------------------------------------------------------------------------------

create_regression_table <- function(model, exponentiate = TRUE) {
  tbl_regression(
    model,
    exponentiate = exponentiate,
    label = list(
      age ~ "Age (years)",
      gender ~ "Gender (ref: Male)",
      education ~ "Education level (ref: Primary or less)",
      household_size ~ "Household size",
      income_pc ~ "Per capita income (million VND)",
      urban ~ "Urban residence (ref: Rural)",
      province ~ "Province (ref: Hanoi)"
    )
  ) %>%
    add_global_p() %>%
    bold_p(t = 0.05) %>%
    modify_caption("**Table 3. Determinants of Food Security**") %>%
    modify_footnote(
      estimate ~ ifelse(exponentiate,
                        "OR = Odds Ratio; CI = Confidence Interval",
                        "Coefficient; CI = Confidence Interval")
    )
}

# Usage:
# model <- svyglm(food_secure ~ age + gender + education + income_pc + urban,
#                 design = design, family = quasibinomial())
# table3 <- create_regression_table(model)

# ------------------------------------------------------------------------------
# 4. COMPARE MULTIPLE MODELS
# ------------------------------------------------------------------------------

create_model_comparison <- function(model1, model2, model3,
                                    model_names = c("Unadjusted", "Partially Adjusted", "Fully Adjusted")) {
  tbl_merge(
    tbls = list(
      tbl_regression(model1, exponentiate = TRUE),
      tbl_regression(model2, exponentiate = TRUE),
      tbl_regression(model3, exponentiate = TRUE)
    ),
    tab_spanner = paste0("**", model_names, "**")
  ) %>%
    modify_caption("**Table 4. Progressive Model Comparison**")
}

# ------------------------------------------------------------------------------
# 5. EXPORT FUNCTIONS
# ------------------------------------------------------------------------------

export_to_word <- function(table, filename) {
  table %>%
    as_flex_table() %>%
    flextable::save_as_docx(path = filename)

  message(paste("Table exported to:", filename))
}

export_to_html <- function(table, filename) {
  table %>%
    as_gt() %>%
    gt::gtsave(filename)

  message(paste("Table exported to:", filename))
}

# Usage:
# export_to_word(table1, "output/tables/table1.docx")
# export_to_html(table1, "output/tables/table1.html")

# ------------------------------------------------------------------------------
# 6. FULL WORKFLOW EXAMPLE
# ------------------------------------------------------------------------------

# Uncomment to run full workflow:
#
# # Load data
# survey_data <- readRDS("data/processed/survey_clean.rds")
#
# # Create survey design
# design <- survey_data %>%
#   as_survey_design(ids = psu, strata = strata, weights = weight, nest = TRUE)
#
# # Create tables
# table1 <- create_table1(design)
# table1_compare <- create_table1(design, by_var = food_secure)
# table2 <- create_indicator_table(design)
#
# # Run regression
# model <- design %>%
#   svyglm(food_secure ~ age + gender + education + income_pc + urban + province,
#          design = ., family = quasibinomial())
# table3 <- create_regression_table(model)
#
# # Export all tables
# export_to_word(table1, "output/tables/table1_characteristics.docx")
# export_to_word(table1_compare, "output/tables/table1_by_food_security.docx")
# export_to_word(table2, "output/tables/table2_indicators.docx")
# export_to_word(table3, "output/tables/table3_regression.docx")
