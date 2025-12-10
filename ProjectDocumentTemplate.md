# Lunarium #

## Summary ##

In Lunarium, you are a lone astronaut sent on a daring mission to establish the first colony on the moon.

The planet you call home grows increasingly crowded, and humanity needs a backup plan. In this strategy resource management game, you are tasked with mining for ores, cultivating food, and powering your growing colony as more civilians of Planet Earth are shipped offworld. In your quest to tame this barren rock, you can’t be everywhere at once.

Luckily, you’ve been equipped with LunaBots, which you can control from the many terminals in your lunar headquarters to manage the colony from a central location. Earth Command has tasked you with building quickly, so to boost resource acquisition, LunaBots have been equipped with advanced building techniques to get the colony up-and-running in about 10 minutes! Carefully manage your power grid, achieve a surplus of food for your growing colony, and triage whatever setbacks the hazardous environment of the moon throws at you! Become the first to achieve a stable, populous colony on the moon by meeting Earth Command’s population threshold!

## Project Resources

[Web-playable version of your game.](https://itch.io/)  
[Trailor](https://youtube.com)  
[Press Kit](https://dopresskit.com/)  
[Proposal: make your own copy of the linked doc.](https://docs.google.com/document/d/1qwWCpMwKJGOLQ-rRJt8G8zisCa2XHFhv6zSWars0eWM/edit?usp=sharing)  

## Gameplay Explanation ##

**In this section, explain how the game should be played. Treat this as a manual within a game. Explaining the button mappings and the most optimal gameplay strategy is encouraged.**


**Add it here if you did work that should be factored into your grade but does not fit easily into the proscribed roles! Please include links to resources and descriptions of game-related material that does not fit into roles here.**

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
