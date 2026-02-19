#!/bin/bash
#
# NVIM CONFIG AUDIT SCRIPT
# Scans for weird shit, explains why it's weird, asks you to delete
#

set -e

NVIM_DIR="$HOME/.config/nvim"
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

issues_found=0
issues_fixed=0

# Header
echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        NEOVIM CONFIG AUDIT - THE MESS DETECTOR               ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to prompt user
prompt_delete() {
    local file="$1"
    local reason="$2"
    local severity="$3"  # HIGH, MEDIUM, LOW
    
    issues_found=$((issues_found + 1))
    
    case $severity in
        HIGH)
            echo -e "${RED}[SEVERITY: HIGH]${NC}"
            ;;
        MEDIUM)
            echo -e "${YELLOW}[SEVERITY: MEDIUM]${NC}"
            ;;
        *)
            echo -e "${GREEN}[SEVERITY: LOW]${NC}"
            ;;
    esac
    
    echo -e "${BLUE}File:${NC} $file"
    echo -e "${BLUE}Issue:${NC} $reason"
    
    if [ -f "$file" ]; then
        echo -e "${BLUE}Size:${NC} $(wc -l < "$file") lines"
    elif [ -d "$file" ]; then
        echo -e "${BLUE}Contents:${NC} $(ls -1 "$file" 2>/dev/null | wc -l) items"
    fi
    
    echo ""
    read -p "Delete this? [y/n/s(kip)/q(uit)]: " response
    
    case "$response" in
        [yY])
            if [ -f "$file" ]; then
                rm "$file"
            elif [ -d "$file" ]; then
                rm -rf "$file"
            fi
            echo -e "${GREEN}✓ Deleted${NC}"
            issues_fixed=$((issues_fixed + 1))
            ;;
        [qQ])
            echo "Quitting..."
            exit 0
            ;;
        *)
            echo -e "${YELLOW}Skipped${NC}"
            ;;
    esac
    echo ""
}

# Function to report duplicates
report_duplicate() {
    local file1="$1"
    local file2="$2"
    
    issues_found=$((issues_found + 1))
    echo -e "${YELLOW}[DUPLICATE FILES]${NC}"
    echo -e "${BLUE}File 1:${NC} $file1"
    echo -e "${BLUE}File 2:${NC} $file2"
    
    if diff -q "$file1" "$file2" > /dev/null 2>&1; then
        echo -e "${RED}Status: IDENTICAL${NC}"
    else
        echo -e "${YELLOW}Status: DIFFERENT${NC}"
        echo "Differences:"
        diff "$file1" "$file2" | head -20
    fi
    
    echo ""
    read -p "Delete file 2 ($file2)? [y/n/q]: " response
    
    case "$response" in
        [yY])
            rm "$file2"
            echo -e "${GREEN}✓ Deleted $file2${NC}"
            issues_fixed=$((issues_fixed + 1))
            ;;
        [qQ])
            echo "Quitting..."
            exit 0
            ;;
        *)
            echo -e "${YELLOW}Kept both files${NC}"
            ;;
    esac
    echo ""
}

cd "$NVIM_DIR"

echo -e "${BLUE}━ SCANNING FOR DUPLICATES ━${NC}"
echo ""

# Check for duplicate files across tools/ and ui/
if [ -f "lua/eigengrau/plugins/tools/oil-sidebar.lua" ] && [ -f "lua/eigengrau/plugins/ui/oil-sidebar.lua" ]; then
    report_duplicate "lua/eigengrau/plugins/tools/oil-sidebar.lua" "lua/eigengrau/plugins/ui/oil-sidebar.lua"
fi

if [ -f "lua/eigengrau/plugins/tools/snacks.lua" ] && [ -f "lua/eigengrau/plugins/ui/snacks.lua" ]; then
    report_duplicate "lua/eigengrau/plugins/tools/snacks.lua" "lua/eigengrau/plugins/ui/snacks.lua"
fi

if [ -f "lua/eigengrau/plugins/tools/ui-extras.lua" ] && [ -f "lua/eigengrau/plugins/ui/ui-extras.lua" ]; then
    report_duplicate "lua/eigengrau/plugins/tools/ui-extras.lua" "lua/eigengrau/plugins/ui/ui-extras.lua"
fi

echo -e "${BLUE}━ SCANNING DISABLED FOLDER MESS ━${NC}"
echo ""

# Check disabled/unloaded duplicates
if [ -f "lua/eigengrau/plugins/disabled/buffersticks.lua" ] && [ -f "lua/eigengrau/plugins/disabled/unloaded/buffersticks.lua" ]; then
    prompt_delete "lua/eigengrau/plugins/disabled/unloaded/buffersticks.lua" "Exact duplicate of parent disabled/ folder file" "LOW"
fi

if [ -f "lua/eigengrau/plugins/disabled/md-keys.lua" ] && [ -f "lua/eigengrau/plugins/disabled/unloaded/md-keys.lua" ]; then
    prompt_delete "lua/eigengrau/plugins/disabled/unloaded/md-keys.lua" "Exact duplicate of parent disabled/ folder file" "LOW"
fi

if [ -f "lua/eigengrau/plugins/disabled/treesj.lua" ] && [ -f "lua/eigengrau/plugins/disabled/unloaded/treesj.lua" ]; then
    prompt_delete "lua/eigengrau/plugins/disabled/unloaded/treesj.lua" "Exact duplicate of parent disabled/ folder file" "LOW"
fi

echo -e "${BLUE}━ SCANNING UNUSED FOLDER ━${NC}"
echo ""

if [ -f "unused/black-atom.lua" ]; then
    prompt_delete "unused/black-atom.lua" "Disabled colorscheme - you use 'plain' now. 'enabled = false' in file." "LOW"
fi

if [ -f "unused/projects.lua" ]; then
    prompt_delete "unused/projects.lua" "Tiny 10-byte file - placeholder or forgotten?" "MEDIUM"
fi

if [ -d "unused" ]; then
    # Check if empty after deletions
    if [ -z "$(ls -A unused 2>/dev/null)" ]; then
        prompt_delete "unused/" "Empty directory after cleanup" "LOW"
    fi
fi

echo -e "${BLUE}━ SCANNING FOR DISABLED PLUGIN MESS ━${NC}"
echo ""

# Check disabled folder for abandoned plugins
disabled_plugins=$(find lua/eigengrau/plugins/disabled -name "*.lua" -not -path "*/unloaded/*" 2>/dev/null)

if [ -n "$disabled_plugins" ]; then
    echo -e "${YELLOW}Found disabled plugins (not in unloaded/):${NC}"
    for plugin in $disabled_plugins; do
        echo "  - $plugin"
    done
    echo ""
    read -p "Delete ALL disabled plugins in disabled/ (not unloaded/) [y/n/q]: " response
    
    case "$response" in
        [yY])
            for plugin in $disabled_plugins; do
                rm "$plugin"
                echo -e "${GREEN}✓ Deleted $plugin${NC}"
                issues_fixed=$((issues_fixed + 1))
            done
            issues_found=$((issues_found + $(echo "$disabled_plugins" | wc -w)))
            ;;
        [qQ])
            echo "Quitting..."
            exit 0
            ;;
        *)
            echo -e "${YELLOW}Kept all disabled plugins${NC}"
            ;;
    esac
    echo ""
fi

echo -e "${BLUE}━ SCANNING FOR MYSTERIOUS FILES ━${NC}"
echo ""

if [ -f "lua/eigengrau/plugins/tools/99.lua" ]; then
    prompt_delete "lua/eigengrau/plugins/tools/99.lua" "Mysterious filename - what does '99' mean? Check contents." "MEDIUM"
fi

if [ -f "lua/eigengrau/plugins/optional/soundmode.lua" ]; then
    if [ ! -s "lua/eigengrau/plugins/optional/soundmode.lua" ]; then
        prompt_delete "lua/eigengrau/plugins/optional/soundmode.lua" "Empty or unreadable file" "MEDIUM"
    fi
fi

echo -e "${BLUE}━ SCANNING FOR EMPTY/COMMENTED CODE ━${NC}"
echo ""

# Check for files that are mostly comments or empty
find lua -name "*.lua" -exec sh -c '
    lines=$(wc -l < "$1")
    if [ "$lines" -lt 5 ]; then
        echo "Very short file: $1 ($lines lines)"
    fi
' _ {} \;

echo ""

echo -e "${BLUE}━ SCANNING FOR DEPRECATED PATTERNS ━${NC}"
echo ""

# Check for deprecated vim.cmd usage where native Lua exists
echo "Checking for vim.cmd antipatterns..."
grep -r "vim.cmd" lua/eigengrau/config/ --include="*.lua" | grep -E "(set |let |command |augroup)" | head -10 || echo -e "${GREEN}No major antipatterns found${NC}"

echo ""

echo -e "${BLUE}━ SCANNING FOR PLUGIN OVERLAP ━${NC}"
echo ""

echo -e "${YELLOW}You have multiple plugins that might do the same job:${NC}"
echo ""

# Check for telescope + fzf-lua
if grep -q "telescope" lua/eigengrau/plugins/tools/*.lua 2>/dev/null && grep -q "fzf-lua" lua/eigengrau/plugins/tools/*.lua 2>/dev/null; then
    echo -e "${RED}[OVERLAP]${NC} Fuzzy finders: telescope.nvim AND fzf-lua"
    echo "  → Both do file finding, grep, buffer switching"
    echo "  → Recommendation: Pick fzf-lua (faster) or telescope (more extensions)"
    echo ""
fi

# Check for multiple markdown plugins
md_plugins=$(grep -l "markdown" lua/eigengrau/plugins/editor/writing/*.lua 2>/dev/null | wc -l)
if [ "$md_plugins" -gt 1 ]; then
    echo -e "${RED}[OVERLAP]${NC} Markdown plugins: $md_plugins found"
    echo "  → render-markdown, markdown-preview, markdowny"
    echo "  → Recommendation: Keep render-markdown (native), drop others"
    echo ""
fi

# Check for multiple writing focus plugins
if grep -q "goyo" lua/eigengrau/plugins/editor/writing/*.lua 2>/dev/null && grep -q "pencil" lua/eigengrau/plugins/editor/writing/*.lua 2>/dev/null; then
    echo -e "${RED}[OVERLAP]${NC} Writing focus: goyo AND pencil"
    echo "  → Both do prose/distraction-free editing"
    echo "  → Recommendation: Pick one based on features you use"
    echo ""
fi

echo ""

echo -e "${BLUE}━ SCANNING FOR BROKEN REFERENCES ━${NC}"
echo ""

# Check if plain colorscheme reference exists
if grep -q 'dir = "/home/claroscuro/projects/plain-nvim/vim-colors-plain"' lua/eigengrau/plugins/core/colorschemes/plain.lua 2>/dev/null; then
    if [ ! -d "/home/claroscuro/projects/plain-nvim/vim-colors-plain" ]; then
        echo -e "${RED}[BROKEN REFERENCE]${NC}"
        echo "Your plain colorscheme points to:"
        echo "  /home/claroscuro/projects/plain-nvim/vim-colors-plain"
        echo "But that directory doesn't exist!"
        echo ""
        echo "You're probably using the local colors/ folder instead."
        read -p "Fix the reference in plain.lua? [y/n]: " response
        
        case "$response" in
            [yY])
                sed -i 's|dir = "/home/claroscuro/projects/plain-nvim/vim-colors-plain"|dir = vim.fn.stdpath("config") .. "/vim-colors-plain"|' lua/eigengrau/plugins/core/colorschemes/plain.lua
                echo -e "${GREEN}✓ Fixed reference${NC}"
                ;;
            *)
                echo -e "${YELLOW}Skipped${NC}"
                ;;
        esac
        echo ""
    fi
fi

echo ""

echo -e "${BLUE}━ SCANNING FOR UNUSED UI FOLDERS ━${NC}"
echo ""

if [ -d "lua/eigengrau/plugins/ui" ]; then
    echo -e "${YELLOW}Found ui/ folder with:${NC}"
    ls -1 lua/eigengrau/plugins/ui/
    echo ""
    echo "These might be duplicates of tools/ folder files."
    read -p "Check and delete ui/ folder after verifying? [y/n]: " response
    
    case "$response" in
        [yY])
            echo -e "${YELLOW}ui/ folder kept for now - verify manually:${NC}"
            echo "  diff lua/eigengrau/plugins/ui/ lua/eigengrau/plugins/tools/"
            ;;
    esac
    echo ""
fi

echo ""

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                      AUDIT COMPLETE                          ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Issues found: ${YELLOW}$issues_found${NC}"
echo -e "Issues fixed/deleted: ${GREEN}$issues_fixed${NC}"
echo ""

if [ "$issues_fixed" -eq "$issues_found" ] && [ "$issues_found" -gt 0 ]; then
    echo -e "${GREEN}All issues resolved! ✨${NC}"
elif [ "$issues_fixed" -lt "$issues_found" ]; then
    echo -e "${YELLOW}Some issues remain. Run again or fix manually.${NC}"
else
    echo -e "${GREEN}No major issues found!${NC}"
fi

echo ""
echo "Next steps:"
echo "  1. Run 'nvim' to test your config"
echo "  2. Run ':checkhealth' to verify LSP/plugins"
echo "  3. Run ':Lazy' to see plugin status"
echo ""
