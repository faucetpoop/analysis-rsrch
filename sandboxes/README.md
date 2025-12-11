# Analysis Research - Multi-Sandbox Architecture

**Migration Date:** 2025-12-10
**Total Features:** 29 features distributed across 4 sandboxes
**Architecture:** Feature-driven development with isolated sandboxes

## Overview

This project uses a **multi-sandbox architecture** where features are organized into focused, independent workspaces. Each sandbox has its own agent-foreman instance, feature list, and documentation.

## Sandbox Structure

```
sandboxes/
├── 01-survey-understanding/     # Foundation: XLSForm parsing and documentation
├── 02-data-pipeline/            # Core: Data import and cleaning
├── 03-indicators/               # Analysis: Food security and economic indicators
└── 04-analysis-reporting/       # Output: Maps and thesis-ready tables
```

## Quick Start

### Work on a Specific Sandbox

```bash
cd sandboxes/01-survey-understanding
agent-foreman status
agent-foreman next
```

### Check Overall Progress

```bash
# From project root
./scripts/sandbox-status.sh
```

### Recommended Order

1. **01-survey-understanding** - Start here (foundation work)
2. **02-data-pipeline** - Data import and cleaning
3. **03-indicators** - Indicator calculations
4. **04-analysis-reporting** - Final outputs

## Sandbox Details

### 01: Survey Understanding
**Purpose:** Parse XLSForm, generate codebook, document survey modules
**Features:** 4 failing
**Priority:** Foundation (run first)

Key outputs:
- Parsed XLSForm with skip logic
- Variable codebook
- Survey module documentation
- Construct-to-question mapping

### 02: Data Pipeline
**Purpose:** R project setup, Kobo API, data cleaning
**Features:** 7 failing
**Priority:** Core Infrastructure (run second)

Key outputs:
- R project with renv
- Kobo API connection
- Merged survey versions A & B
- Clean, analysis-ready data

### 03: Indicators
**Purpose:** Calculate food security and economic indicators
**Features:** 12 failing
**Priority:** Core Analysis (run third)

Key outputs:
- HDDS, FCS, rCSI, FIES indicators
- Income and expenditure analysis
- Likert scale processing and reliability

### 04: Analysis & Reporting
**Purpose:** Geospatial analysis and thesis-ready outputs
**Features:** 6 failing
**Priority:** Final Outputs (run fourth)

Key outputs:
- Choropleth maps
- Survey-weighted tables
- Word exports for thesis

## Feature Distribution

| Sandbox | Module | Features | Status |
|---------|--------|----------|--------|
| 01-survey-understanding | data-import, documentation | 4 | failing |
| 02-data-pipeline | core, data-import, data-cleaning | 7 | failing |
| 03-indicators | indicators, economics, likert | 12 | failing |
| 04-analysis-reporting | geospatial, reporting | 6 | failing |
| **Total** | | **29** | |

## Architecture Benefits

1. **Focus** - Work on related features together without distraction
2. **Isolation** - Each sandbox is independent, changes don't affect others
3. **Parallelization** - Multiple agents could work on different sandboxes
4. **Clarity** - Clear purpose and boundaries for each workspace
5. **Incremental** - Complete one sandbox before moving to the next

## Working Across Sandboxes

### Cross-Sandbox Dependencies

```
01-survey-understanding (codebook, construct mapping)
          ↓
02-data-pipeline (clean data)
          ↓
03-indicators (calculated indicators)
          ↓
04-analysis-reporting (final outputs)
```

### Sharing Outputs

Each sandbox has an `/output` directory. Downstream sandboxes can reference upstream outputs:

```bash
# Example: 02-data-pipeline uses codebook from 01-survey-understanding
cp ../01-survey-understanding/output/codebook.csv docs/reference/
```

## Migration History

**Original Structure:**
- 29 features in single `ai/feature_list.json`
- 10 research areas in `research-areas/`

**New Structure:**
- 4 sandboxes with isolated feature lists
- Research areas distributed to relevant sandboxes as documentation
- Original files backed up in `.migration-backup/`

## Commands Reference

### Per-Sandbox Commands

```bash
cd sandboxes/[sandbox-name]
agent-foreman status          # Check sandbox status
agent-foreman next            # Get next feature
agent-foreman check <id>      # Verify feature
agent-foreman done <id>       # Mark complete + commit
```

### Global Commands (from project root)

```bash
./scripts/sandbox-status.sh           # Status of all sandboxes
./scripts/sandbox-progress.sh         # Combined progress logs
./scripts/sandbox-test-all.sh         # Run all sandbox tests
```

## File Organization

Each sandbox contains:

```
[sandbox-name]/
├── SANDBOX.md              # Entry point and overview
├── ai/
│   ├── feature_list.json   # Sandbox-specific features
│   ├── progress.log        # Sandbox work history
│   └── init.sh             # Bootstrap script
├── docs/                   # Research areas and guides
├── scripts/                # Reference implementations
├── tests/                  # Test files
└── output/                 # Generated artifacts
```

## Best Practices

1. **Complete one sandbox before starting the next** - Respect dependencies
2. **Read SANDBOX.md first** - Understand purpose and success criteria
3. **Use the recommended order** - Foundation → Core → Analysis → Output
4. **Reference docs/** - Each sandbox has relevant research area documentation
5. **Share outputs intentionally** - Copy artifacts to downstream sandboxes as needed

## Troubleshooting

### "Feature not found"
You're probably in the wrong sandbox. Check `feature_list.json` or use the master index to find which sandbox contains the feature.

### "Dependency missing"
Make sure you've completed upstream sandboxes first. Check the dependency chain in this README.

### "Need to work on multiple features"
If features are in the same sandbox, work sequentially. If in different sandboxes, complete the upstream sandbox first.

## Recovery

If something goes wrong during migration:

```bash
# Restore original structure from backup
rm -rf sandboxes/
cp -r .migration-backup/ai ai/
cp -r .migration-backup/research-areas research-areas/
```

## Support

For issues with the multi-sandbox architecture, refer to:
- Individual `SANDBOX.md` files for sandbox-specific questions
- Original research area docs in each `docs/` directory
- Migration plan in `plans/multi-sandbox-architecture-plan.md`

---

**Last Updated:** 2025-12-10
**Migration Status:** Complete
**Total Sandboxes:** 4
**Total Features:** 29
