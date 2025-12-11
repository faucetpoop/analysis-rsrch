# Survey Context Implementation Plan: Phase 0 & Phase 1

**Created:** 2024-12-11
**Surveys:** Household Survey + Vendor Survey (Long Biên 2024, including Food Waste)
**Framework:** Turner et al. (2018) External/Personal Food Environment Determinants

---

## Executive Summary

This plan implements Phase 0 (Framework Alignment) and Phase 1 (Survey Intent & Module Stories) for understanding your survey instruments through the Turner et al. (2018) framework lens.

**Key Discovery:** Your surveys are rich and well-aligned with Turner's framework:
- **Household Survey**: 33 modules covering demographics, location/migration, neighborhood services, urban farming, home vending, dwelling, food diversity (HDDS), food environment sources (8 vendor types), food security (FIES), typhoon resilience, food waste, and economics
- **Vendor Survey**: 10 modules covering vendor characteristics, food diversity, location factors, statements about business, typhoon impacts, and food waste

---

## Survey Structure Overview

### Household Survey Modules (33 groups)

| Module ID | Module Name | Turner Framework Alignment |
|-----------|-------------|---------------------------|
| `general` | General/Consent | Context |
| `household` | Household Composition | Context |
| `demographics` | Demographics | Context |
| `location_001` | Household Location | Context |
| `locationreasons` | Migration Reasons | Context (NOT causal testing) |
| `movefactors` | Location Factors | Personal: Desirability |
| `neighb` | Neighborhood | External: Market properties |
| `neighb/services` | Neighborhood Services | External: Market properties |
| `neighb/statements_neighb` | Neighborhood Statements | Personal: Desirability |
| `socialfoodaccess` | Social Food Access | Personal: Accessibility |
| `uf` | Urban Farming | External: Cultivated (Downs) |
| `uf_demographics` | Farming Demographics | Context |
| `ven` | Home Vending | External: Vendor properties |
| `ven_demographics` | Vending Demographics | Context |
| `ven_statements` | Vending Statements | External: Vendor properties |
| `dwelling` | Dwelling Characteristics | Context |
| `fooddiversity` | **Food Diversity (HDDS)** | **OUTCOME** |
| `foodenv` | Food Environment | External: All domains |
| `foodenv/supermarket` | Supermarket Access | External: Vendor (Modern) |
| `foodenv/largesupermarket` | Large Supermarket | External: Vendor (Modern) |
| `foodenv/market` | Wet Market Access | External: Vendor (Informal) |
| `foodenv/streetvendor` | Street Vendor | External: Vendor (Informal) |
| `foodenv/wholesaler` | Wholesaler | External: Vendor (Formal) |
| `foodenv/retailer` | Retailer | External: Vendor (Formal) |
| `foodenv/restaurant` | Restaurant | External: Vendor (Formal) |
| `foodenv/foodtruck` | Food Truck | External: Vendor (Informal) |
| `foodsecurity` | Food Security (FIES) | Related Outcome |
| `typhoon` | Typhoon Resilience | Context (Yagi 2024) |
| `foodwaste` | Food Waste | Related Outcome |
| `economic` | Economic Status | Personal: Affordability |
| `vehicles` | Vehicles Owned | Context (wealth proxy) |
| `debriefing` | Debriefing | Meta |
| `end_001` | End | Meta |

### Vendor Survey Modules (10 groups)

| Module ID | Module Name | Turner Framework Alignment |
|-----------|-------------|---------------------------|
| `general` | General/Consent | Context |
| `vendor` | Vendor Characteristics | External: Vendor properties |
| `fooddiversity` | Food Diversity Sold | External: Product properties |
| `location_001` | Vendor Location | External: Market properties |
| `movefactors` | Location Factors | External: Market properties |
| `statements` | Vendor Statements | External: Vendor properties |
| `typhoon` | Typhoon Impact | Context |
| `foodwaste` | Vendor Food Waste | Related Outcome |
| `debriefing` | Debriefing | Meta |
| `end_001` | End | Meta |

---

## Phase 0: Framework Alignment

**Goal:** Ensure deep understanding of Turner et al. (2018) framework before analyzing survey
**Time:** 1-2 hours
**Output:** Verified understanding, annotated framework reference

### Tasks

#### 0.1 Read Framework Anchor Document
- [ ] Read `00-RESEARCH-AIM.md` completely
- [ ] Understand External vs Personal distinction
- [ ] Review scope constraints (descriptive mapping, not causal)

#### 0.2 Map Survey to HLPE Pathway
```
Food Supply ─► Food Environment ─► Consumer Behavior ─► Diet
    │               │                    │              │
    │         ┌─────┴─────┐        ┌─────┴─────┐       │
    │         │EXTERNAL   │        │PERSONAL   │       │
    │         │• Vendor   │        │• Access   │       │
    │         │• Product  │        │• Afford   │       │
    │         │• Market   │        │• Conven   │       │
    │         │• Policy   │        │• Desire   │       │
    │         └───────────┘        └───────────┘       │
    │               │                    │              │
    │               └────────┬───────────┘              │
    │                        ▼                          │
    │                      HDDS                         │
    └──────────────────────────────────────────────────┘

Your Survey Coverage:
├── Vendor Survey: External (vendor/product/market)
└── Household Survey: External + Personal + Outcome
```

#### 0.3 Identify Downs et al. Food Environment Types in Survey

| Downs Type | Household Survey Coverage | Vendor Survey Coverage |
|------------|--------------------------|----------------------|
| **Wild** | Not captured | Not captured |
| **Cultivated** | `uf` (urban farming) | - |
| **Informal** | `foodenv/market`, `foodenv/streetvendor`, `foodenv/foodtruck` | `vendortype` options |
| **Formal** | `foodenv/retailer`, `foodenv/wholesaler`, `foodenv/restaurant` | `vendortype` options |
| **Modern** | `foodenv/supermarket`, `foodenv/largesupermarket` | `vendortype` options |

#### 0.4 Document Scope Constraints

**In Scope (Descriptive Mapping):**
- Characterizing Long Biên's food environment using Turner domains
- Associations between External/Personal determinants and HDDS
- Describing patterns by Downs typology

**Out of Scope (Acknowledge in Limitations):**
- Causal claims about urbanization/migration → diet
- Testing governance effects
- CCE framework validation (speculative only)
- Typhoon module is context, not causal testing

---

## Phase 1: Survey Intent & Module Stories

**Goal:** Document each survey module's purpose, framework alignment, and analytical role
**Time:** 4-6 hours (iterative)
**Output:** `outputs/module-stories/*.md` for each module

### Module Story Execution Order

Work in this order to build understanding progressively:

#### Priority 1: Core Outcome & Determinant Modules

| # | Module | File | Why First |
|---|--------|------|-----------|
| 1 | `fooddiversity` | `05-food-diversity-hdds.md` | Primary outcome (HDDS) |
| 2 | `foodenv/*` (8 modules) | `06-food-environment-sources.md` | Core External determinants |
| 3 | `economic` | `07-economic-affordability.md` | Core Personal determinant |
| 4 | `socialfoodaccess` | `08-social-food-access.md` | Personal: Accessibility |

#### Priority 2: Context & Control Modules

| # | Module | File | Why |
|---|--------|------|-----|
| 5 | `demographics` | `01-demographics.md` | Control variables |
| 6 | `household` | `02-household-composition.md` | Per capita calculations |
| 7 | `dwelling` | `03-dwelling.md` | Wealth proxy, cooking |
| 8 | `vehicles` | `04-vehicles.md` | Wealth proxy |

#### Priority 3: External Environment Supplements

| # | Module | File | Why |
|---|--------|------|-----|
| 9 | `neighb` + subgroups | `09-neighborhood.md` | External: Market properties |
| 10 | `uf` + `uf_demographics` | `10-urban-farming.md` | Cultivated food source |
| 11 | `ven` + subgroups | `11-home-vending.md` | Informal vendor properties |

#### Priority 4: Related Outcomes & Context

| # | Module | File | Why |
|---|--------|------|-----|
| 12 | `foodsecurity` | `12-food-security-fies.md` | FIES related outcome |
| 13 | `foodwaste` | `13-food-waste.md` | Related outcome |
| 14 | `typhoon` | `14-typhoon-yagi.md` | Context (Typhoon Yagi 2024) |
| 15 | `location*` + `movefactors` | `15-location-migration.md` | Context (NOT causal testing) |

#### Priority 5: Vendor Survey

| # | Module | File | Why |
|---|--------|------|-----|
| 16 | All vendor modules | `20-vendor-survey-overview.md` | External environment characterization |

### Module Story Template Adaptation

For each module, complete the template with these Turner-specific sections:

```markdown
## Framework Alignment

**Primary Turner domain:** [Select from checklist]
**HLPE pathway position:** [Select]
**Downs et al. environment type:** [Select if applicable]
**In scope for descriptive mapping?:** [Yes/Partial/No]

## Purpose Statement

> This module captures **[WHAT]** because **[TURNER FRAMEWORK ROLE]**,
> and feeds into **[WHICH ANALYSIS]**.

## Questions Included

| Q# | Variable Name | Turner Domain | What It Measures |
|----|---------------|---------------|------------------|

## Framework Role

### How This Module Fits Turner et al. (2018)
[Diagram showing where module sits]

### Specific Turner Sub-domains Covered
[Table of sub-domains and coverage]

### What This Module Does NOT Capture
[List gaps]
```

---

## Iterative Improvement Process

### Iteration 1: Initial Pass (Days 1-2)
1. Complete Phase 0 framework alignment
2. Create module stories for Priority 1 modules (outcome + core determinants)
3. Begin `question-annotations.csv` for HDDS and food environment modules

### Iteration 2: Context Integration (Days 3-4)
1. Complete Priority 2-3 module stories
2. Update construct mapping as patterns emerge
3. Cross-reference with Priority 1 findings
4. Revise earlier module stories if framework understanding deepens

### Iteration 3: Complete Coverage (Days 5-6)
1. Complete Priority 4-5 module stories
2. Finish `question-annotations.csv`
3. Complete `construct-mapping.md`
4. Draft `interpretation-guardrails.md`

### Iteration 4: Synthesis & Review (Day 7)
1. Review all module stories for consistency
2. Verify framework alignment across all outputs
3. Complete `vietnam-context-notes.md` integration
4. Sign off on `survey-review-checklist.md`

---

## Key Framework Mapping Discoveries

### Turner Domain Coverage

| Turner Domain | Survey Questions | Coverage |
|---------------|-----------------|----------|
| **EXTERNAL** | | |
| Vendor properties | `foodenv/*` (8 modules), `ven`, `vendor` | **Excellent** |
| Product properties | `foodgroups`, `wholeorprocessed` | Good |
| Market properties | `neighb/services`, location modules | Good |
| Marketing/regulation | Limited | **Gap** |
| **PERSONAL** | | |
| Accessibility | `socialfoodaccess`, transport, distance | Good |
| Affordability | `economic`, income | Good |
| Convenience | Implicit in food env frequency | Partial |
| Desirability | `movefactors/foodenvironment`, statements | Partial |
| **OUTCOME** | | |
| HDDS | `fooddiversity` (16 food groups) | **Excellent** |

### Downs Typology Coverage

| Type | Coverage | Notes |
|------|----------|-------|
| Wild | Not captured | Expected gap for urban area |
| Cultivated | `uf` module | Urban farming, home gardens |
| Informal | Excellent | Market, street vendor, food truck |
| Formal | Excellent | Retailer, wholesaler, restaurant |
| Modern | Excellent | Supermarket, large supermarket |

### Framework Gaps to Document

1. **Marketing/regulation** - No questions on advertising, food labeling, policy
2. **Convenience** - Only implicit through frequency questions
3. **Desirability** - Limited to general statements, not food-specific preferences
4. **Wild foods** - Not captured (appropriate for urban setting)

---

## Files to Create/Update

### Phase 0 Outputs
- [ ] Annotate `00-RESEARCH-AIM.md` with survey-specific notes (in outputs)
- [ ] Update `00-PROGRESS.md` with Phase 0 completion

### Phase 1 Outputs
- [ ] `outputs/module-stories/01-demographics.md`
- [ ] `outputs/module-stories/02-household-composition.md`
- [ ] `outputs/module-stories/03-dwelling.md`
- [ ] `outputs/module-stories/04-vehicles.md`
- [ ] `outputs/module-stories/05-food-diversity-hdds.md`
- [ ] `outputs/module-stories/06-food-environment-sources.md`
- [ ] `outputs/module-stories/07-economic-affordability.md`
- [ ] `outputs/module-stories/08-social-food-access.md`
- [ ] `outputs/module-stories/09-neighborhood.md`
- [ ] `outputs/module-stories/10-urban-farming.md`
- [ ] `outputs/module-stories/11-home-vending.md`
- [ ] `outputs/module-stories/12-food-security-fies.md`
- [ ] `outputs/module-stories/13-food-waste.md`
- [ ] `outputs/module-stories/14-typhoon-yagi.md`
- [ ] `outputs/module-stories/15-location-migration.md`
- [ ] `outputs/module-stories/20-vendor-survey-overview.md`
- [ ] `outputs/question-annotations.csv` (begin populating)
- [ ] `outputs/construct-mapping.md` (update with discoveries)

---

## Success Criteria

### Phase 0 Complete When:
- [ ] Can explain Turner External vs Personal distinction from memory
- [ ] Can articulate why this is descriptive mapping (not causal testing)
- [ ] Understand Downs typology application to Long Biên
- [ ] Know which survey modules map to which Turner domains

### Phase 1 Complete When:
- [ ] Every household survey module has a story file
- [ ] Vendor survey has overview module story
- [ ] All stories include Turner domain alignment
- [ ] Questions documented with framework classification
- [ ] Framework gaps identified and documented
- [ ] Ready to proceed to Phase 2 (Question-Level Analysis)

---

## Notes for Implementation

### Vietnamese Language Considerations
- Survey is in Vietnamese with English variable names
- Response options are in Vietnamese (e.g., "CÓ" = Yes, "KHÔNG" = No)
- Food groups use Vietnamese names - will need translation table
- Neighborhoods are Long Biên specific

### Special Survey Features
1. **Food Waste Module** - Included in both surveys (2024 addition)
2. **Typhoon Yagi Module** - Context for September 2024 typhoon impact
3. **16 Food Groups** - Extended HDDS (standard is 12)
4. **8 Vendor Types** - Comprehensive food environment coverage
5. **GPS Location** - Spatial data available

### Research Aim Alignment Check
Every module story must answer:
> "How does this module help examine associations between External/Personal determinants and HDDS in Long Biên?"

---

*Plan Version: 1.0 | Created: 2024-12-11*
