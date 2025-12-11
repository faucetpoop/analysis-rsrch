# Area 5 – Income, Expenditure & Vietnam Monetary Context

**Goal:** Build sensible, interpretable economic indicators from raw money data.

---

## Vietnam Economic Context

### Poverty Measurement Approaches

**Vietnam uses two main approaches:**

1. **Income-based (Government of Vietnam)**
   - Multi-dimensional approach
   - 10 non-monetary dimensions + 1 monetary (income)
   - Separate thresholds for urban/rural

2. **Expenditure-based (World Bank)**
   - Based on household expenditure per capita
   - International poverty lines (PPP-adjusted)

### Current Poverty Lines

**National Statistics (2023-2025):**
- 2023 Poverty Rate: 3.4% of population
- 2025 Target: ~1% multidimensional poverty

**World Bank Benchmarks:**
| Line | Rate (2022) |
|------|-------------|
| Extreme ($2.15/day, 2017 PPP) | <1% |
| Lower-Middle Income ($3.65/day) | 4.2% |
| Upper-Middle Income ($6.85/day) | 19.7% |

**Key Insight:** 1 in 5 Vietnamese remain vulnerable to poverty shocks.

---

## Data Cleaning Best Practices

### Initial Exploration
```r
# Summary statistics
summary(data$income)
summary(data$expenditure)

# Visualize distributions
library(ggplot2)

# Histogram
ggplot(data, aes(x = income)) +
  geom_histogram(bins = 50) +
  scale_x_continuous(labels = scales::comma) +
  labs(title = "Income Distribution")

# Box plot for outliers
ggplot(data, aes(y = income)) +
  geom_boxplot() +
  scale_y_continuous(labels = scales::comma)

# Scatter: expenditure vs income
ggplot(data, aes(x = income, y = expenditure)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = TRUE, color = "red")
```

### Converting to Numeric
```r
# Handle commas and dots in monetary values
data <- data %>%
  mutate(
    income = as.numeric(gsub(",", "", income)),
    expenditure = as.numeric(gsub(",", "", expenditure))
  )
```

---

## Identifying Outliers

### Z-Score Method
```r
data <- data %>%
  mutate(
    income_z = (income - mean(income, na.rm = TRUE)) / sd(income, na.rm = TRUE),
    income_outlier_z = abs(income_z) > 3  # >3 SD
  )
```

### IQR Method
```r
income_q1 <- quantile(data$income, 0.25, na.rm = TRUE)
income_q3 <- quantile(data$income, 0.75, na.rm = TRUE)
income_iqr <- income_q3 - income_q1

data <- data %>%
  mutate(
    income_outlier_iqr = income < (income_q1 - 1.5 * income_iqr) |
                         income > (income_q3 + 1.5 * income_iqr)
  )

# Flag for review
data %>%
  filter(income_outlier_iqr) %>%
  select(household_id, income, province, household_size) %>%
  arrange(desc(income))
```

---

## Outlier Handling Strategies

### 1. Winsorizing (Recommended)
Replace extreme values at specified percentiles:

```r
library(DescTools)

data <- data %>%
  mutate(
    income_winsor = Winsorize(income, probs = c(0.01, 0.99), na.rm = TRUE),
    expenditure_winsor = Winsorize(expenditure, probs = c(0.01, 0.99), na.rm = TRUE)
  )

# Manual winsorization
p01 <- quantile(data$income, 0.01, na.rm = TRUE)
p99 <- quantile(data$income, 0.99, na.rm = TRUE)

data <- data %>%
  mutate(
    income_winsor = case_when(
      income < p01 ~ p01,
      income > p99 ~ p99,
      TRUE ~ income
    )
  )
```

### 2. Log Transformation
For right-skewed distributions:

```r
data <- data %>%
  mutate(
    log_income = log(income + 1),
    log_expenditure = log(expenditure + 1)
  )
```

### 3. Per Capita and Equivalence Scales
```r
# Simple per capita
data <- data %>%
  mutate(
    income_pc = income / household_size,
    expenditure_pc = expenditure / household_size
  )

# OECD equivalence scale
# First adult: 1.0, Additional adults: 0.7, Children (<14): 0.5
data <- data %>%
  mutate(
    equivalence_scale = 1 + (adults - 1) * 0.7 + children * 0.5,
    income_equiv = income / equivalence_scale,
    expenditure_equiv = expenditure / equivalence_scale
  )
```

---

## Poverty Analysis

### Calculating Poverty Status
```r
# Define poverty lines (use official Vietnam values)
poverty_line_rural <- 1000000  # VND per month per capita
poverty_line_urban <- 1300000  # VND per month per capita

data <- data %>%
  mutate(
    poverty_line = if_else(urban == 1, poverty_line_urban, poverty_line_rural),
    poor = expenditure_pc < poverty_line,

    # Poverty gap (depth)
    poverty_gap = pmax(0, poverty_line - expenditure_pc),
    poverty_gap_ratio = poverty_gap / poverty_line,

    # Squared poverty gap (severity)
    poverty_gap_squared = (poverty_gap_ratio)^2
  )
```

### Foster-Greer-Thorbecke (FGT) Measures
```r
poverty_stats <- data %>%
  summarize(
    # FGT0: Headcount ratio
    poverty_rate = mean(poor, na.rm = TRUE) * 100,

    # FGT1: Poverty gap index
    poverty_gap_index = mean(poverty_gap_ratio, na.rm = TRUE) * 100,

    # FGT2: Poverty severity index
    poverty_severity = mean(poverty_gap_squared, na.rm = TRUE) * 100,

    n_poor = sum(poor, na.rm = TRUE),
    n_total = n()
  )
```

---

## Food Expenditure Share

Important indicator for food security (Engel's Law):

```r
data <- data %>%
  mutate(
    food_exp_share = (food_expenditure / total_expenditure) * 100,

    # Higher share indicates lower welfare
    food_poor = food_exp_share > 60  # Example threshold
  )

# Summary by group
data %>%
  group_by(province) %>%
  summarize(
    mean_food_share = mean(food_exp_share, na.rm = TRUE),
    median_food_share = median(food_exp_share, na.rm = TRUE),
    sd_food_share = sd(food_exp_share, na.rm = TRUE)
  )
```

---

## Aggregating Income/Expenditure

### Summing Components
```r
data <- data %>%
  mutate(
    # Food categories
    total_food_exp = rowSums(select(.,
      food_cereals, food_meat, food_fish, food_dairy,
      food_vegetables, food_fruits, food_other
    ), na.rm = TRUE),

    # Non-food categories
    total_nonfood_exp = rowSums(select(.,
      housing, utilities, transport, education, health, clothing
    ), na.rm = TRUE),

    # Verify against reported total
    calculated_total = total_food_exp + total_nonfood_exp,
    exp_mismatch = abs(calculated_total - total_expenditure) > 100
  )

# Investigate mismatches
data %>%
  filter(exp_mismatch) %>%
  select(household_id, total_expenditure, calculated_total)
```

---

## Inequality Measures

```r
library(ineq)

# Gini coefficient
gini_income <- Gini(data$income, na.rm = TRUE)
gini_expenditure <- Gini(data$expenditure, na.rm = TRUE)

# By group
data %>%
  group_by(province) %>%
  summarize(
    gini = Gini(income, na.rm = TRUE),
    mean_income = mean(income, na.rm = TRUE),
    median_income = median(income, na.rm = TRUE)
  )

# Quintile analysis
data <- data %>%
  mutate(
    income_quintile = cut(income,
      breaks = quantile(income, probs = seq(0, 1, 0.2), na.rm = TRUE),
      labels = c("Q1", "Q2", "Q3", "Q4", "Q5"),
      include.lowest = TRUE
    )
  )
```

---

## Methods Section Notes

Document in your methods:
- Currency and reference year (e.g., "all values in VND, 2024 prices")
- Whether income or expenditure used (and why)
- Poverty line sources
- Outlier handling approach
- Per capita vs. equivalence scale

---

## Checklist

- [ ] Convert monetary values to numeric, handling separators
- [ ] Explore distributions with histograms and box plots
- [ ] Identify and flag outliers (Z-score and IQR methods)
- [ ] Decide on outlier handling strategy (document decision)
- [ ] Calculate per capita income and expenditure
- [ ] Apply poverty lines (urban/rural differentiated)
- [ ] Calculate FGT poverty measures
- [ ] Calculate food expenditure share
- [ ] Aggregate income sources and expenditure categories
- [ ] Verify aggregations against reported totals
- [ ] Calculate inequality measures if relevant
- [ ] Document all transformations for methods section

---

## Resources

### Vietnam Poverty
- [World Bank: Demystifying Poverty Measurement in Vietnam](https://documents.worldbank.org/curated/en/923881468303855779/Demystifying-poverty-measurement-in-Vietnam)
- [Vietnam Poverty Targets 2025](https://www.vietnam.vn/en/viet-nam-du-kien-chi-con-khoang-1-ho-ngheo-vao-cuoi-nam-2025)
- [CEIC Vietnam Poverty Statistics](https://www.ceicdata.com/en/vietnam/poverty)

### Methodology
- [World Bank Handbook on Poverty and Inequality](https://documents1.worldbank.org/curated/en/488081468157174849/pdf/483380PUB0Pove101OFFICIAL0USE0ONLY1.pdf)
- [OECD Economic Surveys Vietnam 2025](https://www.oecd.org/en/publications/oecd-economic-surveys-viet-nam-2025_fb37254b-en/)

### Vietnam Data Sources
- [GSO VHLSS 2022 Results](https://www.gso.gov.vn/en/default/2024/04/results-of-the-viet-nam-household-living-standards-survey-2022/)
- [UNU-WIDER VARHS](https://www.wider.unu.edu/database/viet-nam-data)

### R Packages
- [ineq](https://cran.r-project.org/web/packages/ineq/) - Inequality measures
- [DescTools](https://cran.r-project.org/web/packages/DescTools/) - Winsorize and more
