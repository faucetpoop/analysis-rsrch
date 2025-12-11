# Area 6 – Likert Scales & Psychometric Bits

**Goal:** Treat attitudinal / perception questions correctly and consistently.

---

## Scale Design Best Practices

### Balanced Scale Design
Provide equal options for positive and negative responses:

```r
# 5-point Likert example
# 1 = Strongly Disagree
# 2 = Disagree
# 3 = Neutral
# 4 = Agree
# 5 = Strongly Agree

# Avoid unbalanced scales (e.g., 4 positive, 2 negative options)
```

### Clear Anchors
Define what each point represents in your codebook:

```r
likert_labels <- c(
  "1" = "Strongly Disagree",
  "2" = "Disagree",
  "3" = "Neither Agree nor Disagree",
  "4" = "Agree",
  "5" = "Strongly Agree"
)
```

---

## Coding and Recoding

### Reverse Coding

Some items need to be reversed to ensure consistent direction:

```r
# Reverse code items (for 5-point scale)
# Formula: (max_value + 1) - x
data <- data %>%
  mutate(
    item_3_rev = 6 - item_3,
    item_5_rev = 6 - item_5,
    item_7_rev = 6 - item_7
  )

# Function for flexibility
reverse_code <- function(x, max_value) {
  (max_value + 1) - x
}

# Apply to multiple columns
data <- data %>%
  mutate(across(
    c(item_3, item_5, item_7),
    ~reverse_code(., max_value = 5),
    .names = "{.col}_rev"
  ))
```

---

## Scale Construction

### Sum vs. Average

```r
# Sum method
data <- data %>%
  mutate(
    perception_sum = rowSums(select(., fsp_1:fsp_8), na.rm = FALSE)
  )

# Average method (preferred for scales with missing items)
data <- data %>%
  mutate(
    perception_mean = rowMeans(select(., fsp_1:fsp_8), na.rm = TRUE)
  )
```

### Requiring Minimum Items
```r
data <- data %>%
  rowwise() %>%
  mutate(
    n_items_answered = sum(!is.na(c_across(fsp_1:fsp_8))),

    # Only calculate if at least 6 of 8 items answered
    fsp_mean = if_else(
      n_items_answered >= 6,
      mean(c_across(fsp_1:fsp_8), na.rm = TRUE),
      NA_real_
    )
  ) %>%
  ungroup()
```

---

## Reliability Analysis - Cronbach's Alpha

### Purpose
Assess **internal consistency** - do items measure the same construct?

### Acceptable Values
| Alpha | Interpretation |
|-------|----------------|
| α ≥ 0.90 | Excellent |
| α ≥ 0.80 | Good (target for most research) |
| α ≥ 0.70 | Acceptable |
| α < 0.70 | Questionable - consider removing items |
| α > 0.95 | Possible redundancy |

### Calculation with psych Package
```r
library(psych)

# Select scale items (include reversed items)
scale_items <- data %>%
  select(fsp_1, fsp_2, fsp_3_rev, fsp_4,
         fsp_5_rev, fsp_6, fsp_7_rev, fsp_8)

# Calculate Cronbach's alpha
alpha_result <- alpha(scale_items)

# View results
print(alpha_result)

# Extract key statistics
alpha_result$total$raw_alpha        # Overall alpha
alpha_result$alpha.drop             # Alpha if item dropped
alpha_result$item.stats             # Item-total correlations
```

### Interpreting Output

**"Alpha if item dropped" table:**
- `raw_alpha`: What alpha would be if you removed this item
- If alpha increases substantially, consider removing that item

**Item-total correlation (r.drop):**
- Should be > 0.30
- Low correlations suggest item doesn't fit the scale

### Improving Reliability
```r
# Identify problematic items
problematic <- alpha_result$alpha.drop %>%
  filter(raw_alpha > alpha_result$total$raw_alpha + 0.05)

# Remove item and recalculate
scale_items_revised <- scale_items %>%
  select(-problematic_item_name)

alpha_revised <- alpha(scale_items_revised)

# Compare
cat("Original alpha:", alpha_result$total$raw_alpha, "\n")
cat("Revised alpha:", alpha_revised$total$raw_alpha, "\n")
```

### Sample Size Considerations
- Small sample (<30): Unreliable estimates
- Target: n ≥ 100 for stable estimates
- Desired α = 0.70: Can achieve with n < 30
- Desired α ≥ 0.80: Requires larger samples

---

## Visualization Best Practices

### Using likert Package

```r
library(likert)

# Prepare data - convert to factors with labels
likert_data <- data %>%
  select(fsp_1:fsp_8) %>%
  mutate(across(everything(),
    ~factor(., levels = 1:5,
      labels = c("Strongly Disagree", "Disagree",
                 "Neutral", "Agree", "Strongly Agree")
    )
  ))

# Create likert object
likert_obj <- likert(as.data.frame(likert_data))

# Plot diverging stacked bar chart
plot(likert_obj,
  type = "bar",
  centered = TRUE,
  plot.percent.low = FALSE,   # Important: set to FALSE
  plot.percent.high = FALSE,  # to preserve column order
  plot.percent.neutral = FALSE
)
```

**Known Bug:** Default `plot.percent.*` arguments change variable ordering from column order to alphabetical. Set all to FALSE.

### Using ggplot2

```r
# Calculate percentages
likert_summary <- data %>%
  select(fsp_1:fsp_8) %>%
  pivot_longer(everything(),
    names_to = "item",
    values_to = "response"
  ) %>%
  count(item, response) %>%
  group_by(item) %>%
  mutate(percentage = n / sum(n) * 100)

# Diverging stacked bar chart
ggplot(likert_summary,
  aes(x = item, y = percentage, fill = factor(response))) +
  geom_bar(stat = "identity", position = "stack") +
  coord_flip() +
  scale_fill_brewer(palette = "RdBu",
    labels = c("Strongly Disagree", "Disagree",
               "Neutral", "Agree", "Strongly Agree")
  ) +
  labs(title = "Food Security Perception Scale Responses",
       x = "Item", y = "Percentage", fill = "Response") +
  theme_minimal()
```

---

## Reporting Likert Data

### Item-Level Summaries
```r
item_summary <- data %>%
  select(fsp_1:fsp_8) %>%
  pivot_longer(everything(),
    names_to = "item",
    values_to = "response"
  ) %>%
  group_by(item) %>%
  summarize(
    n = sum(!is.na(response)),
    mean = mean(response, na.rm = TRUE),
    sd = sd(response, na.rm = TRUE),
    median = median(response, na.rm = TRUE),
    mode = as.numeric(names(sort(table(response), decreasing = TRUE)[1]))
  )
```

### Scale-Level Summary
```r
scale_summary <- data %>%
  summarize(
    n = sum(!is.na(fsp_mean)),
    mean = mean(fsp_mean, na.rm = TRUE),
    sd = sd(fsp_mean, na.rm = TRUE),
    median = median(fsp_mean, na.rm = TRUE),
    min = min(fsp_mean, na.rm = TRUE),
    max = max(fsp_mean, na.rm = TRUE),
    cronbach_alpha = alpha_result$total$raw_alpha
  )
```

### Frequency Tables
```r
# Per response category
data %>%
  count(fsp_1) %>%
  mutate(percentage = n / sum(n) * 100)
```

---

## R Packages for Likert Analysis

### likert Package
- **CRAN:** [likert](https://cran.r-project.org/web/packages/likert/)
- **Functions:** `likert()`, `summary.likert()`, `plot.likert()`
- **Visualization:** Diverging stacked bars, heatmaps, density plots

### LikertEZ Package (New - March 2025)
- **CRAN:** [LikertEZ](https://cran.r-project.org/web/packages/LikertEZ/)
- **Features:**
  - Descriptive statistics
  - Relative Importance Index (RII)
  - Built-in reliability analysis (Cronbach's Alpha)
  - Response distribution plots

### psych Package
- **Function:** `alpha()` for reliability
- **Also:** `omega()` for hierarchical factor analysis (more complete than alpha)

---

## Checklist

- [ ] Identify all Likert items in survey
- [ ] Check response option coding (1-5? 1-7?)
- [ ] Identify items needing reverse coding
- [ ] Apply reverse coding to negatively-worded items
- [ ] Calculate scale scores (sum or average)
- [ ] Run Cronbach's alpha on scale
- [ ] Review item-total correlations
- [ ] Consider removing problematic items
- [ ] Create visualizations (diverging stacked bars)
- [ ] Document reliability in methods section

---

## Resources

### Reliability Analysis
- [Cronbach's Alpha Explained](https://www.numberanalytics.com/blog/cronbachs-alpha-explained-7-survey-steps)
- [R for HR: Cronbach's Alpha](https://rforhr.com/cronbachsalpha.html)
- [Statistics by Jim: Cronbach's Alpha](https://statisticsbyjim.com/basics/cronbachs-alpha/)
- [Lisa DeBruine: psych::alpha()](https://debruine.github.io/post/psych-alpha/)

### Visualization
- [On Likert Scales in R](https://jakec007.github.io/2021-06-23-R-likert/)
- [Rigors Data Solutions Likert Guide](https://www.rigordatasolutions.com/post/visualizing-likert-scale-data-with-the-likert-package-in-r-a-practical-guide)
- [R Companion: Plots for Likert Data](https://rcompanion.org/handbook/E_03.html)
- [Design of Diverging Stacked Bar Charts](https://www.researchgate.net/publication/289590282_Design_of_Diverging_Stacked_Bar_Charts_for_Likert_Scales_and_Other_Applications)

### Sample Size
- [Review on Sample Size Determination](https://pmc.ncbi.nlm.nih.gov/articles/PMC6422571/)
