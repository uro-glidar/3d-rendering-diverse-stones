# 3D Rendering Repository: Diverse Kidney Stone Models

High-fidelity 3D kidney stone models stratified by chemical composition, developed for use in urological simulation research and surgical training tool development.

---

## Dataset Overview

This repository contains **18 individual kidney stone models** across four chemical composition groups, each reconstructed and rendered to reflect the characteristic surface texture and geometry of clinically encountered stone types.

| Composition | Code | n |
|---|---|---|
| Calcium oxalate monohydrate / dihydrate | COM | 8 |
| Calcium hydrogen phosphate dihydrate (brushite) | CHPD | 3 |
| Magnesium ammonium phosphate / hydroxyapatite / carbonate apatite | MAPHCA / MAPHDCA | 2 |
| Uric acid | UA | 5 + U2 |

A full catalogue of models is provided in [`stone-list.pdf`](./stone-list.pdf) and [`stone-list.docx`](./stone-list.docx).

---

## File Formats

Each stone model is provided in **Universal Scene Description (USD)** format — an open, interoperable standard developed by Pixar and widely supported across 3D software. Every model consists of four component files:

| Extension | Contents |
|---|---|
| `.usd` | Root assembly file |
| `.geo.usd` | Mesh geometry |
| `.material.usd` | Surface material and texture properties |
| `.layers.usd` | Layer composition and scene hierarchy |

**Texture Dependencies**: All USD material files reference texture maps located in the `dependencies/` folder (96 PNG files: BaseColor, Normal, Roughness, and AmbientOcclusion for each stone). These are **relative paths** and will resolve correctly when the entire repository structure is preserved.

Three **Blender project files** (`.blend`) are also included:
- `combined-all-stones.blend` — all 18 models in a single scene with correct texture linking
- `combined-com.blend` — COM stones grouped separately

---

## Getting Started

### Prerequisites
- Clone or download this entire repository (maintaining the directory structure)
- For USD files: Any USD-compatible viewer
- For Blender files: Blender 3.0+ with USD support

### Opening Files

**USD Files**: Open any `.usd` file in your preferred USD viewer or 3D application. Textures will load automatically from the relative paths in the `dependencies/` folder.

**Blender Files**: Open `.blend` files directly in Blender. All textures are linked via relative paths and will load automatically (no need to re-link manually).

### Repository Structure
```
3d-rendering-diverse-stones/
├── *.usd                 # Root USD assembly files
├── *.geo.usd            # Geometry layers
├── *.material.usd       # Materials with texture references
├── *.layers.usd         # Layer composition
├── *.blend              # Blender project files
├── dependencies/        # Texture maps (PNG files)
├── README.md            # This file
└── PATH_FIXES.md        # Technical notes on texture path fixes
```

---

## Software Compatibility

These files are compatible with:
- [Blender](https://www.blender.org/) (v3.0+ with USD support)
- [Houdini](https://www.sidefx.com/)
- [NVIDIA Omniverse](https://www.nvidia.com/en-us/omniverse/)
- Any USD-compliant viewer or pipeline (e.g. usdview)

---

## Intended Use Cases

- Validation of kidney stone simulation realism (texture and geometry)
- Development and benchmarking of endourology surgical training simulators
- Computer vision and machine learning training data for stone recognition
- 3D printing of patient-specific stone phantoms
- Interactive model assessment in future simulation platforms

---

## Technical Notes

**Texture Paths**: All texture references use relative paths from the repository root. This ensures that:
- Files work consistently across different machines and operating systems
- No hardcoded paths break when the repo is moved or shared
- Blender files automatically find textures without manual relinking

For detailed technical information about texture path organization and troubleshooting, see [`PATH_FIXES.md`](./PATH_FIXES.md).

---

## Citation

If you use these models in your research, please cite:

Pérez, K.C., Porto, J.G., Civetta, L. et al. A validated custom pipeline for three-dimensional kidney stone renderings to create an open access repository. Urolithiasis 54, 117 (2026). https://doi.org/10.1007/s00240-026-02019-9

---

