# Descriptives & Reporting - Best Practices Guide

## Quick Reference
- **Purpose**: Create publication-ready tables and summaries
- **Key Packages**: gtsummary, gt, flextable
- **Related Areas**: All analysis areas feed into reporting
- **Agent-Foreman Features**: `reporting.tables.descriptive-summary`, `reporting.tables.indicator-results`, `reporting.export.word-docx`

## Prerequisites
- [ ] Analysis dataset with all indicators calculated
- [ ] Survey design object (if using weights)
- [ ] Variable labels defined

## Core Workflow

### Step 1: Set Up gtsummary
```r
library(gtsummary)
library(gt)
library(flextable)

# Set consistent theme
theme_gtsummary_compact()
# Or journal-specific
theme_gtsummary_journal("jama")
```

### Step 2: Create Table 1 (Sample Characteristics)
```r
table1 <- survey_data %>%
  select(age, gender, education, household_size, income_pc, hdds_score, food_secure) %>%
  tbl_summary(
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    label = list(
      age ~ "Age (years)",
      hdds_score ~ "Dietary diversity score"
    )
  ) %>%
  modify_caption("**Table 1. Baseline Household Characteristics**") %>%
  bold_labels()
```

### Step 3: Create Weighted Table (with survey design)
```r
design <- survey_data %>%
  as_survey_design(ids = psu, strata = strata, weights = weight)

table1_weighted <- design %>%
  tbl_svysummary(
    by = food_secure,
    include = c(age, gender, education, income_pc, hdds_score)
  ) %>%
  add_n() %>%
  add_p() %>%
  add_overall()
```

### Step 4: Create Regression Table
```r
model <- design %>%
  svyglm(food_secure ~ age + gender + education + income_pc,
         family = quasibinomial())

tbl_regression(model, exponentiate = TRUE) %>%
  add_global_p() %>%
  bold_p(t = 0.05)
```

### Step 5: Export to Word
```r
# IMPORTANT: Use flextable for Word output (not kableExtra)
table1 %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = "table1.docx")
```

## Checklists

### Before Starting
- [ ] gtsummary, gt, flextable installed
- [ ] Survey design object created (if weighted)
- [ ] Variable labels applied

### Quality Assurance
- [ ] Table 1 (sample characteristics) created
- [ ] Tables use survey weights where appropriate
- [ ] Group comparisons include p-values
- [ ] Regression tables show OR/RR with CI
- [ ] Consistent decimal places throughout
- [ ] Proper captions and footnotes
- [ ] Exported to Word successfully
- [ ] Narrative summaries written

## Common Pitfalls
1. **Using mean() instead of survey_mean()**: Ignoring weights → **Solution**: Use tbl_svysummary
2. **kableExtra for Word**: Doesn't support .docx → **Solution**: Use flextable
3. **Inconsistent formatting**: Mixed decimal places → **Solution**: Set digits parameter globally

## Templates
- `templates/gtsummary-table-template.R` - Standard table template

## External Resources
- [gtsummary Website](https://www.danieldsjoberg.com/gtsummary/)
- [tbl_svysummary Reference](https://www.danieldsjoberg.com/gtsummary/reference/tbl_svysummary.html)
- [flextable Book](https://ardata-fr.github.io/flextable-book/)
- [Quick Descriptive Tables for MS Word](https://www.adrianbruegger.com/post/quick-descriptive-tables/)

## Related Areas
- [05-food-security-indicators](../05-food-security-indicators/) - Indicator tables
- [06-income-expenditure](../06-income-expenditure/) - Economic tables
- [08-documentation-standards](../08-documentation-standards/) - Codebook tables
