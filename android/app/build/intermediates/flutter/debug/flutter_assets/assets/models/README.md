# 3D Character Models

This directory should contain the following GLB files for the character animations:

1. `character_neutral.glb` - Default standing pose
2. `character_happy.glb` - Happy expression
3. `character_excited.glb` - Excited animation
4. `character_waving.glb` - Waving animation
5. `character_dancing.glb` - Dancing animation

## Model Requirements

- Format: GLB (GL Transmission Format Binary)
- Size: Keep under 10MB per model
- Dimensions: Normalized to approximately 2 units tall
- Textures: Embedded in GLB
- Animations: Should be 60 frames long to match the app's animation system

## Recommended 3D Character Sources

You can obtain suitable 3D character models from:

1. Ready Player Me - https://readyplayer.me/
   - Create custom avatars
   - Export as GLB
   - Includes basic animations

2. Mixamo - https://www.mixamo.com/
   - Free character models
   - Extensive animation library
   - Export as FBX and convert to GLB

3. Microsoft's Babylon.js - https://sandbox.babylonjs.com/
   - Various character models
   - Direct GLB export
   - Animation support

## Converting Models

To convert models to GLB format:
1. Use Blender (free, open-source)
2. Import your model
3. Export as GLB
4. Ensure animations are included

## Testing Models

Before adding models to the app:
1. Test in https://sandbox.babylonjs.com/
2. Verify animations work
3. Check file size
4. Validate textures 