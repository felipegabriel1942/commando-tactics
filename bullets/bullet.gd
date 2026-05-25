extends Node2D
class_name Bullet

@export var speed := 300

@onready var area_2d: Area2D = $Area2D

var direction := Vector2.ZERO
var target: Variant
var board_map: TileMapLayer
var hit := true

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	
	if board_map != null:
		var occupied_cells = GridUtils.get_occupied_cells(area_2d, board_map)
		
		if hit and !occupied_cells.is_empty():
			for cell in occupied_cells:
				if target.occupied_cells.has(cell):
					queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		board_map = body
