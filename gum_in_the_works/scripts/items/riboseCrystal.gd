extends Node2D

@onready var sugar_crystal_resource: Inv_Item = load("res://resources/items/ribose_crystal.tres")
@onready var inventory: Inventory = load("res://resources/mc_resources/inventory.tres")

var priority: int = 0

func interact():
	inventory.add_item(sugar_crystal_resource)
	queue_free()
