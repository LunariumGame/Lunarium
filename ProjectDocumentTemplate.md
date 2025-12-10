# Lunarium #

## Summary ##

In Lunarium, you are a lone astronaut sent on a daring mission to establish the first colony on the moon.

The planet you call home grows increasingly crowded, and humanity needs a backup plan. In this strategy resource management game, you are tasked with mining for ores, cultivating food, and powering your growing colony as more civilians of Planet Earth are shipped offworld. In your quest to tame this barren rock, you can’t be everywhere at once.

Luckily, you’ve been equipped with LunaBots, which you can control from the many terminals in your lunar headquarters to manage the colony from a central location. Earth Command has tasked you with building quickly, so to boost resource acquisition, LunaBots have been equipped with advanced building techniques to get the colony up-and-running in about 10 minutes! Carefully manage your power grid, achieve a surplus of food for your growing colony, and triage whatever setbacks the hazardous environment of the moon throws at you! Become the first to achieve a stable, populous colony on the moon by meeting Earth Command’s population threshold!

## Project Resources

[Itch.io](https://itch.io/)  
[Trailer](https://www.youtube.com/watch?v=dQwvocwWPB8)  
[Proposal](https://docs.google.com/document/d/1BND99DF8VDu08BmWQeBlosrSl8PL4FcekbvLlHaypSw/edit?tab=t.0#heading=h.i3tv2mxf7h7z)  

## Gameplay Explanation ##

<details>
<summary>The Manual</summary>

### Controls ###
Lunarium's controls are simple, and consist of WASD or the arrow keys for simple RTS-like movement. Hold shift to scroll faster in the game world. Pan on your trackpad to zoom
in and out of the game world. Left-click on buttons in the game world to open up their corresponding UI element, or perform an in-game event. If you select a building button, 
press left-click again to attempt to place a building in the world. Right-click or Escape, while holding the building, will delete the building from your cursor. Press 
escape to close any UI element you opened. If no other UI is open, it will instead open the in-game settings menu.

### Gameplay Loop ###

Lunarium is a resource management and building turn-based strategy game. The player (astronaut) is tasked with managing a colony, and is given a starting allowance to construct 
buildings which generate various resources that interplay with each other. The astronaut starts with just a headquarters, and must build up their colony accordingly. When the 
astronaut advances to the next turn, the yield of buildings (indicated in each building panel when it is clicked) will be added to their economy. The astronaut must manage these 
resources carefully, or they will lock their per-turn resource production. Every two turns, colonists are shipped to the moon by a shuttle, and the astronaut must make sure they 
can support this population. The astronaut wins the game when they reach a colony population of 100. The astronaut loses the game if their colony starves, and reaches a 
population of 0.


### Buildings & Resource Types ###

1) Refinery - this building generates iron per-turn. Iron is used to construct all the buildings in the game, including the iron refinery itself. This is an important resource to generate other resources. 2) Reactor - The reactor is capable of generating electricity, which takes effect immediately and is not on a per-turn basis. Electricity goes towards the power grid quota, which is important to keeping buildings powered and functioning properly. More detail on electricity generation can be consulted in the "The Power Grid" section below. 3) Eco Dome - The eco dome generates food on a per-turn basis, and is necessary to keep your colony alive. Failure to supply the appropriate amount of food will cause colonists to die on a per-turn basis. If you lose all your colonists, your colony fails. Details are discussed further in the "Consumption and Starvation" section below including the
subtleties of their cost.

4) Residence - This building houses colonists, and does not generate any particular resources, but they are important toward winning the game (especially if one wishes to win
the game quickly). More information in "Colonial Shuttles" on how these buildings work.

5) Headquarters - The headquarters is what the astronaut starts with, and is primarily there for aesthetic (a planned but unimplemented feature was for it to house a tech tree!).

Each building has an intrinsic cost on deployment in terms of iron and electricity, and can be consulted by clicking the building button associated with the given building. 
Only the reactor does not cost electricity. Both resource costs are extracted immediately during the turn. To see the exact costs, check out the "Upgrading" section.


### Colonial Shuttles ###
Every two turns, Earth Command sends a shuttle, laden with incoming colonists, to the colony. These colonists need a place to live, or they will be turned back, so the astronaut
must build residency buildings to support them. The astronaut should carefully monitor their population limitations to ensure they can lodge the incoming colonists. Each 
residency supports 10 colonists, to start, and each shuttle sends 10 colonists. 

### The Power Grid ###
The power grid refers to the non-turn based system which in which buildings consume power, inspired by Supreme Commander (but certainly not as complicated). Buildings require
power, and if the astronaut exceeds their

### Consumption and Starvation ###


### Upgrading ###
| Cost (Iron) | Production | Power Draw |
| :------ | :---------- | :------ |
| Bold    | Highlight important text | **Important** |
| Italic  | Emphasize words or phrases | *Emphasized* |
| Code    | Display inline code | `print("Hello")` |

refinery
cost
10
15
20
prod
4
8
12
power
10
15
20


plant
10
15
20
prod
10
20
30



residential
cost
10
15
20
prod
20
40
80
power
10
15
20

eco_dome
production
10
20
30
power_table
10
15
20
cost
10
15
20


### Destroying ### 

### Turn-based Strategies ###

</details>


# External Code, Ideas, and Structure #

If your project contains code that: 1) your team did not write, and 2) does not fit cleanly into a role, please document it in this section. Please include the author of the code, where to find the code, and note which scripts, folders, or other files that comprise the external contribution. Additionally, include the license for the external code that permits you to use it. You do not need to include the license for code provided by the instruction team.

If you used tutorials or other intellectual guidance to create aspects of your project, include reference to that information as well.

## Color Vision Deficiency Matrices

All code for the CVD plugin was written in-house by Wen Kai.

The color deficiency simulation matrices for our CVD Simulator plugin (`addons/cvd_sim) were based on the full strength CVD matrices from
[*A Physiologically-based Model for Simulation of Color Vision Deficiency*](https://www.inf.ufrgs.br/~oliveira/pubs_files/CVD_Simulation/CVD_Simulation.html).
That paper was found through the [Firefox Source Docs](https://firefox-source-docs.mozilla.org/devtools-user/accessibility_inspector/simulation/index.html).

The matrix for achromatopsia (monochrome vision) was based on [the GIMP luminance equation](https://docs.gimp.org/2.10/en/gimp-filter-desaturate.html).

## Label/Button scaling

The article ["The simplest way to scale UI in Godot"](https://humnom.net/thoughts/67b7374e-the-simplest-way-to-scale-ui-in-godot.html) was referenced when researching approaches to text scaling.
We ultimately took a different approach for scaling.

# Team Member Contributions

This section be repeated once for each team member. Each team member should provide their name and GitHub user information.

The general structures is 
```
Team Member 1
  Main Role
    Documentation for main role.
  Sub-Role
    Documentation for Sub-Role
  Other contribtions
    Documentation for contributions to the project outside of the main and sub roles.

Team Member 2
  Main Role
    Documentation for main role.
  Sub-Role
    Documentation for Sub-Role
  Other contribtions
    Documentation for contributions to the project outside of the main and sub roles.
...
```

For each team member, you shoudl work of your role and sub-role in terms of the content of the course. Please look at the role sections below for specific instructions for each role.

Below is a template for you to highlight items of your work. These provide the evidence needed for your work to be evaluated. Try to have at least four such descriptions. They will be assessed on the quality of the underlying system and how they are linked to course content. 

*Short Description* - Long description of your work item that includes how it is relevant to topics discussed in class. [link to evidence in your repository](https://github.com/dr-jam/ECS189L/edit/project-description/ProjectDocumentTemplate.md)

Here is an example:  
*Procedural Terrain* - The game's background consists of procedurally generated terrain produced with Perlin noise. The game can modify this terrain at run-time via a call to its script methods. The intent is to allow the player to modify the terrain. This system is based on the component design pattern and the procedural content generation portions of the course. [The PCG terrain generation script](https://github.com/dr-jam/CameraControlExercise/blob/513b927e87fc686fe627bf7d4ff6ff841cf34e9f/Obscura/Assets/Scripts/TerrainGenerator.cs#L6).

You should replay any **bold text** with your relevant information. Liberally use the template when necessary and appropriate.

Add addition contributions int he Other Contributions section.

# Joe Vogel #

### Third-Party Assets
<u>Fonts</u>  
<i>[m5x7](https://managore.itch.io/m5x7)</i> by Daniel Linssen - Creative Commons License  

<u>Sprites</u>  
<i>[Lunarium Title](https://chatgpt.com/)</i> by ChatGPT - Free Use  
<i>[Rotating Moon](https://deep-fold.itch.io/pixel-planet-generator)</i> by Deep-Fold - MIT License  
<i>[Settings Cog](https://kenney.nl/assets/mobile-controls)</i> from Kenney.nl - Creative Commons

<u>Shaders</u>
<i>[Lightweight Pixel Perfect Outline](https://godotshaders.com/shader/lightweight-pixel-perfect-outline/)</i> by flytrap - Creative Commons

<u>Music</u>  
<i>[Space Music Pack](https://gooseninja.itch.io/space-music-pack)</i> by Goose Ninja - Free Use  

<u>Effects</u>
<i>[Star Twinkle](https://pixabay.com/users/koiroylers-44305058/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=355937)</i> by Koi Roylers, Pixabay - [License](https://pixabay.com/service/license-summary/)

### Original Assets
<i>Moon 16x16</i> by Joe Vogel   
<i>Cursor</i> by Joe Vogel


## Wen Kai Yiang ([wk-y](https://github.com/wk-y))

### Systems and Tools Engineer

[Tooling documentation](ToolsDocumentation.md)

* Colorblindness simulator plugin - for use by UI, Asset, and Accessibility roles:
  * [Colorblindness simulator implementation](https://github.com/LunariumGame/Lunarium/pull/39)
  * [Refactor into an editor plugin](https://github.com/LunariumGame/Lunarium/pull/45)
* Resource engine - stores and updates player's resource counts, handles upgrade modifiers
  * [Resource engine](https://github.com/LunariumGame/Lunarium/pull/41) - implementation of engine and framework for upgrade modifiers 
  * [Conditional modifiers](https://github.com/LunariumGame/Lunarium/pull/87) - framework for modifier conditions, implements a modifier to apply based on class
* Electricity generation mechanics
  * [Implementation](https://github.com/LunariumGame/Lunarium/pull/80)
  * [Configuration](https://github.com/LunariumGame/Lunarium/pull/137) - 
  * [Building debug overlay](https://github.com/LunariumGame/Lunarium/pull/138) - used to debug power status
* [NotificationManager](https://github.com/LunariumGame/Lunarium/pull/184) - processes event signals into textual notifications
* [UiScaleManager](https://github.com/LunariumGame/Lunarium/blob/dev/scripts/managers/ui_scale_manager.gd) - manages the current scale setting of the UI
   * [Label scaling](https://github.com/LunariumGame/Lunarium/pull/64) - scales labels
   * [Button scaling](https://github.com/LunariumGame/Lunarium/pull/102) - scales buttons using the theme
* [Crater background PCG](https://github.com/LunariumGame/Lunarium/pull/140) - randomly placed craters to give the background character

### Accessibility and Usability Design

* UI Scaling
   * [Label scaling](https://github.com/LunariumGame/Lunarium/pull/64) - scaling of labels in the HUD
   * [Button scaling](https://github.com/LunariumGame/Lunarium/pull/102) - scaling of the next turn button
* [Cursor scaling](https://github.com/LunariumGame/Lunarium/pull/149)
   * Scale cursor based on screen resolution
   * Shake to find cursor

### Core game mechanics
* [Population growth shuttle](https://github.com/LunariumGame/Lunarium/pull/113) - provides the colony with population increases
* [Starvation](https://github.com/LunariumGame/Lunarium/pull/109) - kills colonists when food runs out
* [Win condition check](https://github.com/LunariumGame/Lunarium/pull/107) - win when population target is met
* [Game loop](https://github.com/LunariumGame/Lunarium/pull/55) - handles game updates between turns
