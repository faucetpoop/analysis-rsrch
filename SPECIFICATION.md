# Specification: Analysis Research (Food Security Survey Data)

**Version:** 1.0
**Date:** 2025-12-10
**Status:** Active

## Problem Statement

Vietnamese household survey data requires sophisticated analysis to generate valid food security and dietary diversity indicators for thesis research. The analysis must account for:
- Complex survey structures (multi-select, skip logic, grouped modules)
- Multiple data versions with different module coverage
- Vietnam-specific monetary and cultural context
- Spatial variation in geocoded responses
- Rigorous academic documentation standards

Without systematic analysis covering all research areas, the thesis risks methodological gaps, invalid indicators, or poor interpretation of findings.

## Goals

- Produce publication-ready food security indicators (HDDS, FIES) from survey data
- Generate comprehensive descriptive statistics for thesis results chapter
- Create spatial visualizations showing geographic patterns
- Document all methods transparently in codebooks and appendices
- Maintain reproducible R workflow for analysis replication

## Non-Goals

- Advanced statistical modeling (regressions, structural equation modeling)
- Causal inference or intervention evaluation
- Software package development for general use
- Policy analysis or programmatic recommendations
- New data collection or survey instrument development

## Scope Definition

**In Scope:**
- R workflow development (import, clean, transform, analyze)
- Survey structure documentation (XLSForm, module mapping)
- Data version harmonization (A/B merge strategy)
- Indicator construction (HDDS, FIES, income ratios, Likert scales)
- Missing data handling strategy
- Geospatial analysis (maps, spatial aggregation)
- Codebook and data dictionary generation
- Descriptive statistics tables and visualizations

**Out of Scope:**
- Statistical inference beyond descriptives
- Comparative analysis with other countries/regions
- Longitudinal analysis (cross-sectional only)
- Advanced spatial statistics (spatial regression, clustering)
- Web applications or interactive dashboards

## Functional Requirements

**FR1:** Import KoBo survey data (XML/XLSX) and raw CSV responses into R
**FR2:** Clean and harmonize versions A (no food waste) and B (with food waste)
**FR3:** Calculate HDDS according to official FAO guidelines with Vietnam food group mapping
**FR4:** Generate food insecurity indicators (FIES or similar) with proper scoring
**FR5:** Process income and expenditure data accounting for Vietnam currency context
**FR6:** Analyze Likert scale responses with proper coding and scale construction
**FR7:** Create geocoded maps showing spatial distribution of key indicators
**FR8:** Generate complete data dictionary with variable descriptions and value labels
**FR9:** Produce descriptive statistics tables (means, SD, frequencies) for thesis
**FR10:** Document all transformations and assumptions in codebook

## Non-Functional Requirements

**NFR1:** Analysis must be reproducible - R scripts run end-to-end without manual intervention
**NFR2:** Code must be well-documented with comments explaining survey-specific logic
**NFR3:** Data processing must preserve traceability to original survey questions
**NFR4:** Outputs must meet academic publication standards (formatting, citation)
**NFR5:** Workflow must handle typical survey issues (outliers, missing data) gracefully

## Technical Constraints

- Must use R (tidyverse ecosystem preferred)
- Must work with KoBo Toolbox export formats (XML, XLSX, CSV)
- Must accommodate two data versions with partial overlap
- Must reference Vietnam-specific context (currency, poverty lines, food systems)
- Must generate outputs compatible with thesis LaTeX document
- Geospatial analysis limited to R sf package capabilities

## Acceptance Criteria

**AC1:** Given raw survey exports, R scripts successfully import and merge versions A and B
**AC2:** HDDS calculation produces valid scores (0-12 range) for all households with complete food consumption data
**AC3:** Missing data is correctly categorized (structural, non-response, error) and documented
**AC4:** Data dictionary includes all variables with question text, type, and value labels
**AC5:** Descriptive statistics tables match academic journal formatting standards
**AC6:** Maps display geocoded households with indicator overlays (e.g., HDDS by location)
**AC7:** Codebook documents all derived variables with calculation formulas
**AC8:** Income/expenditure analysis accounts for Vietnam currency and context
**AC9:** Likert scale analysis includes reliability checks (Cronbach's alpha if multi-item)
**AC10:** All outputs are reproducible from raw data with documented R scripts

## Success Metrics

- HDDS calculated for >95% of households (accounting for legitimate skip logic)
- Zero unexplained missing data patterns (all documented in codebook)
- Data dictionary covers 100% of variables used in analysis
- Reproducibility test: independent analyst can re-run scripts and match results
- Thesis committee approval of methods chapter based on documentation quality

## Dependencies

**Internal dependencies:**
- Research area documentation (10 areas mapped)
- Survey structure understanding (XLSForm analysis)
- Vietnam context research (monetary, food systems, cultural)

**External dependencies:**
- KoBo survey definition files (XML/XLSX)
- Raw survey data exports (CSV with versions A and B)
- Vietnam reference data (poverty lines, food group definitions)
- Academic literature on HDDS, FIES methodologies
- R packages: tidyverse, sf, readxl, survey/srvyr (if weighted)

**Blocked by:**
- Clarification on which food groups map to HDDS categories for Vietnam
- Reference period confirmation (24-hour vs. 7-day recall)
- Understanding of skip logic for structural missingness
- Vietnam monetary context documentation

## Risks and Mitigation

**Risk 1:** Survey skip logic creates complex missing data patterns that break indicator calculations
- Impact: High
- Likelihood: Medium
- Mitigation: Map complete skip logic from XLSForm, document structural vs. response missingness, handle each case explicitly in code

**Risk 2:** Vietnam food items don't map cleanly to standard HDDS food groups
- Impact: High
- Likelihood: Medium
- Mitigation: Consult FAO HDDS guidelines, review Vietnam-specific adaptations in literature, document mapping decisions in codebook

**Risk 3:** Income/expenditure data has outliers or currency formatting issues
- Impact: Medium
- Likelihood: High
- Mitigation: Implement robust data cleaning, outlier detection, and Vietnam currency context documentation

**Risk 4:** Version A/B merge introduces errors or biases
- Impact: High
- Likelihood: Low
- Mitigation: Thorough testing of merge logic, sensitivity checks, explicit documentation of which variables differ

**Risk 5:** Geospatial analysis reveals privacy concerns with household locations
- Impact: Medium
- Likelihood: Low
- Mitigation: Aggregation strategy for maps, no individual household identification in outputs

## Open Questions

- [ ] What is the official recall period for food consumption (24h or 7d)? [Research needed]
- [ ] Which Vietnam poverty line should be used for contextualization? [Supervisor input]
- [ ] Are survey weights required for analysis? [Check survey documentation]
- [ ] What level of spatial aggregation is appropriate for maps (province, district)? [Ethics review]
- [ ] Should food waste analysis be primary focus or supplementary? [Thesis scope decision]

## Design Approach

Analysis will follow a modular R workflow structure:

1. **Import module:** KoBo data import, validation, initial cleaning
2. **Harmonization module:** Merge versions A/B, resolve conflicts, document differences
3. **Indicator modules:** Separate scripts for HDDS, FIES, income, Likert scales
4. **Spatial module:** Geocoding validation, map generation, spatial aggregation
5. **Documentation module:** Automated codebook and data dictionary generation
6. **Reporting module:** Tables, figures, and descriptive statistics for thesis

Each module will have associated unit tests (where applicable) and documentation linking survey questions to derived variables. The agent-foreman feature list will track progress across all modules.

Research areas (0-9) provide the conceptual framework, while agent-foreman features track specific implementation tasks.

## References and Related Documents

**Related specifications:**
- None (standalone project)

**Architecture/Design:**
- `ai/feature_list.json` - Implementation roadmap
- `research-areas/` - Conceptual framework for analysis

**Research:**
- `r-survey-food-security-research-analysis.md` - Detailed analysis notes
- `readme.txt` - Original project planning notes
- Literature on HDDS, FIES, Vietnam food systems (to be compiled)

**External references:**
- FAO HDDS guidelines
- FIES measurement documentation
- Vietnam poverty statistics (GSO)
- KoBo Toolbox documentation

## Notes

This project bridges methodological rigor with practical thesis needs. The 10 research areas provide comprehensive coverage of all analysis aspects, while agent-foreman features track concrete implementation tasks.

Key principle: understand before analyzing. Area 0 (deep understanding) is foundational - survey intent, question logic, Vietnam context must be solid before indicator construction.

Data versions A/B reflect survey evolution - version A omitted food waste module, version B included it. This is NOT missing data but intentional design difference. Analysis must handle both versions appropriately.

Vietnam monetary context is non-negotiable - currency, reference year, typical income/expenditure patterns, and poverty benchmarks must be thoroughly documented for income analysis credibility.

Geospatial component adds value but should not dominate - focus remains on food security indicators and descriptive analysis, with spatial patterns as supplementary insight.

---

## Change History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-10 | EB | Initial specification for workbench migration |
