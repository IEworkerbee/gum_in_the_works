extends TileMapLayer

func place_tile_smart(coordinate: Vector2i, atlas_id: int, is_first: bool = true):
	# Places a tile in a specific layer, and updates terrain around to fit styling.
	var surrounding_cells = self.get_surrounding_cells(coordinate)
	var surrounding_non_texture_cells = surrounding_cells.filter(filter_texture_cells.bind(atlas_id))
	var surrounding_texture_cells = surrounding_cells.filter(filter_non_texture_cells.bind(atlas_id))
	var directions: Array = surrounding_non_texture_cells.map(vector_to_direction.bind(coordinate))
	
	_set_tile(directions, atlas_id, coordinate)
	if is_first:
		# update neighbors
		for coord in surrounding_texture_cells:
			place_tile_smart(coord, atlas_id, false)

func _set_tile(directions: Array, tile_set_index: int, map_coords: Vector2i):
	# updates tile at coordinate with given input directions for connective sides
	var x: int
	var y: int
	
	# get atlas and its dimensions
	var dimension = self.tile_set.get_source(tile_set_index).get_atlas_grid_size()
	
	var total = (8 * int(directions.has("top"))) + (4 * int(directions.has("bottom"))) + (2 * int(directions.has("left"))) + int(directions.has("right"))
	x = total % dimension.y
	y = ceil(total / dimension.x)
	
	var coordinate: Vector2i = Vector2i(x, y)
	
	self.set_cell(map_coords, tile_set_index, coordinate)

func filter_texture_cells(coord: Vector2i, atlas_id: int) -> bool:
	# Returns if coordinate is not in specified atlas 
	return self.get_cell_source_id(coord) != atlas_id
	
func filter_non_texture_cells(coord: Vector2i, atlas_id: int) -> bool:
	return self.get_cell_source_id(coord) == atlas_id
	
func filter_texture_cells_placeable(coord: Vector2i, atlas_id: int, coord_of_placeable: Vector2i, center: Vector2i, distance_from_center: int) -> bool:
	var within: bool = false
	if abs(coord.x - center.x) + abs(coord.y - center.y) <= distance_from_center:
		within = true
	return self.get_cell_source_id(coord) == atlas_id and self.get_cell_atlas_coords(coord) == coord_of_placeable and within

func vector_to_direction(adjacent_coord: Vector2i, original_coord: Vector2i) -> String:
	var vect_d: Vector2i = original_coord - adjacent_coord
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
