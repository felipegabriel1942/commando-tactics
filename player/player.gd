extends Node2D
class_name Player

@onready var area_2d: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var occupied_cells: Array[Vector2i] = []
var is_moving := false

func move(path: Array[Vector2], tile_map: TileMapLayer) -> void:
	if path.is_empty() or is_moving:
		return
	
	var current_position := path[0]
	
	is_moving = true
	
	for i in range(1, path.size()):
		var target_position = path[i]
		
		_update_movement_animation(current_position, target_position)

		await _move_to(target_position)
		
		current_position = target_position

	animated_sprite_2d.play("idle_side")
	is_moving = false
	
	occupied_cells.clear()
	occupied_cells.append_array(GridUtils.get_occupied_cells(area_2d, tile_map))

func _update_movement_animation(
	from: Vector2,
	to: Vector2
) -> void:
	var direction := (to - from).normalized()

	# Horizontal
	if abs(direction.x) > 0.0:
		animated_sprite_2d.flip_h = direction.x < 0
		animated_sprite_2d.play("move_side")
		return

	# Vertical
	if direction.y < 0:
		animated_sprite_2d.play("move_up")
	else:
		animated_sprite_2d.play("move_down")

func _move_to(target_position: Vector2) -> void:
	var tween = create_tween()
		
	tween.tween_property(
		self,
		"global_position",
		Vector2(target_position.x - 8, target_position.y - 24),
		0.15
	)
			
	await tween.finished

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		occupied_cells.append_array(GridUtils.get_occupied_cells(area_2d, body))
		GlobalEvents.player_spawned.emit(self)
