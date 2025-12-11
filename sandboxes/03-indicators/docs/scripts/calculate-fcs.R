# ==============================================================================
# Calculate Food Consumption Score (FCS)
# ==============================================================================
# Purpose: Calculate FCS using WFP methodology (7-day recall, weighted)
# Reference: WFP Food Consumption Score Metadata
# ==============================================================================

library(tidyverse)

# ------------------------------------------------------------------------------
# 1. FCS FOOD GROUP WEIGHTS
# ------------------------------------------------------------------------------
# WFP standard weights for food groups

fcs_weights <- list(
  starches = 2,      # Main staples (cereals, roots, tubers)
  pulses = 3,        # Pulses, legumes, nuts
  vegetables = 1,    # Vegetables and leaves
  fruits = 1,        # Fruits
  meat_fish = 4,     # Meat, fish, eggs
  milk = 4,          # Milk and dairy products
  sugar = 0.5,       # Sugar and honey
  oil = 0.5          # Oils and fats
)

# ------------------------------------------------------------------------------
# 2. CALCULATE FCS SCORE
# ------------------------------------------------------------------------------
# Input: Number of days each food group was consumed in past 7 days (0-7)

calculate_fcs <- function(data,
                          starches_var = "starches_days",
                          pulses_var = "pulses_days",
                          vegetables_var = "vegetables_days",
                          fruits_var = "fruits_days",
                          meat_fish_var = "meat_fish_days",
                          milk_var = "milk_days",
                          sugar_var = "sugar_days",
                          oil_var = "oil_days") {

  data %>%
    mutate(
      # Cap days at 7 (in case of data entry errors)
      across(c(!!sym(starches_var), !!sym(pulses_var), !!sym(vegetables_var),
               !!sym(fruits_var), !!sym(meat_fish_var), !!sym(milk_var),
               !!sym(sugar_var), !!sym(oil_var)),
             ~pmin(., 7, na.rm = TRUE)),

      # Calculate weighted score
      fcs_score = (!!sym(starches_var) * fcs_weights$starches) +
                  (!!sym(pulses_var) * fcs_weights$pulses) +
                  (!!sym(vegetables_var) * fcs_weights$vegetables) +
                  (!!sym(fruits_var) * fcs_weights$fruits) +
                  (!!sym(meat_fish_var) * fcs_weights$meat_fish) +
                  (!!sym(milk_var) * fcs_weights$milk) +
                  (!!sym(sugar_var) * fcs_weights$sugar) +
                  (!!sym(oil_var) * fcs_weights$oil),

      # Check if sugar AND oil consumed daily (for adjusted thresholds)
      sugar_oil_daily = (!!sym(sugar_var) == 7) & (!!sym(oil_var) == 7),

      # Standard thresholds
      fcs_category_standard = case_when(
        fcs_score <= 21 ~ "Poor",
        fcs_score <= 35 ~ "Borderline",
        fcs_score > 35 ~ "Acceptable"
      ),

      # Adjusted thresholds (for high sugar/oil diets)
      fcs_category_adjusted = case_when(
        sugar_oil_daily & fcs_score <= 28 ~ "Poor",
        sugar_oil_daily & fcs_score <= 42 ~ "Borderline",
        sugar_oil_daily & fcs_score > 42 ~ "Acceptable",
        !sugar_oil_daily ~ fcs_category_standard
      )
    )
}

# ------------------------------------------------------------------------------
# 3. USAGE EXAMPLE
# ------------------------------------------------------------------------------

# Uncomment and run:
# data <- readRDS("data/processed/survey_clean.rds")
# data <- calculate_fcs(data)

# ------------------------------------------------------------------------------
# 4. QUALITY CHECKS
# ------------------------------------------------------------------------------

check_fcs <- function(data) {
  cat("FCS Quality Checks\n")
  cat("==================\n\n")

  # Score distribution
  cat("Score Distribution:\n")
  print(summary(data$fcs_score))

  # Category counts (standard)
  cat("\nStandard Categories:\n")
  print(table(data$fcs_category_standard, useNA = "ifany"))

  # Proportion needing adjustment
  adjusted <- sum(data$sugar_oil_daily, na.rm = TRUE)
  cat(paste("\nHouseholds with daily sugar AND oil:", adjusted,
            "(", round(adjusted / nrow(data) * 100, 1), "%)\n"))

  # Check range
  out_of_range <- sum(data$fcs_score < 0 | data$fcs_score > 112, na.rm = TRUE)
  if (out_of_range > 0) {
    warning(paste(out_of_range, "values outside theoretical range (0-112)"))
  }
}

# Uncomment and run:
# check_fcs(data)
