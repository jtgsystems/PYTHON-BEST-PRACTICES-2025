# AGENTS.md

## Repo Snapshot
- Repository: `jtgsystems/PYTHON-BEST-PRACTICES-2025`
- Default branch: `main`
- Visibility: `public`
- Summary: Python best practices guide 2025 - Modern coding standards, patterns & optimization techniques
- Detected stack: mixed or uncategorized source repo

## Read First
- `README.md`
- `CLAUDE.md`
- `.github/workflows/`

## Key Paths
- `01-CORE-PRINCIPLES/`
- `02-LINTING-FORMATTING/`
- `03-TESTING-FRAMEWORKS/`
- `04-PROJECT-STRUCTURE/`
- `05-PERFORMANCE-SECURITY/`
- `06-CI-CD-TEMPLATES/`

## Working Rules
- Keep changes focused on the task and match the existing file layout and naming patterns.
- Update tests and docs when behavior changes or public interfaces move.
- Do not commit secrets, credentials, ad-hoc exports, or large generated artifacts unless the repository already tracks them intentionally.
- Prefer the existing automation and CI workflow over one-off commands when both paths exist.
- Legacy agent guidance exists in `CLAUDE.md`; keep it aligned with `AGENTS.md` if those files remain in use.

## Verified Commands
- No reliable build or test command was detected from the repo root manifests.
- Check the files in `Read First` and `.github/workflows/` before changing code or release logic.

## Change Checklist
- Run the relevant tests or static checks for the files you changed before finishing.
- Keep human-facing docs aligned with behavior changes.
- If the repo has specialized areas later, add nested `AGENTS.md` files close to that code instead of overloading the root file.

## Notes
- CI source of truth lives in `.github/workflows/`.

This file should stay short, specific, and current. Update it whenever the repo's real setup or verification steps change.
