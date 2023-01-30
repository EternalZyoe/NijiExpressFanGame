extends Spatial

var time: float = 0.0

func _process(delta):
	time += delta
	
	$Camera.rotation_degrees.x = (sin(time*0.7) + 1.0) * 0.5 * 0.3
	$Camera.rotation_degrees.y = (sin(time*1.1) + 1.0) * 0.5 * 0.3
