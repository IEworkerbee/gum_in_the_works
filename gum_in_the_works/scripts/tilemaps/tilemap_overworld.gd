extends TileMapLayer

func place_tile_smart(coordinate: Vector2i, atlas_id: int, is_first: bool = true):
	# Places a tile in a specific layer, and updates terrain around to fit styling.
	var surrounding_cells = self.get_surrounding_cells(coordinate)
	var surrounding_non_cells_placable = surrounding_cells.filter(filter_cells.bind(atlas_id))
	var surrounding_true_cells = surrounding_cells.filter(filter_non_cells.bind(atlas_id))
	var directions: Array = surrounding_non_cells_placable.map(vector_to_direction.bind(coordinate))
	_set_tile(directions, atlas_id, coordinate)
	if is_first:
		for coord in surrounding_true_cells:
			place_tile_smart(coord, atlas_id, false)

func _set_tile(directions: Array, tile_set_index: int, map_coords: Vector2i):
	var x: int
	var y: int
	
	# get atlas and its dimensions
	var dimension = self.tile_set.get_source(tile_set_index).get_atlas_grid_size()
	
	var total = (8 * int(directions.has("top"))) + (4 * int(directions.has("bottom"))) + (2 * int(directions.has("left"))) + int(directions.has("right"))
	print(total)
	x = total % dimension.y
	y = ceil(total / dimension.x)
	
	var coordinate: Vector2i = Vector2i(x, y)
	
	self.set_cell(map_coords, tile_set_index, coordinate)

func filter_cells(a: Vector2i, b: int) -> bool:
	return self.get_cell_source_id(a) != b
	
func filter_non_cells(a: Vector2i, b: int) -> bool:
	return self.get_cell_source_id(a) == b
	
func vector_to_direction(a: Vector2i, o: Vector2i) -> String:
	var vect_d: Vector2i = o - a
	var direction: String
	if vect_d == Vector2i(0, 1):
		direction = "top"
	elif vect_d == Vector2i(0, -1):
		direction = "bottom"
	elif vect_d == Vector2i(-1, 0):
		direction = "right"
	else:
		direction = "left"
	return direction
