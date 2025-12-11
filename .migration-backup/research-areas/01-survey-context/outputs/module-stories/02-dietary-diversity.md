# Module Story: Dietary Diversity (HDDS)

**Reference:** [00-RESEARCH-AIM.md](../../00-RESEARCH-AIM.md) for framework definitions.

---

## Framework Alignment

**Primary Turner domain:**
- [ ] External: Vendor properties
- [ ] External: Product properties
- [ ] External: Market properties
- [ ] External: Marketing/regulation
- [ ] Personal: Accessibility
- [ ] Personal: Affordability
- [ ] Personal: Convenience
- [ ] Personal: Desirability
- [x] Outcome: Dietary diversity (HDDS)
- [ ] Context: Control variables
- [ ] Mixed: Multiple domains (list below)

**HLPE pathway position:**
- [ ] Food supply chain
- [ ] Food environment
- [ ] Consumer behavior
- [x] Diet/nutrition outcome

**Downs et al. environment type (if applicable):**
- [x] N/A

**In scope for descriptive mapping?**
- [x] Yes - directly measures Turner framework component
- [ ] Yes - provides context/control variables
- [ ] Partial - some questions in scope, some not
- [ ] No - outside framework (document why included)

---

## Purpose Statement

> This module captures **dietary diversity through 24-hour food group recall** because **HDDS is the primary outcome variable in Turner's framework**, and feeds into **the dependent variable in all External/Personal → HDDS association analyses**.

---

## Questions Included

| Q# | Variable Name | Turner Domain | What It Measures | Response Type |
|----|---------------|---------------|------------------|---------------|
| | | Outcome | Cereals/grains consumed | binary (yes/no) |
| | | Outcome | White roots/tubers consumed | binary |
| | | Outcome | Vegetables consumed | binary |
| | | Outcome | Fruits consumed | binary |
| | | Outcome | Meat consumed | binary |
| | | Outcome | Eggs consumed | binary |
| | | Outcome | Fish/seafood consumed | binary |
| | | Outcome | Legumes/nuts/seeds consumed | binary |
| | | Outcome | Milk/dairy consumed | binary |
| | | Outcome | Oils/fats consumed | binary |
| | | Outcome | Sweets consumed | binary |
| | | Outcome | Spices/condiments consumed | binary |

---

## Framework Role

### How This Module Fits Turner et al. (2018)

```
External ──┐
           ├──► HDDS (THIS MODULE)
Personal ──┘
```

This module measures: **Primary Outcome**

### Specific Turner Sub-domains Covered

| Sub-domain | Questions | Coverage |
|------------|-----------|----------|
| Dietary diversity (outcome) | All 12 food groups | Full |

### What This Module Does NOT Capture

List Turner sub-domains that are NOT covered by this module:
- All External determinants
- All Personal determinants
- Food quantities (only binary consumption)
- Nutrient adequacy (proxy only)

---

## Skip Logic

**This module is shown when:**
```
[Always shown - core outcome module]
```

**Questions within this module have conditions:**

| Question | Shown When | Structural NA When | Framework Impact |
|----------|------------|-------------------|------------------|
| All food groups | Always | N/A | N/A |

---

## Key Assumptions

What does this module assume about respondents?

- [x] They can accurately recall past 24 hours
- [x] They understand food group categories
- [x] They are willing to report honestly about consumption
- [x] The household member answering knows what was eaten

**Framework-specific assumptions:**
- [x] HDDS adequately captures dietary diversity
- [x] 24-hour recall provides valid snapshot
- [x] Binary consumption is meaningful indicator

---

## Potential Weaknesses

| Issue | Affected Questions | Turner Domain Impact | Mitigation |
|-------|-------------------|---------------------|------------|
| 24hr recall bias | All | May underestimate diversity | Acknowledge recall window |
| Day-to-day variation | All | Single day may be atypical | Note as limitation |
| Binary measure | All | Loses quantity information | Use HDDS as intended |
| Respondent knowledge | All | May not know all ingredients | Document who answered |

---

## How This Feeds Analysis

**Used in script:** `scripts/0X-hdds.R`

**Framework role in analysis:**
- [x] Outcome variable (HDDS)
- [ ] External determinant predictor
- [ ] Personal determinant predictor
- [ ] Control variable
- [ ] Stratification variable

**Transformation:**
- [x] Sum of items → score (HDDS = sum of 12 food groups, range 0-12)
- [ ] Mean of items → scale score
- [ ] Categorization → groups
- [ ] Direct use → no transformation

**Output indicator(s):**
- [x] HDDS (range: 0-12)

---

## Research Questions Addressed

Which of your research questions does this module help answer?

| RQ | How This Module Contributes | External/Personal/Outcome |
|----|----------------------------|--------------------------|
| All | Primary outcome variable | Outcome |
| RQ1 | External determinants → HDDS | Outcome |
| RQ2 | Personal determinants → HDDS | Outcome |

---

## Long Biên Context Considerations

What Long Biên-specific factors affect interpretation of this module?

**Food environment context:**
- Vietnamese diets typically rice-based (high cereal consumption expected)
- Fish and pork common protein sources
- Vegetable diversity high in Vietnamese cuisine

**Urban context:**
- Greater food diversity expected in urban areas
- Higher HDDS scores likely compared to rural

**Relevant Downs et al. considerations:**
- [x] Informal markets may provide high diversity
- [x] Modern retail growing but may reduce diversity?

---

## Descriptive Mapping Notes

**What patterns can this module describe?**
- [x] Distribution of HDDS scores
- [x] Variation in dietary diversity across groups
- [x] Association with External/Personal determinants

**What this module CANNOT tell us (scope limits):**
- [x] Causal effects on dietary diversity
- [x] Nutrient adequacy (only proxy)
- [x] Food quantities consumed
- [x] Diet quality beyond diversity

---

## Sign-off

- [ ] Story written with Turner framework alignment
- [ ] Questions documented with domain mapping
- [ ] Skip logic mapped with framework impact noted
- [ ] Weaknesses identified with framework implications
- [ ] Scope constraints acknowledged
- [ ] Ready for analysis

**Date completed:** ___________
