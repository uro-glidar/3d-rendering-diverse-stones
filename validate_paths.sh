#!/bin/bash
# Validate and diagnose texture path issues in the 3D rendering project

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "═══════════════════════════════════════════════════════════════"
echo "  3D Rendering Project - Path Validation Script"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if usdcat is available
check_usdcat() {
    if ! command -v usdcat &> /dev/null; then
        echo -e "${YELLOW}⚠ Warning: usdcat not found. USD file validation will be skipped.${NC}"
        return 1
    fi
    return 0
}

# Validate USD material files
validate_usd_files() {
    echo -e "\n${BLUE}[1] Checking USD Material Files${NC}"
    echo "─────────────────────────────────────────────────────────────"

    local usd_files=$(find . -maxdepth 1 -name "*.material.usd" | wc -l)
    echo "Found $usd_files .material.usd files"

    if ! check_usdcat; then
        echo "Skipping USD content validation"
        return
    fi

    local abs_path_count=0
    local issues=0

    for usd_file in *.material.usd; do
        # Check for absolute paths in USD file
        if usdcat "$usd_file" 2>/dev/null | grep -q "@/"; then
            echo -e "  ${RED}✗${NC} $usd_file contains absolute paths"
            ((issues++))
        else
            echo -e "  ${GREEN}✓${NC} $usd_file has correct relative paths"
        fi
    done

    if [ $issues -eq 0 ]; then
        echo -e "\n${GREEN}✓ All USD files use correct relative paths${NC}"
    else
        echo -e "\n${RED}✗ $issues USD file(s) have issues${NC}"
    fi
}

# Validate dependencies folder
validate_dependencies() {
    echo -e "\n${BLUE}[2] Checking Dependencies Folder${NC}"
    echo "─────────────────────────────────────────────────────────────"

    if [ ! -d "dependencies" ]; then
        echo -e "${RED}✗ dependencies/ folder not found${NC}"
        return 1
    fi

    local texture_count=$(find dependencies -name "*.png" | wc -l)
    echo "Found $texture_count PNG texture files in dependencies/"

    # Check for missing textures referenced in USD files
    echo ""
    echo "Verifying all referenced textures exist..."

    local missing=0
    local checked=0

    if check_usdcat; then
        for usd_file in *.material.usd; do
            for texture_ref in $(usdcat "$usd_file" 2>/dev/null | grep "asset inputs:file" | grep -oE "dependencies/[^@]*" | sort -u); do
                ((checked++))
                if [ ! -f "$texture_ref" ]; then
                    echo -e "  ${RED}✗ Missing: $texture_ref${NC}"
                    ((missing++))
                fi
            done
        done

        if [ $missing -eq 0 ]; then
            echo -e "  ${GREEN}✓ All $checked referenced textures found${NC}"
        else
            echo -e "  ${RED}✗ $missing missing textures out of $checked checked${NC}"
        fi
    fi
}

# Validate Blend file
validate_blend_file() {
    echo -e "\n${BLUE}[3] Checking Blend File${NC}"
    echo "─────────────────────────────────────────────────────────────"

    if [ ! -f "combined-all-stones.blend" ]; then
        echo -e "${YELLOW}⚠ combined-all-stones.blend not found${NC}"
        return 1
    fi

    # Check for absolute paths in blend file
    local abs_path_count=$(strings combined-all-stones.blend | grep -E "^/|kimberly-stones" | wc -l)
    local rel_path_count=$(strings combined-all-stones.blend | grep -E "^//dependencies" | wc -l)

    echo "Blend file texture paths:"
    echo "  Relative paths (good): $rel_path_count"
    echo "  Absolute paths (problematic): $abs_path_count"

    if [ $abs_path_count -gt 0 ]; then
        echo -e "\n${RED}✗ Blend file contains hardcoded absolute paths${NC}"
        echo -e "  ${YELLOW}This will cause textures to fail on other machines.${NC}"
        echo -e "  ${BLUE}Solution: Run 'fix_blend_textures.py' with Blender${NC}"
        return 1
    else
        echo -e "\n${GREEN}✓ Blend file uses only relative paths${NC}"
        return 0
    fi
}

# Check directory structure
check_structure() {
    echo -e "\n${BLUE}[4] Directory Structure${NC}"
    echo "─────────────────────────────────────────────────────────────"

    tree -L 2 -I '__pycache__' 2>/dev/null || find . -maxdepth 2 -type d | sort
}

# Summary and recommendations
print_summary() {
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "  Summary & Recommendations"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""

    local blend_ok=0
    local usd_ok=1

    if [ ! -f "combined-all-stones.blend" ]; then
        echo -e "${YELLOW}⚠ No blend file to validate${NC}"
        blend_ok=1
    elif strings combined-all-stones.blend | grep -q "kimberly-stones"; then
        echo -e "${RED}✗ ISSUE: Blend file has absolute paths${NC}"
        blend_ok=0
    else
        echo -e "${GREEN}✓ OK: Blend file uses relative paths${NC}"
        blend_ok=1
    fi

    if check_usdcat; then
        for usd_file in *.material.usd; do
            if usdcat "$usd_file" 2>/dev/null | grep -q "@/"; then
                echo -e "${RED}✗ ISSUE: USD files have absolute paths${NC}"
                usd_ok=0
                break
            fi
        done
    fi

    if [ $blend_ok -eq 1 ] && [ $usd_ok -eq 1 ]; then
        echo -e "${GREEN}✓ All files are ready for sharing!${NC}"
    elif [ $blend_ok -eq 0 ]; then
        echo ""
        echo "To fix the Blend file texture paths:"
        echo ""
        echo "  1. Make sure Blender is installed"
        echo "  2. Run this command:"
        echo "     blender --background combined-all-stones.blend --python fix_blend_textures.py"
        echo ""
        echo "  3. Or manually fix in Blender:"
        echo "     - Open combined-all-stones.blend"
        echo "     - Go to Shading workspace"
        echo "     - For each material, relink textures from dependencies/ folder"
        echo "     - Save the file"
    fi

    echo ""
}

# Main execution
main() {
    validate_usd_files
    validate_dependencies
    validate_blend_file
    check_structure
    print_summary
}

main
