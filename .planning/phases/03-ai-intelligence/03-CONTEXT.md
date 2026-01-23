# Phase 03 Context: AI Intelligence

## Interaction & Layout
- **Chat Interface:** Sidebar (vertical split).
- **Inline Assistance:** Minimally invasive diffs (avoid large virtual text blocks that shift code unexpectedly).
- **Startup:** Lazy loaded, but accessible via leader key (e.g., `<leader>a`).

## Model Strategy
- **Primary Provider:** Google Gemini.
- **Configuration:**
    - Active: Gemini (Flash/Pro as appropriate for speed vs smarts).
    - Inactive (Commented): Anthropic (Claude), OpenAI.
    - **Goal:** Easy switch if Gemini API issues arise, but cleaner config by default.

## Context & Privacy
- **Policy:** Open. No `.nomodel` or privacy filters required for this local environment.
- **Scope:** Current buffer and explicit inclusions only.

## Slash Commands & Workflows
### Code
- `/explain`: Explain selected code or symbol.
- `/fix`: Fix bugs or diagnostics in selection.
- `/commit`: Generate commit message from staged changes.
- `/prettify`: Format or beautify code/text (distinct from LSP formatting if needed, or as an alias).

### Markdown / Notes (Academic & Prose)
- `/tasks`: Extract actionable tasks from a chunk of text into a checklist.
- `/proofread`: Academic/Prose style check. Focus on clarity, tone, and grammar without changing meaning.
