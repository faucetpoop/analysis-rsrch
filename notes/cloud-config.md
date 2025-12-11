# Claude Cloud Configuration Reference

This note captures the current Claude configuration for both the **analysis-rsrch** project workspace and the global `~/.claude` environment.

## Project Workspace (analysis-rsrch)
- Entry docs: `CLAUDE.md` (agent-foreman rules), `CONTEXT.md`, `SPECIFICATION.md`, `ARCHITECTURE.md`, `MIGRATION-COMPLETE.md`.
- Harness: `agent-foreman` with commands (`status`, `next`, `check`, `done`, `impact`, `scan`); follow one-feature-at-a-time and TDD guidance (use `CI=true` for tests).
- Root helper: `./ai/init.sh` (`bootstrap`, `dev`, `check`, `build`, `status`, `help`).
- Multi-sandbox layout under `sandboxes/` (01–04). Each sandbox has its own `ai/feature_list.json`, `ai/progress.log`, `ai/init.sh`, and `SANDBOX.md`.
- Global scripts: `scripts/sandbox-status.sh` (aggregate status) and `scripts/sandbox-progress.sh` (combined progress logs).

## Global Claude Environment (`~/.claude`)

### Settings
- File: `~/.claude/settings.json`
- Model: `haiku`
- alwaysThinkingEnabled: false
- Enabled plugins: superpowers, episodic-memory, orchestration, compound-engineering, repomix-explorer, document-skills, genkit-starter-kits, genkit-image, scientific-skills, commit-commands, scientific-packages, agent-foreman, docs-cleaner, neurodivergent-visual-org, claude-scientific-writer, genkit-webhooks, skill-porter, gemini-search, plugin-orchestrator, pi-pathfinder, openrouter, database-migrations, database-design, git-pr-workflows, documentation-generation, full-stack-orchestration, codebase-cleanup, genkit.

### Installed Plugins (with versions)
- agent-foreman@agent-foreman-plugins (0.1.92)
- claude-scientific-writer@claude-scientific-writer (21e16477a27c)
- codebase-cleanup@claude-code-workflows (1.2.0)
- commit-commands@claude-code-plugins (1.0.0)
- compound-engineering@every-marketplace (2.9.3)
- database-design@claude-code-workflows (1.2.0)
- database-migrations@claude-code-workflows (1.2.0)
- docs-cleaner@daymade-skills (1.0.0)
- document-skills@anthropic-agent-skills (00756142ab04)
- documentation-generation@claude-code-workflows (1.2.0)
- episodic-memory@superpowers-marketplace (1.0.13)
- full-stack-orchestration@claude-code-workflows (1.2.1)
- gemini-search@gemini-search-dev (0.1.3)
- genkit-image@genkit-marketplace (1.0.0)
- genkit-starter-kits@genkit-marketplace (1.0.0)
- genkit-webhooks@genkit-marketplace (1.0.0)
- genkit@genkit-marketplace (1.7.0)
- git-pr-workflows@claude-code-workflows (1.2.1)
- openrouter@skillsforge-marketplace (9b321fd2abfc)
- orchestration@orchestration-marketplace (1.0.0)
- pi-pathfinder@claude-code-plugins-plus (1.0.0)
- repomix-explorer@repomix (1.1.0)
- scientific-skills@claude-scientific-skills (78331e1b3775)
- superpowers@superpowers-marketplace (3.6.2)

### Skills (`~/.claude/skills/`)
- Art
- clean-architecture
- codex-cli
- context7
- latex-posters
- scientific-schematics

### Command Templates (`~/.claude/commands/`)
- cleanproject.md — “Clean Project” helper to remove artifacts
- commit.md — smart git commit message helper + pre-commit checks
- contributing.md — contribution strategy checklist
- create-todos.md — generate contextual TODO comments
- docs.md — documentation manager flow
- explain-like-senior.md — senior-style explanation helper
- find-todos.md — scan codebase for TODO markers
- fix-imports.md — repair broken imports (args supported)
- fix-todos.md — locate and resolve TODOs (args supported)
- format.md — auto-format code (detects formatter)
- implement.md — feature implementation engine (args supported)
- make-it-pretty.md — readability improvements
- predict-issues.md — predictive code analysis
- reddit-thread-analyzer.md — Reddit thread analyzer command
- refactor.md — refactoring engine (args supported)
- remove-comments.md — remove redundant comments
- review.md — code review helper
- scaffold.md — intelligent scaffolding (args supported)
- security-scan.md — security analysis (args supported)
- session-end.md — end-of-session summarizer
- session-start.md — start-of-session initializer
- test.md — smart test runner
- todos-to-issues.md — convert TODOs to GitHub issues
- understand.md — project understanding walk
- undo.md — undo last CCPlugins operation
  - Notes: `.DS_Store` present; `sc/` is a directory placeholder (ignored).

### Plans (`~/.claude/plans/`)
- distributed-honking-seahorse.md
- nifty-soaring-dusk.md
- reactive-growing-pnueli.md
- rosy-swinging-flame-agent-b87e54b1.md
- rosy-swinging-flame.md
- silly-churning-mountain.md
- zazzy-sleeping-waterfall.md

Plan previews (first non-empty lines):
- distributed-honking-seahorse.md — “Parallel Gemini CLI + Claude Code Diagram Processing Pipeline” (Draft, 2025-12-09)
- nifty-soaring-dusk.md — “Plan: Create Root-Level CLAUDE.md” (context: workbench docs governance)
- reactive-growing-pnueli.md — “Implementation Plan: Unified Dotfiles Management System” (project: config-fix-poject)
- rosy-swinging-flame-agent-b87e54b1.md — “Bibliography Processing Pipeline - Best Practices Research (2025)” (research summary)
- rosy-swinging-flame.md — “Bibliography Processing Pipeline” (goal: automate Zotero cleanup report)
- silly-churning-mountain.md — “Integration Plan: fresh/000-docs → WorkspaceOS” (v1.0, 2025-12-08)
- zazzy-sleeping-waterfall.md — “Inbox Command Scaffold for Claude Plugin” (goal: minimal /inbox capture command)

### Projects (`~/.claude/projects/`)
- -Users-emersonburke
- -Users-emersonburke--claude-squad-worktrees-ewe-188013aa729ea8b8
- -Users-emersonburke--claude-squad-worktrees-f-18801392618eb5d0
- -Users-emersonburke-conductor-workspaces-analysis-rsrch-belgrade
- -Users-emersonburke-conductor-workspaces-analysis-rsrch-farmerville
- -Users-emersonburke-conductor-workspaces-analysis-rsrch-mogadishu
- -Users-emersonburke-conductor-workspaces-analysis-rsrch-montgomery
- -Users-emersonburke-conductor-workspaces-analysis-rsrch-montreal
- -Users-emersonburke-conductor-workspaces-analysis-rsrch-v1-el-paso
- -Users-emersonburke-conductor-workspaces-analysis-rsrch-v1-kuwait
- -Users-emersonburke-conductor-workspaces-analysis-rsrch-v1-sao-paulo
- -Users-emersonburke-conductor-workspaces-analysis-rsrch-v2-port-louis
- -Users-emersonburke-conductor-workspaces-conductor-playground-cayenne
- -Users-emersonburke-conductor-workspaces-conductor-playground-cheyenne
- -Users-emersonburke-conductor-workspaces-conductor-playground-miami
- -Users-emersonburke-conductor-workspaces-conductor-playground-ottawa
- -Users-emersonburke-conductor-workspaces-conductor-playground-saskatoon
- -Users-emersonburke-conductor-workspaces-conductor-playground-tripoli
- -Users-emersonburke-conductor-workspaces-conductor-playground-victoria
- -Users-emersonburke-conductor-workspaces-desktopos-brasilia
- -Users-emersonburke-conductor-workspaces-desktopos-dhaka
- -Users-emersonburke-conductor-workspaces-desktopos-hat-yai
- -Users-emersonburke-conductor-workspaces-desktopos-perth
- -Users-emersonburke-conductor-workspaces-desktopos-santo
- -Users-emersonburke-conductor-workspaces-desktopos-sarajevo
- -Users-emersonburke-conductor-workspaces-desktopos-tallahassee
- -Users-emersonburke-conductor-workspaces-desktopos-vilnius
- -Users-emersonburke-conductor-workspaces-desktopos-walla-walla
- -Users-emersonburke-conductor-workspaces-reset-cancun
- -Users-emersonburke-Desktop
- -Users-emersonburke-Desktop-desktopos
- -Users-emersonburke-Desktop-inbox
- -Users-emersonburke-Desktop-inbox-projects-analysis-rsrch
- -Users-emersonburke-Desktop-inbox-projects-bibliography-processor
- -Users-emersonburke-Desktop-inbox-projects-figures
- -Users-emersonburke-Desktop-inbox-projects-tmpdesigniterate
- -Users-emersonburke-Desktop-workbench
- -Users-emersonburke-Desktop-workbench-projects
- -Users-emersonburke-Desktop-workbench-projects-alfred-hidden-files-workflow
- -Users-emersonburke-Desktop-workbench-projects-analog-style-research
- -Users-emersonburke-Desktop-workbench-projects-analysis-rsrch
- -Users-emersonburke-Desktop-workbench-projects-config-fix-project
- -Users-emersonburke-Desktop-workbench-projects-latex-tikz-framework
- -Users-emersonburke-Desktop-workbench-projects-obsidian-plugin-setup
- -Users-emersonburke-Desktop-workbench-projects-thesis-figure-enhancements
- -Users-emersonburke-Desktop-workbench-projects-tools-bibliography-processor
- -Users-emersonburke-Documents-obsidian-vault
- -Users-emersonburke-Library-Mobile-Documents-com-apple-CloudDocs-inbox
- -Users-emersonburke-Library-Mobile-Documents-com-apple-CloudDocs-inbox-config-fix-poject
- -Users-emersonburke-Library-Mobile-Documents-com-apple-CloudDocs-inbox-np-dev
- -Users-emersonburke-Library-Mobile-Documents-com-apple-CloudDocs-inbox-projectos-dev
- -Users-emersonburke-Library-Mobile-Documents-com-apple-CloudDocs-inbox-resourceps-dev
- -Users-emersonburke-Library-Mobile-Documents-com-apple-CloudDocs-inbox-workspaceos-dev

### Other Notable Paths
- History: `~/.claude/history.jsonl`
- File history: `~/.claude/file-history/`
- Session env snapshots: `~/.claude/session-env/`
- Shell snapshots: `~/.claude/shell-snapshots/`
- Todos store: `~/.claude/todos/`
