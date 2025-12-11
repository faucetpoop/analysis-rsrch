# Survey-Framework Mapping: Turner et al. (2018)

**Surveys:** Household Survey + Vendor Survey (Long Biên 2024)
**Framework:** Turner et al. (2018) External/Personal Food Environment Determinants
**Outcome:** HDDS (Household Dietary Diversity Score)

---

## Household Survey Modules (33 groups)

| Module | Turner Domain | HLPE Position | Downs Type | Key Variables |
|--------|---------------|---------------|------------|---------------|
| `general` | Context | - | - | location, surveyorname, consent |
| `household` | Context | - | - | respondent info, hh_size, hh_members |
| `demographics` | Context | - | - | age, gender, ethnicity, education, occupation |
| `location_001` | Context | - | - | GPS coordinates, locationtime |
| `locationreasons` | Context | - | - | moveaway_reason, movetowards_reason |
| `movefactors` | Personal: Desirability | Consumer | - | foodenvironment, safety, flooding, infrastructure importance |
| `neighb` | External: Market | Food Env | Mixed | neighborhood characteristics |
| `neighb/services` | External: Market | Food Env | Mixed | satisfaction with markets, streetvendors, supermarkets, restaurants |
| `neighb/statements_neighb` | Personal: Desirability | Consumer | - | agreement scales on neighborhood quality |
| `socialfoodaccess` | Personal: Accessibility | Consumer | - | food sharing, borrowing, community access |
| `uf` | External: Cultivated | Food Env | Cultivated | urban farming participation, land types, purpose |
| `uf_demographics` | Context | - | Cultivated | farming household member details |
| `ven` | External: Vendor | Food Env | Informal | home vending activity, products sold |
| `ven_demographics` | Context | - | Informal | vending household member details |
| `ven_statements` | External: Vendor | Food Env | Informal | vending business statements |
| `dwelling` | Context | - | - | housingtype, tenure, rooms, cookingsource, utilities |
| **`fooddiversity`** | **OUTCOME: HDDS** | **Diet** | - | **16 food groups (24hr recall)** |
| `foodenv` | External: Mixed | Food Env | Mixed | intro to food environment section |
| `foodenv/supermarket` | External: Vendor | Food Env | Modern | frequency, transport, time, foodgroups, expenditure |
| `foodenv/largesupermarket` | External: Vendor | Food Env | Modern | frequency, transport, time, foodgroups, expenditure |
| `foodenv/market` | External: Vendor | Food Env | Informal | frequency, transport, time, foodgroups, expenditure |
| `foodenv/streetvendor` | External: Vendor | Food Env | Informal | frequency, transport, time, foodgroups, expenditure |
| `foodenv/wholesaler` | External: Vendor | Food Env | Formal | frequency, transport, time, foodgroups, expenditure |
| `foodenv/retailer` | External: Vendor | Food Env | Formal | frequency, transport, time, foodgroups, expenditure |
| `foodenv/restaurant` | External: Vendor | Food Env | Formal | frequency, transport, time, foodgroups, expenditure |
| `foodenv/foodtruck` | External: Vendor | Food Env | Informal | frequency, transport, time, foodgroups, expenditure |
| `foodsecurity` | Related Outcome | Diet | - | FIES 8 questions (worried, unhealthy, few_kinds, skipped, ate_less, ranout, hungry, wholeday) |
| `typhoon` | Context | - | - | Yagi preparation, coping, financial impact, damages |
| `foodwaste` | Related Outcome | Consumer | - | amount, frequency, reasons, disposal methods |
| `economic` | Personal: Affordability | Consumer | - | income, expenditure, food expenditure share |
| `vehicles` | Context (wealth proxy) | - | - | motorcycle, car, bicycle ownership |
| `debriefing` | Meta | - | - | surveyor notes |
| `end_001` | Meta | - | - | submission |

---

## Vendor Survey Modules (10 groups)

| Module | Turner Domain | HLPE Position | Downs Type | Key Variables |
|--------|---------------|---------------|------------|---------------|
| `general` | Context | - | Mixed | location, vendortype, consent, neighborhood |
| `vendor` | External: Vendor | Food Env | Mixed | resp_gender, age, staff, ethnicity, ownership |
| `fooddiversity` | External: Product | Food Env | Mixed | foodgroups sold, wholeorprocessed |
| `location_001` | External: Market | Food Env | Mixed | locationtime, previouslocation, homelocation |
| `movefactors` | External: Market | Food Env | Mixed | bridge_city, customers, supplychain, flooding, infrastructure |
| `statements` | External: Vendor | Food Env | Mixed | customers_wealth, customers_ethn, satisfaction, future plans |
| `typhoon` | Context | - | - | typhoon_prepare, typhoon_cope, financial impact, damages |
| `foodwaste` | Related Outcome | - | - | amount, frequency, reasons, disposal |
| `debriefing` | Meta | - | - | surveyor notes |
| `end_001` | Meta | - | - | submission |

---

## Turner Framework Coverage Summary

### External Determinants

| Sub-domain | Coverage | Source Modules |
|------------|----------|----------------|
| **Vendor properties** | Excellent | `foodenv/*` (8 types), `ven`, vendor survey |
| **Product properties** | Good | `foodgroups` in all food env modules, vendor `fooddiversity` |
| **Market properties** | Good | `neighb/services`, `location`, vendor `movefactors` |
| **Marketing/regulation** | **Gap** | Not captured |

### Personal Determinants

| Sub-domain | Coverage | Source Modules |
|------------|----------|----------------|
| **Accessibility** | Good | `socialfoodaccess`, transport questions in `foodenv/*` |
| **Affordability** | Good | `economic`, expenditure questions in `foodenv/*` |
| **Convenience** | Partial | Implicit via frequency, time to reach vendors |
| **Desirability** | Partial | `movefactors`, `statements` modules |

### Outcomes

| Outcome | Coverage | Source Module |
|---------|----------|---------------|
| **HDDS** | Excellent | `fooddiversity` - 16 food groups, 24hr recall |
| **FIES** | Good | `foodsecurity` - 8 standard questions |
| **Food waste** | Good | `foodwaste` - both surveys |

---

## Downs et al. Typology Coverage

| Type | Coverage | Notes |
|------|----------|-------|
| **Wild** | Not captured | Expected gap for urban area |
| **Cultivated** | Good | `uf` module - urban farming, home gardens |
| **Informal** | Excellent | market, streetvendor, foodtruck, home vending |
| **Formal** | Excellent | retailer, wholesaler, restaurant |
| **Modern** | Excellent | supermarket, largesupermarket |

---

## 16 Food Groups (Extended HDDS)

Standard HDDS uses 12 groups; this survey uses 16:

1. Cereals (corn, rice, wheat, bread, noodles)
2. White roots/tubers (potatoes, cassava)
3. Vitamin A vegetables (pumpkin, carrot, orange sweet potato)
4. Dark green leafy vegetables (spinach, bok choy, cabbage)
5. Other vegetables (tomato, onion, eggplant)
6. Vitamin A fruits (mango, papaya, watermelon)
7. Other fruits (banana, orange, apple)
8. Organ meat (liver, kidney, heart)
9. Other meat (beef, pork, chicken)
10. Eggs
11. Fish and seafood
12. Legumes, nuts, seeds
13. Milk and milk products
14. Oils and fats
15. Sweets
16. Spices, condiments, beverages

---

## 8 Vendor Types in Food Environment Module

Each vendor type captures: frequency, transport mode, travel time, food groups purchased, expenditure

| Vendor Type | Downs Category | Turner Domain |
|-------------|----------------|---------------|
| Supermarket | Modern | External: Vendor |
| Large supermarket | Modern | External: Vendor |
| Wet market | Informal | External: Vendor |
| Street vendor | Informal | External: Vendor |
| Wholesaler | Formal | External: Vendor |
| Retailer | Formal | External: Vendor |
| Restaurant | Formal | External: Vendor |
| Food truck | Informal | External: Vendor |

---

## Framework Gaps

1. **Marketing/regulation** - No questions on food advertising, labeling, or policy
2. **Convenience** - Only implicit through frequency/time questions, no direct measurement
3. **Desirability** - Limited to general location statements, not food-specific preferences
4. **Wild foods** - Not captured (appropriate for urban Long Biên setting)
5. **Food prices** - Expenditure captured but not prices at vendor level

---

## Scope Constraints

**In Scope (Descriptive Mapping):**
- Characterizing Long Biên's food environment using Turner domains
- Associations between External/Personal determinants and HDDS
- Describing patterns by Downs typology

**Out of Scope:**
- Causal claims about urbanization/migration → diet
- Testing governance effects
- Typhoon module is context only, not causal testing
- CCE framework validation (speculative only)

---

*Generated: 2024-12-11 | Framework: Turner et al. (2018)*
