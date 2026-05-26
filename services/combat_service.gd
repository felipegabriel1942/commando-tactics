extends RefCounted
class_name CombatService

var grid_manager: GridManager

func _init(grid_manager_ref: GridManager) -> void:
	grid_manager = grid_manager_ref

func attack(attacker, target) -> void:
	if attacker.is_shooting:
		return
	
	attacker.is_shooting = true
	
	var direction := _get_direction_to_target(attacker, target)
	
	attacker.update_visuals(direction)

	# calcular se acertou ou não aqui
	var dit_hit := roll_dice() <= hit_chance(attacker, target)
		
	await attacker.fire_burst(target, dit_hit)
	
	if dit_hit:
		target.take_damage()
	
	attacker.is_shooting = false

func _get_direction_to_target(attacker: Node2D, target: Node2D) -> Vector2:
	var direction := (
		target.global_position - attacker.global_position
	)
	
	return Vector2(direction).normalized()

func get_attack_direction(
	attacker: Vector2i,
	target: Vector2i
) -> Vector2i:
	var delta = target - attacker
	
	if abs(delta.x) > abs(delta.y):
		return Vector2i(sign(delta.x), 0)
	
	return Vector2i(0, sign(delta.y))
	
# Mover depois para um serviço/manager
func roll_dice() -> int:
	return randi_range(1, 100)
	
func hit_chance(attacker, target) -> int:
	var attacker_accuracy = 95
	var target_evasion = 5
	var cover_bonus = get_cover_bonus(attacker.occupied_cells.get(0), target.occupied_cells.get(0))
	
	return clamp(attacker_accuracy - (target_evasion + cover_bonus), 5, 95)
	
func get_cover_bonus(
	attacker_cell: Vector2i,
	target_cell: Vector2i
) -> int:
	
	var direction = get_attack_direction(
		attacker_cell, 
		target_cell
	)
	
	var cover_cell = target_cell - direction
	
	var cover = grid_manager.get_object_at_cell(cover_cell)
	
	if cover == null:
		return 0
	
	match cover.data.cover_type:
		CoverTypeEnum.CoverType.HALF:
			return 40
		
		CoverTypeEnum.CoverType.FULL:
			return 80
	
	return 0
