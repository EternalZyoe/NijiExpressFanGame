extends Node2D

func getClosestNode2DToMouseInArray(input: Array):
	var closestIndex = -1
	var closestDistance = 10000000000
	
	for i in range(input.size()):
		var node2D: Node2D = input[i]
		
		var distance: float = node2D.position.distance_to(get_global_mouse_position())
		
		if distance < closestDistance:
			closestIndex = i
			closestDistance = distance
	
	if closestIndex == -1:
		return null
	
	return input[closestIndex]
