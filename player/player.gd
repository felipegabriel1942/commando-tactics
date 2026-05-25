extends Node2D
class_name Player

const SHOOT_ANIMATIONS := {
	FacingDirectionEnum.FacingDirection.UP: "shoot_up",
	FacingDirectionEnum.FacingDirection.UP_RIGHT: "shoot_diagonal_up",
	FacingDirectionEnum.FacingDirection.RIGHT: "shoot_side",
	FacingDirectionEnum.FacingDirection.DOWN_RIGHT: "shoot_diagonal_down",
	FacingDirectionEnum.FacingDirection.DOWN: "shoot_down",
	FacingDirectionEnum.FacingDirection.DOWN_LEFT: "shoot_diagonal_down",
	FacingDirectionEnum.FacingDirection.LEFT: "shoot_side",
	FacingDirectionEnum.FacingDirection.UP_LEFT: "shoot_diagonal_up",
}

const MUZZLE_POSITIONS := {
	FacingDirectionEnum.FacingDirection.UP: Vector2(13, 7),
	FacingDirectionEnum.FacingDirection.UP_RIGHT: Vector2(16, 7),
	FacingDirectionEnum.FacingDirection.RIGHT: Vector2(16, 12),
	FacingDirectionEnum.FacingDirection.DOWN_RIGHT: Vector2(13, 21),
	FacingDirectionEnum.FacingDirection.DOWN: Vector2(3, 21),
	FacingDirectionEnum.FacingDirection.DOWN_LEFT: Vector2(3, 21),
	FacingDirectionEnum.FacingDirection.LEFT: Vector2(0, 12),
	FacingDirectionEnum.FacingDirection.UP_LEFT: Vector2(0, 7),
}

const BURST_COUNT := 3
const BURST_DELAY := 0.15

@onready var area_2d: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var muzzle: Marker2D = $Muzzle

var occupied_cells: Array[Vector2i] = []
var is_moving := false
var is_shooting := false
var facing_direction := FacingDirectionEnum.FacingDirection.RIGHT

const PLAYER_WEAPON_BULLET = preload("uid://bj1m0sc6ca5nx")

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
	
	#Recalculando celulas ocupadas após se mover
	occupied_cells.clear()
	occupied_cells.append_array(GridUtils.get_occupied_cells(area_2d, tile_map))
	
	is_moving = false

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
	
func shoot(target: Enemy) -> void:
	if is_shooting:
		return
	
	is_shooting = true
	
	var direction := _get_direction_to_target(target)
	facing_direction = _get_facing_direction(Vector2(round(direction.x), round(direction.y)))
	
	muzzle.position = MUZZLE_POSITIONS[facing_direction]
	
	# calcular se acertou ou não aqui
	var hit := true
	
	_update_attack_visuals()
	
	await _fire_burst(target, hit)
	
	if hit:
		target.take_damage()
	
	is_shooting = false
	
func _update_attack_visuals() -> void:
	animated_sprite_2d.flip_h = _should_flip()
	animated_sprite_2d.play(SHOOT_ANIMATIONS[facing_direction])

func _should_flip() -> bool:
	return facing_direction in [
		FacingDirectionEnum.FacingDirection.LEFT,
		FacingDirectionEnum.FacingDirection.UP_LEFT,
		FacingDirectionEnum.FacingDirection.DOWN_LEFT
	]
	
func _get_direction_to_target(target: Enemy) -> Vector2:
	var direction := (
		target.global_position - global_position
	)
	
	return Vector2(direction).normalized()

func _get_facing_direction(direction: Vector2) -> FacingDirectionEnum.FacingDirection:
	return FacingDirectionEnum.FACING_DIRECTION_MAP[direction]

func _fire_burst(target: Enemy, hit: bool) -> void:
	for i in BURST_COUNT:
		_spawn_bullet(target, hit)
		
		if i < BURST_COUNT - 1:
			await get_tree().create_timer(BURST_DELAY).timeout

func _spawn_bullet(target: Enemy, hit: bool) -> void:
	var bullet = PLAYER_WEAPON_BULLET.instantiate()

	bullet.global_position = muzzle.global_position 
	bullet.direction = _get_direction_to_target(target)
	bullet.target = target
	bullet.hit = hit

	get_tree().current_scene.add_child(bullet)

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		occupied_cells.append_array(GridUtils.get_occupied_cells(area_2d, body))
		GlobalEvents.player_spawned.emit(self)
