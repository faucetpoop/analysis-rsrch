# Documentation Standards - Best Practices Guide

## Quick Reference
- **Purpose**: Create clear documentation for thesis and reproducibility
- **Key Packages**: codebook, codebookr, dataReporter, pointblank
- **Related Areas**: All areas (documentation is cross-cutting)
- **Agent-Foreman Features**: `documentation.codebook.generate`, `documentation.appendix.survey-modules`, `documentation.construct-map.create`

## Prerequisites
- [ ] Clean analysis dataset
- [ ] Variable labels defined
- [ ] Value labels for categorical variables

## Core Workflow

### Step 1: Add Labels to Data
```r
library(labelled)

data <- data %>%
  mutate(
    income_total = income_total %>%
      set_variable_labels("Total household income in past month (VND)") %>%
      add_value_labels(.list = c("Refused" = -77, "Don't know" = -88)),

    province = province %>%
      set_variable_labels("Province of residence") %>%
      add_value_labels("Hanoi" = 1, "HCMC" = 2, "Da Nang" = 3)
  )
```

### Step 2: Generate Codebook
```r
library(codebook)

# Generate automatic codebook
codebook_data <- codebook(data)

# Or table summary
codebook::codebook_table(data)
```

### Step 3: Create Missing Data Summary
```r
missing_report <- data %>%
  summarize(across(everything(),
    list(n_missing = ~sum(is.na(.)), pct_missing = ~mean(is.na(.)) * 100)
  )) %>%
  pivot_longer(everything(),
    names_to = c("variable", ".value"),
    names_pattern = "(.+)_(n_missing|pct_missing)"
  )

write_csv(missing_report, "missing_data_summary.csv")
```

### Step 4: Create Survey Module Table
```r
library(gt)

survey_modules <- tibble(
  Module = c("Demographics", "Food consumption", "Food security", "Income", "Expenditure"),
  Purpose = c("Household characteristics", "Dietary recall", "Experience scale", "Sources and amounts", "Spending categories"),
  Questions = c("Q1-Q15", "D1-D12", "FS1-FS8", "I1-I10", "E1-E20"),
  Indicators = c("Sample description", "HDDS", "FIES raw score", "Total income", "Food share")
) %>%
  gt() %>%
  tab_header(title = "Table A3. Survey Modules")
```

## Checklists

### Before Starting
- [ ] All variables in final dataset identified
- [ ] Variable naming conventions established
- [ ] Missing data codes defined

### Quality Assurance
- [ ] Variable labels added to all variables
- [ ] Value labels added to categorical variables
- [ ] Missing data codes documented
- [ ] Automatic codebook generated
- [ ] Survey design summary table created
- [ ] Variable definitions table created
- [ ] Survey modules table created
- [ ] Skip logic documented
- [ ] Full questionnaire in appendix

## Common Pitfalls
1. **No labels**: Generic variable names without descriptions → **Solution**: Add labels before analysis
2. **Undocumented missing codes**: -77, -88 without explanation → **Solution**: Include in codebook
3. **Manual table editing**: Losing reproducibility → **Solution**: Generate tables with code

## Templates
- `templates/codebook-template.md` - Manual codebook structure
- `templates/data-dictionary-template.md` - Variable documentation
- `templates/survey-appendix-template.md` - Thesis appendix format

## External Resources
- [codebook Package](https://rubenarslan.github.io/codebook/)
- [codebookr Documentation](https://brad-cannell.github.io/codebookr/)
- [Tidy Survey Book - Documentation](https://tidy-survey-r.github.io/tidy-survey-book/c03-survey-data-documentation.html)

## Related Areas
- [01-survey-context](../01-survey-context/) - Survey understanding
- [03-kobo-xlsform](../03-kobo-xlsform/) - XLSForm structure
- [10-reporting](../10-reporting/) - Table generation
