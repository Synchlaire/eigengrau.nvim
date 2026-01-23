# Phase 04 Context: Deep Obsidian

## Vault Structure
- **Path:** `~/Vaults/Littlewing`
- **Organization:** PARA-style (`Areas`, `projects`, `resources`, `archive`, `inbox`).
- **Dashboard/Home:** `Areas/` (Primary entry point).
- **Log/Daily Notes:** `logs/` (Format: `YYYY-MM-DD`).

## Configuration Decisions (obsidian.nvim)
- **Workspaces:**
    - Name: `Littlewing`
    - Path: `~/Vaults/Littlewing`
    - Overrides: `disable_frontmatter = false`.
- **Daily Notes:**
    - Folder: `logs`
    - Date Format: `%Y-%m-%d`
    - Template: `daily-log.md` (Auto-apply on creation).
- **Templates:**
    - Folder: `templates`
    - Substitution: Use current date/time variables.
- **Attachments:**
    - Folder: `resources/assets`
    - Image Paste: Yes, auto-move to assets folder.
- **Links:**
    - Wiki-links: `[[Note Name]]` (Standard).
    - Completion: Integrate with `nvim-cmp` (via `cmp-obsidian` or similar).

## Exclusions / Safety
- **Crew-Station:** Treat as read-only or low-priority (do not modify via automated workflows).
- **Inbox:** Default target for new, unfiled notes.
