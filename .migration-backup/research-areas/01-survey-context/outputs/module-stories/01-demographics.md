# Module Story: Demographics

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
- [ ] Outcome: Dietary diversity (HDDS)
- [x] Context: Control variables
- [ ] Mixed: Multiple domains (list below)

**HLPE pathway position:**
- [ ] Food supply chain
- [ ] Food environment
- [ ] Consumer behavior
- [ ] Diet/nutrition outcome

**Downs et al. environment type (if applicable):**
- [x] N/A

**In scope for descriptive mapping?**
- [x] Yes - provides context/control variables
- [ ] Yes - directly measures Turner framework component
- [ ] Partial - some questions in scope, some not
- [ ] No - outside framework (document why included)

---

## Purpose Statement

> This module captures **household demographic characteristics** because **demographics serve as control variables and stratification factors in the Turner framework analysis**, and feeds into **control variables in the External/Personal → HDDS association analysis**.

---

## Questions Included

| Q# | Variable Name | Turner Domain | What It Measures | Response Type |
|----|---------------|---------------|------------------|---------------|
| | | Context | Household size | integer |
| | | Context | Respondent role/gender | select_one |
| | | Context | Age of respondent | integer |
| | | Context | Education level | select_one |
| | | Context | Marital status | select_one |
| | | | | |

---

## Framework Role

### How This Module Fits Turner et al. (2018)

```
External ──┐
           ├──► HDDS
Personal ──┘
     ▲
     │
Demographics (Control variables)
```

This module measures: **Context / Controls**

### Specific Turner Sub-domains Covered

| Sub-domain | Questions | Coverage |
|------------|-----------|----------|
| N/A - Control variables | All | Full |

### What This Module Does NOT Capture

List Turner sub-domains that are NOT covered by this module:
- All External determinants (separate modules)
- All Personal determinants (separate modules)
- Outcome (HDDS module)

---

## Skip Logic

**This module is shown when:**
```
[Always shown - baseline module]
```

**Questions within this module have conditions:**

| Question | Shown When | Structural NA When | Framework Impact |
|----------|------------|-------------------|------------------|
| | | | None - control variables |

---

## Key Assumptions

What does this module assume about respondents?

- [x] They can accurately recall household composition
- [x] They understand the categories
- [x] They are willing to report honestly about demographics
- [x] The household member answering knows about household composition

**Framework-specific assumptions:**
- [x] Demographics are appropriate control variables for Turner analysis
- [x] These factors may moderate External/Personal → HDDS associations

---

## Potential Weaknesses

| Issue | Affected Questions | Turner Domain Impact | Mitigation |
|-------|-------------------|---------------------|------------|
| Household definition | HH size | May affect per capita calculations | Define clearly in methods |
| Social desirability | Education | Minor | Acknowledge in limitations |
| | | | |

---

## How This Feeds Analysis

**Used in script:** `scripts/0X-descriptives.R`

**Framework role in analysis:**
- [ ] Outcome variable (HDDS)
- [ ] External determinant predictor
- [ ] Personal determinant predictor
- [x] Control variable
- [x] Stratification variable

**Transformation:**
- [ ] Sum of items → score
- [ ] Mean of items → scale score
- [ ] Categorization → groups
- [x] Direct use → no transformation

**Output indicator(s):**
- [x] Sample characteristics table
- [x] Stratification variables for subgroup analysis

---

## Research Questions Addressed

Which of your research questions does this module help answer?

| RQ | How This Module Contributes | External/Personal/Outcome |
|----|----------------------------|--------------------------|
| All | Provides control variables | Context |
| | Enables stratified analysis | Context |

---

## Long Biên Context Considerations

What Long Biên-specific factors affect interpretation of this module?

**Food environment context:**
- N/A for demographics

**Urban context:**
- Urban household structures may differ from rural
- Education levels likely higher than national average

**Relevant Downs et al. considerations:**
- [x] N/A for demographics

---

## Descriptive Mapping Notes

**What patterns can this module describe?**
- [x] Distribution of household characteristics
- [x] Variation across demographic groups
- [ ] Association with HDDS (as controls)

**What this module CANNOT tell us (scope limits):**
- [x] Causal effects of demographics on diet
- [x] Change over time
- [x] Why certain demographics associate with HDDS

---

## Sign-off

- [ ] Story written with Turner framework alignment
- [ ] Questions documented with domain mapping
- [ ] Skip logic mapped with framework impact noted
- [ ] Weaknesses identified with framework implications
- [ ] Scope constraints acknowledged
- [ ] Ready for analysis

**Date completed:** ___________
