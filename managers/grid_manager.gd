extends Node
class_name GridManager

@export var tile_map_layer: TileMapLayer
@export var world_ojects: Node2D
@export var debug := false

var grid: AStarGrid2D
var tile_size: int = 16
var occupied_cells := {}

func _ready() -> void:
	grid = AStarGrid2D.new()
	grid.region = tile_map_layer.get_child(0).get_used_rect()
	grid.cell_size = Vector2i(tile_size, tile_size)
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS
	grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	grid.update()
	
	GlobalEvents.object_spawned.connect(on_object_spawned)
	GlobalEvents.player_spawned.connect(on_player_spawned)
	GlobalEvents.enemy_spawned.connect(on_enemy_spawned)
	
func on_object_spawned(object: WorldObject) -> void:
	for cell in object.occupied_cells:
		grid.set_point_solid(cell, false)
		grid.update()
		occupied_cells[cell] = object
				
		if debug:
			highlight_cell(map_to_local(cell), Color(1, 0, 1, 0.5))

func on_player_spawned(player: Player) -> void:
	for cell in player.occupied_cells:
		occupied_cells[cell] = player
		
		if debug:
			highlight_cell(map_to_local(cell), Color(1, 0, 1, 0.5))

func on_enemy_spawned(enemy: Enemy) -> void:
	for cell in enemy.occupied_cells:
		occupied_cells[cell] = enemy
		
		if debug:
			highlight_cell(map_to_local(cell), Color(1, 0, 1, 0.5))

func get_movable_cells(current_pos: Vector2, range: int) -> Array[Vector2]:
	var movable_cells: Array[Vector2i] = []
	var start_cell: Vector2i = local_to_map(current_pos)
	var visited := {}
	var frontier: Array[Dictionary] = [
		{
			"cell": start_cell,
			"distance": 0
		}
	]
	visited[start_cell] = true
	
	while frontier.size() > 0:
		var current_data = frontier.pop_front()
		var current: Vector2i = current_data["cell"]
		var distance: int = current_data["distance"]
		
		# Se chegou no limite do range, não continua expandindo
		if distance >= range:
			continue
		
		for neighbor in get_neighbors(current):
			if not grid.region.has_point(neighbor):
				continue
				
			if grid.is_point_solid(neighbor):
				continue
		
			if visited.has(neighbor):
				continue
				
			if occupied_cells.has(neighbor):
				continue
			
			visited[neighbor] = true
	
			frontier.append({
				"cell": neighbor,
				"distance": distance + 1
			})
			
			movable_cells.append(neighbor)
			
	var mapped_result: Array[Vector2] = []
	
	for cell in movable_cells:
		var vec2_cell = map_to_local(cell)
		mapped_result.append(vec2_cell)
	
	return mapped_result

func get_path_to_position(current_pos: Vector2, target_pos: Vector2) -> Array[Vector2]:
	var start_cell: Vector2i = local_to_map(current_pos)
	var target_cell: Vector2i = local_to_map(target_pos)
	
	# Guarda de qual célula cada célula veio
	var came_from := {}
	
	var frontier: Array[Vector2i] = [start_cell]
	
	came_from[start_cell] = start_cell
	
	while frontier.size() > 0:
		var current: Vector2i = frontier.pop_front()
		
		# Encontrou o destino
		if current == target_cell:
			break
			
		for neighbor in get_neighbors(current):
			if not grid.region.has_point(neighbor):
				continue
			
			if grid.is_point_solid(neighbor):
				continue
			
			if grid.is_point_solid(neighbor):
				continue
			
			if occupied_cells.has(neighbor):
				continue
				
			if came_from.has(neighbor):
				continue
			
			came_from[neighbor] = current
			frontier.append(neighbor)

	# Não existe caminho
	if not came_from.has(target_cell):
		return []

	# Reconstrói o caminho
	var path: Array[Vector2i] = []

	var current: Vector2i = target_cell

	while current != start_cell:
		path.push_front(current)
		current = came_from[current]

	path.push_front(start_cell)

	# Converte para posição local
	var mapped_path: Array[Vector2] = []

	for cell in path:
		mapped_path.append(
			tile_map_layer.get_child(0).map_to_local(cell)
		)
		
		if debug:
			highlight_cell(map_to_local(cell), Color(0, 0, 1, 0.5))

	return mapped_path

func free_cell(cell: Vector2i) -> void:
	occupied_cells.erase(cell)

func occupy_cell(object: Node2D, cell: Vector2i) -> void:
	occupied_cells[cell] = object

func get_neighbors(cell: Vector2i) -> Array[Vector2i]:
	return [
		cell + Vector2i.RIGHT,
		cell + Vector2i.LEFT,
		cell + Vector2i.UP,
		cell + Vector2i.DOWN
	]

func local_to_map(position: Vector2) -> Vector2i:
	return tile_map_layer.get_child(0).local_to_map(position)
	
func map_to_local(position: Vector2i) -> Vector2:
	return tile_map_layer.get_child(0).map_to_local(position)

func highlight_cell(cell: Vector2, color: Color) -> void:
	var rect = ColorRect.new()
	rect.color = color
	rect.position = Vector2(cell.x - 8, cell.y - 8)
	rect.size = Vector2(16, 16)
	rect.z_index = 0
	rect.y_sort_enabled = true
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.add_to_group("highlighted_cell")
	get_parent().add_child(rect)

func clear_highlighted_cells() -> void:
	var nodes = get_tree().get_nodes_in_group("highlighted_cell")
	
	for node in nodes:
		node.queue_free()
