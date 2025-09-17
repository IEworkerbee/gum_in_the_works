extends Resource

class_name Inventory

@export var data: Array[Inv_Item]
@export var counts: Array[int]

# This ready acts as an intializer I need to call, because init runs
# before export data, and there is no _ready func in resource
func ready():
	counts.resize(data.size())

# 1 = Success | -1 = Failure
func add_item(item : Inv_Item) -> int:
	var index: int = data.find(item)
	if index == -1:
		index = data.find(null)
		data[index] = item
		counts[index] = 1
		print(counts[index])
		return 1
	else:
		counts[index] += 1
		print(counts[index])
		return 1
	
		
# 1 = Success | -1 = Failure
func remove_item(item: Inv_Item) -> int:
	var index: int = data.find(item)
	if index == -1:
		return -1
	counts[index] -= 1
	if counts[index] == 0:
		var size: int = data.size()
		data[index] = null
		data = data.filter(func(x): return x != null)
		data.resize(size)
		counts = counts.filter(func(x): return x != 0)
		counts.resize(size)
		print("Out of sugar")	
	else:
		print(counts[index])
	return 1
	
