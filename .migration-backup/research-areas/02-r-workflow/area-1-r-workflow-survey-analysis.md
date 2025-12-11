# Area 1 – R Workflow for Survey & Indicator Analysis

**Goal:** Be fluent enough in R to run the full analysis end-to-end.

---

## Essential Packages

### Core Tidyverse
```r
library(tidyverse)    # Data manipulation and visualization
library(readxl)       # Excel file import
library(readr)        # CSV file import
library(dplyr)        # Data manipulation
library(tidyr)        # Data tidying
```

### Survey-Specific
```r
library(survey)       # Complex survey design analysis
library(srvyr)        # Tidyverse-compatible survey analysis
library(srvyrexploR)  # Survey exploration tools
```

### Additional Tools
```r
library(haven)        # SPSS/Stata data import with labels
library(labelled)     # Working with labelled data
library(sjlabelled)   # Value/variable label management
library(broom)        # Tidy model outputs
library(gt)           # Table formatting
library(gtsummary)    # Summary tables for surveys
```

---

## Data Import Best Practices

### Excel Files from KoboToolbox
```r
data <- read_excel("kobotoolbox_export.xlsx")
```

### CSV with Vietnamese Text
```r
data <- read_csv("survey_data.csv",
                 locale = locale(encoding = "UTF-8"))
```

### SPSS Files with Labels
```r
data <- haven::read_sav("survey_data.sav") %>%
  haven::as_factor()  # Convert labelled to factors
```

---

## Complex Survey Design

### Understanding Survey Design Components

- **Primary Sampling Units (PSUs):** First units sampled (e.g., communes, villages)
- **Strata:** Mutually exclusive groups to reduce variance (e.g., urban/rural)
- **Weights:** Adjustment factors for probability of selection and non-response

### Creating Survey Design Objects

**Using survey package:**
```r
options(survey.lonely.psu = "adjust")

design_obj <- svydesign(
  id = ~psu,                    # Primary sampling unit
  strata = ~strata,             # Stratification variable
  weights = ~weight,            # Sampling weights
  nest = TRUE,                  # PSUs nested within strata
  survey.lonely.psu = "adjust", # Handle strata with single PSU
  data = survey_data
)
```

**Using srvyr for tidyverse syntax:**
```r
design_srvyr <- survey_data %>%
  as_survey_design(
    ids = psu,
    strata = strata,
    weights = weight,
    nest = TRUE
  )
```

### Handling Lonely PSUs

When a stratum contains only one PSU, variance cannot be estimated. Options:
- `"fail"` - Default, throws error
- `"adjust"` - Center at population mean (recommended)
- `"remove"` - Ignore PSU for variance computation
- `"average"` - Use average variance across strata

```r
options(survey.lonely.psu = "adjust")
```

---

## Workflow Order Matters

**Critical:** The order of operations is essential in survey analysis:

1. **Create survey design object FIRST**
2. **Then filter/subset data** (never filter before creating design)
3. **Then calculate statistics**

```r
# Correct order
design <- svydesign(id = ~psu, strata = ~strata,
                    weights = ~weight, data = survey_data)

# Filter AFTER design creation
design_subset <- design %>%
  filter(province == "Hanoi")

# Calculate statistics
design_subset %>%
  summarize(mean_income = survey_mean(income))
```

---

## Data Manipulation with Survey Weights

### Group By and Summarize
```r
design_srvyr %>%
  group_by(province) %>%
  summarize(
    mean_income = survey_mean(income, na.rm = TRUE),
    median_income = survey_median(income, na.rm = TRUE),
    total_hh = survey_total()
  )
```

### Available Survey Functions
- **Means:** `survey_mean()`
- **Totals:** `survey_total()`
- **Proportions:** `survey_prop()`
- **Quantiles:** `survey_quantile()`
- **Medians:** `survey_median()`

---

## Regression with Survey Data

**Note:** srvyr does NOT fully incorporate modeling. Use survey package directly:

```r
model <- design_obj %>%
  svyglm(food_secure ~ income + education + household_size,
         design = .,
         family = quasibinomial())
```

---

## Working with Labelled Data

### Using sjlabelled Package
```r
library(sjlabelled)

# Retrieve labels
get_label(data$variable)       # Variable label
get_labels(data$variable)      # Value labels

# Restore labels after operations
data_subset <- copy_labels(data_subset, data)

# Remove labels for analysis
data_clean <- remove_labels(data)
```

### Workflow for SPSS Data
1. Import with `haven::read_sav()`
2. Work with labels using sjlabelled
3. Convert to factors/numerics for analysis
4. Re-apply labels after transformations with `copy_labels()`

---

## Project Structure

```
vietnam-food-security/
├── README.md
├── vietnam-food-security.Rproj
├── renv/
├── renv.lock
├── data/
│   ├── raw/              # TREAT AS READ-ONLY
│   ├── processed/        # Cleaned data
│   └── external/         # Reference data
├── scripts/
│   ├── 01-data-import.R
│   ├── 02-data-cleaning.R
│   ├── 03-variable-creation.R
│   ├── 04-survey-design.R
│   ├── 05-descriptive-stats.R
│   └── ...
├── functions/            # Custom functions
├── output/
│   ├── figures/
│   ├── tables/
│   └── models/
└── docs/
```

---

## Package Management with renv

```r
# Initialize in project
renv::init()

# After installing new packages
renv::snapshot()

# Restore packages (after cloning project)
renv::restore()

# Check status
renv::status()
```

---

## Checklist

- [ ] Set up RStudio Project with renv
- [ ] Install core packages (survey, srvyr, tidyverse)
- [ ] Understand survey design components (PSU, strata, weights)
- [ ] Practice creating survey design objects
- [ ] Test group_by + summarize workflow
- [ ] Review modular script organization

---

## Key Resources

### Primary Guide
- [Exploring Complex Survey Data Analysis Using R](https://tidy-survey-r.github.io/tidy-survey-book/) - Zimmer et al. (2024) - Free, comprehensive, tidyverse-focused

### Additional Resources
- [UCLA Survey Data Analysis with R](https://stats.oarc.ucla.edu/r/seminars/survey-data-analysis-with-r/)
- [srvyr GitHub](https://github.com/gergness/srvyr)
- [Pew Research tidyverse + survey](https://www.pewresearch.org/decoded/2019/06/12/using-tidy-verse-tools-with-pew-research-center-survey-data-in-r/)

### Package Documentation
- [srvyr CRAN](https://cran.r-project.org/web/packages/srvyr/srvyr.pdf)
- [survey CRAN](https://cran.r-project.org/web/packages/survey/)
- [sjlabelled](https://strengejacke.github.io/sjlabelled/articles/labelleddata.html)

---

## Installation Script

```r
# Survey analysis
install.packages(c("survey", "srvyr"))

# Tidyverse ecosystem
install.packages("tidyverse")

# Labelled data
install.packages(c("haven", "sjlabelled", "labelled"))

# Project management
install.packages("renv")

# From GitHub
pak::pkg_install("tidy-survey-r/srvyrexploR")
```
