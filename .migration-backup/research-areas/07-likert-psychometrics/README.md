# Likert Scales & Psychometrics - Best Practices Guide

## Quick Reference
- **Purpose**: Correctly analyze attitudinal/perception survey questions
- **Key Packages**: psych (alpha), likert (visualization), LikertEZ
- **Related Areas**: [04-data-management](../04-data-management/), [10-reporting](../10-reporting/)
- **Agent-Foreman Features**: `likert.coding.recode-scales`, `likert.reliability.cronbach-alpha`, `likert.visualization.diverging-bars`

## Prerequisites
- [ ] Likert items identified in survey
- [ ] Response scale documented (1-5, 1-7, etc.)
- [ ] Items requiring reverse coding identified

## Core Workflow

### Step 1: Identify Items Needing Reverse Coding
Negatively-worded items need reversal for consistent direction:
```r
# Reverse code for 5-point scale: (max + 1) - x
reverse_code <- function(x, max_value) (max_value + 1) - x

data <- data %>%
  mutate(across(
    c(item_3, item_5, item_7),
    ~reverse_code(., max_value = 5),
    .names = "{.col}_rev"
  ))
```

### Step 2: Calculate Scale Scores
```r
# Average method (handles missing items)
data <- data %>%
  mutate(perception_mean = rowMeans(select(., fsp_1:fsp_8), na.rm = TRUE))

# Require minimum items answered
data <- data %>%
  rowwise() %>%
  mutate(
    n_items = sum(!is.na(c_across(fsp_1:fsp_8))),
    fsp_mean = if_else(n_items >= 6,
                       mean(c_across(fsp_1:fsp_8), na.rm = TRUE),
                       NA_real_)
  ) %>% ungroup()
```

### Step 3: Assess Reliability (Cronbach's Alpha)
```r
library(psych)

scale_items <- data %>%
  select(fsp_1, fsp_2, fsp_3_rev, fsp_4, fsp_5_rev, fsp_6, fsp_7_rev, fsp_8)

alpha_result <- alpha(scale_items)
print(alpha_result)

# Target: alpha >= 0.70 (acceptable), >= 0.80 (good)
# Check "alpha if item dropped" for problematic items
```

### Step 4: Create Visualizations
```r
library(likert)

likert_data <- data %>%
  select(fsp_1:fsp_8) %>%
  mutate(across(everything(),
    ~factor(., levels = 1:5,
      labels = c("Strongly Disagree", "Disagree", "Neutral", "Agree", "Strongly Agree"))
  ))

likert_obj <- likert(as.data.frame(likert_data))

# IMPORTANT: Set plot.percent.* = FALSE to preserve column order
plot(likert_obj, type = "bar", centered = TRUE,
     plot.percent.low = FALSE, plot.percent.high = FALSE, plot.percent.neutral = FALSE)
```

## Checklists

### Before Starting
- [ ] All Likert items identified
- [ ] Response coding documented (1-5? 1-7?)
- [ ] Negatively-worded items identified

### Quality Assurance
- [ ] Reverse coding applied where needed
- [ ] Scale scores calculated
- [ ] Cronbach's alpha >= 0.70
- [ ] Item-total correlations > 0.30
- [ ] Problematic items reviewed/removed
- [ ] Visualizations created
- [ ] Reliability documented in methods

## Common Pitfalls
1. **Forgetting reverse coding**: Mixing item directions → **Solution**: Apply formula before summing
2. **Using sum with missing data**: Getting lower scores for incomplete responses → **Solution**: Use mean with minimum items required
3. **Likert plot ordering bug**: Items reordered alphabetically → **Solution**: Set plot.percent.* = FALSE

## Scripts
- `scripts/reliability-analysis.R` - Cronbach's alpha calculation

## External Resources
- [Statistics by Jim: Cronbach's Alpha](https://statisticsbyjim.com/basics/cronbachs-alpha/)
- [On Likert Scales in R](https://jakec007.github.io/2021-06-23-R-likert/)
- [psych::alpha() Guide](https://debruine.github.io/post/psych-alpha/)

## Related Areas
- [04-data-management](../04-data-management/) - Variable creation
- [08-documentation-standards](../08-documentation-standards/) - Scale documentation
- [10-reporting](../10-reporting/) - Results tables
