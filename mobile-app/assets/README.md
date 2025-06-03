# AR Assets Required

For the AR functionality to work properly, you need to add the following assets:

1. `triangle.png` - A simple transparent PNG with a white triangle outline for plane detection visualization
   - Size: 64x64 pixels recommended
   - Format: PNG with transparency
   - Place in: `assets/triangle.png`

2. 3D Models
   - Format: GLB (GLTF Binary)
   - Naming: `puff_0.glb`, `puff_1.glb`, etc.
   - Place in: `assets/models/`
   - Recommended size: Keep under 5MB per model
   - Include textures in the GLB file

3. Textures (if needed separately)
   - Format: PNG or JPG
   - Place in: `assets/textures/`

## Quick Start
1. Create a simple triangle.png for plane detection
2. Export your 3D puff models in GLB format
3. Place the models in the `assets/models/` directory
4. Update the `pubspec.yaml` if you add any new asset directories 