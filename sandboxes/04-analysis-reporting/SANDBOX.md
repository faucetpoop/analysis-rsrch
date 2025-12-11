# Sandbox 04: Analysis & Reporting

**Status:** Active
**Priority:** Final Outputs (run fourth)
**Features:** 6 failing

## Purpose

Final outputs: Choropleth maps, survey-weighted tables, and Word exports for thesis integration. This sandbox produces publication-ready visualizations and tables.

## Quick Start

```bash
cd sandboxes/04-analysis-reporting
agent-foreman status
agent-foreman next
```

## Features

### Geospatial Analysis (3 features)
| ID | Description | Status |
|----|-------------|--------|
| geospatial.data.load-gadm | Load Vietnam administrative boundaries | failing |
| geospatial.mapping.choropleth | Create choropleth maps using tmap | failing |
| geospatial.aggregation.survey-weighted | Aggregate survey-weighted statistics by province | failing |

### Reporting (3 features)
| ID | Description | Status |
|----|-------------|--------|
| reporting.tables.descriptive-summary | Generate Table 1 sample characteristics | failing |
| reporting.tables.indicator-results | Create indicator summary tables | failing |
| reporting.export.word-docx | Export tables to Word format | failing |

## Research Areas Included

- **09-geospatial** - Geospatial analysis and mapping
- **10-reporting** - Descriptive statistics and thesis reporting

## Key Resources

- `/docs/area-8-geospatial-analysis.md` - Spatial analysis methods
- `/docs/area-9-descriptives-reporting.md` - gtsummary and flextable workflows
- `/docs/scripts/` - Reference scripts for mapping and table generation
- `/docs/templates/` - Table and figure templates

## Dependencies

**Upstream:** 03-indicators (needs calculated indicators for visualization)
**Downstream:** None (this produces final outputs)

## Success Criteria

- Vietnam GADM boundaries loaded at province/district level
- Choropleth maps created for food security indicators
- Survey-weighted statistics aggregated by province
- Table 1 (sample characteristics) generated with survey weights
- Indicator summary tables with confidence intervals
- All tables exported to Word format for thesis integration

## Next Steps

After completing this sandbox:
1. Review all outputs for thesis integration
2. Verify map accuracy and clarity
3. Check table formatting meets thesis requirements
4. Consider additional visualizations if needed

## Notes

This sandbox produces thesis-ready outputs. Focus on publication quality - maps should be clear and accessible, tables should follow APA formatting or thesis guidelines. All statistics must be survey-weighted using the srvyr package.
