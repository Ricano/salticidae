extends Position2D


onready var tip = $Skeleton2D/Bone1/Bone2/Tip
onready var foot = $Foot

var max_speed = 400
var acceleration = 200
var friction = 0

var velocity=Vector2()









# Called when the node enters the scene tree for the first time.
func _ready():
# Get the first bone in the chain
# Get the first bone in the chain
	var bone = tip

	# Traverse the parent-child hierarchy to get the parent bones
	while bone != null and bone is Bone2D:
		var parent_bone = bone.get_parent()
		if parent_bone != null and parent_bone is Bone2D:
			# Do something with the parent bone
			print("Parent bone:", parent_bone)
		bone = parent_bone

	pass # Replace with function body.


func _process(delta):
	move(delta)




func move(delta):
	

# Set the new position of the IK target node
	tip.global_transform.origin = foot.global_position

# Update the transforms of the bones in the IK chain
	var parent_bone = tip.get_parent()
	while parent_bone != null and parent_bone is Bone2D:
		parent_bone.global_transform
		parent_bone = parent_bone.get_parent()

	
	var input_vector = get_input()

	velocity = velocity.move_toward(input_vector.normalized() * max_speed, acceleration * delta)

	# apply friction
	velocity *= 1.0 - friction * delta

	foot.global_position += velocity * delta


	foot.global_position.x = clamp(foot.global_position.x, 0, Globals.screen_size.x)
	foot.global_position.y = clamp(foot.global_position.y, 0, Globals.screen_size.y)




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
