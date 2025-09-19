extends StaticBody2D

@onready var ribose_crystal: Inv_Item = preload("res://resources/items/ribose_crystal.tres")
@onready var inventory: Inventory = preload("res://resources/mc_resources/inventory.tres")

@onready var tile_map: TileMapLayer = $"../TileMapLayer"
@onready var tm_position = tile_map.local_to_map(tile_map.to_local(self.global_position))
@onready var perimeter_coords: Array[Vector2i] = [tm_position]
@onready var all_coords: Array[Vector2i] = []

var scene_weeping_sugarbell = preload("res://scenes/entities/plants/weeping_sugarbells.tscn")
var priority: int = 2
var planted: Array[bool] = []
var processing_sig: bool = true
var random_num: float

func _process(_delta: float):
	if processing_sig and all_coords.size() > 0:
		_plant()

func interact():
	var success = inventory.remove_item(ribose_crystal)
	if success == 1:
		expand()

func expand() -> int:
	var distance_from_center: int = 3
	# 0 = No place to put tile | 1 = Placed a tile succesfully
	if perimeter_coords.size() == 0:
		# No possible tile can be placed
		return 0

	var choice = perimeter_coords.pick_random()
	var surrounding_cells = tile_map.get_surrounding_cells(choice)
	var surrounding_non_cells_placeable = surrounding_cells.filter(tile_map.filter_texture_cells_placeable.bind(distance_from_center).bind(tm_position).bind(Vector2i(1,0)).bind(1))
	var coord_to_pick = surrounding_non_cells_placeable.pick_random()
	tile_map.place_tile_smart(coord_to_pick, 2)
	
	all_coords.append(coord_to_pick)
	planted.append(false)
	
	if tile_map.get_surrounding_cells(coord_to_pick).filter(tile_map.filter_texture_cells_placeable.bind(distance_from_center).bind(tm_position).bind(Vector2i(1,0)).bind(1)).size() > 0:
		# If any neighbors are placeable tiles, add this coordinate to perimeter_coords
		perimeter_coords.append(coord_to_pick)
	for coord in tile_map.get_surrounding_cells(coord_to_pick).filter(tile_map.filter_non_texture_cells.bind(2)):
		# For coords in neighbors with texture 
		if tile_map.get_surrounding_cells(coord).filter(tile_map.filter_texture_cells_placeable.bind(distance_from_center).bind(tm_position).bind(Vector2i(1,0)).bind(1)).size() == 0:
			# If coord has no placeable neighbors, remove it from perimeter
			perimeter_coords.erase(coord)
	if surrounding_non_cells_placeable.size() == 1:
		# If no neighbors of original pick are placeble tiles, remove choice from perimeter 
		perimeter_coords.erase(choice)
	return 1
	
func _plant() -> int:
	processing_sig = false
	randomize()
	random_num = randf_range(5, 10)
	await get_tree().create_timer(random_num).timeout
	var choice: Vector2i = all_coords.pick_random()
	var choice_idx: int = all_coords.find(choice)
	if planted[choice_idx]:
		processing_sig = true
		return 0
	var weeping_instance = scene_weeping_sugarbell.instantiate()
	var pos: Vector2 = tile_map.map_to_local(choice)
	pos.y += 16
	weeping_instance.position = pos - self.global_position
	weeping_instance.y_sort_enabled = true
	add_child(weeping_instance)
	planted[choice_idx] = true
	processing_sig = true
	return 1
	 
	
