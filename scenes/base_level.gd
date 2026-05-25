extends Node2D
class_name BaseLevel

@onready var player: Player = $YSortRoot/Player
@onready var grid_manager: GridManager = $GridManager
@onready var ground_map_layer: TileMapLayer = $YSortRoot/RootMapLayer/GroundMapLayer

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		
		var movable_cells = grid_manager.get_movable_cells(player.area_2d.get_child(0).global_position, 4)
		var path = grid_manager.get_path_to_position(player.area_2d.get_child(0).global_position, get_global_mouse_position())
				
		if !path.is_empty():
			for cell in player.occupied_cells:
				grid_manager.free_cell(cell)
			
			await player.move(path, ground_map_layer)
			
			for cell in player.occupied_cells:
				grid_manager.occupy_cell(player, cell)

		handle_player_turn()
		
func handle_player_turn() -> void:
	pass
