# Construct-Question Mapping Table

## Instructions
Map each analytic construct to the survey questions that measure it.
This table serves as documentation for your methods section.

---

## Construct Mapping

| Construct | Survey Questions | Transformation | Indicator | Notes |
|-----------|-----------------|----------------|-----------|-------|
| **Dietary Diversity** | D1-D12 (food groups) | Sum of groups consumed | HDDS (0-12) | 24-hour recall |
| **Food Insecurity (Experience)** | FS1-FS8 | Sum or Rasch model | FIES raw (0-8) | Past 30 days |
| **Food Consumption Quality** | FC1-FC8 (7-day frequency) | Weighted sum | FCS (0-112) | WFP weights |
| **Coping Behaviors** | CP1-CP5 (7-day frequency) | Weighted sum | rCSI (0-56) | Universal weights |
| **Household Income** | I1-I10 (income sources) | Sum all sources | Total income (VND) | Monthly |
| **Food Expenditure** | E1-E10 (food categories) | Sum food items | Food expenditure (VND) | Monthly |
| **Economic Vulnerability** | Income + Expenditure | Per capita, vs poverty line | Poverty status (0/1) | Vietnam lines |
| **Perception Scale** | FSP1-FSP8 | Mean (after reverse coding) | Perception score (1-5) | Cronbach's alpha |
| *[Add more constructs]* | | | | |

---

## Question-Level Notes

### Module: [Module Name]

| Question | Variable Name | Concept Measured | Potential Weaknesses |
|----------|---------------|------------------|---------------------|
| Q1 | `var_name` | [What it measures] | [Bias/limitation] |
| Q2 | `var_name` | [What it measures] | [Bias/limitation] |

---

## Skip Logic Patterns

| Question | Shown When | Structural NA When |
|----------|------------|-------------------|
| Q5 | Q4 == "yes" | Q4 != "yes" |
| FW1-FW15 | survey_version == "B" | survey_version == "A" |

---

## Reverse Coding Required

| Item | Original Wording | Direction |
|------|------------------|-----------|
| FSP3 | "I rarely worry about food" | Negative (reverse) |
| FSP5 | "Food is always available" | Negative (reverse) |

---

## Data Quality Notes

- **Social desirability concerns**: [List questions]
- **Recall bias risks**: [List questions]
- **Translation issues**: [List questions]
