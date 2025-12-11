# ==============================================================================
# Setup Packages for Survey Analysis
# ==============================================================================
# Run this script once to install all required packages for the Vietnam
# Food Security survey analysis project.
# ==============================================================================

# Core survey analysis packages
install.packages(c("survey", "srvyr"))

# Tidyverse ecosystem
install.packages("tidyverse")

# Labelled data handling
install.packages(c("haven", "sjlabelled", "labelled"))

# Reporting and tables
install.packages(c("gtsummary", "gt", "flextable"))

# Missing data analysis
install.packages(c("naniar", "mice", "missForest"))

# Geospatial
install.packages(c("sf", "tmap", "geodata"))

# Psychometrics
install.packages(c("psych", "likert"))

# Economic analysis
install.packages(c("DescTools", "ineq"))

# Documentation
install.packages(c("codebook", "codebookr"))

# Project management
install.packages("renv")

# From GitHub (requires pak)
if (!requireNamespace("pak", quietly = TRUE)) {
  install.packages("pak")
}

pak::pkg_install("tidy-survey-r/srvyrexploR")
pak::pkg_install("dickoa/robotoolbox")

# ==============================================================================
# Verify Installation
# ==============================================================================

required_packages <- c(
  "survey", "srvyr", "tidyverse", "haven", "sjlabelled", "labelled",
  "gtsummary", "gt", "flextable", "naniar", "sf", "tmap", "psych"
)

missing <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]

if (length(missing) == 0) {
  message("All required packages installed successfully!")
} else {
  warning("Missing packages: ", paste(missing, collapse = ", "))
}
