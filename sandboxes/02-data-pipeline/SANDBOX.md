# Sandbox 02: Data Pipeline

**Status:** Active
**Priority:** Core Infrastructure (run second)
**Features:** 7 failing

## Purpose

Core infrastructure: R project setup, Kobo API connection, data cleaning and version merging. This sandbox establishes the data pipeline from KoboToolbox to clean, analysis-ready datasets.

## Quick Start

```bash
cd sandboxes/02-data-pipeline
agent-foreman status
agent-foreman next
```

## Features

| ID | Description | Status |
|----|-------------|--------|
| core.config.project-setup | Initialize R project with renv and structure | failing |
| core.config.package-dependencies | Install required R packages | failing |
| data-import.kobo.api-connection | Connect to KoboToolbox API | failing |
| data-import.kobo.download-submissions | Download survey submissions | failing |
| data-cleaning.versions.merge-ab | Merge survey versions A and B | failing |
| data-cleaning.multiselect.process | Process select_multiple columns | failing |
| data-cleaning.missing.classify | Classify missing data types | failing |

## Research Areas Included

- **02-r-workflow** - R project setup and survey analysis workflow
- **04-data-management** - Raw data management and cleaning

## Key Resources

- `/docs/R-Survey-Analysis-Best-Practices.md` - Comprehensive R workflow guide
- `/docs/area-1-r-workflow-survey-analysis.md` - Survey-specific R patterns
- `/docs/area-3-raw-data-management.md` - Data cleaning strategies
- `/docs/scripts/` - Reference scripts for data processing

## Dependencies

**Upstream:** 01-survey-understanding (codebook and construct mapping)
**Downstream:** 03-indicators (needs clean data for calculations)

## Success Criteria

- R project initialized with renv and proper folder structure
- KoboToolbox API connection working with authentication
- Survey versions A and B successfully merged with proper NA handling
- select_multiple columns processed into binary indicators
- Missing data classified as structural vs non-response vs error

## Next Steps

After completing this sandbox:
1. Move to **03-indicators** to calculate food security and economic indicators
2. Use cleaned data for indicator calculations
3. Apply survey weights during analysis

## Notes

Requires KoboToolbox API credentials. Survey versions A (without food waste module) and B (with food waste module) need careful merging to handle structural missingness correctly.
