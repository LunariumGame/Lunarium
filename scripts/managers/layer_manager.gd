# global script that enforces a hierarchical ordering constraint for CanvasLayer nodes
extends Node

# enum order: lowest layer -> topmost layer
enum order {
	BUILDINGS,
	HUD,
	CURSOR,
	MAIN_MENU,
	SETTINGS
}
