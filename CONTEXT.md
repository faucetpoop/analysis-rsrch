# Project: Analysis Research (Food Security Survey Data)

**Version:** 1.0
**Date:** 2025-12-10
**Status:** Active

## Overview

Analysis workbench for Vietnamese household survey research focused on food security, dietary diversity, and food waste. The project involves R-based statistical analysis of KoBo survey data with multiple measurement instruments (HDDS, FIES, income/expenditure, Likert scales) and geocoded household locations.

This is a comprehensive thesis research project requiring deep methodological understanding, context-aware analysis, and rigorous documentation for academic publication.

## Goals

- Conduct end-to-end analysis of Vietnamese household food security survey data
- Generate validated food security and dietary diversity indicators (HDDS, FIES)
- Process complex survey data structures (multi-select, skip logic, multiple versions)
- Produce publication-ready descriptive statistics and spatial visualizations
- Document methods transparently for thesis appendices and codebooks

## Scope

**In Scope:**
- R workflow development for survey data analysis
- KoBo/XLSForm survey structure understanding and documentation
- Data cleaning and harmonization (versions A/B with/without food waste module)
- Household Dietary Diversity Score (HDDS) calculation
- Food insecurity indicator construction
- Income and expenditure processing with Vietnam monetary context
- Likert scale analysis for attitudinal/perception questions
- Geospatial analysis with geocoded household responses
- Data dictionary and codebook generation
- Descriptive statistics and reporting for thesis

**Out of Scope:**
- Causal inference or advanced statistical modeling
- New survey design or data collection
- Software development beyond analysis scripts
- Policy recommendations (descriptive analysis only)

## Owner/Team

**Owner:** Research student (thesis work)
**Stakeholders:** Thesis supervisors, academic reviewers

## Timeline

**Started:** 2025-12-10
**Target completion:** TBD based on thesis timeline
**Milestones:**
- Phase 1: Deep survey understanding and context research
- Phase 2: R workflow setup and data cleaning
- Phase 3: Indicator construction and validation
- Phase 4: Descriptive analysis and visualization
- Phase 5: Documentation and thesis integration

## Current Status

**Phase:** Active - Understanding survey structure and planning analysis
**Progress:** Initial setup with agent-foreman feature-driven development harness
**Last updated:** 2025-12-10

## Current Focus

Establishing analysis workflow and understanding survey structure. Agent-foreman harness initialized for structured feature development.

## Research Areas

The project spans 10 research areas (Area 0-9) covering:
0. Deep understanding of survey and Vietnam context
1. R workflow for survey and indicator analysis
2. KoBo/XLSForm and survey structure
3. Raw data management (versions, missingness, multi-select)
4. Food security and dietary diversity indicators (HDDS + others)
5. Income, expenditure, and Vietnam monetary context
6. Likert scales and psychometric analysis
7. Documentation (data dictionary, codebook, appendix)
8. Geospatial analysis with geocoded responses
9. Descriptives and reporting strategy

See `readme.txt` and `research-areas/` for detailed breakdown.

## Blockers/Issues

- [ ] Need to understand Vietnam monetary context for income/expenditure - Impact: Medium
- [ ] Survey versions A/B harmonization strategy - Impact: High
- [ ] Missing data interpretation (structural vs. non-response) - Impact: High

## Next Steps

- [ ] Review complete research area checklist
- [ ] Map survey questions to analytical constructs
- [ ] Set up R project structure
- [ ] Document KoBo XLSForm structure
- [ ] Define data cleaning workflow

## Dependencies

**Internal:**
- Research area documentation in `research-areas/`
- Survey file: `r-survey-food-security-research-analysis.md`
- Planning documents in `plans/`

**External:**
- KoBo survey XML/XLSX files
- Raw survey data (versions A and B)
- Vietnam context documentation (poverty lines, monetary reference)
- Academic literature on HDDS, FIES, and food security measurement

## Key Decisions

- Using agent-foreman for feature-driven development workflow
- TDD mode configured for structured analysis development
- Analysis broken into 10 research areas for systematic coverage

## Resources

**Documentation:**
- `readme.txt` - Original project notes and research area overview
- `r-survey-food-security-research-analysis.md` - Detailed survey analysis notes
- `CLAUDE.md` - Agent-foreman integration instructions

**Project files:**
- `ai/feature_list.json` - Feature backlog
- `ai/progress.log` - Development progress tracking
- `research-areas/` - Detailed research area breakdowns

**Related projects:**
- None currently (standalone thesis research)

## Notes

This project uses the agent-foreman long-task harness for AI-assisted development. Always read `ai/feature_list.json` and `ai/progress.log` before starting work. Follow TDD workflow: read acceptance criteria, implement, verify with `agent-foreman check`, then mark complete with `agent-foreman done`.

Survey data has two versions (A without food waste, B with food waste). Missing food waste data in version A is structural, not response-based. Multi-select questions and skip logic create complex missingness patterns that require careful interpretation.

Vietnam monetary context is critical for income/expenditure analysis - currency, reference year, poverty benchmarks, and typical household patterns must be documented.
