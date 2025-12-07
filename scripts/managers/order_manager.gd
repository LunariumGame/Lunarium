# global script that enforces a hierarchical z-index ordering constraint
extends Node

# enum order: lowest layer -> topmost layer
enum order {
	BUILDINGS,
	HUD,
	CURSOR,
	MAIN_MENU,
	SETTINGS
}
