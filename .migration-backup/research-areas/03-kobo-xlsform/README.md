# KoboToolbox & XLSForm Structure - Best Practices Guide

## Quick Reference
- **Purpose**: Understand survey structure and data export formats
- **Key Packages**: robotoolbox, tidyr, fastDummies
- **Related Areas**: [02-r-workflow](../02-r-workflow/), [04-data-management](../04-data-management/)
- **Agent-Foreman Features**: `data-import.kobo.api-connection`, `data-import.kobo.download-submissions`, `data-import.xlsform.parse-structure`

## Prerequisites
- [ ] KoboToolbox account with API token
- [ ] Access to XLSForm file
- [ ] robotoolbox package installed

## Core Workflow

### Step 1: Set Up API Connection
```r
# Store in .Renviron
KOBOTOOLBOX_URL=https://kf.kobotoolbox.org/
KOBOTOOLBOX_TOKEN=your_api_token_here

# Or set programmatically
kobo_setup(url = "https://kf.kobotoolbox.org",
           token = "your_api_token")
```

### Step 2: Download Data
```r
library(robotoolbox)

# List available assets
assets <- kobo_asset_list()

# Download data
data <- kobo_data(asset_id = "your_asset_id",
                  select_multiple_sep = "/")
```

### Step 3: Understand Skip Logic
Document all `relevant` expressions from XLSForm:
```r
# Skip logic creates structural missingness
# If Q2 shown only when Q1 == "yes":
data %>%
  mutate(
    q2_structural_na = is.na(q2) & q1 != "yes",
    q2_nonresponse = is.na(q2) & q1 == "yes"
  )
```

### Step 4: Handle Select_multiple
```r
# Method 1: Create binary columns
library(fastDummies)
data_dummies <- data %>%
  dummy_cols(
    select_columns = "food_sources",
    split = " ",
    remove_selected_columns = FALSE
  )

# Method 2: Manual with str_detect
data <- data %>%
  mutate(
    source_market = if_else(str_detect(food_sources, "market"), 1, 0),
    source_garden = if_else(str_detect(food_sources, "garden"), 1, 0)
  )
```

## Checklists

### Before Starting
- [ ] KoboToolbox API token obtained
- [ ] XLSForm file accessible
- [ ] robotoolbox package installed

### Quality Assurance
- [ ] All modules documented with purposes
- [ ] Skip logic patterns mapped
- [ ] All select_multiple questions identified
- [ ] Processing strategy defined for each multi-select
- [ ] Repeat group relationships documented

## Common Pitfalls
1. **Ignoring skip logic**: Treating all NAs as missing → **Solution**: Map relevant expressions
2. **Wrong N for multi-select**: Using response count instead of respondent count → **Solution**: Calculate N as respondents asked
3. **Losing repeat group links**: Not preserving parent-child relationships → **Solution**: Use `_uuid` and `_parent_uuid`

## Templates
- `templates/xlsform-documentation-template.md` - Document survey modules

## External Resources
- [robotoolbox Website](https://dickoa.gitlab.io/robotoolbox/)
- [KoboToolbox XLSForm Guide](https://support.kobotoolbox.org/getting_started_xlsform.html)
- [R for the Rest of Us: Select All](https://rfortherestofus.com/2022/05/select-all/)

## Related Areas
- [02-r-workflow](../02-r-workflow/) - R environment setup
- [04-data-management](../04-data-management/) - Data cleaning after import
- [08-documentation-standards](../08-documentation-standards/) - Codebook creation
