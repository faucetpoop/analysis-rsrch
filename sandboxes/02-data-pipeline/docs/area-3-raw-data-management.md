# Area 3 – Raw Data Management: Versions, Missingness, Multi-Select

**Goal:** Have one clean, trustworthy analysis dataset.

---

## Merging Survey Versions (A & B)

### Your Context
- **Version A:** Without food waste questions
- **Version B:** With food waste questions
- Both are single data sheets
- Missing food waste in A = "not collected", not "don't know"

### Comparing Structures
```r
# List column names in each version
names_a <- names(data_a)
names_b <- names(data_b)

# Find differences
setdiff(names_b, names_a)  # Columns only in B
setdiff(names_a, names_b)  # Columns only in A
intersect(names_a, names_b) # Common columns

# Compare types for common columns
compare_types <- tibble(
  variable = intersect(names_a, names_b),
  type_a = map_chr(data_a[variable], class),
  type_b = map_chr(data_b[variable], class)
) %>%
  filter(type_a != type_b)
```

### Harmonising and Binding
```r
# Ensure consistent types
data_a <- data_a %>%
  mutate(across(where(is.character), as.character))

data_b <- data_b %>%
  mutate(across(where(is.character), as.character))

# Bind rows (extra FW columns in B will be NA for A)
data_combined <- bind_rows(
  data_a %>% mutate(survey_version = "A"),
  data_b %>% mutate(survey_version = "B")
)

# Document: FW missing in A = "not collected"
data_combined <- data_combined %>%
  mutate(
    fw_not_collected = survey_version == "A"
  )
```

---

## Types of Missingness

### 1. Structural Missingness (Missing by Design)

**Definition:** Intentionally missing due to skip logic or logical structure

**Examples:**
- "Age of youngest child" for respondents without children
- Food waste questions for Version A respondents
- Response-contingent questions properly skipped

**Handling:**
- **Do NOT impute** - this is not a flaw
- Filter appropriately before analysis
- Document in codebook

### 2. Non-Response Missingness

**Definition:** Should exist but missing due to refusal, don't know, or error

**Types:**
- Item non-response (specific questions skipped)
- Unit non-response (entire survey not completed)
- Partial response (survey started but not finished)

### 3. User-Defined Missing Values

Track **why** items are missing:

```r
# Common missing value codes
data <- data %>%
  mutate(
    income_clean = case_when(
      income == -77 ~ NA_real_,  # Refused
      income == -88 ~ NA_real_,  # Don't know
      income == -99 ~ NA_real_,  # Not applicable
      TRUE ~ income
    ),
    income_missing_reason = case_when(
      income == -77 ~ "refused",
      income == -88 ~ "dont_know",
      income == -99 ~ "not_applicable",
      is.na(income) ~ "no_response",
      TRUE ~ "valid"
    )
  )
```

---

## Analyzing Missingness Patterns

### Using naniar Package
```r
library(naniar)

# Overall missingness
data %>% miss_var_summary()    # By variable
data %>% miss_case_summary()   # By case

# Visualize patterns
vis_miss(data)

# By group
data %>%
  group_by(province) %>%
  miss_var_summary()
```

### Distinguishing Structural from Non-Response
```r
data <- data %>%
  mutate(
    # Structural: skipped due to version or logic
    fw_structural_na = is.na(fw_behavior) & survey_version == "A",

    # True missing: should have answered but didn't
    fw_nonresponse = is.na(fw_behavior) & survey_version == "B"
  )

# Report missingness by type
data %>%
  summarize(
    n_structural = sum(fw_structural_na),
    n_nonresponse = sum(fw_nonresponse),
    pct_nonresponse = mean(fw_nonresponse) * 100
  )
```

---

## Multi-Select Handling

### Interpreting 0/1 Columns
```r
# From KoboToolbox export, select_multiple becomes:
# food_source.market = 1 (selected) or 0 (not selected)
# food_source.garden = 1 or 0
# etc.

# Count selections per respondent
data <- data %>%
  mutate(
    n_food_sources = rowSums(select(., starts_with("food_source.")))
  )
```

### Reshaping Wide to Long
```r
# Wide format (columns per option)
data_long <- data %>%
  pivot_longer(
    cols = starts_with("food_source."),
    names_to = "source_type",
    names_prefix = "food_source.",
    values_to = "selected"
  ) %>%
  filter(selected == 1)
```

### Calculating Percentages
```r
# Per option (% of respondents who selected)
data %>%
  summarize(across(
    starts_with("food_source."),
    ~mean(. == 1, na.rm = TRUE) * 100,
    .names = "pct_{.col}"
  ))
```

---

## Missing Data Strategy Decision Tree

### Do NOT Impute When:
- Structural missingness (skip logic, version differences)
- Missing Not At Random (MNAR) with unknown mechanism
- High missingness (>40-50%) on key variables
- Pattern indicates data quality issues

### Consider Imputation When:
- Missing Completely At Random (MCAR) or Missing At Random (MAR)
- Low to moderate missingness (<20%)
- Variable is important predictor in models
- Multiple variables with correlated missingness

---

## Imputation Methods

### Multiple Imputation (MICE)
```r
library(mice)

imputed_data <- mice(
  data = survey_data,
  m = 5,                    # Number of imputations
  method = "pmm",           # Predictive mean matching
  maxit = 50,               # Iterations
  seed = 123
)

# Analyze each imputed dataset
models <- with(imputed_data,
               lm(food_security ~ income + education))

# Pool results
pooled_results <- pool(models)
summary(pooled_results)
```

### Random Forest (missForest)
```r
library(missForest)

imputed <- missForest(
  xmis = survey_data,
  maxiter = 10,
  ntree = 100
)

data_complete <- imputed$ximp
imputed$OOBerror  # Check error
```

---

## Building Master Dataset

### Workflow
1. Import all data versions
2. Compare and harmonize structures
3. Bind rows with version indicator
4. Create structural NA flags
5. Recode user-defined missing values
6. Document all decisions
7. Save processed data

```r
# Save intermediate results
saveRDS(survey_clean, "data/processed/survey_clean.rds")

# Load back
survey_clean <- readRDS("data/processed/survey_clean.rds")
```

---

## Documentation Requirements

Always document:
1. **Missingness rates** for all variables
2. **Patterns** of missingness (correlations)
3. **Reasons** for missingness (when coded)
4. **Decisions** made (impute vs. exclude)
5. **Methods** used for imputation
6. **Sensitivity analyses** comparing complete-case vs. imputed

### Create Missingness Summary Table
```r
missing_summary <- data %>%
  summarize(across(
    everything(),
    list(
      n_missing = ~sum(is.na(.)),
      pct_missing = ~mean(is.na(.)) * 100
    )
  )) %>%
  pivot_longer(
    everything(),
    names_to = c("variable", ".value"),
    names_pattern = "(.+)_(n_missing|pct_missing)"
  )
```

---

## Checklist

- [ ] Compare structures of Version A and B
- [ ] Harmonize variable names and types
- [ ] Bind rows with version indicator
- [ ] Create structural NA flags (skip logic, version differences)
- [ ] Recode user-defined missing values (-77, -88, -99)
- [ ] Generate missingness summary table
- [ ] Document all multi-select variables and their handling
- [ ] Decide imputation strategy for each variable with missingness
- [ ] Save clean master dataset with documentation

---

## Resources

### Missing Data
- [Tidy Survey Book - Missing Data](https://tidy-survey-r.github.io/tidy-survey-book/c11-missing-data.html)
- [The Turing Way - Structured Missingness](https://book.the-turing-way.org/project-design/missing-data/missing-data-structured-missingness/)
- [Princeton Missing Data Guide](https://libguides.princeton.edu/R-Missingdata)

### Packages
- [naniar](https://cran.r-project.org/web/packages/naniar/)
- [mice](https://cran.r-project.org/web/packages/mice/)
- [missForest](https://cran.r-project.org/web/packages/missForest/)
