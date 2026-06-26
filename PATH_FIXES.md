# Fixing Texture Path Issues in 3D Rendering Project

## Problem Summary

The project has texture path issues when shared via GitHub:
- **USD files** (.material.usd): ✓ Already use correct relative paths
- **Blend file** (combined-all-stones.blend): ✗ Contains hardcoded absolute paths that break on other machines

## Issue Details

### USD Material Files
The `.material.usd` files reference textures using correct relative paths:
```
asset inputs:file = @dependencies/_COM2_BaseColor.png@
```

These paths are portable and will work correctly when files are organized as:
```
project-root/
  *.material.usd
  *.layers.usd
  *.geo.usd
  dependencies/
    _COM2_BaseColor.png
    _COM2_Normal.png
    ...
```

### Blend File Issue
The `combined-all-stones.blend` file contains:
1. **Relative paths** (good): `//dependencies/_COM2_BaseColor.png`
   - The `//` protocol means "relative to this .blend file"
2. **Absolute paths** (problematic): `...p_Stone_Kidney_models_and_Images/stone_files/kimberly-stones/dependencies/_COM2_BaseColor.png`
   - These are hardcoded absolute paths from the original project location
   - They won't exist on other machines, causing texture loading to fail

## Solutions

### Solution 1: Fix Blend File (Recommended)

Use the provided `fix_blend_textures.py` script to automatically convert all absolute paths to relative paths:

```bash
blender --background combined-all-stones.blend --python fix_blend_textures.py
```

This will:
- Convert all absolute paths to relative paths (using `//dependencies/...`)
- Maintain material assignments
- Save the file with corrected paths

### Solution 2: Manual Fix in Blender

If the script doesn't work:

1. Open `combined-all-stones.blend` in Blender
2. Go to **Shading** workspace
3. For each material:
   - Select the Image Texture node
   - Open the file selector
   - Navigate to the `dependencies` folder
   - Select the correct texture file
   - This will create a relative path reference
4. Save the file (Ctrl+S / Cmd+S)

### Solution 3: For USD Files (No Action Needed)

The USD material files already have correct relative paths and should work out of the box. If you encounter issues:

1. Verify the directory structure is:
   ```
   project-root/
   ├── *.material.usd
   ├── *.layers.usd
   ├── *.geo.usd
   └── dependencies/
       └── *.png
   ```

2. When loading USD files, ensure the viewer is started from the project root directory

## Prevention for Future Exports

### From Adobe Substance 3D Sampler
When exporting materials to USD:
- Use relative paths in the export settings if available
- Don't accept absolute paths in the export dialog
- Verify the exported files reference `dependencies/...` correctly

### From Blender
When exporting or saving:
- Always save the `.blend` file in the project root
- Keep the `dependencies` folder at the same level as the `.blend` file
- Use "Pack All" or "Make Paths Relative" before sharing
- In Blender: File → External Data → Make All Paths Relative

## Verification

To verify paths are correct:

**For USD files:**
```bash
for file in *.material.usd; do
  usdcat "$file" | grep "asset inputs:file"
done
```

Should show only relative paths like: `@dependencies/...@`

**For Blend file (in Blender Python):**
```python
import bpy
for image in bpy.data.images:
    print(f"{image.name}: {image.filepath}")
```

Should show only relative paths starting with `//` or `./dependencies/`

## Current Status

✓ All texture files present in `dependencies/` folder  
✓ USD files have correct relative paths  
⚠️ Blend file needs path correction (use `fix_blend_textures.py`)
