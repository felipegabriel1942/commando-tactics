extends Node
class_name GridUtils

static func get_occupied_cells(area: Area2D, tile_map_layer: TileMapLayer) -> Array[Vector2i]:
	var occupied_cells: Array[Vector2i] = []
	
	var collision := area.get_node("CollisionShape2D")
		
	if collision.shape is RectangleShape2D:
		var shape := collision.shape as RectangleShape2D

		# Retângulo global da colisão
		var global_rect = Rect2(
			collision.global_position - (shape.size / 2.0),
			shape.size
		)

		# Tiles inicial/final
		var start_cell = tile_map_layer.local_to_map(
			tile_map_layer.to_local(global_rect.position)
		)

		var end_cell = tile_map_layer.local_to_map(
			tile_map_layer.to_local(global_rect.end)
		)

		for x in range(start_cell.x, end_cell.x + 1):
			for y in range(start_cell.y, end_cell.y + 1):

				var cell = Vector2i(x, y)

				# Retângulo do tile no mundo
				var tile_local_pos = tile_map_layer.map_to_local(cell)
				var tile_world_pos = tile_map_layer.to_global(tile_local_pos)

				var tile_rect = Rect2(
					tile_world_pos,
					tile_map_layer.tile_set.tile_size
				)

				# Só adiciona se realmente intersectar
				if global_rect.intersects(tile_rect):
					occupied_cells.append(cell)

	return occupied_cells
