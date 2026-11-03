# DEMON MODS — Agent Instructions

## Scope
This repository contains development work for DEMON MODS, including BeamNG.drive maps, vehicle mods, and related Python tools. These instructions apply to the whole repository. Do not assume that local game files or the user's computer are accessible.

## Operating principles
- Inspect existing files and document the intended change before editing.
- Make small, reversible changes; preserve originals and keep version history.
- Never delete or overwrite user files, publish releases, change repository visibility, or deploy websites without explicit approval.
- Do not commit credentials, tokens, personal information, customer data, or private financial records.
- Prefer a separate branch and a pull request for substantial changes.
- Clearly distinguish verified results from assumptions; report what was tested and what was not.
- Do not claim a mod works in-game unless it has actually been tested.

## BeamNG.drive
- Target the user's reported BeamNG.drive 0.40.4.0 build unless a newer target is confirmed.
- Validate mod ZIP structure, file references, naming, and applicable JSON/JBeam/Lua syntax before release.
- Keep mods separate from original game files; avoid modifying the base installation.
- Prioritize stable roads, functional AI routes, sensible collision meshes, performance, and visual consistency.
- For SUBIYAH KUWAIT PRO, preserve approved Kuwait-specific road, bridge, desert, signage, lighting, and speed-camera requirements. Verify geography and measurements instead of inventing precision.
- Test changes incrementally and record known issues and rollback steps.

## Python and Blender
- The user's previously reported environment includes Python 3.13 and Blender 4.5 LTS portable; verify actual versions before running scripts.
- Prefer reproducible scripts, explicit inputs/outputs, logging, and safe dry-run modes.
- Back up assets before conversion or export; validate exported geometry and paths.

## Performance
- Optimize with the user's RTX 2060 SUPER and 1080p gameplay as a practical baseline, without claiming benchmarks that have not been measured.

## Workflow
1. Read relevant files and identify dependencies.
2. State a concise plan, risks, and expected outputs.
3. Implement the smallest safe change.
4. Run available checks and record their results.
5. Summarize changed files, unresolved issues, and manual in-game tests needed.
6. Request approval before deployment, destructive actions, or public release.

## Separation of concerns
Keep personal schedules, budgets, banking details, and private household information outside this code repository. Store only project-appropriate technical documentation here.
