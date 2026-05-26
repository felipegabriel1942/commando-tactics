extends Node2D
class_name Enemy

@export var data: CharacterData

@onready var area_2d: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent

var occupied_cells: Array[Vector2i] = []

func take_damage() -> void:
	for i in range(2):
		animated_sprite_2d.material.set_shader_parameter("active", true)
	
		await get_tree().create_timer(0.1).timeout
	
		animated_sprite_2d.material.set_shader_parameter("active", false)
		
		await get_tree().create_timer(0.1).timeout
	
	health_component.take_damage(1)
	
func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		occupied_cells.append_array(GridUtils.get_occupied_cells(area_2d, body))
		GlobalEvents.enemy_spawned.emit(self)

func _on_died() -> void:
	GlobalEvents.enemy_died.emit(self)
	queue_free()
