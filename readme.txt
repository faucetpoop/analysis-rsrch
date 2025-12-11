# Analysis bench 
- Primary analysis with r 
- Xlxs and xml of kobo surveys 
	- Module groups? 
- xlxs and csv of raw survey data 
	- *two versions A without food wate questions and B with FW questions 
	- they are single data sheet & missing food waste is no issue, it was for some somethinging else 
	- * multi select, skip logic complexity -> missi n data doesn’t mean remove 
- key data to generate -> hdds & food insecurity 
- income and food expenditure 
	- Needs deep and manual processing and Vietnam monetary context 
- Scales of likart? How respondes are coded? Reporting and analyzing this? 
- Datasictiory? Survey table for appendix? Codebook? 
- Reporting descriptive statistics and descriptive summaries 
- Responses geocoded -> useful geoprocessing that is beneficial? 
- -> relevent context7 accessible documentation for reference? /apoi
- ==[[analysis-research-areas]]==

Nice, that’s an important one to add.

  

I’ll slot it in as a new Area 0 because it underpins everything else.

  

  

  

  

🔎 Area 0 – Deep Understanding of the Survey & Context

  

  

Goal: Really understand what your survey means (concepts, wording, and Vietnam context), not just how to crunch it.

  

  

0.1. Survey intent & conceptual backbone

  

  

What to dig into / reflect on

  

- Overall purpose of the survey  
    

- What research questions was it designed to answer?
- Which modules serve which research questions?

-   
    
- Concepts behind modules  
    

- Food insecurity → which dimension(s)? (access, utilisation, stability, etc.)
- Dietary diversity → what exactly is being approximated (quality, micronutrient adequacy)?
- Food waste → households’ behaviours, norms, constraints?
- Income/expenditure → welfare, vulnerability, poverty?

-   
    

  

  

Outputs for yourself

  

- A short written “story per module”:  
    “This module captures X because Y, and later feeds into Z indicator(s).”

  

  

  

  

  

0.2. Question-level reading: content, logic, and assumptions

  

  

What to review

  

- Go through the XLSForm question by question and ask:  
    

- What is this question trying to measure? (latent construct)
- What assumptions does it make about respondents’ understanding?
- In which situations is this question misleading or weak?

-   
    
- Pay special attention to:  
    

- Screeners and filters (who gets included/excluded downstream)
- Frequency / quantity questions (food consumption, spending)
- Recall period (does it suit the local reality & seasonality?)
- Likert items (what attitude or perception is really underneath)

-   
    

  

  

Outputs

  

- A small note (few words) next to each key question:  
    

- “concept: perceived food insecurity”,
- “risk: recall bias for occasional foods”, etc.

-   
    
- A list of known weaknesses (for the limitations section).

  

  

  

  

  

0.3. Contextual understanding (Vietnam, local food & money realities)

  

  

What to research / reflect on

  

- Food environment & diets  
    

- Typical household diets in your study area
- Common staple foods, vegetables, proteins
- Seasonality: are you capturing a “normal” period or a special one?

-   
    
- Food waste context  
    

- Cultural attitudes towards food waste
- How leftovers, sharing, composting, feeding animals, etc. work locally
- Any local policies, campaigns, or norms relevant to food waste

-   
    
- Economic context  
    

- Typical income sources in your population (formal/informal, remittances, agriculture, etc.)
- Key expenditure categories (food, rent, education, fuel, etc.)
- How people talk about money (weekly vs monthly; cash vs in-kind)

-   
    

  

  

Outputs

  

- 1–2 pages of “context notes” you can later mine for:  
    

- Introduction (context)
- Methods (why your questions make sense here)
- Discussion (why some results look the way they do)

-   
    

  

  

  

  

  

0.4. From survey questions to analytic constructs

  

  

What to clarify

  

- For each key construct (HDD, food insecurity, food waste behaviour, vulnerability, etc.):  
    

- Which specific questions/items are used?
- Which questions are supporting context rather than direct components?
- Are there redundant questions you won’t use? Why?

-   
    
- Build a “construct map”:  
    

- Rows = constructs (HDD, “perceived food security”, “FW attitudes”, “economic vulnerability”…)
- Columns = survey questions feeding into that construct
- Notes on transformation: sums, indices, categories, etc.

-   
    

  

  

Outputs

  

- A construct–question mapping table (can double as an appendix figure or internal documentation).
- Clear justification in your methods for why this question set measures that concept in this context.

  

  

  

  

  

0.5. Interpretation limits & bias awareness

  

  

What to think through

  

- Who might have answered differently from what they do?  
    

- Social desirability (e.g. admitting to wasting food, or being food insecure)
- Gender dynamics (who in the household answered? main cook? head?)
- Literacy / numeracy issues (for frequency, quantities, money)

-   
    
- What your survey cannot tell you  
    

- Causality (cross-sectional limitations)
- Aspects of diet or waste you don’t see (e.g. micronutrients, informal sharing)
- Households not covered by your sample (migrants, homeless, etc.)

-   
    

  

  

Outputs

  

- A bullet list of “Interpretation guardrails” you can keep in front of you while analysing and writing:  
    

- “Don’t over-interpret small HDD differences as health outcomes.”
- “Food waste self-reports likely under-estimate true waste.”
- Etc.

-   
    

  

  

  

  

  

Updated Area Overview (for your checklist)

  

  

- Area 0 – Deep understanding of survey & context ✅ (new)
- Area 1 – R workflow for survey & indicator analysis
- Area 2 – KoBo/XLSForm & survey structure
- Area 3 – Raw data mgmt: versions, missingness, multi-select
- Area 4 – HDD & food insecurity indicators
- Area 5 – Income, expenditure & Vietnam monetary context
- Area 6 – Likert scales & psychometric bits
- Area 7 – Documentation: data dictionary, codebook, appendix
- Area 8 – Geospatial analysis with geocoded responses
- Area 9 – Descriptives & reporting strategy

  

  

If you want, next I can compress all of this into a one-page “research areas” checklist (with checkboxes and very short bullet points) you can paste straight into Notion/Word.
  

  

  

Area 1 – R Workflow for Survey & Indicator Analysis

  

  

Goal: Be fluent enough in R to run the full analysis end-to-end.

  

Components to research / refresh

  

- Core R + tidyverse workflow  
    

- Import: readxl, readr
- Wrangle: dplyr, tidyr
- Project structure (RStudio Projects, folder organisation)

-   
    
- Survey-style data in R  
    

- Handling large-ish datasets
- Basic summarising: group_by(), summarise(), across()
- (Optional) Complex survey designs: survey, srvyr (if you have weights/strata/psu)

-   
    

  

  

Use this area for: everything that touches data import, cleaning, and calculation of HDD, FI, Likert, income, etc.

  

  

  

  

Area 2 – KoBo / XLSForm & Survey Structure

  

  

Goal: Understand exactly how your questionnaire becomes your dataset.

  

Components

  

- XLSForm basics  
    

- survey, choices, settings sheets
- Key fields: type, name, label, relevant, choice_filter

-   
    
- Module groups  
    

- begin_group / end_group, begin_repeat
- How modules map to sections in your data (naming patterns)

-   
    
- Skip logic  
    

- relevant expressions (when is a question asked?)
- Distinguish:  
    

- Not applicable (structural) vs
- Truly missing / non-response

-   
    

-   
    
- Select_one vs select_multiple  
    

- How select_multiple turns into many columns in the export
- How the coding ties back to choices sheet

-   
    

  

  

Use this area for: understanding multi-selects, missingness, module tables for the appendix, and correct interpretation of NA.

  

  

  

  

Area 3 – Raw Data Management: Versions, Missingness, Multi-Select

  

  

Goal: Have one clean, trustworthy analysis dataset.

  

Components

  

- Merging versions A (no food waste) & B (with food waste)  
    

- Comparing structures (which variables differ?)
- Harmonising names and types
- bind_rows() with extra FW columns only present in B
- Documenting: FW missing in A = “not collected”, not “don’t know”

-   
    
- Multi-select handling  
    

- Interpreting 0/1 or Yes/No columns from select_multiple
- Reshaping if needed (wide ↔ long)
- Calculating counts / percentages per option

-   
    
- Missing data strategy  
    

- Types: structural vs non-response vs data error
- How to handle each in:  
    

- Descriptives
- Indicator construction

-   
    
- Simple missingness summaries and checks

-   
    

  

  

Use this area for: building your master dataset and deciding what NA actually means before analysis.

  

  

  

  

Area 4 – Food Security & Dietary Diversity Indicators (HDD + others)

  

  

Goal: Correctly compute and interpret your key outcome variables.

  

Components

  

- HDD / HDDS  
    

- Official definitions & food groups
- Recall period (24h? 7 days?) consistent with your survey
- Rules for scoring (binary per group → total score)
- Categories (low/medium/high if used)

-   
    
- Other food insecurity measures (if in your survey)  
    

- FIES, HFIAS, FCS, rCSI, etc.
- Questionnaire wording & response options
- Scoring rules, cut-offs, interpretation

-   
    
- Implementation in R  
    

- Mapping survey questions to food groups / items
- Code logic: recoding, summing, categorising
- Quality checks: distribution, internal consistency, weird values

-   
    

  

  

Use this area for: everything that defines your main “food security / diet” variables.

  

  

  

  

Area 5 – Income, Expenditure & Vietnam Monetary Context

  

  

Goal: Build sensible, interpretable economic indicators from raw money data.

  

Components

  

- Data cleaning & aggregation  
    

- Converting to numeric, handling commas/dots
- Aggregating income sources → total household income
- Aggregating expenditures → total, food, non-food
- Computing ratios (e.g. food expenditure share)

-   
    
- Outliers & skewness  
    

- Identifying extreme values
- Possible strategies (winsorising, log-transform, flagging)

-   
    
- Contextualisation for Vietnam  
    

- Currency & reference year (e.g. “all values in VND, 2024 prices”)
- Any relevant national poverty lines or benchmarks you might compare to
- Typical income / expenditure patterns for similar populations (if literature exists)

-   
    

  

  

Use this area for: methods text on money variables, plus robust income/expenditure results.

  

  

  

  

Area 6 – Likert Scales & Psychometric Bits

  

  

Goal: Treat attitudinal / perception questions correctly and consistently.

  

Components

  

- Coding and recoding  
    

- How options are stored (numbers vs strings)
- Mapping to ordered numeric scale
- Reverse coding where necessary (so “higher = more of X”)

-   
    
- Scale construction  
    

- When multiple items form one construct
- Summing vs averaging scores
- Reliability (Cronbach’s alpha, item–total correlations)

-   
    
- Reporting  
    

- Frequency tables per response category
- Means/SD or medians/IQR (depending on how you treat Likert)
- Stacked and diverging bar plots for visualisation

-   
    

  

  

Use this area for: attitudinal sections, perceived insecurity, perceptions of food waste, etc.

  

  

  

  

Area 7 – Documentation: Data Dictionary, Codebook, Survey Appendix

  

  

Goal: Have clear documentation that supports the thesis and your own sanity.

  

Components

  

- Data dictionary / codebook structure  
    

- Variable name
- Label (question text)
- Type (numeric, categorical, multi-select, derived)
- Response options / value labels
- Module/group
- Notes (skip logic, “special” codes, derived variables)
- Use in analysis (HDD, FI, income, descriptive only, etc.)

-   
    
- Survey appendix table  
    

- Modules → purpose, key question themes, links to indicators
- Possibly listing “key variables per module” rather than every single question

-   
    
- Tools & automation  
    

- R tools for generating overviews/table templates
- Strategy for keeping XLSForm, dataset, and codebook aligned

-   
    

  

  

Use this area for: writing the methods appendix and keeping track of what each variable does.

  

  

  

  

Area 8 – Geospatial Analysis with Geocoded Responses

  

  

Goal: Make smart, lightweight use of geocoded data to enrich the thesis.

  

Components

  

- Spatial data basics in R  
    

- Points as sf objects
- Admin boundaries (Vietnam provinces/districts)
- Coordinate Reference Systems (CRS)

-   
    
- Useful operations  
    

- Plotting households on a base map
- Aggregating indicators by area (e.g. mean HDD, % food insecure by province)
- Possibly: urban/rural or other area-type classifications

-   
    
- Maps for thesis  
    

- Study area map (methods)
- 1–2 thematic maps (e.g. spatial distribution of HDD or food insecurity)

-   
    

  

  

Use this area for: visual story-telling and any spatial pattern discussion.

  

  

  

  

Area 9 – Descriptives & Reporting Strategy

  

  

Goal: Know how you want to summarise and present everything.

  

Components

  

- Descriptive statistics patterns  
    

- How you will summarise:  
    

- Socio-demographics
- Indicators (HDD, FI, income)
- Likert scale results

-   
    
- Standard table layouts (Table 1: sample characteristics, etc.)

-   
    
- Narrative style  
    

- How to phrase findings (e.g. “X% of households…”)
- How to integrate Vietnam context and literature comparisons

-   
    

  

  

Use this area for: making your analysis outputs “thesis-ready” instead of just raw numbers.

  

  

  

  

How to use these areas efficiently

  

  

If you want a sequence:

  

1. Area 2 + 3 (KoBo + raw data/missingness) – understand what you have.
2. Area 1 (R workflow) – set up the engine to work with it.
3. Area 4 + 5 + 6 (HDD/FI, income, Likert) – nail your main constructs.
4. Area 8 (geo) – add spatial flavour if relevant.
5. Area 7 + 9 (documentation + reporting) – shape it into thesis outputs.

  

  

If you’d like, I can turn this into a one-page checklist with tick-boxes under each area that you can literally print or paste into Notion.