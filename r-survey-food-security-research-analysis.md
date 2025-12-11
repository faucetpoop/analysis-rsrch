# R Resources for Survey Data Analysis: Food Security Research
**Research Analysis Report**
Date: 2025-12-10
Status: Research Complete
Type: Resource Analysis

## Executive Summary

This comprehensive research analysis identifies and evaluates R packages,
documentation, and code repositories for conducting thesis-quality survey data
analysis focused on food security indicators, KoboToolbox workflows, and
Vietnam-specific contexts. The analysis covers 7 major research objectives with
specific package recommendations, implementation examples, and direct links to
official documentation.

---

## 1. R Packages for Survey Analysis

### Core Survey Packages

**srvyr Package** (Primary Recommendation)
- **Purpose**: Tidyverse-compatible interface for complex survey analysis
- **Key Features**: Dplyr-like syntax for survey means, proportions, quantiles
- **Installation**: `pak::pkg_install("gergness/srvyr")`
- **Documentation**: [Official CRAN](https://cran.r-project.org/web/packages/srvyr/srvyr.pdf)
- **GitHub**: [gergness/srvyr](https://github.com/gergness/srvyr)
- **Updated**: July 23, 2025

**survey Package** (Foundation)
- **Purpose**: Original R package for complex survey design (2003-)
- **Capabilities**: Point estimates, variance estimation, regression models
- **Relationship**: srvyr wraps survey functions with tidyverse syntax
- **Best Practice**: Use srvyr for analysis, survey for advanced features

**Comprehensive Textbook Resource**
- **Title**: "Exploring Complex Survey Data Analysis Using R"
- **Authors**: Zimmer, Powell, Velasquez (CRC Press, November 2024)
- **Free Online**: [Tidy Survey Book](https://tidy-survey-r.github.io/tidy-survey-book/)
- **GitHub**: [tidy-survey-r/tidy-survey-book](https://github.com/tidy-survey-r/tidy-survey-book)
- **Companion Package**: srvyrexploR ([GitHub](https://github.com/tidy-survey-r/srvyrexploR))
- **Coverage**: Complex designs, weighting, stratification, clustering

**New Extension: svrep Package (2025)**
- **Purpose**: Resampling-based variance estimation
- **Use Case**: Construct replicate weights for complex samples
- **Published**: Survey Statistician January 2025 (Issue 91)
- **Complements**: srvyr (for analysis) + svrep (for variance estimation)

### Survey Design Specification

**Key Functions** (survey package):
```r
library(survey)
options(survey.lonely.psu = "adjust")
options(survey.adjust.domain.lonely = TRUE)

# Stratified cluster design
design <- svydesign(
  strata = ~SDMVSTRA,
  id = ~SDMVPSU,
  weights = ~WTSAF2YR,
  nest = TRUE,
  data = survey_data
)
```

**Key Concepts**:
- **Stratification**: Reduces standard errors by grouping similar units
- **Clustering (PSUs)**: Accounts for hierarchical sampling structure
- **Design Effects (DEFF)**: Variance inflation due to complex design
- **Weights**: Probability of selection + post-stratification adjustments

**Learning Resources**:
- [UCLA Survey Data Analysis with R](https://stats.oarc.ucla.edu/r/seminars/survey-data-analysis-with-r/)
- [Social Research Update 43](https://sru.soc.surrey.ac.uk/SRU43.html)
- [Tidy Survey Book Chapter 10](https://tidy-survey-r.github.io/tidy-survey-book/c10-sample-designs-replicate-weights.html)

---

## 2. KoboToolbox/XLSForm Integration

### Primary Package: robotoolbox

**Official R Package** (CRAN + GitHub)
- **Repository**: [dickoa/robotoolbox](https://github.com/dickoa/robotoolbox)
- **Documentation**: [robotoolbox website](https://dickoa.gitlab.io/robotoolbox/)
- **API Version**: KoboToolbox API v2
- **CRAN**: [robotoolbox](https://cran.r-project.org/web/packages/robotoolbox/index.html)

**Installation**:
```r
# From GitHub
pak::pkg_install("dickoa/robotoolbox")

# From GitLab
remotes::install_gitlab("dickoa/robotoolbox")
```

**Setup & Authentication**:
```r
# Store in .Renviron
KOBOTOOLBOX_URL=https://kobo.unhcr.org/
KOBOTOOLBOX_TOKEN=your_api_token_here

# Retrieve token
kobo_token()
```

**Key Features**:
- **Asset Management**: List and filter forms by UID
- **Data Extraction**: `kobo_data()` / `kobo_submissions()` functions
- **Spatial Data**: Handles geopoint, geotrace, geoshape as WKT
- **Linked Data**: Uses `dm` package for relational queries
- **Audit Logs**: `kobo_audit()` function for quality control

**Handling select_multiple**:
- robotoolbox automatically splits select_multiple into binary columns
- Relationship modeling via `dm` package for linked questions
- Supports select_one_from_file and select_multiple_from_file

**Supported Servers**:
- https://kobo.unhcr.org/
- https://kf.kobotoolbox.org/
- https://kobo.humanitarianresponse.info/
- Any custom KoboToolbox server

**Community Introduction**:
- [KoboToolbox Forum Post](https://community.kobotoolbox.org/t/introducing-the-r-package-robotoolbox/26018)

### Alternative Packages

**kobohr_apitoolbox**
- **GitHub**: [ppsapkota/kobohr_apitoolbox](https://github.com/ppsapkota/kobohr_apitoolbox)
- **Features**: Upload, share XLSForm, download data
- **APIs**: Both KPI (v2) and API v1 support

**koboAPI**
- **GitHub**: [ElliottMess/koboAPI](https://github.com/ElliottMess/koboAPI)
- **Purpose**: Link KoboToolbox API with R
- **Status**: Alternative implementation

**surveycto Package (XLSForm-compatible)**
- **Developer**: Waiguru254
- **Functions**: `koboimport`, `rodkmult`, `rodkmultlab`, `rodksinglelab`
- **GitHub**: [Waiguru254/surveycto](https://github.com/Waiguru254/surveycto)

**Related Inspiration: ruODK**
- **Purpose**: ODK Central API client for R
- **Relevance**: Inspired robotoolbox design
- **Use if**: Working with ODK instead of KoboToolbox

---

## 3. Food Security Indicator Implementations

### FIES (Food Insecurity Experience Scale)

**Official FAO Package: RM.weights**
- **CRAN**: [RM.weights](https://cran.r-project.org/web/packages/RM.weights/index.html)
- **GitHub Mirror**: [cran/RM.weights](https://github.com/cran/RM.weights)
- **Version**: 2.0 (July 21, 2025)
- **Authors**: Carlo Cafiero, Mark Nord, Sara Viviani (FAO)
- **Maintainer**: sara.viviani@fao.org

**Methodology**:
- **Statistical Model**: Rasch model (Item Response Theory)
- **Estimation**: Weighted Conditional Maximum Likelihood (CML)
- **Questions**: 8-item scale (yes/no responses)
- **Recall Period**: 1 month or 12 months

**Key Features**:
- Statistical validation of FIES using Rasch model
- Prevalence rate calculation for SDG Indicator 2.1.2
- Equate item parameters across contexts/countries
- Handles dichotomous and polytomous (partial credit) items
- Global standard: 2014-2016 FAO reference (default)

**Sample Data Included**:
- Gallup World Poll FIES data
- Sampling weights + demographic variables
- Multiple country examples

**Documentation**:
- [Manual for RM.weights Implementation](https://www.sesric.org/imgs/news/1752_Manual_on_RM_Weights_Package_EN.pdf)
- [FAO Voices of the Hungry](https://www.fao.org/in-action/voices-of-the-hungry/fies/en/)
- [INDDEX FIES Page](https://inddex.nutrition.tufts.edu/data4diets/indicator/food-insecurity-experience-scale-fies)

**Output Indicators**:
1. Proportion with moderate or severe food insecurity (SDG 2.1.2)
2. Proportion with severe food insecurity

**Learning Resources**:
- [SDG 2.1.2 e-Learning Course](https://elearning.fao.org/pluginfile.php/491591/mod_scorm/content/5/story_content/external_files/SDG2.1.2_lesson4.pdf)
- [IMPACT-R FIES Report](https://impact-r.org/reports/apide/html/food/fies_intro.html)

### FCS, rCSI, HDDS, HFIAS (WFP Indicators)

**WFP-VAM GitHub Organization**
- **Main Page**: [WFP-VAM](https://github.com/WFP-VAM)
- **Purpose**: Food security, markets, climate analysis tools

**Key Repositories**:

**1. DataQualityChecks** (Python, not R - but has R syntax files)
- **Repository**: [WFP-VAM/DataQualityChecks](https://github.com/WFP-VAM/DataQualityChecks)
- **Indicators**: FCS, rCSI, HDDS, HFIAS, Household Expenditure
- **Language**: Primarily Python
- **R Resources**: SPSS/R syntax available for expenditure cleaning
- **Status**: Under development

**2. RBD_FS_CH_guide_EN** (Comprehensive Guide)
- **Repository**: [WFP-VAM/RBD_FS_CH_guide_EN](https://github.com/WFP-VAM/RBD_FS_CH_guide_EN)
- **Online Book**: [Cadre Harmonisé Guide](https://wfp-vam.github.io/RBD_FS_CH_guide_EN/)
- **Content**:
  - Chapter 4: Household Hunger Scale
  - Chapter 5: rCSI (questionnaire + R/SPSS syntax)
  - Chapter 6: FCS & HDDS (questionnaire + R/SPSS syntax)

**3. RAMResourcesScripts**
- **Purpose**: Corporate needs assessment micro-data analysis
- **Contribution**: Public space for sharing scripts

**4. wfpthemes**
- **Repository**: [WFP-VAM/wfpthemes](https://github.com/WFP-VAM/wfpthemes)
- **Purpose**: WFP-branded data visualizations
- **Installation**: `remotes::install_github("WFP-VAM/wfpthemes")`

**5. DataBridgesKnots**
- **Repository**: [WFP-VAM/DataBridgesKnots](https://github.com/WFP-VAM/DataBridgesKnots/)
- **Purpose**: Get WFP VAM monitoring data (Python, STATA, R)

### Food Consumption Score (FCS)

**Calculation Method**:
1. Sum consumption frequencies by food group (9 groups)
2. Recode values >7 to 7
3. Multiply by importance weights (per WFP guidelines)
4. Sum weighted scores = FCS

**Thresholds**:
- **Standard**: Poor ≤21, Borderline 21.5-35, Acceptable >35
- **Oil/Sugar Areas**: Poor <28, Borderline 28-42, Acceptable >42

**Official Documentation**:
- [WFP FCS Metadata](https://www.wfp.org/publications/meta-data-food-consumption-score-fcs-indicator)
- [VAM Resource Centre](https://vamresources.manuals.wfp.org/docs/food-consumption-score)
- [INDDEX FCS Page](https://inddex.nutrition.tufts.edu/data4diets/indicator/food-consumption-score-fcs)
- [FSCluster Handbook](https://fscluster.org/handbook/Section_two_fcs.html)

**R Implementation**:
- WFP RBD Guide Chapter 6 includes R syntax
- No dedicated CRAN package found
- Straightforward to implement from guidelines

### Household Dietary Diversity Score (HDDS)

**Food Groups**: 12 groups (FAO standard)
**Recall Period**: 24 hours
**Classification**:
- Low: ≤5 food groups
- Medium: 6-8 food groups
- High: ≥9 food groups

**Official Guidelines**:
- [FAO Guidelines PDF](https://www.fao.org/4/i1983e/i1983e00.pdf)
- [FANTA Guide](https://www.fantaproject.org/monitoring-and-evaluation/household-dietary-diversity-score)
- [WFP VAM HDDS](https://vamresources.manuals.wfp.org/docs/household-dietary-diversity-score-hdds)
- [INDDEX HDDS Page](https://inddex.nutrition.tufts.edu/data4diets/indicator/household-dietary-diversity-score-hdds)

**R Implementation**:
- WFP RBD Guide Chapter 6 includes R syntax
- XLS questionnaire templates available
- No dedicated CRAN package identified

### Household Food Insecurity Access Scale (HFIAS)

**Score Range**: 0-27 (lower = less food insecurity)
**Recall Period**: Past 4 weeks (30 days)
**Output**: 4 types of indicators

**Official Documentation**:
- [FSCluster HFIAS Handbook](https://fscluster.org/handbook/Section_two_hfias.html)
- FANTA technical papers

**R Implementation**:
- WFP DataQualityChecks validates HFIAS
- No dedicated CRAN package found

### Reduced Coping Strategies Index (rCSI)

**Questions**: 5 strategies over past 7 days
**Calculation**: Frequency × severity weight
**Thresholds** (IPC Phase):
- Phase 1: 0-3
- Phase 2: 4-18
- Phase 3: ≥19

**Official Documentation**:
- [FSCluster rCSI Handbook](https://fscluster.org/handbook/Section_two_rcsi.html)
- [IndiKit rCSI](https://www.indikit.net/indicator/3950-reduced-coping-strategy-index-rcsi)
- [RBD Guide Chapter 5](https://wfp-vam.github.io/RBD_FS_CH_guide_EN/)

**R Implementation**:
- WFP RBD Guide Chapter 5 includes tidyverse syntax
- Example: Convert rCSI to IPC thresholds

### Additional Food Security Resources

**Comprehensive Comparisons**:
- [FANTA Household Food Consumption Indicators Study](https://www.fantaproject.org/sites/default/files/resources/HFCIS-report-Dec2015.pdf)
- [IPC Guidance Note on Indicators](https://www.ipcinfo.org/fileadmin/user_upload/ipcinfo/docs/IPC_Guidance_Note_on_Indicators.pdf)
- [Systematic Literature Review](https://pmc.ncbi.nlm.nih.gov/articles/PMC10161169/)

---

## 4. Documentation Tools for Survey Data

### gtsummary Package (Primary Recommendation)

**Overview**:
- **Purpose**: Publication-ready summary and analytic tables
- **Website**: [gtsummary](https://www.danieldsjoberg.com/gtsummary/)
- **Citation**: Sjoberg et al. (2021) The R Journal 13:570-80
- **Updated**: Continuously maintained

**Key Features**:
- **One-line code**: Create complex tables with minimal syntax
- **Survey support**: `tbl_svysummary()` for survey objects
- **Multiple outputs**: HTML, Word, RTF, LaTeX, PDF
- **Integrations**: Works with broom, gt, labelled packages
- **Model tables**: Regression, survival, survey models

**Basic Usage**:
```r
library(gtsummary)

# Descriptive table
tbl_summary(data)

# Survey-weighted table
tbl_svysummary(survey_design)

# Export to Word
as_flex_table() %>%
  flextable::save_as_docx(path = "table.docx")
```

**Learning Resources**:
- [The R Journal Article](https://journal.r-project.org/articles/RJ-2021-053/)
- [tbl_summary() Tutorial](https://www.danieldsjoberg.com/gtsummary/articles/tbl_summary.html)
- [RStudio Education Blog](https://education.rstudio.com/blog/2020/07/gtsummary/)
- [gtsummary + Quarto/Rmarkdown](https://www.danieldsjoberg.com/gtsummary/articles/rmarkdown.html)

**Packages to Install**:
- gtsummary, tidyverse, labelled, usethis, causaldata
- fs, skimr, car, emmeans

### dataMaid / dataReporter Package

**Status**: dataMaid renamed to dataReporter (use dataReporter)
- **GitHub**: [ekstroem/dataMaid](https://github.com/ekstroem/dataMaid)
- **CRAN**: [dataMaid](https://cran.r-project.org/web/packages/dataMaid/dataMaid.pdf)

**Purpose**:
- Data screening and quality reporting
- Automatic codebook generation
- Flag potential problems in data

**Key Function**: `makeCodebook()`
- Creates R Markdown codebook
- Outputs to PDF, HTML, Word
- Summarizes dataset contents
- Documents variable types, distributions, missing data

**Citation**:
- Petersen AH, Ekstrøm CT (2019). Journal of Statistical Software 90(6):1-38

**Best For**:
- Technical data documentation
- Quality assurance reporting
- Identifying data issues before analysis

### pointblank Package

**Developer**: RStudio (Posit)
- **GitHub**: [rstudio/pointblank](https://github.com/rstudio/pointblank)
- **Purpose**: Data quality assessment + metadata reporting

**Key Features**:
- **Validation workflow**: Methodical data frame/table validation
- **Informant object**: Maintain and update table information
- **Data dictionary**: `info_*()` functions define metadata
- **Snippets**: `info_snippet()` + `snip_*()` for dynamic stats

**Use Cases**:
- Continuous data quality monitoring
- Living data dictionaries
- Database table documentation

### Survey Data Documentation (from Tidy Survey Book)

**Chapter 3**: [Survey Data Documentation](https://tidy-survey-r.github.io/tidy-survey-book/c03-survey-data-documentation.html)

**Components**:
- **Technical guides**: Survey methodology, sampling design
- **Questionnaires**: Question wording, skip logic
- **Codebooks**: Variable names, labels, codes, missing values
- **Errata**: Known issues, corrections

**Best Practice**:
1. Review all documentation before analysis
2. Understand survey design (weights, strata, clusters)
3. Document variable transformations
4. Create analysis codebook alongside technical codebook

### Additional Documentation Packages

**skimr**:
- Quick data frame summaries
- Inline spark graphs
- Complementary to gtsummary

**gt Package**:
- Foundation for gtsummary
- ~100 functions for table customization
- Fine-grained control over appearance

**Comparison Summary**:
- **gtsummary**: Best for analysis tables (descriptive, regression)
- **dataReporter**: Best for data quality codebooks
- **pointblank**: Best for ongoing data validation
- **skimr**: Best for quick exploratory summaries

---

## 5. Geospatial Survey Analysis

### sf Package (Primary Tool)

**Purpose**: Simple Features for R
**Best Practice**: Modern standard for spatial data in R
**Integration**: Works seamlessly with tidyverse, survey packages

### GADM Data for Vietnam

**Download Sources**:
- **GADM 4.1**: [Download Vietnam](https://gadm.org/download_country.html)
- **GADM 3.6**: [Legacy Version](https://gadm.org/download_country_v3.html)
- **ISO Code**: VNM (for Vietnam)

**File Formats**:
- **GeoPackage** (.gpkg): Recommended modern format
- **Shapefile** (.shp + .shx + .dbf + .prj): Legacy but widely compatible
- Both work with sf and terra packages

**R Packages for GADM**:

**geodata Package** (Recommended):
```r
library(geodata)
vietnam_adm <- gadm(country = "VNM", level = 1, path = tempdir())
```

**GADMTools Package**:
- **CRAN**: [GADMTools](https://www.rdocumentation.org/packages/GADMTools/versions/3.8-2)
- **Functions**: `gadm_sf_loadCountries()` for Simple Features
- **Formats**: SpatialPolygonsDataFrame and sf support (v3.5+)
- **GitHub**: [inSileco/inSilecoDataRetrieval](https://github.com/inSileco/inSilecoDataRetrieval)

**Manual Download**:
- Download .gpkg or .shp for Vietnam provinces/districts
- Load with `sf::st_read("path/to/file.gpkg")`

### Creating Choropleth Maps with Survey Data

**Workflow**:
1. Calculate survey statistics by geographic unit
2. Load Vietnam admin boundaries (GADM)
3. Join survey results to spatial data
4. Create thematic map

**Package Options**:

**tmap Package** (Recommended):
- **Syntax**: Similar to ggplot2 (layered grammar of graphics)
- **Website**: [r-tmap](https://r-tmap.github.io/tmap/)
- **Documentation**: [Thematic Maps](https://r-tmap.github.io/tmap/)

**Basic tmap Syntax**:
```r
library(tmap)

tm_shape(vietnam_data) +
  tm_fill(col = "food_insecurity_rate",
          palette = "YlOrRd",
          title = "FCS Category") +
  tm_borders() +
  tm_layout(legend.outside = TRUE)
```

**ggplot2 + geom_sf**:
- **Tutorial**: [R Graph Gallery Choropleth](https://r-graph-gallery.com/327-chloropleth-map-from-geojson-with-ggplot2.html)
- **Package**: giscoR for easy geometry access

**Basic ggplot2 Syntax**:
```r
library(sf)
library(ggplot2)

ggplot(vietnam_data) +
  geom_sf(aes(fill = food_insecurity_rate)) +
  scale_fill_viridis_c() +
  theme_minimal()
```

**Other Mapping Packages**:
- **leaflet**: Interactive web maps
- **GISTools**: Spatial statistics
- **spplot**: Legacy sp package plotting

### Best Practices for Survey Choropleths

**Data Distribution**:
- Check distribution before mapping (long tail issues)
- Consider log scale for skewed data
- Convert continuous to categorical with meaningful brackets

**Geocoded Point Data**:
- Use `geom_sf()` for point layers over polygon base
- Calculate density/aggregation to polygons for choropleth
- Privacy: Aggregate to admin level (don't show exact locations)

**Learning Resources**:
- [Spatial Data with R - Chapter 3](https://cengel.github.io/R-spatial/mapping.html)
- [R Graph Gallery Choropleth](https://r-graph-gallery.com/choropleth-map.html)
- [CSO Ireland tmap Tutorial](https://www.cso.ie/en/media/csoie/methods/otherresearch/sdgs/Plotting_choropleth_maps_in_R_with_tmap.pdf)
- [Introduction to Choropleth Maps](https://rstudio-pubs-static.s3.amazonaws.com/324400_69a673183ba449e9af4011b1eeb456b9.html)

### Survey-Weighted Spatial Analysis

**Combine survey and sf packages**:
```r
library(survey)
library(sf)

# Create survey design
survey_design <- svydesign(
  ids = ~cluster, strata = ~province,
  weights = ~weight, data = survey_sf_data
)

# Calculate province-level estimates
province_stats <- svyby(
  ~fcs_category, ~province,
  design = survey_design,
  FUN = svymean
)

# Join to spatial data
vietnam_map <- vietnam_adm %>%
  left_join(province_stats, by = c("NAME_1" = "province"))

# Map
tm_shape(vietnam_map) +
  tm_fill(col = "fcs_acceptable", palette = "Greens")
```

---

## 6. Likert Scale Analysis in R

### likert Package

**CRAN**: [likert](https://cran.r-project.org/web/packages/likert/index.html)
**R-Universe**: [jbryer.r-universe.dev/likert](https://jbryer.r-universe.dev/likert)
**Updated**: August 2, 2025

**Purpose**:
- Analyze and visualize Likert response items
- Emphasis on stacked bar plots (preferred method)
- Tabular results + density plots

**Key Functions**:
- `likert()`: Create likert object
- `summary.likert()`: Summarize responses
- `plot.likert()`: Visualize (bar, heat, density plots)

**Visualization Types**:
- `likert.bar.plot()`: Diverging stacked bars (default)
- `likert.heat.plot()`: Heatmap visualization
- `likert.density.plot()`: Density plots for quantitative use

**Plot Customization**:
```r
plot(likert_obj,
     type = "bar",              # or "heat", "density"
     centered = TRUE,           # diverging bars
     center = 3,                # neutral point
     plot.percent.low = FALSE,  # BUG FIX: set to FALSE
     plot.percent.high = FALSE, # to preserve column order
     plot.percent.neutral = FALSE)
```

**Known Issues**:
- **Bug**: Default `plot.percent.*` arguments change variable ordering
  from column order to alphabetical
- **Solution**: Set all percent arguments to FALSE

### LikertEZ Package (New - March 2025)

**CRAN**: [LikertEZ](https://cran.r-project.org/web/packages/LikertEZ/index.html)

**Features**:
- Descriptive statistics
- Relative Importance Index (RII)
- Reliability analysis (Cronbach's Alpha)
- Response distribution plots

**Advantages**:
- More modern interface
- Built-in reliability analysis
- Integrated RII calculation

### Diverging Stacked Bar Charts

**Research Support**:
- [ResearchGate Paper](https://www.researchgate.net/publication/289590282_Design_of_Diverging_Stacked_Bar_Charts_for_Likert_Scales_and_Other_Applications)
- Best for Likert data with comparative evaluation
- Include count information for transparency

**Design Considerations**:
- **Comparability**: Main challenge with diverging bars
- **Centering**: Choose neutral point carefully
- **Scale**: 2/4-level scales may favor diverging bars more than 5/7-level

**ggplot2 Alternative**:
- Create custom diverging bars with `geom_col()` + `position_stack()`
- More control but more code

### Reliability Analysis

**psych Package** (Primary):
- `alpha()`: Cronbach's alpha + Guttman's λ6
- Item-total correlations
- Alpha if item deleted
- Scale diagnostics

**Thresholds**:
- α ≥ 0.70: Acceptable
- α 0.60-0.69: Questionable
- α < 0.60: Unacceptable
- α > 0.95: Possible redundancy

**Advanced Alternative**:
- `omega()`: Hierarchical factor analysis (ω_h, ω_t)
- More complete reliability assessment than alpha

**Learning Resources**:
- [R for HR: Cronbach's Alpha](https://rforhr.com/cronbachsalpha.html)
- [Lisa DeBruine: psych::alpha()](https://debruine.github.io/post/psych-alpha/)
- [RPubs Reliability Analysis](https://rpubs.com/hauselin/reliabilityanalysis)
- Revelle & Condon (2019). Psychological Assessment 31(12):1395-1411

### Visualization Tutorials

- [On Likert Scales in R](https://jakec007.github.io/2021-06-23-R-likert/)
- [Rigors Data Solutions Guide](https://www.rigordatasolutions.com/post/visualizing-likert-scale-data-with-the-likert-package-in-r-a-practical-guide)
- [R Companion: Plots for Likert Data](https://rcompanion.org/handbook/E_03.html)

---

## 7. Vietnam-Specific Context

### Vietnam Poverty Lines and Benchmarks (2025)

**National Poverty Statistics**:
- **2023 National Poverty Line**: 3.4% of population
- **2025 Target**: ~1% multidimensional poverty rate
- **Ethnic Minorities 2025**: 12.55% poverty rate (target)

**World Bank Benchmarks**:
- **Extreme Poverty** ($2.15/day, 2017 PPP): <1% (2022)
- **Lower-Middle Income** ($3.65/day): 4.2%
- **Upper-Middle Income** ($6.85/day): 19.7%

**Interpretation**:
- Extreme poverty nearly eradicated
- 1 in 5 Vietnamese remain vulnerable to poverty shocks
- Rural, agriculture-based, ethnic minority households at higher risk

**Official Sources**:
- [Vietnam Poverty Targets 2025](https://www.vietnam.vn/en/viet-nam-du-kien-chi-con-khoang-1-ho-ngheo-vao-cuoi-nam-2025)
- [ADB Vietnam Poverty](https://www.adb.org/where-we-work/viet-nam/poverty)
- [OECD Economic Surveys Vietnam 2025](https://www.oecd.org/en/publications/oecd-economic-surveys-viet-nam-2025_fb37254b-en/full-report/towards-more-inclusive-growth_0f09c63a.html)

### Multidimensional Poverty

**Vietnam MPI Report 2021**:
- [Viet Nam Multi-dimensional Poverty Report](https://ophi.org.uk/sites/default/files/2025-10/vietnam_2021_mpi.pdf)
- Beyond income: health, education, living standards
- Ethnic minority disparities
- Rural-urban gaps

### Vietnam Food Security Research

**Key Study (November 2024)**:
- **Title**: "Does escaping the multidimensional poverty line improve
  family food security? Evidence from rural Vietnam"
- **Journal**: Agriculture & Food Security (BioMed Central)
- **Link**: [Full Article](https://agricultureandfoodsecurity.biomedcentral.com/articles/10.1186/s40066-024-00502-3)
- **Data**: VARHS 2016 & 2018 (407 low-income households)
- **Indicators**: HDDS + per capita food expenditure
- **Finding**: Explores poverty-food security correlation

**COVID-19 Impact Study**:
- **Title**: "Income shock and food insecurity prediction Vietnam under
  the pandemic"
- **Source**: PMC
- **Link**: [PMC Article](https://pmc.ncbi.nlm.nih.gov/articles/PMC8849200/)

**Urban Food Insecurity**:
- **Title**: "Household food insecurity, diet, and weight status in a
  disadvantaged district of Ho Chi Minh City, Vietnam"
- **Journal**: BMC Public Health (2015)
- **Link**: [Full Article](https://bmcpublichealth.biomedcentral.com/articles/10.1186/s12889-015-1566-z)

**Persistent Rural Poverty**:
- **Title**: "Persistent Poverty in Rural Vietnam: Differential Asset
  Dynamics and the Role of Ethnic Minorities"
- **Journal**: Journal of Development Studies (2025)
- **Link**: [Full Article](https://www.tandfonline.com/doi/full/10.1080/00220388.2025.2489563)

### Vietnam Household Living Standards Survey (VHLSS)

**Overview**:
- **Implementing Agency**: General Statistics Office (GSO) Vietnam
- **Frequency**: Annual (2011-2022); Biennial (2002-2010)
- **Start**: 1993
- **Purpose**: Monitor living standards, poverty reduction, MDG/SDG progress

**Survey Content**:
- Demographics, education, professional level
- Income, expenditures
- Health services use, employment status
- Housing, amenities, utilities
- Electricity, water, sanitation

**Sample Size**:
- **2022**: ~47,000 households
- **2008**: 45,945 households (3,063 communes/wards)
- **Representative**: National, regional, urban, rural, provincial

**Panel Component**:
- Panels between: 2002-2004, 2004-2006, 2006-2008

**Data Access** (Updated October 2024):
- **Email**: hoptacquocte@gso.gov.vn
- **Recipient**: Director General of GSO
- **Status**: No official dissemination policy (difficult access)

**Documentation Sources**:
- [GSO VHLSS 2022 Results](https://www.gso.gov.vn/en/default/2024/04/results-of-the-viet-nam-household-living-standards-survey-2022/)
- [GSO VHLSS 2020 Results](https://www.gso.gov.vn/en/data-and-statistics/2022/06/results-of-the-viet-nam-household-living-standards-survey-2020/)
- [World Bank Microdata Library](https://microdata.worldbank.org/index.php/catalog/2370) (2004 example)
- [Brian McCaig's Notes](https://sites.google.com/site/briandmccaig/notes-on-vhlsss)
- [Atlas of Longitudinal Datasets](https://atlaslongitudinaldatasets.ac.uk/datasets/vhlss)

### Vietnam Access to Resources Household Survey (VARHS)

**Overview**:
- **Type**: Panel survey of rural households
- **Start**: 2002 (pilot in 4 provinces, 932 households)
- **Current**: Biennial since 2006 (~2,600 households, 12 provinces)
- **Panel**: 2,162 households interviewed 5 times (2006-2014)
- **Latest**: 2008-2016 panel with replication files

**Geographic Coverage** (12 Provinces):
- Dak Lak, Dak Nong, Dien Bien
- Ha Tay, Khanh Hoa
- Lai Chau, Lam Dong, Lao Cai
- Long An, Nghe An, Phu Tho, Quang Nam

**Survey Focus**:
- Rural land markets
- Credit sources (formal/informal)
- Employment access
- Input/output market access
- Income generation
- Agricultural activities
- Household enterprises
- Food expenditures

**Implementing Institutions**:
- Central Institute for Economic Management (CIEM) - MPI
- Institute of Labour Science and Social Affairs (ILSSA) - MoLISA
- UNU-WIDER

**Data Access**:
- **Open Access**: [UNU-WIDER Vietnam Data](https://www.wider.unu.edu/database/viet-nam-data)
- **Survey Data**: [Growth, Structural Transformation Book](https://www.wider.unu.edu/database/survey-data-growth-structural-transformation-and-rural-change-viet-nam-book)

**Published Research**:
- [Oxford Academic Book Chapter](https://academic.oup.com/book/26791/chapter/195735000)
- Food Policy special issue 2016 (replication files available)
- [Library of Congress Entry](https://www.loc.gov/item/2019666880/)

**Use in Food Security Research**:
- 2024 Agriculture & Food Security study used VARHS 2016 & 2018
- HDDS calculation
- Poverty escape analysis

---

## 8. Additional Essential Packages

### Working with Labelled Data (SPSS/Stata Import)

**haven Package** (tidyverse):
- **Purpose**: Read/write SPSS, Stata, SAS files
- **Function**: `read_sav()` for SPSS
- **Class**: `haven_labelled` for value/variable labels

**sjlabelled Package**:
- **CRAN**: [sjlabelled](https://cran.r-project.org/web/packages/sjlabelled/)
- **Documentation**: [Working with Labelled Data](https://strengejacke.github.io/sjlabelled/articles/labelleddata.html)
- **Functions**:
  - `get_label()`: Retrieve variable labels
  - `get_labels()`: Retrieve value labels
  - `copy_labels()`: Restore labels after subsetting
  - `remove_labels()`: Strip label attributes
- **Missing Values**: Handle tagged_na (multiple missing types)

**labelled Package**:
- Alternative to sjlabelled
- Part of tidyverse ecosystem

**Best Practice**:
1. Import with `haven::read_sav()`
2. Work with labels using sjlabelled
3. Convert to factors/numerics for analysis
4. Re-apply labels after transformations with `copy_labels()`

**Tutorial**:
- [Working with SPSS labels in R](https://martinctc.github.io/blog/working-with-spss-labels-in-r/)
- [Piping Hot Data: Leveraging Labelled Data](https://www.pipinghotdata.com/posts/2020-12-23-leveraging-labelled-data-in-r/)

### Effect Size Calculation

**effectsize Package** (easystats):
- **Website**: [easystats effectsize](https://easystats.github.io/effectsize/)
- **CRAN**: [effectsize](https://cran.r-project.org/web/packages/effectsize/)
- **Indices**: Cohen's d, Hedges' g, r, odds-ratios, etc.
- **Features**: Confidence intervals, conversions between indices

**effsize Package**:
- **CRAN**: [effsize](https://cran.r-project.org/web/packages/effsize/effsize.pdf)
- **Functions**: `cohen.d()`, Hedges' g correction

**psych Package**:
- `cohen.d()`: Standardized mean differences by group
- Converts d to r equivalent
- Reports t-statistic and p-values

**Interpretation Guidelines** (Cohen 1992):
- |d| < 0.2: Negligible
- |d| < 0.5: Small
- |d| < 0.8: Medium
- |d| ≥ 0.8: Large

**Caution**: Context matters - don't blindly apply thresholds

**Learning Resources**:
- [Interactive Cohen's d](https://rpsychologist.com/cohend/)
- [Effect Sizes: Getting Started](https://cran.r-project.org/web/packages/effectsize/vignettes/effectsize.html)

### Table Export for Thesis (Word/PDF)

**flextable Package** (Primary for Word):
- **Purpose**: Tables for Word, PowerPoint, HTML, PDF
- **Integration**: Works with officer package
- **Export**: `save_as_docx(path = "table.docx")`

**officer Package**:
- Manipulate Word/PowerPoint documents
- Used by flextable for export

**kableExtra Package**:
- **Best for**: HTML and PDF (LaTeX)
- **Limitation**: Does NOT support Word (docx) output
- **Recommendation**: Use flextable for Word instead

**Best Practice for Thesis**:
- **PDF output**: kableExtra or gtsummary → LaTeX
- **Word output**: flextable or gtsummary → as_flex_table() → docx
- **Consistency**: Use gtsummary for both, export via appropriate route

**Example Workflow**:
```r
library(gtsummary)
library(flextable)

# Create table
tbl <- tbl_summary(data)

# Export to Word
tbl %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = "table1.docx")
```

**Learning Resources**:
- [Alternative to kable for Word](https://taehoonh.me/content/post/alternative-to-kable-function-when-knitting-to-ms-word.html)
- [Quick Descriptive Tables for MS Word](https://www.adrianbruegger.com/post/quick-descriptive-tables/)
- [UCLA Output Tables in R](https://stats.oarc.ucla.edu/wp-content/uploads/2024/08/Table_R_seminar.html)

**Other Table Packages**:
- **gt**: RStudio package, foundation for gtsummary
- **openxlsx**: Export to Excel
- **stargazer**: Regression tables (PDF/LaTeX/HTML)
- **tableone**: Medical research descriptive tables

---

## Summary of Key Recommendations

### Survey Analysis Workflow

1. **Import KoboToolbox Data**: robotoolbox package
2. **Handle Labels**: sjlabelled for value/variable labels
3. **Create Survey Design**: survey/srvyr packages
4. **Calculate Food Security Indicators**:
   - FIES: RM.weights package
   - FCS, rCSI, HDDS: WFP-VAM R syntax from RBD Guide
5. **Descriptive Tables**: gtsummary (survey-weighted)
6. **Reliability Analysis**: psych::alpha()
7. **Effect Sizes**: effectsize package
8. **Geospatial Analysis**: sf + tmap + GADM Vietnam data
9. **Likert Scales**: likert or LikertEZ package
10. **Export to Word**: gtsummary → as_flex_table() → docx

### Essential Reading

**Must-Read Book**:
- [Exploring Complex Survey Data Analysis Using R](https://tidy-survey-r.github.io/tidy-survey-book/)
- Comprehensive, free, updated 2024

**Food Security Guidelines**:
- FAO FIES Manual (RM.weights documentation)
- WFP RBD Cadre Harmonisé Guide (Chapters 4-6)
- FANTA Indicator Guides

**Vietnam Context**:
- UNU-WIDER VARHS documentation
- GSO VHLSS reports
- Recent food security research (2024 Agriculture & Food Security)

### Package Installation Script

```r
# Survey analysis
install.packages(c("survey", "srvyr", "srvyrexploR"))

# KoboToolbox
pak::pkg_install("dickoa/robotoolbox")

# Food security indicators
install.packages("RM.weights")
pak::pkg_install("WFP-VAM/wfpthemes")

# Documentation
install.packages(c("gtsummary", "dataReporter", "pointblank", "skimr"))

# Geospatial
install.packages(c("sf", "tmap", "geodata", "GADMTools"))

# Likert scales
install.packages(c("likert", "LikertEZ"))

# Reliability
install.packages("psych")

# Effect sizes
install.packages(c("effectsize", "effsize"))

# Labelled data
install.packages(c("haven", "sjlabelled", "labelled"))

# Table export
install.packages(c("flextable", "officer", "kableExtra", "gt"))

# Tidyverse ecosystem
install.packages("tidyverse")
```

---

## Sources Index

### Survey Analysis
- [Tidy Survey Book](https://tidy-survey-r.github.io/tidy-survey-book/)
- [srvyr CRAN](https://cran.r-project.org/web/packages/srvyr/srvyr.pdf)
- [srvyr GitHub](https://github.com/gergness/srvyr)
- [UCLA Survey Data Analysis](https://stats.oarc.ucla.edu/r/seminars/survey-data-analysis-with-r/)

### KoboToolbox
- [robotoolbox Website](https://dickoa.gitlab.io/robotoolbox/)
- [robotoolbox GitHub](https://github.com/dickoa/robotoolbox)
- [robotoolbox CRAN](https://cran.r-project.org/web/packages/robotoolbox/index.html)

### Food Security Indicators
- [RM.weights CRAN](https://cran.r-project.org/web/packages/RM.weights/index.html)
- [FAO FIES](https://www.fao.org/in-action/voices-of-the-hungry/fies/en/)
- [WFP-VAM GitHub](https://github.com/WFP-VAM)
- [WFP RBD Guide](https://wfp-vam.github.io/RBD_FS_CH_guide_EN/)
- [FAO HDDS Guidelines](https://www.fao.org/4/i1983e/i1983e00.pdf)
- [WFP FCS Metadata](https://www.wfp.org/publications/meta-data-food-consumption-score-fcs-indicator)

### Documentation
- [gtsummary Website](https://www.danieldsjoberg.com/gtsummary/)
- [dataMaid GitHub](https://github.com/ekstroem/dataMaid)
- [pointblank GitHub](https://github.com/rstudio/pointblank)

### Geospatial
- [GADM](https://gadm.org/download_country.html)
- [tmap](https://r-tmap.github.io/tmap/)
- [R Graph Gallery Choropleth](https://r-graph-gallery.com/327-chloropleth-map-from-geojson-with-ggplot2.html)

### Likert Scales
- [likert CRAN](https://cran.r-project.org/web/packages/likert/index.html)
- [LikertEZ CRAN](https://cran.r-project.org/web/packages/LikertEZ/index.html)
- [psych alpha](https://rforhr.com/cronbachsalpha.html)

### Vietnam Context
- [UNU-WIDER VARHS](https://www.wider.unu.edu/database/viet-nam-data)
- [GSO VHLSS](https://www.gso.gov.vn/en/default/2024/04/results-of-the-viet-nam-household-living-standards-survey-2022/)
- [Agriculture & Food Security 2024](https://agricultureandfoodsecurity.biomedcentral.com/articles/10.1186/s40066-024-00502-3)

### Additional Packages
- [sjlabelled](https://strengejacke.github.io/sjlabelled/articles/labelleddata.html)
- [effectsize](https://easystats.github.io/effectsize/)
- [flextable for Word](https://taehoonh.me/content/post/alternative-to-kable-function-when-knitting-to-ms-word.html)

---

## Next Steps

1. **Install Core Packages**: Run installation script above
2. **Read Tidy Survey Book**: Chapters 1-4, 10 (survey design fundamentals)
3. **Test robotoolbox**: Connect to KoboToolbox, download sample data
4. **WFP Syntax**: Download R syntax from RBD Guide for FCS/rCSI/HDDS
5. **VARHS Data**: Request access from UNU-WIDER for practice
6. **Vietnam Shapefiles**: Download GADM 4.1 Vietnam provinces (GeoPackage)
7. **Create Workflow Template**: Standardized analysis pipeline script

This research provides a comprehensive foundation for conducting high-quality
survey data analysis for food security research in Vietnam using R. All
resources identified are actively maintained and suitable for thesis-level work.
