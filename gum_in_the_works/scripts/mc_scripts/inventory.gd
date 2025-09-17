extends Resource

class_name Inventory

@export var data: Array[Inv_Item]
@export var counts: Array[int]

# This ready acts as an intializer I need to call, because init runs
# before export data, and there is no _ready func in resource
func ready():
	counts.resize(data.size())

func add_item(item : Inv_Item):
	var index: int = data.find(item)
	if index == -1:
		index = data.find(null)
		data[index] = item
		counts[index] = 1
	else:
		counts[index] += 1
	print(counts[index])
		
		
	
