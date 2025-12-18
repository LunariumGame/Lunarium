# Tools documentation

Here you will find documentation for the development tools included in Lunarium.

## Color Vision Deficiency Editor Plugin

The Color Vision Deficiency (CVD) editor plugin can be used to simulate CVD/colorblindness.
To use the plugin:

1. Open the "CVD" editor plane.
2. Click on a CVD condition to enable it.
3. Click "None" to disable CVD simulation.

## Debug Overlays

Debug overlays are available on buildings to show their power state.
Press `\` to toggle.

This feature is disabled in release builds.

## Crater PCG script

Craters use a tool script to procedurally generate themselves at design-time.
To regenerate the craters:

1. Open `res://scenes/craters.tscn` in the editor.
2. Click on the "Craters"/root node.
3. Click "Regenerate" in the inspector panel until you are satisfied with the crater layout.