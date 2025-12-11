# Codebook: [Dataset Name]

## Dataset Overview

| Attribute | Value |
|-----------|-------|
| **Dataset Name** | |
| **Version** | |
| **Date Created** | |
| **Last Modified** | |
| **Number of Observations** | |
| **Number of Variables** | |
| **Data Source** | |
| **Contact** | |

---

## Variable Documentation

### Section: [Section Name]

| Variable | Label | Type | Values | Missing Codes | Notes |
|----------|-------|------|--------|---------------|-------|
| `var1` | Description | numeric | 0-100 | -77=Refused | |
| `var2` | Description | factor | 1=Yes, 2=No | -88=Don't know | |
| `var3` | Description | character | Free text | NA=Not answered | |

---

## Missing Data Codes

| Code | Meaning |
|------|---------|
| -77 | Refused to answer |
| -88 | Don't know |
| -99 | Not applicable (structural) |
| NA | No response / System missing |

---

## Derived Variables

| Variable | Label | Formula | Source Variables |
|----------|-------|---------|------------------|
| `hdds_score` | HDDS (0-12) | Sum of food groups | fg_1 through fg_12 |
| `income_pc` | Per capita income | income_total / household_size | income_total, household_size |

---

## Skip Logic Patterns

| Variable | Shown When | Structural NA When |
|----------|------------|-------------------|
| `child_age` | has_children == 1 | has_children != 1 |
| `fw_*` | survey_version == "B" | survey_version == "A" |

---

## Value Labels

### [Variable Name]

| Value | Label |
|-------|-------|
| 1 | Category 1 |
| 2 | Category 2 |
| 3 | Category 3 |

---

## Data Quality Notes

### Known Issues
- [List any known data quality issues]

### Cleaning Applied
- [List data cleaning steps applied]

### Recommendations
- [Any recommendations for users]

---

## Change Log

| Date | Version | Changes |
|------|---------|---------|
| YYYY-MM-DD | 1.0 | Initial release |
| YYYY-MM-DD | 1.1 | Added derived variables |
