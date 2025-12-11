# Research Aim & Framework Reference

**Read this first. Reference it constantly. Every output should align with this.**

---

## Research Aim

> Examine how **external and personal food-environment determinants** are associated with **household dietary diversity** in Long Biên District, Hà Nội, Vietnam.

---

## Framework Stack

```
┌─────────────────────────────────────────────────────────────────────┐
│                        HLPE FOOD SYSTEMS PATHWAY                    │
│                         (Macro Anchor Frame)                        │
│                                                                     │
│   Food Supply ──► Food Environment ──► Consumer Behavior ──► Diet  │
│      Chain            ▲                      ▲              (HDDS)  │
│                       │                      │                      │
│              ┌────────┴──────────────────────┴────────┐             │
│              │      TURNER ET AL. (2018) FRAMEWORK    │             │
│              │           (Primary Analytical Lens)    │             │
│              │                                        │             │
│              │  ┌──────────────┐  ┌───────────────┐   │             │
│              │  │   EXTERNAL   │  │   PERSONAL    │   │             │
│              │  │ DETERMINANTS │  │ DETERMINANTS  │   │             │
│              │  ├──────────────┤  ├───────────────┤   │             │
│              │  │ • Vendor/    │  │ • Accessibility│  │             │
│              │  │   product    │  │ • Affordability│  │             │
│              │  │   properties │  │ • Convenience  │  │             │
│              │  │ • Market     │  │ • Desirability │  │             │
│              │  │   properties │  │               │   │             │
│              │  │ • Marketing  │  │               │   │             │
│              │  │   regulations│  │               │   │             │
│              │  └──────────────┘  └───────────────┘   │             │
│              │              │              │          │             │
│              │              └──────┬───────┘          │             │
│              │                     ▼                  │             │
│              │            DIETARY DIVERSITY           │             │
│              │                 (HDDS)                 │             │
│              └────────────────────────────────────────┘             │
│                                                                     │
│         ┌─────────────────────────────────────────────────┐         │
│         │        DOWNS ET AL. FOOD ENVIRONMENT TYPOLOGY   │         │
│         │               (Complementary Lens)              │         │
│         │  Wild | Cultivated | Informal | Formal | Modern │         │
│         └─────────────────────────────────────────────────┘         │
│                                                                     │
│         ┌─────────────────────────────────────────────────┐         │
│         │      CCE FRAMEWORK (Speculative/Discussion)     │         │
│         │        Community/Collective Environment         │         │
│         │              NOT empirically validated          │         │
│         └─────────────────────────────────────────────────┘         │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Turner et al. (2018) Domain Definitions

### External Food Environment Determinants
Characteristics of the food environment *outside* the individual/household:

| Domain | Description | Example Survey Questions |
|--------|-------------|-------------------------|
| **Vendor properties** | Who sells food, where, when | Vendor type, location, hours |
| **Product properties** | What food is available | Diversity, quality, freshness |
| **Market properties** | Structure of food retail | Market density, distance, type |
| **Marketing & regulation** | Promotional/policy environment | Advertising exposure, labeling |

### Personal Food Environment Determinants
How individuals *interact with* the food environment:

| Domain | Description | Example Survey Questions |
|--------|-------------|-------------------------|
| **Accessibility** | Physical/geographic access | Distance to vendors, transport |
| **Affordability** | Economic access | Food prices, income, budget |
| **Convenience** | Time/effort considerations | Preparation time, ready-to-eat |
| **Desirability** | Preferences and norms | Taste, culture, social norms |

### Outcome
| Domain | Description | Measurement |
|--------|-------------|-------------|
| **Dietary diversity** | Variety of food groups consumed | HDDS (0-12 food groups, 24hr recall) |

---

## Scope Constraints

### This Thesis IS:
- ✅ **Descriptive mapping study**
- ✅ Framework application (Turner et al. as-is)
- ✅ Systematic characterization of Long Biên's food environment
- ✅ Pattern identification for future research
- ✅ Association analysis (X associated with Y)

### This Thesis IS NOT:
- ❌ Causal hypothesis testing
- ❌ Testing urbanization effects
- ❌ Testing migration effects
- ❌ Testing governance effects
- ❌ Empirical validation of CCE framework
- ❌ Claiming X causes Y

### Language Discipline

| AVOID | USE INSTEAD |
|-------|-------------|
| "causes" | "is associated with" |
| "determines" | "relates to" |
| "proves" | "suggests" / "indicates" |
| "impact of X on Y" | "association between X and Y" |
| "urbanization leads to" | "urban areas show patterns of" |

---

## Framework Filter Questions

**Ask these when reviewing every survey question:**

1. **Turner domain?**
   - [ ] External: Vendor properties
   - [ ] External: Product properties
   - [ ] External: Market properties
   - [ ] External: Marketing/regulation
   - [ ] Personal: Accessibility
   - [ ] Personal: Affordability
   - [ ] Personal: Convenience
   - [ ] Personal: Desirability
   - [ ] Outcome: Dietary diversity (HDDS)
   - [ ] Context: Demographics/control variables
   - [ ] Out of scope

2. **HLPE pathway position?**
   - [ ] Food supply chain
   - [ ] Food environment
   - [ ] Consumer behavior
   - [ ] Diet/nutrition outcome

3. **Downs et al. environment type?**
   - [ ] Wild (foraged, hunted)
   - [ ] Cultivated (home gardens, farms)
   - [ ] Informal (wet markets, street vendors)
   - [ ] Formal (supermarkets, registered shops)
   - [ ] Modern (convenience stores, online)
   - [ ] N/A

4. **In scope for descriptive mapping?**
   - [ ] Yes - descriptive characterization
   - [ ] Yes - association analysis
   - [ ] No - would require causal inference
   - [ ] No - not in framework

---

## Mapping Constructs to Framework

| Survey Construct | Turner Domain | HLPE Position | Downs Type | Primary/Control |
|------------------|---------------|---------------|------------|-----------------|
| HDDS | Outcome | Diet | N/A | **Primary outcome** |
| Food group consumption | Outcome | Diet | N/A | Primary |
| Market distance | External: Market | Food environment | Varies | Primary |
| Food prices | Personal: Affordability | Food environment | Varies | Primary |
| Vendor preference | External: Vendor | Food environment | Varies | Primary |
| Income | Personal: Affordability | Consumer behavior | N/A | Primary |
| Food expenditure | Personal: Affordability | Consumer behavior | N/A | Primary |
| Household size | Context | N/A | N/A | Control |
| Education | Context | N/A | N/A | Control |
| Age | Context | N/A | N/A | Control |

---

## Analysis Implications

### Bivariate Analysis Structure
```
EXTERNAL determinants ──────┐
                            ├──► Association with ──► HDDS
PERSONAL determinants ──────┘
```

### Regression Structure
```
HDDS = f(External determinants, Personal determinants, Controls)

NOT: HDDS = f(urbanization) or f(migration) or f(governance)
```

### What You Can Conclude
- "Households with higher [external factor] showed [higher/lower] dietary diversity"
- "Personal affordability was [positively/negatively] associated with HDDS"
- "The Long Biên food environment is characterized by [pattern]"

### What You Cannot Conclude
- "Urbanization causes dietary change"
- "Migration affects food security"
- "Policy X improves dietary diversity"

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────┐
│           FRAMEWORK QUICK REFERENCE             │
├─────────────────────────────────────────────────┤
│                                                 │
│  PRIMARY LENS: Turner et al. (2018)             │
│  ├── External: Vendor, Product, Market, Policy  │
│  ├── Personal: Access, Afford, Convenient, Want │
│  └── Outcome: HDDS                              │
│                                                 │
│  ANCHOR: HLPE Food Systems Pathway              │
│  Supply → Environment → Behavior → Diet         │
│                                                 │
│  COMPLEMENT: Downs et al. Typology              │
│  Wild | Cultivated | Informal | Formal | Modern │
│                                                 │
│  SCOPE: Descriptive mapping only                │
│  ✓ Associations  ✗ Causation                   │
│                                                 │
│  SPECULATIVE: CCE (Discussion only)             │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## References

- Turner, C., et al. (2018). Concepts and critical perspectives for food environment research: A global framework with implications for action in low- and middle-income countries. *Global Food Security*, 18, 93-101.
- HLPE. (2017). Nutrition and food systems. *High Level Panel of Experts on Food Security and Nutrition*.
- Downs, S. M., et al. (2020). Food environment typology: Advancing an expanded definition, framework, and methodological approach for improved characterization of wild, cultivated, and built food environments toward sustainable diets. *Foods*, 9(4), 532.

---

*This file is the anchor for all survey context work. Return here when uncertain.*
