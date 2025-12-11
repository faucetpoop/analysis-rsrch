# Sandbox 01: Survey Understanding

**Status:** Active
**Priority:** Foundation (run first)
**Features:** 4 failing

## Purpose

Foundation work: Understanding survey structure, generating codebook, and documenting survey modules. This sandbox focuses on parsing the XLSForm and creating comprehensive documentation before any data processing begins.

## Quick Start

```bash
cd sandboxes/01-survey-understanding
agent-foreman status
agent-foreman next
```

## Features

| ID | Description | Status |
|----|-------------|--------|
| data-import.xlsform.parse-structure | Parse XLSForm structure and skip logic | failing |
| documentation.codebook.generate | Generate variable codebook | failing |
| documentation.appendix.survey-modules | Create survey module documentation | failing |
| documentation.construct-map.create | Build construct-to-question mapping | failing |

## Research Areas Included

- **01-survey-context** - Survey understanding and context
- **03-kobo-xlsform** - XLSForm structure and parsing
- **08-documentation-standards** - Documentation templates and standards

## Key Resources

- `/docs/00-RESEARCH-AIM.md` - Research objectives and survey design
- `/docs/area-0-survey-context-understanding.md` - Survey context guide
- `/docs/area-2-kobo-xlsform-structure.md` - XLSForm parsing details
- `/docs/templates/` - Documentation templates

## Dependencies

**Upstream:** None (this is the foundation)
**Downstream:** All other sandboxes depend on codebook and construct mapping

## Success Criteria

- XLSForm successfully parsed with skip logic captured
- Codebook generated with all variables documented
- Survey module documentation table created for thesis appendix
- Construct-to-question mapping table complete

## Next Steps

After completing this sandbox:
1. Move to **02-data-pipeline** for data import and cleaning
2. Use generated codebook to inform data cleaning decisions
3. Reference construct mapping when building indicators

## Notes

This sandbox does NOT require actual survey data - all work is based on the XLSForm structure. Focus on understanding and documenting what the survey measures before processing any responses.
