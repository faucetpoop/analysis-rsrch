# Area 2 – KoBo / XLSForm & Survey Structure

**Goal:** Understand exactly how your questionnaire becomes your dataset.

---

## XLSForm Basics

### Key Sheets
- **survey:** Question definitions
- **choices:** Response options for select questions
- **settings:** Form configuration

### Key Fields in Survey Sheet
| Field | Purpose |
|-------|---------|
| `type` | Question type (text, integer, select_one, etc.) |
| `name` | Variable name in exported data |
| `label` | Question text shown to enumerator |
| `relevant` | Skip logic expression |
| `choice_filter` | Dynamic filtering of choices |
| `constraint` | Validation rules |
| `required` | Whether response is mandatory |

### Choice Names
- Must be unique within a choice list
- Same choice name can be reused across different lists
- Example: `yes_no` and `yes_no_maybe` lists can both have `yes` and `no`

---

## Module Groups

### Group Structure
```
begin_group
  name: demographics
  label: Demographic Information

  [questions inside group]

end_group
```

### Repeat Groups
```
begin_repeat
  name: household_members
  label: Household Member Details
  repeat_count: ${num_members}

  [repeated questions]

end_repeat
```

- Creates parent-child relationships in data
- Exported as separate sheets/files
- Must join back using `_uuid` and `_parent_uuid`

---

## Skip Logic (Relevant Field)

### Understanding Skip Logic
- Controls when questions are displayed
- Creates **structural missingness** in data
- Distinguish from true non-response

### Example Relevant Expressions
```
${has_children} = 'yes'
${age} >= 18
${income_source} = 'agriculture' or ${income_source} = 'fishing'
```

### Implications for Analysis
```r
# Document skip patterns
# If Q2 is only shown when Q1 == "yes"
# Then Q2 NAs when Q1 != "yes" are structural, not missing

data %>%
  mutate(
    q2_structural_na = is.na(q2) & q1 != "yes",
    q2_nonresponse = is.na(q2) & q1 == "yes"
  )
```

---

## Select_one vs Select_multiple

### Select_one
- Single response
- Exports as one column with choice name
- Example: `select_one yes_no` → column with "yes" or "no"

### Select_multiple
- Multiple responses allowed
- **Exports in two possible formats:**
  1. Single concatenated column (options separated by spaces)
  2. Multiple binary columns (one per option)

### Processing Select_multiple

**Approach 1: Using tidyr::separate_rows()**
```r
# Data looks like: "option1 option2 option3"
data_expanded <- data %>%
  separate_rows(food_sources, sep = " ") %>%
  mutate(selected = 1)
```

**Approach 2: Creating Binary Variables**
```r
library(fastDummies)

data_dummies <- data %>%
  dummy_cols(
    select_columns = "food_sources",
    split = " ",
    remove_selected_columns = FALSE
  )
```

**Approach 3: Manual with str_detect()**
```r
data <- data %>%
  mutate(
    source_market = if_else(str_detect(food_sources, "market"), 1, 0),
    source_garden = if_else(str_detect(food_sources, "garden"), 1, 0),
    source_forest = if_else(str_detect(food_sources, "forest"), 1, 0)
  )
```

### Calculating N-Sizes for Multiple-Select

**Important:** N should be respondents ASKED the question, not responses given:

```r
n_respondents <- data %>%
  filter(!is.na(food_sources)) %>%
  nrow()

# Calculate percentages based on respondents
data %>%
  summarize(
    pct_market = sum(source_market == 1) / n_respondents * 100,
    pct_garden = sum(source_garden == 1) / n_respondents * 100
  )
```

---

## R Packages for KoboToolbox

### robotoolbox (Recommended)

**Installation:**
```r
pak::pkg_install("dickoa/robotoolbox")
```

**Setup & Authentication:**
```r
# Store in .Renviron
KOBOTOOLBOX_URL=https://kf.kobotoolbox.org/
KOBOTOOLBOX_TOKEN=your_api_token_here

# Or set programmatically
kobo_setup(url = "https://kf.kobotoolbox.org",
           token = "your_api_token")
```

**Key Functions:**
```r
# List available assets
assets <- kobo_asset_list()

# Download data
data <- kobo_data(asset_id = "your_asset_id")

# Handle select_multiple
data <- kobo_data(asset_id = "your_asset_id",
                  select_multiple_sep = "/")
```

**Key Features:**
- Direct API access to KoboToolbox v2
- Preserves labelled data
- Handles repeat groups with dm package
- Automatic select_multiple splitting
- Supports geopoint, geotrace, geoshape as WKT
- Audit log retrieval with `kobo_audit()`

**Supported Servers:**
- https://kf.kobotoolbox.org/
- https://kobo.unhcr.org/
- https://kobo.humanitarianresponse.info/
- Any custom KoboToolbox server

### Alternative Packages

**koboloadeR:**
- Metapackage for workflow automation
- Analysis plan configuration in XLSForm
- Report generation without coding

**kobohr_apitoolbox:**
- Upload and share XLSForms
- API v1 and v2 support

---

## Handling Repeat Groups

```r
library(dm)

# Data comes as relational structure
main_data <- kobo_data(asset_id = "xxx")
repeat_data <- kobo_submissions(asset_id = "xxx",
                                 form = "repeat_group_name")

# Merge using left join
combined <- main_data %>%
  left_join(repeat_data, by = c("_uuid" = "_parent_uuid"))

# Or use dm for relational structure
survey_dm <- dm(
  main = main_data,
  repeats = repeat_data
) %>%
  dm_add_fk(repeats, `_parent_uuid`, main, `_uuid`)
```

---

## Module Table for Appendix

Create a table documenting each survey module:

| Module | Purpose | Key Questions | Indicators |
|--------|---------|---------------|------------|
| Demographics | Household characteristics | Q1-Q15 | Sample description |
| Food consumption | Dietary recall | D1-D12 | HDDS |
| Food security | Experience scale | FS1-FS8 | FIES raw score |
| Income | Sources and amounts | I1-I10 | Total income |
| Expenditure | Spending categories | E1-E20 | Food share |
| Food waste | Behaviours and attitudes | FW1-FW15 | Waste frequency |

---

## Checklist

- [ ] Review XLSForm survey, choices, settings sheets
- [ ] Document module groups and their purposes
- [ ] Map skip logic patterns (relevant expressions)
- [ ] Identify all select_multiple questions
- [ ] Plan processing strategy for each select_multiple
- [ ] Set up robotoolbox connection
- [ ] Test data download and structure
- [ ] Document repeat group relationships

---

## Resources

### KoboToolbox Documentation
- [Getting started with XLSForm](https://support.kobotoolbox.org/getting_started_xlsform.html)
- [KoboToolbox Community Forum](https://community.kobotoolbox.org/)

### robotoolbox
- [robotoolbox Website](https://dickoa.gitlab.io/robotoolbox/)
- [robotoolbox GitHub](https://github.com/dickoa/robotoolbox)
- [KoboToolbox Forum Introduction](https://community.kobotoolbox.org/t/introducing-the-r-package-robotoolbox/26018)

### Handling Multiple-Select
- [R for the Rest of Us: Select All](https://rfortherestofus.com/2022/05/select-all/)
- [fastDummies Package](https://cran.r-project.org/web/packages/fastDummies/)
