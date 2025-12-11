# 01 - Survey Context Understanding

**Executable workspace for deeply understanding your survey through the Turner et al. (2018) framework.**

---

## Research Aim

> Examine how **external and personal food-environment determinants** are associated with **household dietary diversity** in Long Biên District, Hà Nội, Vietnam.

**Framework:** Turner et al. (2018) | **Scope:** Descriptive mapping (not causal)

---

## Quick Start

```bash
# 1. Read the framework anchor FIRST
open 00-RESEARCH-AIM.md

# 2. Open progress tracker
open 00-PROGRESS.md

# 3. Work through phases 0-5
# 4. Every output must align with Turner framework
```

---

## Framework Integration

Every template in this workspace includes framework alignment sections:

```
┌─────────────────────────────────────────────────────────────────┐
│                    FRAMEWORK STACK                              │
├─────────────────────────────────────────────────────────────────┤
│  HLPE Food Systems Pathway (Anchor)                             │
│  Supply → Environment → Behavior → Diet                         │
│                  │              │                               │
│         ┌────────┴──────────────┴────────┐                      │
│         │   TURNER ET AL. (2018)         │                      │
│         │   Primary Analytical Lens      │                      │
│         │                                │                      │
│         │  EXTERNAL        PERSONAL      │                      │
│         │  • Vendor        • Accessibility│                     │
│         │  • Product       • Affordability│                     │
│         │  • Market        • Convenience │                      │
│         │  • Marketing     • Desirability│                      │
│         │         │              │       │                      │
│         │         └──────┬───────┘       │                      │
│         │                ▼               │                      │
│         │          HDDS (Outcome)        │                      │
│         └────────────────────────────────┘                      │
│                                                                 │
│  Downs et al. Food Environment Typology (Complement)            │
│  Wild | Cultivated | Informal | Formal | Modern                 │
│                                                                 │
│  CCE Framework (Speculative - Discussion only)                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Workspace Structure

```
01-survey-context/
├── 00-RESEARCH-AIM.md          ← READ FIRST: Framework anchor
├── 00-PROGRESS.md              ← Track progress with framework checkpoints
├── README.md                   ← You are here
├── area-0-survey-context*.md   ← Original reference (conceptual)
├── checklists/
│   └── survey-review-checklist.md
├── templates/                  ← Framework-integrated templates
│   ├── module-story-template.md         # Includes Turner domain alignment
│   ├── vietnam-context-template.md      # Structured by Turner/Downs
│   ├── interpretation-guardrails-template.md  # Scope constraints
│   ├── question-annotations-template.csv      # Framework columns
│   └── construct-mapping-template.md    # Turner framework coverage
└── outputs/                    ← Your framework-aligned work
    ├── module-stories/
    ├── vietnam-context-notes.md
    ├── construct-mapping.md
    ├── interpretation-guardrails.md
    └── question-annotations.csv
```

---

## Execution Phases

### Phase 0: Framework Alignment (START HERE)
**Time:** 30 min | **Output:** Understanding

1. Read `00-RESEARCH-AIM.md` completely
2. Understand Turner's External vs Personal distinction
3. Review the scope constraints (descriptive, not causal)

**Done when:** You can explain why this is a descriptive mapping study.

---

### Phase 1: Survey Intent & Module Stories
**Time:** 2-3 hours | **Output:** `outputs/module-stories/*.md`

1. Open your XLSForm questionnaire
2. Identify each survey module
3. For each module:
   ```bash
   cp templates/module-story-template.md outputs/module-stories/01-[module-name].md
   ```
4. Fill in with **Turner domain alignment**:
   - Which Turner domain does this module measure?
   - Is it External, Personal, Outcome, or Context?
   - How does it fit the HLPE pathway?

**Done when:** Every module maps to Turner framework.

---

### Phase 2: Question-Level Analysis
**Time:** 2-4 hours | **Output:** `outputs/question-annotations.csv`

1. Copy the CSV template:
   ```bash
   cp templates/question-annotations-template.csv outputs/question-annotations.csv
   ```
2. For each question, classify:
   - `turner_domain`: External / Personal / Outcome / Context
   - `turner_subdomain`: Vendor/Product/Market/Marketing OR Access/Afford/Convenient/Desirable
   - `hlpe_position`: Food environment / Consumer behavior / Diet
   - `downs_type`: Wild/Cultivated/Informal/Formal/Modern
   - `in_scope`: Yes - primary / Yes - control / No

**Done when:** Every question has framework classification.

---

### Phase 3: Long Biên Context Research
**Time:** 2-3 hours | **Output:** `outputs/vietnam-context-notes.md`

1. Copy the template:
   ```bash
   cp templates/vietnam-context-template.md outputs/vietnam-context-notes.md
   ```
2. Research and document **through Turner lens**:
   - External: What vendors, products, markets exist in Long Biên?
   - Personal: How do households access, afford, choose food?
   - Apply Downs typology to food sourcing patterns

**Done when:** Context covers all Turner domains and Downs types.

---

### Phase 4: Construct Mapping
**Time:** 1-2 hours | **Output:** `outputs/construct-mapping.md`

1. Copy the template:
   ```bash
   cp templates/construct-mapping-template.md outputs/construct-mapping.md
   ```
2. Complete Turner framework coverage checklist
3. Map each construct to Turner domain
4. Document framework gaps

**Done when:** Complete table linking constructs to Turner framework.

---

### Phase 5: Interpretation Limits
**Time:** 1 hour | **Output:** `outputs/interpretation-guardrails.md`

1. Copy the template:
   ```bash
   cp templates/interpretation-guardrails-template.md outputs/interpretation-guardrails.md
   ```
2. Document scope constraints:
   - What you CAN conclude (associations)
   - What you CANNOT conclude (causation)
   - Language discipline (avoid "causes", use "associated with")
   - CCE is speculative only

**Done when:** Guardrails enforce descriptive mapping scope.

---

## Framework Alignment Checklist

Before proceeding to next phase, verify:

### Turner Coverage
- [ ] External: Vendor properties mapped
- [ ] External: Product properties mapped
- [ ] External: Market properties mapped
- [ ] External: Marketing/regulation mapped
- [ ] Personal: Accessibility mapped
- [ ] Personal: Affordability mapped
- [ ] Personal: Convenience mapped
- [ ] Personal: Desirability mapped
- [ ] Outcome: HDDS clearly identified
- [ ] Framework gaps documented

### Scope Discipline
- [ ] No causal language in any output
- [ ] All claims are associations or descriptions
- [ ] CCE noted as speculative only
- [ ] Cross-sectional limitations acknowledged

---

## Key Files

| File | Purpose |
|------|---------|
| `00-RESEARCH-AIM.md` | Framework definitions, scope constraints, quick reference |
| `00-PROGRESS.md` | Track completion with framework checkpoints |
| `templates/*.md` | Framework-integrated templates |
| `outputs/*.md` | Your framework-aligned documentation |

---

## Definition of Done

| Output | Framework Requirement |
|--------|----------------------|
| Module stories | Each maps to Turner domain |
| Question annotations | Framework columns completed |
| Context notes | Covers Turner domains + Downs types |
| Construct mapping | Turner coverage checklist complete |
| Guardrails | Scope constraints documented |

---

## Outputs Feed Into

| Output | Used By | Framework Role |
|--------|---------|----------------|
| Module stories | All analysis | Turner domain understanding |
| Question annotations | 03-kobo-xlsform | Variable → framework mapping |
| Context notes | Discussion | Turner/Downs interpretation |
| Construct mapping | 05-food-security | External/Personal predictors |
| Guardrails | Thesis writing | Scope enforcement |

---

## Related Areas

- **Previous:** None (this is Phase 1)
- **Next:** [02-r-workflow](../02-r-workflow/) - Set up R environment
- **Reference:** [03-kobo-xlsform](../03-kobo-xlsform/) - XLSForm structure
- **Framework application:** [05-food-security](../05-food-security-indicators/) - HDDS outcome

---

## Troubleshooting

**"Which Turner domain for this question?"**
→ Check `00-RESEARCH-AIM.md` domain definitions table

**"Is this External or Personal?"**
→ External = characteristics of the food environment
→ Personal = how the household interacts with it

**"Can I make this claim?"**
→ Association/description = Yes
→ Causation/effect = No (see guardrails)

**"Where does CCE fit?"**
→ Speculative only. Introduce in Discussion, not Results.

---

*Last updated: 2025-12-10*
