@tool
class_name CvdDock
extends ItemList

signal cvd_filter_selected(value:CvdSimulator.Filter)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear()
	for filter:String in CvdSimulator.Filter.keys():
		add_item(filter.to_pascal_case())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_selected(index: int) -> void:
	cvd_filter_selected.emit(index as CvdSimulator.Filter)
