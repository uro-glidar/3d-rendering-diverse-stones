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

Three **Blender project files** (`.blend`) are also included:
- `combined-all-stones.blend` — all 18 models in a single scene
- `combined-com.blend` — COM stones grouped separately

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

## Citation

If you use these models in your research, please cite:

> [Your citation here — author(s), title, journal, year, DOI]

---

## License

[Specify license here — e.g. CC BY 4.0, MIT, etc.]

---

## Contact

For queries regarding the dataset, please contact [your email or GitHub handle].
