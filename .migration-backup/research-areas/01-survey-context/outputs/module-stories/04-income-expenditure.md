# Module Story: Income & Expenditure

**Reference:** [00-RESEARCH-AIM.md](../../00-RESEARCH-AIM.md) for framework definitions.

---

## Framework Alignment

**Primary Turner domain:**
- [ ] External: Vendor properties
- [ ] External: Product properties
- [ ] External: Market properties
- [ ] External: Marketing/regulation
- [ ] Personal: Accessibility
- [x] Personal: Affordability
- [ ] Personal: Convenience
- [ ] Personal: Desirability
- [ ] Outcome: Dietary diversity (HDDS)
- [ ] Context: Control variables
- [ ] Mixed: Multiple domains (list below)

**HLPE pathway position:**
- [ ] Food supply chain
- [ ] Food environment
- [x] Consumer behavior
- [ ] Diet/nutrition outcome

**Downs et al. environment type (if applicable):**
- [x] N/A

**In scope for descriptive mapping?**
- [x] Yes - directly measures Turner framework component
- [ ] Yes - provides context/control variables
- [ ] Partial - some questions in scope, some not
- [ ] No - outside framework (document why included)

---

## Purpose Statement

> This module captures **household income sources and food expenditure patterns** because **affordability is a key personal determinant in Turner's framework**, and feeds into **Personal determinants → HDDS association analysis**.

---

## Questions Included

| Q# | Variable Name | Turner Domain | What It Measures | Response Type |
|----|---------------|---------------|------------------|---------------|
| | | Personal: Affordability | Total household income | integer |
| | | Personal: Affordability | Income sources | select_multiple |
| | | Personal: Affordability | Food expenditure (total) | integer |
| | | Personal: Affordability | Food expenditure by category | integer |
| | | Personal: Affordability | Food budget perception | likert |
| | | | | |

---

## Framework Role

### How This Module Fits Turner et al. (2018)

```
External ──┐
           ├──► HDDS
Personal ──┘
    │
    └── Affordability ◄── THIS MODULE
```

This module measures: **Personal: Affordability**

### Specific Turner Sub-domains Covered

| Sub-domain | Questions | Coverage |
|------------|-----------|----------|
| Personal: Affordability (income) | [list questions] | Full |
| Personal: Affordability (expenditure) | [list questions] | Full |
| Personal: Affordability (perception) | [list questions] | Partial/Proxy |

### What This Module Does NOT Capture

List Turner sub-domains that are NOT covered by this module:
- External determinants (separate module)
- Personal: Accessibility (separate module)
- Personal: Convenience
- Personal: Desirability
- Actual food prices (External: Product)

---

## Skip Logic

**This module is shown when:**
```
[Document relevant expression]
```

**Questions within this module have conditions:**

| Question | Shown When | Structural NA When | Framework Impact |
|----------|------------|-------------------|------------------|
| | | | |

---

## Key Assumptions

What does this module assume about respondents?

- [ ] They can accurately recall monthly income
- [ ] They understand income source categories
- [ ] They are willing to report honestly about finances
- [ ] The household member answering knows about household finances

**Framework-specific assumptions:**
- [ ] Income adequately captures economic access to food
- [ ] Food expenditure reflects affordability constraints
- [ ] Per capita measures are appropriate

---

## Potential Weaknesses

| Issue | Affected Questions | Turner Domain Impact | Mitigation |
|-------|-------------------|---------------------|------------|
| Under-reporting income | Total income | Affordability underestimated | Use expenditure as proxy |
| Recall bias | Monthly amounts | May be imprecise | Use ranges/categories |
| Social desirability | All financial Qs | Direction unclear | Acknowledge limitation |
| Informal income | Income sources | May be underreported | Document carefully |

---

## How This Feeds Analysis

**Used in script:** `scripts/0X-income.R`

**Framework role in analysis:**
- [ ] Outcome variable (HDDS)
- [ ] External determinant predictor
- [x] Personal determinant predictor
- [ ] Control variable
- [ ] Stratification variable

**Transformation:**
- [x] Sum of items → total income
- [ ] Mean of items → scale score
- [x] Categorization → income quintiles/groups
- [ ] Direct use → no transformation

**Output indicator(s):**
- [x] Total household income (VND/month)
- [x] Per capita income
- [x] Food expenditure share
- [x] Poverty status (vs threshold)

---

## Research Questions Addressed

Which of your research questions does this module help answer?

| RQ | How This Module Contributes | External/Personal/Outcome |
|----|----------------------------|--------------------------|
| RQ2 | Affordability → HDDS | Personal |
| | Income stratification | Personal |

---

## Long Biên Context Considerations

What Long Biên-specific factors affect interpretation of this module?

**Food environment context:**
- Urban incomes generally higher than rural
- Diverse income sources in urban areas
- Food expenditure share may be lower in higher-income urban areas

**Urban context:**
- Formal employment more common
- Business/trade income significant
- Cost of living higher

**Relevant Downs et al. considerations:**
- [x] Affordability may determine access to Formal/Modern vs Informal sources

---

## Descriptive Mapping Notes

**What patterns can this module describe?**
- [x] Distribution of household income
- [x] Variation in food expenditure patterns
- [x] Association between affordability and HDDS

**What this module CANNOT tell us (scope limits):**
- [x] Causal effects of income on diet
- [x] Income changes over time
- [x] How households prioritize food spending

---

## Sign-off

- [ ] Story written with Turner framework alignment
- [ ] Questions documented with domain mapping
- [ ] Skip logic mapped with framework impact noted
- [ ] Weaknesses identified with framework implications
- [ ] Scope constraints acknowledged
- [ ] Ready for analysis

**Date completed:** ___________
