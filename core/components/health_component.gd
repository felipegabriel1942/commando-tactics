extends Node
class_name HealthComponent

@export var data: CharacterData

signal died()

var current_health: int

func _ready() -> void:
	current_health = data.health

func take_damage(damage: int) -> void:
	current_health -= damage
	
	if current_health <= 0:
		died.emit()
