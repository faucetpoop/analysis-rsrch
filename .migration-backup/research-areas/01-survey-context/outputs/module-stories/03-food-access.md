# Module Story: Food Access / External Environment

**Reference:** [00-RESEARCH-AIM.md](../../00-RESEARCH-AIM.md) for framework definitions.

---

## Framework Alignment

**Primary Turner domain:**
- [x] External: Vendor properties
- [x] External: Product properties
- [x] External: Market properties
- [ ] External: Marketing/regulation
- [x] Personal: Accessibility
- [ ] Personal: Affordability
- [ ] Personal: Convenience
- [ ] Personal: Desirability
- [ ] Outcome: Dietary diversity (HDDS)
- [ ] Context: Control variables
- [x] Mixed: Multiple domains (list below)

**Mixed domains:** External (Vendor, Product, Market) + Personal (Accessibility)

**HLPE pathway position:**
- [ ] Food supply chain
- [x] Food environment
- [ ] Consumer behavior
- [ ] Diet/nutrition outcome

**Downs et al. environment type (if applicable):**
- [ ] Wild
- [ ] Cultivated
- [x] Informal
- [x] Formal
- [x] Modern
- [ ] N/A

**In scope for descriptive mapping?**
- [x] Yes - directly measures Turner framework component
- [ ] Yes - provides context/control variables
- [ ] Partial - some questions in scope, some not
- [ ] No - outside framework (document why included)

---

## Purpose Statement

> This module captures **food sourcing patterns and market access** because **these measure External determinants (vendor/product/market properties) and Personal accessibility in Turner's framework**, and feeds into **External determinants → HDDS and Personal accessibility → HDDS association analyses**.

---

## Questions Included

| Q# | Variable Name | Turner Domain | What It Measures | Response Type |
|----|---------------|---------------|------------------|---------------|
| | | External: Market | Distance to nearest market | integer/select_one |
| | | External: Vendor | Primary food source type | select_one |
| | | External: Vendor | Frequency of vendor visits | select_one |
| | | External: Product | Food availability perception | likert |
| | | Personal: Accessibility | Transport to market | select_one |
| | | | | |

---

## Framework Role

### How This Module Fits Turner et al. (2018)

```
EXTERNAL ◄── THIS MODULE (primarily)
  ├── Vendor properties
  ├── Product properties
  └── Market properties
           │
           ├──► HDDS
           │
PERSONAL ◄── THIS MODULE (partially)
  └── Accessibility
```

This module measures: **External determinants + Personal accessibility**

### Specific Turner Sub-domains Covered

| Sub-domain | Questions | Coverage |
|------------|-----------|----------|
| External: Vendor properties | [list questions] | Full / Partial |
| External: Product properties | [list questions] | Full / Partial |
| External: Market properties | [list questions] | Full / Partial |
| Personal: Accessibility | [list questions] | Full / Partial |

### What This Module Does NOT Capture

List Turner sub-domains that are NOT covered by this module:
- External: Marketing/regulation
- Personal: Affordability (separate income module)
- Personal: Convenience (may be partial)
- Personal: Desirability (separate module or not captured)

---

## Skip Logic

**This module is shown when:**
```
[Document relevant expression]
```

**Questions within this module have conditions:**

| Question | Shown When | Structural NA When | Framework Impact |
|----------|------------|-------------------|------------------|
| | | | Does this affect External coverage? |

---

## Key Assumptions

What does this module assume about respondents?

- [ ] They can accurately recall market distances
- [ ] They understand vendor type categories
- [ ] They are willing to report honestly about food sourcing
- [ ] The household member answering makes food purchasing decisions

**Framework-specific assumptions:**
- [ ] These questions adequately capture External determinants
- [ ] The operationalization aligns with Turner's definitions
- [ ] Downs typology categories are distinguishable

---

## Potential Weaknesses

| Issue | Affected Questions | Turner Domain Impact | Mitigation |
|-------|-------------------|---------------------|------------|
| Distance estimation | Market distance | External: Market may be imprecise | Use categories |
| Social desirability | Vendor type | May over-report formal sources | Acknowledge |
| Proxy measurement | Product availability | May not reflect actual availability | Note limitation |

---

## How This Feeds Analysis

**Used in script:** `scripts/0X-food-access.R`

**Framework role in analysis:**
- [ ] Outcome variable (HDDS)
- [x] External determinant predictor
- [x] Personal determinant predictor (accessibility)
- [ ] Control variable
- [ ] Stratification variable

**Transformation:**
- [ ] Sum of items → score
- [ ] Mean of items → scale score
- [ ] Categorization → groups
- [x] Direct use or categorization

**Output indicator(s):**
- [ ] Market access index
- [ ] Vendor diversity score
- [ ] Accessibility measure

---

## Research Questions Addressed

Which of your research questions does this module help answer?

| RQ | How This Module Contributes | External/Personal/Outcome |
|----|----------------------------|--------------------------|
| RQ1 | External food environment → HDDS | External |
| RQ2 | Accessibility → HDDS | Personal |

---

## Long Biên Context Considerations

What Long Biên-specific factors affect interpretation of this module?

**Food environment context:**
- Wet markets likely dominant food source
- Street vendors common in urban Hanoi
- Supermarkets growing but still minority

**Urban context:**
- Higher market density expected
- Multiple vendor types available
- Transport infrastructure affects accessibility

**Relevant Downs et al. considerations:**
- [x] Informal markets dominant in Long Biên
- [x] Formal retail growing
- [x] Mixed food environment

---

## Descriptive Mapping Notes

**What patterns can this module describe?**
- [x] Distribution of food sourcing patterns
- [x] Variation in market access
- [x] Association between access and HDDS

**What this module CANNOT tell us (scope limits):**
- [x] Causal effects of market access on diet
- [x] Why households choose certain vendors
- [x] Change in food environment over time

---

## Sign-off

- [ ] Story written with Turner framework alignment
- [ ] Questions documented with domain mapping
- [ ] Skip logic mapped with framework impact noted
- [ ] Weaknesses identified with framework implications
- [ ] Scope constraints acknowledged
- [ ] Ready for analysis

**Date completed:** ___________
