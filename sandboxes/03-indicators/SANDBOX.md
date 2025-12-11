# Sandbox 03: Indicators

**Status:** Active
**Priority:** Core Analysis (run third)
**Features:** 12 failing

## Purpose

Core analysis: HDDS, FCS, rCSI, FIES calculations and income/expenditure analysis with Likert scale processing. This sandbox implements validated food security indicators and economic analysis.

## Quick Start

```bash
cd sandboxes/03-indicators
agent-foreman status
agent-foreman next
```

## Features

### Food Security Indicators (5 features)
| ID | Description | Status |
|----|-------------|--------|
| indicators.hdds.calculate | Calculate Household Dietary Diversity Score | failing |
| indicators.hdds.categorize | Categorize HDDS (low/medium/high) | failing |
| indicators.fcs.calculate | Calculate Food Consumption Score (WFP) | failing |
| indicators.rcsi.calculate | Calculate reduced Coping Strategies Index | failing |
| indicators.fies.rasch-model | Implement FIES Rasch model (SDG 2.1.2) | failing |

### Economic Indicators (4 features)
| ID | Description | Status |
|----|-------------|--------|
| economics.income.aggregate | Aggregate household income sources | failing |
| economics.expenditure.calculate-shares | Calculate food expenditure share | failing |
| economics.outliers.detect-handle | Detect and handle outliers | failing |
| economics.benchmarks.vietnam-poverty | Compare to Vietnam poverty lines | failing |

### Likert Scales (3 features)
| ID | Description | Status |
|----|-------------|--------|
| likert.coding.recode-scales | Recode Likert responses to numeric | failing |
| likert.reliability.cronbach-alpha | Calculate Cronbach's alpha | failing |
| likert.visualization.diverging-bars | Create diverging bar charts | failing |

## Research Areas Included

- **05-food-security-indicators** - HDDS, FCS, rCSI, FIES methodologies
- **06-income-expenditure** - Vietnam-specific economic analysis
- **07-likert-psychometrics** - Likert scale processing and reliability

## Key Resources

- `/docs/area-4-food-security-indicators.md` - FAO and WFP methodologies
- `/docs/area-5-income-expenditure-vietnam.md` - Vietnam poverty lines and benchmarks
- `/docs/area-6-likert-scales-psychometrics.md` - Psychometric analysis guide
- `/docs/scripts/` - Reference implementations for indicators

## Dependencies

**Upstream:** 02-data-pipeline (needs clean data)
**Downstream:** 04-analysis-reporting (provides indicators for mapping and tables)

## Success Criteria

- HDDS calculated using FAO 12 food group methodology
- FCS calculated with WFP weights and thresholds
- rCSI calculated with IPC phase thresholds
- FIES Rasch model implemented using RM.weights package
- Income and expenditure aggregated with VND currency handling
- Outliers detected and handled appropriately
- Likert scales recoded with reliability analysis complete

## Next Steps

After completing this sandbox:
1. Move to **04-analysis-reporting** for geospatial visualization and thesis outputs
2. Use calculated indicators for choropleth maps
3. Generate survey-weighted summary tables

## Notes

This is the largest sandbox with 12 features spanning food security, economics, and psychometrics. Consider working in module order: food security indicators first, then economics, then Likert scales.
