extends Node2D



const LEG_SCENE_PATH = "res://Leg.tscn"


var leg_scene = preload(LEG_SCENE_PATH)

signal target

onready var body = $Body

var max_speed = 400
var acceleration = 1000
var friction = 0.5
var velocity = Vector2()

var legs
var feet_position=[Vector2(-100,0), Vector2(100, 0), Vector2(0, 100), Vector2(0, -100)]

const LEG_MOVE_TIME = 0.1  # Time to wait between leg movements (in seconds)
var time_since_last_leg_move = 0

onready var label = $Node/Label_R


func _ready():
#	for leg_position in legs_position:
#		var leg = leg_scene.instance()
#		leg.offset = Vector2(leg_position[0], leg_position[1])
#		leg.position=leg.offset
#		add_child(leg)
#
	legs = get_tree().get_nodes_in_group("legs")

	for leg in legs:
		
		#leg.foot.global_position = leg.foot.global_position.linear_interpolate((body.global_position + Vector2(feet_position[legs.find(leg)][0], feet_position[legs.find(leg)][1])),1)
		leg.step(body.global_position + Vector2(feet_position[legs.find(leg)][0], feet_position[legs.find(leg)][1]))
		
	
	
#	label.text = str(0)
	


func _process(delta):
	move(delta)
	
	for leg in legs:
		var distance = leg.foot.global_position.distance_to(body.global_position)
		if too_far(distance) or too_close(distance) or is_foot_on_wrong_side(leg):
			# Only move a leg if enough time has passed since the last leg moved
			if time_since_last_leg_move >= LEG_MOVE_TIME:
				leg.step(body.global_position + Vector2(feet_position[legs.find(leg)][0], feet_position[legs.find(leg)][1]))
				time_since_last_leg_move = 0
			else:
				time_since_last_leg_move += delta
		
func is_foot_on_wrong_side(leg):
	# if is right leg and it's on the left
	if feet_position[legs.find(leg)][0] > 0 and leg.foot.global_position.x - body.global_position.x < 0:
		return true
	# if is left leg and it's on the right
	elif feet_position[legs.find(leg)][0] < 0 and body.global_position.x - leg.foot.global_position.x < 0:
		return true
	# if is top leg and it's below
	elif feet_position[legs.find(leg)][1] > 0 and leg.foot.global_position.y - body.global_position.y < 0:
		return true
		# if is bottom leg and it's on top
	elif feet_position[legs.find(leg)][1] < 0 and body.global_position.y - leg.foot.global_position.y < 0:
		return true
	return false

func too_close(dist):
	return dist < Globals.MIN_LEG_DISTANCE

func too_far(dist):
	return dist > Globals.MAX_LEG_DISTANCE

func move(delta):
	var input_vector = get_input()
	
	velocity = velocity.move_toward(input_vector.normalized() * max_speed, acceleration * delta)

	# apply friction
	if input_vector == Vector2():
		velocity *= 1.0 - friction * delta

	body.global_position += velocity * delta

	body.global_position.x = clamp(body.global_position.x, 0, Globals.screen_size.x)
	body.global_position.y = clamp(body.global_position.y, 0, Globals.screen_size.y)

func get_input():
	var input_vector=Vector2()
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
	return input_vector



