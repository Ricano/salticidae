extends Node2D

const MAX_LEG_DISTANCE = 230
const MIN_LEG_DISTANCE = 30

const LEG_SCENE_PATH = "res://Leg.tscn"


var leg_scene = preload(LEG_SCENE_PATH)


onready var body = $BodyTop
onready var body_bottom = $BodyBottom

var body_size

var max_speed = 400
var acceleration = 1000
var friction = 0.5
var velocity = Vector2()

var body_rotation_speed = 10.0

signal is_moving
var legs
var legs_position=[[70.7107, 70.7107],
 [-70.7107, 70.7107],
 [-70.7107, -70.7107],
 [70.7107, -70.7107]]

const LEG_MOVE_TIME = 0.1  # Time to wait between leg movements (in seconds)
var time_since_last_leg_move = 0

onready var label = $Node/Label_R


func _ready():
	body_size = $BodyBottom.position.y
	
	for leg_position in legs_position:
		var leg = leg_scene.instance()
		leg.offset = Vector2(leg_position[0], leg_position[1])
		leg.position=leg.offset
		leg.show_behind_parent=true
		add_child(leg)

	legs = get_tree().get_nodes_in_group("legs")
	label.text = str(0)
	


func _process(delta):
	move(delta)
	
	for leg in legs:
		strech_leg(leg)
		
		var distance = leg.global_position.distance_to(body.global_position)
		# Only move legs if enough time has passed since the last move
		if too_far(distance) or too_close(distance) or is_leg_on_wrong_side(leg):
			if time_since_last_leg_move >= LEG_MOVE_TIME:
				leg.global_position = leg.global_position.linear_interpolate((body.global_position + leg.offset),1)
				leg.look_at(body.global_position)
				time_since_last_leg_move = 0
			else:
				time_since_last_leg_move += delta
		
func is_leg_on_wrong_side(leg):
	# if is right leg and it's on the left
	if legs_position[legs.find(leg)][0] > 0 and leg.global_position.x - body.global_position.x < 0:
		return true
	# if is left leg and it's on the right
	elif legs_position[legs.find(leg)][0] < 0 and body.global_position.x - leg.global_position.x < 0:
		return true
	# if is top leg and it's below
	elif legs_position[legs.find(leg)][1] > 0 and leg.global_position.y - body.global_position.y < 0:
		return true
		# if is bottom leg and it's on top
	elif legs_position[legs.find(leg)][1] < 0 and body.global_position.y - leg.global_position.y < 0:
		return true
	return false

func too_close(dist):
	return dist < MIN_LEG_DISTANCE

func too_far(dist):
	return dist > MAX_LEG_DISTANCE
	


func strech_leg(leg):
	leg.look_at(body.global_position)
	var distance = leg.global_position.distance_to(body.global_position)
	var bones = leg.get_children()
	for i in len(bones):
		if bones[i].name=="Sprite":
			continue
		bones[i].position.x = 20 + distance/5 * i 
	

func move(delta):
	var input_vector = get_input()

	velocity = velocity.move_toward(input_vector.normalized() * max_speed, acceleration * delta)

	# apply friction if no input
	if input_vector == Vector2.ZERO:
		velocity *= 1.0 - friction * delta
		
	body.global_position += velocity * delta

	if body_bottom.global_position.distance_to(body.global_position) > body_size:
		body_bottom.global_position = body_bottom.global_position.move_toward(body.global_position, 3)

	body.global_position.x = clamp(body.global_position.x, 0, Globals.screen_size.x)
	body.global_position.y = clamp(body.global_position.y, 0, Globals.screen_size.y)

	# Rotate towards the input direction
	if input_vector != Vector2.ZERO:
		var target_rotation = input_vector.angle()
		var rotation_difference = target_rotation - body.rotation
		var shortest_rotation = fmod((rotation_difference + PI), TAU) - PI
		body.rotation += shortest_rotation * delta * body_rotation_speed
		emit_signal("is_moving")


func get_input():
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
	return input_vector
