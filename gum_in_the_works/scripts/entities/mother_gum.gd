extends StaticBody2D

@export var ribose_crystal: Inv_Item
@export var inventory: Inventory
@export var tile_map: TileMapLayer

var priority: int = 2
var perimeter_coords: Array[Vector2i] = [Vector2i(0, -1)]

func interact():
	var success = inventory.remove_item(ribose_crystal)
	if success == 1:
		expand()

func expand() -> int:
	# 0 = No place to put tile | 1 = Placed a tile succesfully
	if perimeter_coords.size() == 0:
		# No possible tile can be placed
		return 0

	var choice = perimeter_coords.pick_random()
	var surrounding_cells = tile_map.get_surrounding_cells(choice)
	var surrounding_non_cells_placeable = surrounding_cells.filter(tile_map.filter_texture_cells_placeable.bind(Vector2i(1,0)).bind(1))
	var coord_to_pick = surrounding_non_cells_placeable.pick_random()
	tile_map.place_tile_smart(coord_to_pick, 2)
	
	if tile_map.get_surrounding_cells(coord_to_pick).filter(tile_map.filter_texture_cells_placeable.bind(Vector2i(1,0)).bind(1)).size() > 0:
		# If any neighbors are placeable tiles, add this coordinate to perimeter_coords
		perimeter_coords.append(coord_to_pick)
	for coord in tile_map.get_surrounding_cells(coord_to_pick).filter(tile_map.filter_non_texture_cells.bind(2)):
		# For coords in neighbors with texture 
		if tile_map.get_surrounding_cells(coord).filter(tile_map.filter_texture_cells_placeable.bind(Vector2i(1,0)).bind(1)).size() == 0:
			# If coord has no placeable neighbors, remove it from perimeter
			perimeter_coords.erase(coord)
	if surrounding_non_cells_placeable.size() == 1:
		# If no neighbors of original pick are placeble tiles, remove choice from perimeter 
		perimeter_coords.erase(choice)
	return 1
	
