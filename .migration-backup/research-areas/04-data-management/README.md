# Raw Data Management - Best Practices Guide

## Quick Reference
- **Purpose**: Create one clean, trustworthy analysis dataset
- **Key Packages**: naniar, mice, missForest
- **Related Areas**: [03-kobo-xlsform](../03-kobo-xlsform/), [05-food-security-indicators](../05-food-security-indicators/)
- **Agent-Foreman Features**: `data-cleaning.versions.merge-ab`, `data-cleaning.multiselect.process`, `data-cleaning.missing.classify`

## Prerequisites
- [ ] Raw data files from KoboToolbox
- [ ] Understanding of survey versions (A vs B)
- [ ] XLSForm with skip logic documentation

## Core Workflow

### Step 1: Compare Survey Versions
```r
# List column differences
setdiff(names_b, names_a)  # Columns only in B
setdiff(names_a, names_b)  # Columns only in A
intersect(names_a, names_b) # Common columns
```

### Step 2: Merge Versions with Indicator
```r
data_combined <- bind_rows(
  data_a %>% mutate(survey_version = "A"),
  data_b %>% mutate(survey_version = "B")
) %>%
  mutate(fw_not_collected = survey_version == "A")
```

### Step 3: Classify Missingness Types
```r
# 1. Structural (by design) - DO NOT IMPUTE
# 2. Non-response (should exist but missing)
# 3. User-defined codes (-77=refused, -88=don't know)

data <- data %>%
  mutate(
    fw_structural_na = is.na(fw_behavior) & survey_version == "A",
    fw_nonresponse = is.na(fw_behavior) & survey_version == "B"
  )
```

### Step 4: Analyze Missingness Patterns
```r
library(naniar)
data %>% miss_var_summary()
vis_miss(data)
```

### Step 5: Document and Save
```r
saveRDS(survey_clean, "data/processed/survey_clean.rds")
```

## Checklists

### Before Starting
- [ ] All raw data files identified
- [ ] Version differences documented
- [ ] Skip logic patterns from XLSForm

### Quality Assurance
- [ ] Structures of Version A and B compared
- [ ] Variable names and types harmonized
- [ ] Structural NA flags created
- [ ] User-defined missing values recoded
- [ ] Missingness summary table generated
- [ ] Imputation strategy documented (if used)

## Common Pitfalls
1. **Imputing structural NAs**: Filling in data that shouldn't exist → **Solution**: Flag and exclude from imputation
2. **Ignoring version differences**: Treating all NAs the same → **Solution**: Add version indicator column
3. **No documentation**: Forgetting cleaning decisions → **Solution**: Create cleaning log

## Templates
- `templates/data-cleaning-log-template.md` - Document cleaning decisions

## External Resources
- [Tidy Survey Book - Missing Data](https://tidy-survey-r.github.io/tidy-survey-book/c11-missing-data.html)
- [The Turing Way - Structured Missingness](https://book.the-turing-way.org/project-design/missing-data/missing-data-structured-missingness/)
- [naniar Package](https://cran.r-project.org/web/packages/naniar/)

## Related Areas
- [03-kobo-xlsform](../03-kobo-xlsform/) - Understanding data structure
- [05-food-security-indicators](../05-food-security-indicators/) - Calculating indicators from clean data
- [08-documentation-standards](../08-documentation-standards/) - Codebook with missingness docs
