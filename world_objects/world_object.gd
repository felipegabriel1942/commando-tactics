extends Node2D
class_name WorldObject

@onready var area_2d: Area2D = $Area2D

var occupied_cells: Array[Vector2i] = []

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		occupied_cells.append_array(GridUtils.get_occupied_cells(area_2d, body))
		GlobalEvents.object_spawned.emit(self)
