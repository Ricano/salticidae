extends Position2D


var offset = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func on_Player_is_moving(body):
#	strech_leg(body)
#
#func strech_leg(body):
#	look_at(body.global_position)
#	var distance = global_position.distance_to(body.global_position)
#	var bones = get_children()
#	for i in len(bones):
#		if bones[i].name=="Sprite":
#			continue
#		bones[i].position.x = 20 + distance/5 * i
#

