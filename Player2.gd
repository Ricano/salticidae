extends Node2D


const MAX_LEG_DISTANCE = 230
const MIN_LEG_DISTANCE = 30


onready var body = $BodyTop
onready var body_bottom = $BodyBottom

var body_size

var max_speed = 400.0
var acceleration = 1000.0
var friction = 0.5
var body_rotation_speed = 10.0

var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	body_size = $BodyBottom.position.y
	
	$Leg2.global_position = body.global_position


func _process(delta):
	if move(delta):
		$Leg2.global_position = body.global_position
func too_close(dist):
	return dist < MIN_LEG_DISTANCE

func too_far(dist):
	return dist > MAX_LEG_DISTANCE
	


func move(delta):
	var input_vector = get_input()

	velocity = velocity.move_toward(input_vector.normalized() * max_speed, acceleration * delta)

	# apply friction
	velocity *= 1.0 - friction * delta

	body.global_position += velocity * delta

	if body_bottom.global_position.distance_to(body.global_position) > body_size:
		body_bottom.global_position = body_bottom.global_position.move_toward(body.global_position, 3)

	body.global_position.x = clamp(body.global_position.x, 0, Globals.screen_size.x)
	body.global_position.y = clamp(body.global_position.y, 0, Globals.screen_size.y)

	# Rotate towards the input direction
	if input_vector != Vector2():
		var target_rotation = input_vector.angle()
		var rotation_difference = target_rotation - body.rotation
		var shortest_rotation = fmod((rotation_difference + PI), TAU) - PI
		body.rotation += shortest_rotation * delta * body_rotation_speed
	if velocity.length() > 0:
		return true
	return false



func get_input():
	var input_vector = Vector2()
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
	return input_vector
