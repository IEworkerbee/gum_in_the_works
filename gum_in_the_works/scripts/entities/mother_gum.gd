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
	#tile_map.set_tile(false, false, false, false, 2, Vector2i(0,0))
	var choice = perimeter_coords.pick_random()
	var surrounding_cells = tile_map.get_surrounding_cells(choice)
	var surrounding_non_cells = surrounding_cells.filter(tile_map.filter_cells.bind(2))
	var coord_to_pick = surrounding_non_cells.pick_random()
	tile_map.place_tile_smart(coord_to_pick, 2)
	perimeter_coords.append(coord_to_pick)
	
	if surrounding_non_cells.size() == 1:
		perimeter_coords.erase(choice)
	return 1
	
