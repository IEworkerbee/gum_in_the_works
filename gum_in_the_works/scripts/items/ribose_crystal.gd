extends Node2D

@export var sugar_crystal_resource: Inv_Item
@export var inventory: Inventory

var priority: int = 0

func interact():
	inventory.add_item(sugar_crystal_resource)
	queue_free()
