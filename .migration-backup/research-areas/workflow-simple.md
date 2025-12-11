# Analysis Workflow

```text
WEEK 1: FOUNDATION
───────────────────
Survey Context → R Setup
                    ↓
WEEK 2: DATA PREP
───────────────────
Import → Clean → Design Object
                    ↓
WEEKS 3-4: ANALYSIS
───────────────────
Food Security ─┬─ Economics ─┬─ Likert
(HDDS/FCS)     │  (poverty)  │  (alpha)
               └──────┬──────┘
                      ↓
WEEK 5: OUTPUTS
───────────────────
Maps ─────┬───── Tables ─────┬───── Docs
(.png)    │     (.docx)      │   (codebook)
          └────────┬─────────┘
                   ↓
            THESIS READY
```

## Data Checkpoints

```
raw/*.rds → clean.rds → indicators.rds → analysis_ready.rds
[never edit]
```

## Scripts (run in order)

1. `01-data-import.R`
2. `02-data-cleaning.R`
3. `03-survey-design.R`
4. `04-calculate-indicators.R`
5. `05-economic-indicators.R`
6. `06-likert-analysis.R`
7. `07-create-maps.R`
8. `08-create-tables.R`
9. `09-create-documentation.R`

## Quick Lookup

| Task | Folder |
|------|--------|
| Survey meaning | 01-survey-context |
| Package install | 02-r-workflow |
| KoboToolbox | 03-kobo-xlsform |
| Missing data | 04-data-management |
| HDDS/FCS/rCSI | 05-food-security |
| Poverty/income | 06-income-expenditure |
| Scale reliability | 07-likert |
| Codebook | 08-documentation |
| Maps | 09-geospatial |
| Word tables | 10-reporting |

---
See: [[workflow-anatomy]] for full diagram
