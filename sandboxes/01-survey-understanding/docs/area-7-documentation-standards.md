# Area 7 – Documentation: Data Dictionary, Codebook, Survey Appendix

**Goal:** Have clear documentation that supports the thesis and your own sanity.

---

## The Importance of Codebooks

Codebooks (data dictionaries) are essential for:
- Understanding variable meanings
- Proper interpretation by external researchers
- Reproducibility
- Long-term data preservation
- Facilitating meta-analysis

**Key Principle:** A codebook should make data **self-explanatory** to someone outside your research group.

---

## What to Include in a Codebook

### Essential Elements

| Element | Description |
|---------|-------------|
| Variable name | Unique identifier (e.g., Q1, income_total, hdds_score) |
| Variable label | Human-readable description |
| Variable type | Numeric, character, factor, date |
| Value labels | Meanings of coded values |
| Missing data codes | Why data is missing (-77 = refused, etc.) |
| Units | For numeric variables (VND, kg, days, etc.) |
| Valid range | Minimum and maximum acceptable values |
| Skip patterns | When variables should be NA |
| Source question | Original survey question text |
| Notes | Special considerations or data quality issues |

---

## R Packages for Codebook Creation

### codebook Package (Recommended)

**Features:**
- Automatic generation from data frames
- Integrates with RMarkdown
- HTML, PDF, Word output
- JSON-LD for search engine indexing
- Reliability analysis for scales
- Works with labelled data

```r
library(codebook)

# Add metadata to variables
data <- data %>%
  mutate(
    income_total = income_total %>%
      labelled::set_variable_labels(
        "Total household income in past month (VND)"
      ) %>%
      labelled::add_value_labels(
        .list = c("Refused" = -77, "Don't know" = -88)
      ),

    province = province %>%
      labelled::set_variable_labels("Province of residence") %>%
      labelled::add_value_labels(
        "Hanoi" = 1,
        "Ho Chi Minh City" = 2,
        "Da Nang" = 3
      )
  )

# Generate codebook
codebook_data <- codebook(data)

# Or create table summary
codebook::codebook_table(data)
```

### codebookr Package

**Features:**
- Creates Word documents
- Uses flextable and officer packages
- Table-based layout

```r
library(codebookr)

# Create basic codebook
cb <- codebook(
  df = data,
  title = "Vietnam Food Security Survey Codebook",
  subtitle = "Household Survey 2024",
  description = "This codebook documents variables from..."
)

# Add custom attributes
cb_detailed <- cb %>%
  cb_add_col_attributes(
    name = c("income_total", "hdds_score"),
    description = c(
      "Total household income from all sources in past month",
      "Household Dietary Diversity Score (0-12 food groups)"
    ),
    source = c(
      "Question H1: What was your total household income...",
      "Calculated from 24-hour dietary recall (Questions D1-D12)"
    )
  )

# Export to Word
print(cb_detailed, "survey_codebook.docx")
```

### dataReporter Package (formerly dataMaid)

**Purpose:**
- Data screening and quality reporting
- Automatic codebook generation
- Flag potential problems in data

```r
library(dataReporter)

# Generate codebook report
makeCodebook(data, output = "html")
```

### pointblank Package

**Purpose:**
- Data quality assessment
- Metadata reporting
- Living data dictionaries

```r
library(pointblank)

# Create informant with metadata
informant <- create_informant(tbl = data) %>%
  info_columns(columns = "income_total",
    info = "Total household income in VND/month"
  ) %>%
  info_snippet(snippet_name = "mean_income",
    fn = ~mean(.$income_total, na.rm = TRUE)
  )
```

---

## Variable Naming Conventions

### Good Practices
```r
# Use question numbers
Q1, Q2a, Q2b

# Or descriptive names
income_total, hdds_score, province

# Be consistent
# Use lowercase with underscores
# Avoid spaces and special characters
```

### Avoid
```r
# Not meaningful
VAR001, VAR002

# Mixed case (hard to remember)
IncomeTotal

# Hyphens (can cause issues)
income-total

# Spaces
income total
```

---

## Missing Data Documentation

```r
# Create missing data summary
missing_report <- data %>%
  summarize(across(
    everything(),
    list(
      n_missing = ~sum(is.na(.)),
      pct_missing = ~mean(is.na(.)) * 100
    )
  )) %>%
  pivot_longer(
    everything(),
    names_to = c("variable", ".value"),
    names_pattern = "(.+)_(n_missing|pct_missing)"
  )

# Export
write_csv(missing_report, "missing_data_summary.csv")
```

---

## Survey Appendix Tables

### Table A1: Survey Design Summary

```r
library(gt)

survey_design_table <- tibble(
  Component = c("Sample frame", "Sampling method", "Sample size",
                "Response rate", "Survey period", "Survey mode"),
  Description = c(
    "Households in 3 provinces (Hanoi, Da Nang, HCMC)",
    "Stratified random sampling by province and urban/rural",
    "1,200 households (400 per province)",
    "87.5% (1,050 completed surveys)",
    "March - May 2024",
    "Face-to-face interviews with household head"
  )
) %>%
  gt() %>%
  tab_header(
    title = "Table A1. Survey Design Characteristics",
    subtitle = "Vietnam Food Security Household Survey 2024"
  )

gtsave(survey_design_table, "table_a1_survey_design.html")
```

### Table A2: Variable Definitions

```r
variable_definitions <- tibble(
  Variable = c("hdds_score", "fies_raw", "income_pc", "poverty_status"),
  Definition = c(
    "Household Dietary Diversity Score: count of 12 food groups consumed in past 24 hours",
    "Food Insecurity Experience Scale: sum of 8 yes/no items (range 0-8)",
    "Per capita household income: total income divided by household size (VND/month)",
    "Poverty status: 1 if expenditure per capita below poverty line, 0 otherwise"
  ),
  `Valid Range` = c("0-12", "0-8", "0-50,000,000", "0-1"),
  Source = c(
    "FAO HDDS guidelines",
    "FAO FIES module",
    "Calculated from Q.H1 and Q.H2",
    "Vietnam poverty line 2024"
  )
) %>%
  gt() %>%
  tab_header(title = "Table A2. Variable Definitions")
```

### Table A3: Survey Modules

| Module | Purpose | Key Questions | Indicators |
|--------|---------|---------------|------------|
| Demographics | Household characteristics | Q1-Q15 | Sample description |
| Food consumption | Dietary recall | D1-D12 | HDDS |
| Food security | Experience scale | FS1-FS8 | FIES raw score |
| Income | Sources and amounts | I1-I10 | Total income |
| Expenditure | Spending categories | E1-E20 | Food share |
| Food waste | Behaviours and attitudes | FW1-FW15 | Waste frequency |

---

## Importing Existing Data Dictionaries

If you have a spreadsheet codebook:

```r
# Read existing data dictionary
data_dict <- read_excel("data_dictionary.xlsx")

# Apply labels to data
library(labelled)

for(i in 1:nrow(data_dict)) {
  var_name <- data_dict$variable[i]
  var_label <- data_dict$label[i]

  if(var_name %in% names(data)) {
    var_label(data[[var_name]]) <- var_label
  }
}
```

---

## Questionnaire Documentation

Include in appendix:
1. **Full questionnaire text**
2. **Skip logic flow diagrams**
3. **Enumerator instructions**
4. **Translations** (if multilingual)
5. **Pre-test results and revisions**

---

## Package Comparison

| Package | Best For | Output Formats |
|---------|----------|----------------|
| codebook | Comprehensive auto-generated codebooks | HTML, PDF, Word |
| codebookr | Word documents with custom attributes | Word |
| dataReporter | Data quality reports + codebooks | HTML, PDF |
| pointblank | Ongoing validation + metadata | HTML |
| skimr | Quick exploratory summaries | Console, RMarkdown |
| gtsummary | Analysis tables (descriptive, regression) | HTML, Word, PDF, LaTeX |

---

## Checklist

- [ ] Define variable naming conventions
- [ ] Add variable labels to all variables
- [ ] Add value labels to categorical variables
- [ ] Document missing data codes and reasons
- [ ] Generate automatic codebook with codebook or codebookr
- [ ] Create survey design summary table
- [ ] Create variable definitions table
- [ ] Create survey modules table
- [ ] Document skip logic patterns
- [ ] Include full questionnaire in appendix
- [ ] Generate missing data summary

---

## Resources

### Codebook Packages
- [codebook Package](https://rubenarslan.github.io/codebook/)
- [codebook Tutorial](https://cran.r-project.org/web/packages/codebook/vignettes/codebook_tutorial.html)
- [codebookr Documentation](https://brad-cannell.github.io/codebookr/)
- [dataReporter (dataMaid)](https://github.com/ekstroem/dataMaid)

### Survey Documentation
- [Tidy Survey Book - Documentation](https://tidy-survey-r.github.io/tidy-survey-book/c03-survey-data-documentation.html)
- [Penn Libraries: Codebooks & Data Dictionaries](https://guides.library.upenn.edu/c.php?g=564157&p=9554907)

### Academic Standards
- [How to Automatically Document Data (SAGE)](https://journals.sagepub.com/doi/full/10.1177/2515245919838783)
