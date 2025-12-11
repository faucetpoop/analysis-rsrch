# Area 9 – Descriptives & Reporting Strategy

**Goal:** Know how you want to summarise and present everything.

---

## gtsummary Package for Survey Research

### Why gtsummary?

- **Publication-ready tables** with minimal code
- **Survey-specific function:** `tbl_svysummary()` for weighted data
- **Automatic variable detection:** Continuous, categorical, dichotomous
- **Missing data reporting** included by default
- **Customizable output:** HTML, LaTeX, Word, Excel
- **Reproducible workflow** - no manual table editing

### Setup
```r
library(gtsummary)
library(gt)
library(survey)
library(srvyr)

# Set theme for consistent styling
theme_gtsummary_compact()

# Or journal-specific theme
theme_gtsummary_journal("jama")
```

---

## Table 1: Baseline Characteristics

### Basic Table 1
```r
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
      hdds_score ~ "Dietary diversity score",
      food_secure ~ "Food secure"
    ),
    missing = "no"
  ) %>%
  modify_caption("**Table 1. Baseline Household Characteristics**") %>%
  bold_labels()
```

### Table 1 with Group Comparison
```r
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
    )
  ) %>%
  add_n() %>%
  add_p() %>%
  modify_spanning_header(c("stat_1", "stat_2") ~
                         "**Food Security Status**") %>%
  bold_labels() %>%
  bold_p(t = 0.05)
```

### Table 1 with Survey Weights
```r
# Create survey design
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
    )
  ) %>%
  add_n() %>%
  add_p() %>%
  add_overall() %>%
  modify_footnote(
    all_stat_cols() ~ "Estimates account for survey design"
  )
```

---

## Customizing Statistics

```r
table_custom <- survey_data %>%
  tbl_summary(
    statistic = list(
      # Different formats per variable type
      age ~ "{mean} ({sd}) | {median} ({p25}, {p75})",
      income_pc ~ "{median} ({p25}, {p75})",
      food_secure ~ "{n} / {N} ({p}%)",
      all_categorical() ~ "{n} ({p}%)"
    ),
    digits = list(
      age ~ c(1, 1, 1, 1, 1),
      income_pc ~ c(0, 0, 0)
    )
  )
```

---

## Regression Results Tables

```r
# Logistic regression
model <- design %>%
  svyglm(
    food_secure ~ age + gender + education + household_size +
                 income_pc + urban + province,
    design = .,
    family = quasibinomial()
  )

# Create table
tbl_regression(
  model,
  exponentiate = TRUE,  # Show odds ratios
  label = list(
    age ~ "Age (years)",
    gender ~ "Gender (ref: Male)",
    education ~ "Education level",
    income_pc ~ "Per capita income (1000 VND)",
    urban ~ "Urban residence (ref: Rural)"
  )
) %>%
  add_global_p() %>%
  bold_p(t = 0.05) %>%
  modify_caption("**Table 3. Determinants of Food Security**")
```

---

## Combining Tables

### Merge Multiple Models
```r
tbl_merge(
  tbls = list(
    model1 %>% tbl_regression(),
    model2 %>% tbl_regression(),
    model3 %>% tbl_regression()
  ),
  tab_spanner = c("**Model 1**", "**Model 2**", "**Model 3**")
) %>%
  modify_caption("**Table 4. Progressive Model Comparison**")
```

### Stack Tables
```r
tbl_stack(
  tbls = list(table1_food_secure, table1_diet_diverse),
  group_header = c("Food Security", "Dietary Diversity")
)
```

---

## Export Options

```r
# To Word (recommended)
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

**Note:** kableExtra does NOT support Word (.docx). Use flextable for Word output.

---

## Descriptive Statistics Patterns

### Socio-Demographics
```r
data %>%
  tbl_summary(
    include = c(age, gender, education, household_size, urban, province),
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    )
  )
```

### Indicators (HDDS, FI, Income)
```r
data %>%
  tbl_summary(
    include = c(hdds_score, fies_raw, income_pc, food_exp_share),
    statistic = list(
      all_continuous() ~ "{mean} ({sd}); Median: {median} (IQR: {p25}-{p75})"
    )
  )
```

### Likert Scale Results
```r
# Item-level frequencies
data %>%
  select(starts_with("fsp_")) %>%
  tbl_summary(
    type = everything() ~ "categorical",
    statistic = all_categorical() ~ "{n} ({p}%)"
  )
```

---

## Narrative Style

### Phrasing Findings
- "X% of households..."
- "The mean HDDS was X (SD = Y)..."
- "Households in urban areas were significantly more likely to..."
- "After adjusting for..., the odds of food security were X times higher..."

### Integrating Context
- Compare to national statistics
- Reference prior Vietnam studies
- Acknowledge regional variation

### Example Paragraph
> "Among the 1,050 surveyed households, 23.4% were classified as food insecure based on the HDDS cutoff of ≤5 food groups. The mean HDDS was 7.2 (SD = 2.1), which is comparable to the 7.5 reported in the 2024 VARHS study. Urban households had significantly higher dietary diversity (mean = 7.8) compared to rural households (mean = 6.6, p < 0.001)."

---

## Standard Table Layouts

### Table 1: Sample Characteristics
- Demographics (age, gender, education)
- Household characteristics (size, urban/rural)
- Geographic distribution (province)

### Table 2: Food Security Indicators
- HDDS scores and categories
- FIES/HFIAS scores and categories
- FCS and rCSI if applicable

### Table 3: Economic Indicators
- Income (total, per capita)
- Expenditure (food, non-food, share)
- Poverty status

### Table 4: Bivariate Analysis
- Characteristics by food security status
- P-values for group comparisons

### Table 5: Regression Results
- Odds ratios with 95% CI
- Progressive models (unadjusted → fully adjusted)

---

## Best Practices for Thesis Tables

### Consistent Formatting
```r
# Use same number of decimal places
digits = list(
  all_continuous() ~ 1,
  all_categorical() ~ c(0, 1)  # n, %
)
```

### Clear Captions
```r
modify_caption("**Table 1.** Baseline Household Characteristics (N = 1,050)")
```

### Informative Footnotes
```r
modify_footnote(
  all_stat_cols() ~ "Values are mean (SD) for continuous and n (%) for categorical",
  p.value ~ "P-values from chi-square (categorical) or t-test (continuous)"
)
```

---

## Citation

When using gtsummary in publications:
```r
citation("gtsummary")

# Cite as:
# Sjoberg DD, Whiting K, Curry M, Lavery JA, Larmarange J.
# Reproducible summary tables with the gtsummary package.
# The R Journal 2021;13:570-80.
# https://doi.org/10.32614/RJ-2021-053
```

---

## Checklist

- [ ] Install gtsummary, gt, flextable
- [ ] Set up consistent table theme
- [ ] Create Table 1 (sample characteristics)
- [ ] Create weighted tables if using survey design
- [ ] Build comparison tables (by food security status)
- [ ] Create regression results tables
- [ ] Export tables to Word for thesis
- [ ] Write narrative summaries for each table
- [ ] Ensure consistent decimal places and formatting
- [ ] Add proper captions and footnotes

---

## Resources

### gtsummary
- [gtsummary Website](https://www.danieldsjoberg.com/gtsummary/)
- [tbl_summary Tutorial](https://www.danieldsjoberg.com/gtsummary/articles/tbl_summary.html)
- [tbl_svysummary Reference](https://www.danieldsjoberg.com/gtsummary/reference/tbl_svysummary.html)
- [R Journal Article](https://journal.r-project.org/articles/RJ-2021-053/)

### Table Export
- [Quick Descriptive Tables for MS Word](https://www.adrianbruegger.com/post/quick-descriptive-tables/)
- [UCLA Output Tables in R](https://stats.oarc.ucla.edu/wp-content/uploads/2024/08/Table_R_seminar.html)
- [Alternative to kable for Word](https://taehoonh.me/content/post/alternative-to-kable-function-when-knitting-to-ms-word.html)

### Other Table Packages
- [flextable](https://ardata-fr.github.io/flextable-book/)
- [gt](https://gt.rstudio.com/)
- [kableExtra](https://haozhu233.github.io/kableExtra/)
