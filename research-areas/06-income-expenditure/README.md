# Income & Expenditure Analysis - Best Practices Guide

## Quick Reference
- **Purpose**: Build sensible economic indicators from monetary data
- **Key Packages**: DescTools (winsorize), ineq (Gini)
- **Related Areas**: [04-data-management](../04-data-management/), [05-food-security-indicators](../05-food-security-indicators/)
- **Agent-Foreman Features**: `economics.income.aggregate`, `economics.expenditure.calculate-shares`, `economics.outliers.detect-handle`, `economics.benchmarks.vietnam-poverty`

## Prerequisites
- [ ] Raw income and expenditure data
- [ ] Vietnam poverty line values
- [ ] Understanding of urban/rural distinctions

## Core Workflow

### Step 1: Convert to Numeric and Explore
```r
data <- data %>%
  mutate(
    income = as.numeric(gsub(",", "", income)),
    expenditure = as.numeric(gsub(",", "", expenditure))
  )

# Visualize
ggplot(data, aes(x = income)) + geom_histogram(bins = 50)
ggplot(data, aes(y = income)) + geom_boxplot()
```

### Step 2: Identify and Handle Outliers
```r
# IQR method
income_q1 <- quantile(data$income, 0.25, na.rm = TRUE)
income_q3 <- quantile(data$income, 0.75, na.rm = TRUE)
income_iqr <- income_q3 - income_q1

data <- data %>%
  mutate(income_outlier = income < (income_q1 - 1.5 * income_iqr) |
                          income > (income_q3 + 1.5 * income_iqr))

# Winsorize (recommended)
library(DescTools)
data <- data %>%
  mutate(income_winsor = Winsorize(income, probs = c(0.01, 0.99), na.rm = TRUE))
```

### Step 3: Calculate Per Capita Values
```r
data <- data %>%
  mutate(
    income_pc = income / household_size,
    expenditure_pc = expenditure / household_size
  )
```

### Step 4: Apply Poverty Lines
```r
poverty_line_rural <- 1000000  # VND/month/capita
poverty_line_urban <- 1300000

data <- data %>%
  mutate(
    poverty_line = if_else(urban == 1, poverty_line_urban, poverty_line_rural),
    poor = expenditure_pc < poverty_line,
    poverty_gap_ratio = pmax(0, poverty_line - expenditure_pc) / poverty_line
  )
```

### Step 5: Calculate Food Expenditure Share
```r
data <- data %>%
  mutate(
    food_exp_share = (food_expenditure / total_expenditure) * 100,
    food_poor = food_exp_share > 60
  )
```

## Checklists

### Before Starting
- [ ] Monetary values identified in dataset
- [ ] Currency and time period documented
- [ ] Poverty line sources identified

### Quality Assurance
- [ ] Values converted to numeric
- [ ] Distributions visualized
- [ ] Outliers identified and flagged
- [ ] Handling strategy documented (winsorize, log, etc.)
- [ ] Per capita values calculated
- [ ] Poverty status calculated
- [ ] Food expenditure share calculated
- [ ] Aggregations verified against totals

## Common Pitfalls
1. **Ignoring separators**: Commas causing numeric conversion errors → **Solution**: Use gsub to remove
2. **Not adjusting for household size**: Comparing total income across different sizes → **Solution**: Calculate per capita
3. **Using wrong poverty line**: Not differentiating urban/rural → **Solution**: Apply location-specific lines

## Templates
- `templates/expenditure-analysis-template.md` - Document economic analysis

## External Resources
- [World Bank: Demystifying Poverty Measurement in Vietnam](https://documents.worldbank.org/curated/en/923881468303855779/Demystifying-poverty-measurement-in-Vietnam)
- [OECD Economic Surveys Vietnam 2025](https://www.oecd.org/en/publications/oecd-economic-surveys-viet-nam-2025_fb37254b-en/)
- [Vietnam Poverty Targets 2025](https://www.vietnam.vn/en/viet-nam-du-kien-chi-con-khoang-1-ho-ngheo-vao-cuoi-nam-2025)

## Related Areas
- [04-data-management](../04-data-management/) - Data cleaning
- [05-food-security-indicators](../05-food-security-indicators/) - Complementary indicators
- [10-reporting](../10-reporting/) - Results presentation
