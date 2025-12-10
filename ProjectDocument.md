# Lunarium #

## Summary ##
In Lunarium, you are a lone astronaut sent on a daring mission to establish the first colony on the moon.

The planet you call home grows increasingly crowded, and humanity needs a backup plan. In this strategy resource management game, you are tasked with mining for ores, cultivating food, and powering your growing colony as more civilians of Planet Earth are shipped offworld. In your quest to tame this barren rock, you can’t be everywhere at once.

Luckily, you’ve been equipped with LunaBots, which you can control from the many terminals in your lunar headquarters to manage the colony from a central location. Earth Command has tasked you with building quickly, so to boost resource acquisition, LunaBots have been equipped with advanced building techniques to get the colony up-and-running in about 10 minutes! Carefully manage your power grid, achieve a surplus of food for your growing colony, and triage whatever setbacks the hazardous environment of the moon throws at you! Become the first to achieve a stable, populous colony on the moon by meeting Earth Command’s population threshold!

## Project Resources

[Itch.io](https://hawkhobo.itch.io/lunarium)  
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
1) Refinery - this building generates iron per-turn. Iron is used to construct all the buildings in the game, including the iron refinery itself. This is an important resource 
to generate other resources. 

2) Reactor - The reactor is capable of generating electricity, which takes effect immediately and is not on a per-turn basis. Electricity goes towards the power grid quota, 
which is important to keeping buildings powered and functioning properly. More detail on electricity generation can be consulted in the "The Power Grid" section below. 

3) Eco Dome - The eco dome generates food on a per-turn basis, and is necessary to keep your colony alive. Failure to supply the appropriate amount of food will cause colonists 
to die on a per-turn basis. If you lose all your colonists, your colony fails. Details are discussed further in the "Consumption and Starvation" section below including the
subtleties of their cost.

4) Residence - This building houses colonists, and does not generate any particular resources, but they are important toward winning the game (especially if one wishes to win
the game quickly). More information in "Colonial Shuttles" on how these buildings work.

5) Headquarters - The headquarters is what the astronaut starts with, and is primarily there for aesthetic (a planned but unimplemented feature was for it to house a tech tree!).
Note this building generates one iron per turn so that the player isn't hardlocked out of the economy if they've made some errors.

Each building has an intrinsic cost on deployment in terms of iron and electricity, and can be consulted by clicking the building button associated with the given building. 
Only the reactor does not cost electricity. Both resource costs are extracted immediately during the turn. To see the exact costs, check out the "Upgrading" section.


### Colonial Shuttles ###
Every two turns, Earth Command sends a shuttle, laden with incoming colonists, to the colony. These colonists need a place to live, or they will be turned back, so the astronaut
must build residency buildings to support them. The astronaut should carefully monitor their population limitations to ensure they can lodge the incoming colonists. Each 
residency supports 10 colonists, to start, and each shuttle sends 10 colonists. 

### The Power Grid ###
The power grid refers to the non-turn based system in which buildings consume power, inspired by Supreme Commander (but certainly not as complicated). Buildings require
power, and if the astronaut exceeds their power budget, the constructed building will shut down. It will not generate resources on the next turn unless the power budget is 
increased, by creating another reactor.

### Consumption and Starvation ###
At the end of every turn, colonists will consume food. Each colonist consumes a single food unit. If the food stockpile at the end of a turn is lower than the population, then
the difference between them becomes the number of starving colonists. This number is then divided in half, and rounded to the nearest whole integer, and becomes the amount of
colonists which will die on the next turn. This is how you lose the game.


### Upgrading ###
Buildings are upgradeable in their respective building panel. They produce more, cost more, and deliver more power draw on the power grid. A full breakdown of their scalar values
can be seen below, upgrade-to-upgrade:

  #### Refinery ####
| Cost | Production (Iron) | Power Draw |
| :------ | :----------   | :------    |
| 10      |     4         | 10         |
| 15  | 8| 15|
| 20    | 12| 20|

  #### Reactor ####
| Cost    | Production (Electricity) | Power Draw |
| :------ | :----------   | :------    |
| 10      |     10         | 0         |
| 15  | 20| 0|
| 20    | 30| 0|

  #### Residential ####
| Cost    | Production (Population) | Power Draw |
| :------ | :----------   | :------    |
| 10      |     20         | 10         |
| 15  | 40| 15|
| 20    | 80| 20|

  #### Eco Dome ####
| Cost    | Production (Food) | Power Draw |
| :------ | :----------   | :------    |
| 10      |     10         | 10         |
| 15  | 20| 15|
| 20    | 30| 20|

### Destroying ### 
If you misplace a building, or simply wish to remove it, you can do so by clicking the destroy button!

### Turn-based Strategies ###
We list a few strategies below to get you started (but we don't want to spoil the whole game :-) ):
* First, monitor your power grid carefully. Ensure that you are not needlessly constructing buildings that can't be powered on the current turn.
* Get some food quick to support incoming colonists! Watch that shuttle every 2 turns. When the colonists come in, you want to be able to feed them (this is the easiest resource
  to forget about, we have found).
* Get a running refinery up immediately. It produces iron 4.0x higher than the standalone headquarters.

</details>


# External Code, Ideas, and Structure #

## Tutorials Used

* [Ultimate Godot AnimationTree Tutorial - They Are Not Scary!](https://www.youtube.com/watch?v=E6ajmQhOeo4)
* [Godot UI Basics - how to build beautiful interfaces that work everywhere (Beginners)](https://www.youtube.com/watch?v=1_OFJLyqlXI)
* [How To Fix Blurry Pixel Art in Godot!](https://www.youtube.com/shorts/p5Gm1DeqXcg)
* [ Using Github To Build Your Game! Creating a Ci/CD System Using Github Actions!](https://www.youtube.com/watch?v=bIXBosDO6f8) 

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

## Joe Vogel ([Coco501](https://github.com/Coco501))

### User Interface and Input
  - [Settings menu](https://github.com/LunariumGame/Lunarium/pull/40)
  - [Main menu styling (& much more)](https://github.com/LunariumGame/Lunarium/pull/205)
  - In-game UI 
    - [Many iterations on the overall layout & design](https://github.com/LunariumGame/Lunarium/pull/147)
    - [Oldsteam theme](https://github.com/LunariumGame/Lunarium/pull/152)
    - [Inspector panel](https://github.com/LunariumGame/Lunarium/pull/168)
  - Controls
    - [Camera speed & zoom](https://github.com/LunariumGame/Lunarium/issues/35)
    - [Hotkeys and input control (Space, ESC, B, Right-click, Shift, etc.)](https://github.com/LunariumGame/Lunarium/pull/163)
    - [World borders](https://github.com/LunariumGame/Lunarium/pull/150)

### Gameplay Playtesting
  - Conducted 9 playtesting sessions
    - [Official Playtesting Document](https://docs.google.com/document/d/1mVwciQaqRTi5cSQx_DC_5bwGkvSAjFtnQ4yakBuf55s/edit?tab=t.nqudi14ugpnn)
  - Made an external document for playtesters to fill out themselves
    - [External Playtesting Document](https://docs.google.com/document/d/1wc2hWlAAw7NJTlG1Mo9_kOsT3hX_q5pVRvdjqzl0JZ4/edit?tab=t.0)
  - Balanced the game and prioritized features based on playtester feedback
    - [Highlighting buildings on hover](https://github.com/LunariumGame/Lunarium/pull/174)
    - [Audio being too loud](https://github.com/LunariumGame/Lunarium/pull/205)
    - Resource balancing

### Other contributions
  - Systems integrations
    - [Building manager UI hookup](https://github.com/LunariumGame/Lunarium/pull/168)
  - Asset contributions and research 
    - [Drew resource, logo, and cursor sprites](https://github.com/LunariumGame/Lunarium/tree/dev/assets/sprites)
    - [Concept art designs](https://imgur.com/a/sxaUOWV)
    - Sourced the game logo and rotating moon animation 
    - Sourced initial soundtrack
  - Minor team organization tasks
  - Game balancing
  - Animation refinements
    - [Fixed opening cutscene bugs](https://github.com/LunariumGame/Lunarium/pull/203)
    - [Gave input on the length of animations, as well as crucial bug fixes in the building animation tree](https://github.com/LunariumGame/Lunarium/pull/205)
  - [Hooked up lose and win screen logic](https://github.com/LunariumGame/Lunarium/pull/189)
  - [Configured global project settings](https://github.com/LunariumGame/Lunarium/pull/43) (resolution, load screen, logo, etc.)


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

## Set Paing

### Game Logic
- Organized the project using the "mirrored" directory structure. Scenes live in the `scenes` folder, scripts in the `scripts` folder, and both follow the same layout for clarity.
- Built a UI stack manager that controls the order of opening and closing windows (e.g., handling ESC/back actions). It tracks all active UI and sets the foundation for the heavier menu interactions in the game.
- Moved all UI elements out of the main `world` scene into separate scenes like `hud` for cleaner integration.
- Updated UI nodes to be fully responsive across different aspect ratios, on both windowed and fullscreen modes.
- Implemented the Main Menu scene.
- Designed the data flow between major systems such as `game_manager`, `resource_manager`, `building_manager`, etc.
- Implemented the "building popup" window on the bottom-left corner and set up the data flow between buildings and the UI.
- Defined the execution order of building logic at end-of-turn (e.g., power plants generate electricity before anything consumes it).
- Added building upgrade functionality.

### Game Feel
- Improved the readability of the top-left resource bar.
- Implemented the max population and electricity cap mechanics.
- Fixed the issue where buildings could be placed under invalid conditions (lack of required resource, out of bound placements, etc).
- Cleaned up and streamlined signaling between systems.
---

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
<u>Sprites</u>  
placeholders:  
<i></i> by Kapila Mhaiskar  
<i></i> by Kapila Mhaiskar  
<i></i> by Kapila Mhaiskar  
<i></i> by Kapila Mhaiskar  
<i></i> by Kapila Mhaiskar  
<i></i> by Kapila Mhaiskar  
<i></i> by Kapila Mhaiskar  
<i></i> by Kapila Mhaiskar  
<i></i> by Kapila Mhaiskar  
<i></i> by Kapila Mhaiskar  

<i>Moon Logo<i> by Joe Vogel      
<i>Cursor</i> by Joe Vogel  
<i>Resource icons</i> by Joe Vogel  
