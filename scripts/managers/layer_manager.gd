# global script that enforces a hierarchical ordering constraint for CanvasLayer nodes
extends Node

# enum order: lower layer -> top layer
enum order {
	BUILDINGS,
	CURSOR,
	HUD,
	SETTINGS,
	MAIN_MENU
}
