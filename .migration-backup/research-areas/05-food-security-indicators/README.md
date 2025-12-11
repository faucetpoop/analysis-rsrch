# Food Security Indicators - Best Practices Guide

## Quick Reference
- **Purpose**: Correctly compute and interpret food security outcome variables
- **Key Packages**: RM.weights (FIES), psych (reliability), corrplot
- **Related Areas**: [04-data-management](../04-data-management/), [10-reporting](../10-reporting/)
- **Agent-Foreman Features**: `indicators.hdds.calculate`, `indicators.hdds.categorize`, `indicators.fcs.calculate`, `indicators.rcsi.calculate`, `indicators.fies.rasch-model`

## Prerequisites
- [ ] Clean dataset with food consumption variables
- [ ] Understanding of indicator methodologies
- [ ] 24-hour recall data (HDDS) or 7-day data (FCS)

## Core Workflow

### Step 1: Calculate HDDS (12 food groups, 24h recall)
```r
data <- data %>%
  mutate(
    hdds_score = rowSums(select(., cereals:miscellaneous), na.rm = TRUE),
    hdds_category = case_when(
      hdds_score <= 3 ~ "Severely food insecure",
      hdds_score <= 5 ~ "Moderately food insecure",
      hdds_score >= 6 ~ "Food secure"
    )
  )
```

### Step 2: Calculate FCS (weighted, 7-day recall)
```r
data <- data %>%
  mutate(
    fcs_score = (starches_days * 2) + (pulses_days * 3) +
                (vegetables_days * 1) + (fruits_days * 1) +
                (meat_fish_days * 4) + (milk_days * 4) +
                (sugar_days * 0.5) + (oil_days * 0.5),
    fcs_category = case_when(
      fcs_score <= 21 ~ "Poor",
      fcs_score <= 35 ~ "Borderline",
      fcs_score > 35 ~ "Acceptable"
    )
  )
```

### Step 3: Calculate rCSI (weighted coping strategies)
```r
data <- data %>%
  mutate(
    rcsi_score = (less_preferred_days * 1) + (borrow_food_days * 2) +
                 (limit_portion_days * 1) + (restrict_adult_days * 3) +
                 (reduce_meals_days * 1),
    rcsi_category = case_when(
      rcsi_score <= 3 ~ "IPC Phase 1 (Minimal)",
      rcsi_score <= 18 ~ "IPC Phase 2 (Stressed)",
      rcsi_score >= 19 ~ "IPC Phase 3+ (Crisis)"
    )
  )
```

### Step 4: Validate with Correlations
```r
library(corrplot)
indicators <- data %>%
  select(hdds_score, fies_raw_score, fcs_score, rcsi_score)
cor_matrix <- cor(indicators, use = "pairwise.complete.obs")
corrplot(cor_matrix, method = "number")
```

## Checklists

### Before Starting
- [ ] Food consumption questions mapped to food groups
- [ ] Recall period confirmed (24h vs 7 days)
- [ ] Weights for FCS and rCSI verified

### Quality Assurance
- [ ] HDDS calculated (0-12 range)
- [ ] FCS calculated with correct weights
- [ ] rCSI calculated if coping questions available
- [ ] FIES Rasch model validated (if using FIES)
- [ ] Correlations between indicators checked
- [ ] Question-to-indicator mapping documented

## Common Pitfalls
1. **Wrong recall period**: Using 7-day data for HDDS → **Solution**: HDDS uses 24h, FCS uses 7 days
2. **Missing food groups**: Not mapping all survey questions → **Solution**: Complete mapping table
3. **Ignoring FCS adjustments**: Not adjusting for high sugar/oil diets → **Solution**: Add 7 to thresholds if daily sugar AND oil

## Scripts
- `scripts/calculate-hdds.R` - HDDS calculation
- `scripts/calculate-fcs.R` - FCS calculation
- `scripts/calculate-rcsi.R` - rCSI calculation

## Templates
- `templates/indicator-results-template.md` - Document indicator results

## External Resources
- [FANTA HDDS Guide](https://www.fantaproject.org/monitoring-and-evaluation/household-dietary-diversity-score)
- [FAO FIES Documentation](https://www.fao.org/measuring-hunger/access-to-food/about-the-food-insecurity-experience-scale-(fies)/en)
- [WFP FCS Metadata](https://www.wfp.org/publications/meta-data-food-consumption-score-fcs-indicator)
- [FSCluster rCSI Handbook](https://fscluster.org/handbook/Section_two_rcsi.html)

## Related Areas
- [04-data-management](../04-data-management/) - Clean data preparation
- [06-income-expenditure](../06-income-expenditure/) - Economic indicators
- [10-reporting](../10-reporting/) - Results tables
