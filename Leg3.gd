extends Node2D

onready var root_bone = $Skeleton2D/Bone2D
onready var mid_bone = $Skeleton2D/Bone2D/Bone2D
onready var tip_bone = $Skeleton2D/Bone2D/Bone2D/Tip

var chain_length = 3 # number of bones in the chain


func _process(delta):
	# Move the tip bone towards the target
	var target = get_global_mouse_position()
	tip_bone.look_at(target)
	tip_bone.global_position = tip_bone.global_position.move_toward(target, delta * 200)
	
	# Update the rest of the chain
	pass_chain(tip_bone)
	
func pass_chain(bone):
	# If this is the root bone, we're done
	if bone == root_bone:
		return
	
	# Get the parent bone and calculate the new position and rotation
	var parent_bone = bone.get_parent()
	var new_position = parent_bone.global_transform.xform(bone.rest.get_origin()) * bone.get_global_scale()
	var new_rotation = parent_bone.global_transform.get_rotation() + bone.rest.get_rotation() * bone.get_global_scale().angle()
	
	# Move the bone to the new position and rotation, and continue with the parent bone
	bone.global_transform = Transform2D(new_rotation, new_position)
	
	# Debug output
	print("Bone: ", bone.get_name(), "Position: ", bone.global_transform.get_origin(), "Rotation: ", bone.global_transform.get_rotation())
	
	pass_chain(parent_bone)





