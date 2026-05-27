extends Node2D
class_name WorldObject

@export var data: ObjectData

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

const NORMAL_ALPHA := 1.0
const FADE_ALPHA := 0.4

var occupied_cells: Array[Vector2i] = []
var units_inside :=0
var fade_tween: Tween

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		occupied_cells.append_array(GridUtils.get_occupied_cells(area_2d, body))
		GlobalEvents.object_spawned.emit(self)

func _on_fade_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player or area.get_parent() is Enemy:
		units_inside += 1
		
		if units_inside == 1:
			set_alpha(FADE_ALPHA)

func _on_fade_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player or area.get_parent() is Enemy:
		units_inside -= 1
		
		if units_inside <= 0:
			units_inside = 0
			set_alpha(NORMAL_ALPHA) 

func set_alpha(alpha: float) -> void:
	if fade_tween:
		fade_tween.kill()
	
	fade_tween = create_tween()
	
	fade_tween.tween_property(
		sprite_2d,
		"modulate:a",
		alpha,
		0.15
	)
