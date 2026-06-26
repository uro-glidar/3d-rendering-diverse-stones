#!/usr/bin/env python3
"""
Fix hardcoded texture paths in Blender files to use relative paths.
"""

import bpy
import os
from pathlib import Path

print("\n" + "="*60)
print("BLENDER TEXTURE PATH FIXER")
print("="*60)

# Get the directory of the blend file
blend_file = bpy.data.filepath
if not blend_file:
    print("ERROR: No blend file is open!")
    exit(1)

blend_dir = Path(blend_file).parent
print(f"\nBlend file: {blend_file}")
print(f"Project directory: {blend_dir}")

# Count changes
fixed = 0
already_relative = 0
not_found = 0

print(f"\n{'='*60}")
print("Processing images...")
print("="*60)

for image in bpy.data.images:
    if not image.filepath or image.source != 'FILE':
        continue

    old_path = image.filepath
    image_name = image.name

    # Skip if already relative
    if old_path.startswith("//"):
        print(f"✓ {image_name}: Already relative")
        already_relative += 1
        continue

    # Get just the filename
    filename = Path(old_path).name

    # Look in dependencies folder
    dep_path = blend_dir / "dependencies" / filename

    if dep_path.exists():
        # Make it relative to blend file directory
        rel_path = os.path.relpath(dep_path, blend_dir)
        # Convert to Blender's relative path format (with //)
        blender_rel_path = f"//{rel_path}"

        image.filepath = blender_rel_path
        print(f"✓ {image_name}")
        print(f"  Old: {old_path[:50]}...")
        print(f"  New: {blender_rel_path}")
        fixed += 1
    else:
        print(f"✗ {image_name}: File not found in dependencies/")
        print(f"  Looking for: {filename}")
        not_found += 1

print(f"\n{'='*60}")
print("RESULTS")
print("="*60)
print(f"Fixed: {fixed}")
print(f"Already relative: {already_relative}")
print(f"Not found: {not_found}")
print(f"Total processed: {fixed + already_relative + not_found}")

# Save the file
print(f"\nSaving file...")
try:
    bpy.ops.wm.save_mainfile()
    print("✓ File saved successfully!")
except Exception as e:
    print(f"✗ Error saving: {e}")

print("\n" + "="*60)
print("DONE")
print("="*60 + "\n")
