extends Node2D

func _ready():
	CarriageArray.append_array(get_children())
	
	CarriageArrangementArray = range(CarriageArray.size())
	
	setupMovementNoise()

func _process(delta):
	updateNoiseTimes()
	
	arrangeCarriages()
	
	checkCarriageSelection()
	
	if Input.is_action_just_pressed("moveCarLeft"):
		shiftSelectedCarriagePosition(1)
	if Input.is_action_just_pressed("moveCarRight"):
		shiftSelectedCarriagePosition(-1)

var CarriageArray = []
var CarriageArrangementArray
var carriage_separation_distance = 72

func arrangeCarriages():
	var frontCarriage = null
	
	for i in range(CarriageArray.size()):
		var carriage = CarriageArray[i]
		
		var arrangement = CarriageArrangementArray[i]
		
		var targetPosition = Vector2.LEFT * carriage_separation_distance * arrangement + getTargetPosOffset(arrangement * 0.6)
		
		carriage.position = lerp(carriage.position, targetPosition, 0.1)
		carriage.rotation = lerp(carriage.rotation, getRotationOffset(arrangement * 0.6), 0.1)

#Shifting Carriages
var selectedCarriage = 0

func checkCarriageSelection():
	for i in range(CarriageArray.size()):
		var keyName = "selectCar" + str(i)
		
		if Input.is_action_just_pressed(keyName):
			selectedCarriage = i
			
			print(selectedCarriage)

func shiftSelectedCarriagePosition(direction: int):
	var initialArrangement = CarriageArrangementArray[selectedCarriage]
	
	var newArrangement
	
	newArrangement = initialArrangement + direction
	
	if newArrangement == CarriageArray.size() or newArrangement < 0:
		return
	
	var indexOfNewArrangement = CarriageArrangementArray.find(newArrangement)
	
	CarriageArrangementArray[selectedCarriage] = newArrangement
	CarriageArrangementArray[indexOfNewArrangement] = initialArrangement

#Noise for complex train movement
var noise: OpenSimplexNoise
var noiseTime: float = 0.0

var VerticalBumpinessCoeff = 5
var HorizontalBumpinessCoeff = 5
var RotationBumpinessCoeff = 2

func setupMovementNoise():
	noise = OpenSimplexNoise.new()
	noise.octaves = 2
	noise.period = 0.4

func updateNoiseTimes():
	noiseTime += get_process_delta_time()

func getTargetPosOffset(offset: float):
	var verticalBumpiness = noise.get_noise_2d(0, noiseTime + offset) * VerticalBumpinessCoeff
	var horizontalBumpiness = noise.get_noise_2d(10, noiseTime + offset) * HorizontalBumpinessCoeff
	
	return Vector2(horizontalBumpiness, verticalBumpiness)

func getRotationOffset(offset: float):
	var rotationBumpiness = noise.get_noise_2d(20, noiseTime + offset) * RotationBumpinessCoeff
	return deg2rad(rotationBumpiness)
