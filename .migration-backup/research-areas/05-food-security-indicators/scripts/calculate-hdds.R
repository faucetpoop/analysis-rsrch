# ==============================================================================
# Calculate Household Dietary Diversity Score (HDDS)
# ==============================================================================
# Purpose: Calculate HDDS from 12 food groups using FAO methodology
# Reference: FAO Guidelines for Measuring Dietary Diversity
# ==============================================================================

library(tidyverse)

# ------------------------------------------------------------------------------
# 1. FOOD GROUP MAPPING
# ------------------------------------------------------------------------------
# Map your survey questions to the 12 HDDS food groups
# Each should be binary: 1 = consumed in past 24 hours, 0 = not consumed

# HDDS Food Groups:
# 1. Cereals (rice, bread, noodles, etc.)
# 2. Root and tubers (potatoes, cassava, etc.)
# 3. Vegetables
# 4. Fruits
# 5. Meat, poultry, offal
# 6. Eggs
# 7. Fish and seafood
# 8. Pulses/legumes/nuts
# 9. Milk and milk products
# 10. Oil/fats
# 11. Sugar/honey
# 12. Miscellaneous (spices, condiments, beverages)

# Example mapping (adjust variable names to your survey):
hdds_variables <- c(
  "fg_cereals",      # Food group 1

"fg_tubers",       # Food group 2
  "fg_vegetables",   # Food group 3
  "fg_fruits",       # Food group 4
  "fg_meat",         # Food group 5
  "fg_eggs",         # Food group 6
  "fg_fish",         # Food group 7
  "fg_legumes",      # Food group 8
  "fg_dairy",        # Food group 9
  "fg_oils",         # Food group 10
  "fg_sugar",        # Food group 11
  "fg_misc"          # Food group 12
)

# ------------------------------------------------------------------------------
# 2. CALCULATE HDDS SCORE
# ------------------------------------------------------------------------------

calculate_hdds <- function(data, food_group_vars) {
  data %>%
    mutate(
      # Sum of food groups consumed (0-12)
      hdds_score = rowSums(select(., all_of(food_group_vars)), na.rm = TRUE),

      # Categorize by food security status
      hdds_category = case_when(
        hdds_score <= 3 ~ "Severely food insecure",
        hdds_score <= 5 ~ "Moderately food insecure",
        hdds_score >= 6 ~ "Food secure / Mildly food insecure"
      ),

      # Alternative categorization (terciles)
      hdds_tercile = case_when(
        hdds_score <= 5 ~ "Low",
        hdds_score <= 8 ~ "Medium",
        hdds_score >= 9 ~ "High"
      )
    )
}

# ------------------------------------------------------------------------------
# 3. USAGE EXAMPLE
# ------------------------------------------------------------------------------

# Uncomment and run:
# data <- readRDS("data/processed/survey_clean.rds")
# data <- calculate_hdds(data, hdds_variables)

# ------------------------------------------------------------------------------
# 4. QUALITY CHECKS
# ------------------------------------------------------------------------------

check_hdds <- function(data) {
  cat("HDDS Quality Checks\n")
  cat("===================\n\n")

  # Distribution
  cat("Score Distribution:\n")
  print(summary(data$hdds_score))

  # Category counts
  cat("\nCategory Counts:\n")
  print(table(data$hdds_category, useNA = "ifany"))

  # Check for out-of-range values
  out_of_range <- sum(data$hdds_score < 0 | data$hdds_score > 12, na.rm = TRUE)
  if (out_of_range > 0) {
    warning(paste(out_of_range, "values outside valid range (0-12)"))
  }

  # Missing values
  missing <- sum(is.na(data$hdds_score))
  cat(paste("\nMissing HDDS scores:", missing, "\n"))
}

# Uncomment and run:
# check_hdds(data)
