# R Workflow for Survey Analysis - Best Practices Guide

## Quick Reference
- **Purpose**: Set up R environment and workflow for survey data analysis
- **Key Packages**: survey, srvyr, tidyverse, haven, sjlabelled, gtsummary
- **Related Areas**: [03-kobo-xlsform](../03-kobo-xlsform/), [10-reporting](../10-reporting/)
- **Agent-Foreman Features**: `core.config.project-setup`, `core.config.package-dependencies`

## Prerequisites
- [ ] R and RStudio installed
- [ ] Basic tidyverse knowledge
- [ ] Understanding of survey design concepts (PSU, strata, weights)

## Core Workflow

### Step 1: Initialize Project with renv
```r
# Create new project, then:
renv::init()
```

### Step 2: Install Core Packages
```r
# Survey analysis
install.packages(c("survey", "srvyr"))

# Tidyverse ecosystem
install.packages("tidyverse")

# Labelled data
install.packages(c("haven", "sjlabelled", "labelled"))

# From GitHub
pak::pkg_install("tidy-survey-r/srvyrexploR")
```

### Step 3: Create Survey Design Object
```r
# CRITICAL: Create design BEFORE filtering
design_srvyr <- survey_data %>%
  as_survey_design(
    ids = psu,
    strata = strata,
    weights = weight,
    nest = TRUE
  )

# Handle lonely PSUs
options(survey.lonely.psu = "adjust")
```

### Step 4: Analysis Workflow
```r
# Filter AFTER design creation
design_subset <- design_srvyr %>%
  filter(province == "Hanoi")

# Calculate weighted statistics
design_subset %>%
  group_by(province) %>%
  summarize(
    mean_income = survey_mean(income, na.rm = TRUE),
    total_hh = survey_total()
  )
```

## Checklists

### Before Starting
- [ ] RStudio Project created
- [ ] renv initialized
- [ ] Core packages installed
- [ ] Survey design documentation available

### Quality Assurance
- [ ] Survey design object created correctly
- [ ] Lonely PSU handling configured
- [ ] Filter operations done AFTER design creation
- [ ] All analyses use survey functions

## Common Pitfalls
1. **Filtering before design**: Loses survey structure → **Solution**: Always create design first
2. **Using mean() instead of survey_mean()**: Ignores weights → **Solution**: Use srvyr survey functions
3. **Not handling lonely PSUs**: Causes errors → **Solution**: Set `options(survey.lonely.psu = "adjust")`

## Scripts
- `scripts/setup-packages.R` - Install all required packages

## Templates
- `templates/analysis-script-template.R` - Standard analysis script structure

## External Resources
- [Tidy Survey Book](https://tidy-survey-r.github.io/tidy-survey-book/) - Primary reference
- [UCLA Survey Data Analysis](https://stats.oarc.ucla.edu/r/seminars/survey-data-analysis-with-r/)
- [srvyr GitHub](https://github.com/gergness/srvyr)

## Related Areas
- [03-kobo-xlsform](../03-kobo-xlsform/) - Data import from KoboToolbox
- [04-data-management](../04-data-management/) - Data cleaning workflows
- [10-reporting](../10-reporting/) - Table and report generation
