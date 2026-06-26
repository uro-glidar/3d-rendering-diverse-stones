#!/usr/bin/env python3
"""
Fix hardcoded texture paths in Blender files to use relative paths.
Run with: blender --background combined-all-stones.blend --python fix_blend_textures.py
"""

import bpy
import os
from pathlib import Path

def fix_image_paths():
    """Convert all image paths to relative paths."""

    # Get the directory of the blend file
    blend_dir = Path(bpy.data.filepath).parent
    print(f"Blend file directory: {blend_dir}")

    # Iterate through all images in the blend file
    for image in bpy.data.images:
        if image.filepath:
            image_path = Path(image.filepath)
            print(f"\nProcessing image: {image.name}")
            print(f"  Current path: {image.filepath}")

            # Try to find the image file in dependencies directory
            dependencies_dir = blend_dir / "dependencies"
            image_filename = image_path.name

            # Check if file exists in dependencies
            potential_path = dependencies_dir / image_filename
            if potential_path.exists():
                # Convert to relative path
                try:
                    rel_path = os.path.relpath(potential_path, blend_dir)
                    image.filepath = rel_path
                    print(f"  Updated to: {rel_path}")
                except Exception as e:
                    print(f"  Error updating path: {e}")
            else:
                # Try to extract just the filename and look for it
                print(f"  Looking for: {image_filename} in {dependencies_dir}")
                if dependencies_dir.exists():
                    # List available files
                    available = list(dependencies_dir.glob("*"))
                    print(f"  Available files in dependencies: {len(available)}")

                    # Try case-insensitive match
                    for f in available:
                        if f.name.lower() == image_filename.lower():
                            rel_path = os.path.relpath(f, blend_dir)
                            image.filepath = rel_path
                            print(f"  Found with different case, updated to: {rel_path}")
                            break

    # Save the file
    try:
        bpy.ops.wm.save_mainfile()
        print("\n✓ File saved successfully!")
    except Exception as e:
        print(f"\n✗ Error saving file: {e}")

if __name__ == "__main__":
    if bpy.data.filepath:
        fix_image_paths()
    else:
        print("Error: No blend file is open. Run with: blender --background <file.blend> --python fix_blend_textures.py")
