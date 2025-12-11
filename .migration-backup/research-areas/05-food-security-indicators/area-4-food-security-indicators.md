# Area 4 – Food Security & Dietary Diversity Indicators (HDD + others)

**Goal:** Correctly compute and interpret your key outcome variables.

---

## Household Dietary Diversity Score (HDDS)

### Overview
- **Purpose:** Qualitative measure of food consumption reflecting household economic ability to access diverse foods
- **Recall Period:** 24 hours
- **Food Groups:** 12 groups
- **Use:** Proxy for household food access (not nutritional quality of individual diet)

### 12 Food Groups
1. Cereals
2. Root and tubers
3. Vegetables
4. Fruits
5. Meat, poultry, offal
6. Eggs
7. Fish and seafood
8. Pulses/legumes/nuts
9. Milk and milk products
10. Oil/fats
11. Sugar/honey
12. Miscellaneous

### Calculation
```r
# Map survey questions to food groups (binary: 1=consumed, 0=not)
data <- data %>%
  mutate(
    hdds_score = rowSums(select(., cereals:miscellaneous), na.rm = TRUE),

    # Categorize food security
    hdds_category = case_when(
      hdds_score <= 3 ~ "Severely food insecure",
      hdds_score <= 5 ~ "Moderately food insecure",
      hdds_score >= 6 ~ "Food secure / Mildly food insecure"
    )
  )
```

### Alternative Thresholds
- Low: ≤5 food groups
- Medium: 6-8 food groups
- High: ≥9 food groups

### Important Considerations
- **Timing matters:** Collect baseline and endline at same time of year
- **Avoid fasting periods:** Don't collect during Ramadan, pre-Easter, etc.
- **24-hour recall:** May not capture usual consumption patterns

---

## Food Insecurity Experience Scale (FIES)

### Overview
- **Developer:** FAO (collected through Gallup World Poll)
- **Questions:** 8 items capturing severity of food insecurity
- **Recall Period:** 1 month or 12 months
- **Response Format:** Yes/No for each question
- **Methodology:** Rasch model (Item Response Theory)

### 8 FIES Questions
1. Worried about food
2. Unable to eat healthy
3. Ate only few kinds of foods
4. Had to skip a meal
5. Ate less than should
6. Ran out of food
7. Were hungry but didn't eat
8. Went whole day without eating

### R Implementation with RM.weights
```r
library(RM.weights)

fies_items <- c(
  "fies_worried", "fies_healthy", "fies_fewfoods", "fies_skipped",
  "fies_ateless", "fies_ranout", "fies_hungry", "fies_wholeday"
)

# Calculate raw score (0-8)
data <- data %>%
  mutate(
    fies_raw_score = rowSums(select(., all_of(fies_items)), na.rm = TRUE)
  )

# For Rasch model analysis - requires FAO's statistical module
# See RM.weights documentation for full implementation
```

### Validation Checks
Statistical validation tests for:
- Items that don't perform well
- Cases with erratic response patterns
- Redundant item pairs
- Proportion of variance explained by model

### SDG Indicator 2.1.2
- Proportion with moderate or severe food insecurity
- Proportion with severe food insecurity

---

## Household Food Insecurity Access Scale (HFIAS)

### Overview
- **Developer:** USAID FANTA (2001-2006)
- **Questions:** 9 questions with frequency (0-3 scale)
- **Scoring:** Sum of frequencies, range 0-27
- **Recall Period:** Past 4 weeks

### Frequency Coding
- 0 = Never (did not occur)
- 1 = Rarely (1-2 times in past 4 weeks)
- 2 = Sometimes (3-10 times)
- 3 = Often (>10 times)

### Calculation
```r
hfias_items <- c(
  "hfias_q1",  # Worry about food
  "hfias_q2",  # Unable to eat preferred foods
  "hfias_q3",  # Eat limited variety
  "hfias_q4",  # Eat unwanted foods
  "hfias_q5",  # Eat smaller meals
  "hfias_q6",  # Eat fewer meals
  "hfias_q7",  # No food in house
  "hfias_q8",  # Go to bed hungry
  "hfias_q9"   # Go whole day without eating
)

data <- data %>%
  mutate(
    hfias_score = rowSums(select(., all_of(hfias_items)), na.rm = TRUE)
  )
```

### Categories
See FANTA guide for full categorization algorithm:
- Food Secure
- Mildly Food Insecure Access
- Moderately Food Insecure Access
- Severely Food Insecure Access

---

## Food Consumption Score (FCS)

### Overview
- **Developer:** WFP (World Food Programme)
- **Recall Period:** 7 days
- **Method:** Frequency-weighted dietary diversity

### Food Group Weights
| Group | Weight |
|-------|--------|
| Starches | 2 |
| Pulses | 3 |
| Vegetables | 1 |
| Fruits | 1 |
| Meat/Fish | 4 |
| Milk | 4 |
| Sugar | 0.5 |
| Oil | 0.5 |

### Calculation
```r
data <- data %>%
  mutate(
    fcs_score =
      (starches_days * 2) +
      (pulses_days * 3) +
      (vegetables_days * 1) +
      (fruits_days * 1) +
      (meat_fish_days * 4) +
      (milk_days * 4) +
      (sugar_days * 0.5) +
      (oil_days * 0.5),

    # Standard cutoffs
    fcs_category = case_when(
      fcs_score <= 21 ~ "Poor",
      fcs_score <= 35 ~ "Borderline",
      fcs_score > 35 ~ "Acceptable"
    )
  )
```

### Adjusted Cutoffs (for sugar/oil-rich diets)
If sugar AND oil consumed daily, add 7 to thresholds:
- Poor: <28
- Borderline: 28-42
- Acceptable: >42

---

## Reduced Coping Strategies Index (rCSI)

### Overview
- **Questions:** 5 strategies about food consumption coping
- **Recall Period:** Past 7 days
- **Method:** Frequency-weighted sum

### Questions and Weights
| Strategy | Weight |
|----------|--------|
| Rely on less preferred foods | 1 |
| Borrow food or rely on help | 2 |
| Limit portion size | 1 |
| Restrict adult consumption for children | 3 |
| Reduce number of meals | 1 |

### Calculation
```r
data <- data %>%
  mutate(
    rcsi_score =
      (less_preferred_days * 1) +
      (borrow_food_days * 2) +
      (limit_portion_days * 1) +
      (restrict_adult_days * 3) +
      (reduce_meals_days * 1),

    # IPC Phase classification
    rcsi_category = case_when(
      rcsi_score <= 3 ~ "IPC Phase 1 (Minimal)",
      rcsi_score <= 18 ~ "IPC Phase 2 (Stressed)",
      rcsi_score >= 19 ~ "IPC Phase 3+ (Crisis or worse)"
    )
  )
```

---

## Correlations Between Indicators

Research shows:
- **High correlations:** CSI, rCSI, and HFIAS (all measure coping/experience)
- **Moderate correlations:** FCS with HFIAS/CSI (FCS measures dietary diversity)
- **Use complementary indicators** for comprehensive assessment

```r
library(corrplot)

indicators <- data %>%
  select(hdds_score, fies_raw_score, hfias_score,
         fcs_score, rcsi_score)

cor_matrix <- cor(indicators, use = "pairwise.complete.obs")
corrplot(cor_matrix, method = "number")
```

---

## Quality Checks

```r
# Distribution checks
summary(data$hdds_score)
hist(data$hdds_score)

# Internal consistency
# For FIES items
library(psych)
alpha(data %>% select(fies_worried:fies_wholeday))

# Weird values
data %>%
  filter(hdds_score < 0 | hdds_score > 12) %>%
  select(household_id, hdds_score)
```

---

## Checklist

- [ ] Map survey questions to HDDS food groups
- [ ] Calculate HDDS score and categories
- [ ] Identify which food insecurity scale is in survey (FIES, HFIAS, or both)
- [ ] Calculate food insecurity scores
- [ ] If using FIES, consider Rasch model validation with RM.weights
- [ ] Calculate FCS if 7-day food frequency data available
- [ ] Calculate rCSI if coping strategies questions available
- [ ] Run correlation analysis between indicators
- [ ] Document question-to-indicator mapping for methods section

---

## Resources

### HDDS
- [FAO Guidelines for Measuring Dietary Diversity](https://www.fao.org/4/i1983e/i1983e00.pdf)
- [INDDEX HDDS Page](https://inddex.nutrition.tufts.edu/data4diets/indicator/household-dietary-diversity-score-hdds)
- [FANTA HDDS Guide](https://www.fantaproject.org/monitoring-and-evaluation/household-dietary-diversity-score)

### FIES
- [FAO FIES About Page](https://www.fao.org/measuring-hunger/access-to-food/about-the-food-insecurity-experience-scale-(fies)/en)
- [RM.weights CRAN](https://cran.r-project.org/web/packages/RM.weights/index.html)
- [Manual for RM.weights](https://www.sesric.org/imgs/news/1752_Manual_on_RM_Weights_Package_EN.pdf)
- [SDG 2.1.2 e-Learning](https://elearning.fao.org/pluginfile.php/491591/mod_scorm/content/5/story_content/external_files/SDG2.1.2_lesson4.pdf)

### FCS & rCSI
- [WFP FCS Metadata](https://www.wfp.org/publications/meta-data-food-consumption-score-fcs-indicator)
- [FSCluster FCS Handbook](https://fscluster.org/handbook/Section_two_fcs.html)
- [FSCluster rCSI Handbook](https://fscluster.org/handbook/Section_two_rcsi.html)
- [WFP RBD Guide (Chapters 4-6)](https://wfp-vam.github.io/RBD_FS_CH_guide_EN/)

### WFP R Resources
- [WFP-VAM GitHub](https://github.com/WFP-VAM)
- [wfpthemes Package](https://github.com/WFP-VAM/wfpthemes)

### Comparative Studies
- [FANTA Household Food Consumption Indicators Study](https://www.fantaproject.org/sites/default/files/resources/HFCIS-report-Dec2015.pdf)
