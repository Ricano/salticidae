extends Position2D
 

onready var joint1 = $Joint1
onready var joint2 = $Joint1/Joint2
onready var foot = $Joint1/Joint2/Foot
 
var len_upper = 0
var len_middle = 0
var len_lower = 0
 
 
var goal_pos = Vector2()
var int_pos = Vector2()
var start_pos = Vector2()

var target_pos
 
func _ready():
	len_upper = joint1.position.x
	len_middle = joint2.position.x
	len_lower = foot.position.x
 
 
func step(g_pos):
	if goal_pos == g_pos:
		return
 
	goal_pos = g_pos
	var hand_pos = foot.global_position
 
	start_pos = hand_pos
 
func _process(delta):
	var target_pos = Vector2()
	target_pos = goal_pos
	update_ik(target_pos)
 
func update_ik(target_pos):
	var offset = target_pos - global_position
	var dis_to_tar = offset.length()
 
	var base_r = offset.angle()
	var len_total = len_upper + len_middle + len_lower
	var len_dummy_side = (len_upper + len_middle) * clamp(dis_to_tar / len_total, 0.0, 1.0)
 
	var base_angles = SSS_calc(len_dummy_side, len_lower, dis_to_tar)
	var next_angles = SSS_calc(len_upper, len_middle, len_dummy_side)
 
	global_rotation = base_angles.B + next_angles.B + base_r
	joint1.rotation = next_angles.C
	joint2.rotation = base_angles.C + next_angles.A
 
func SSS_calc(side_a, side_b, side_c):
	if side_c >= side_a + side_b:
		return {"A": 0, "B": 0, "C": 0}
	var angle_a = law_of_cos(side_b, side_c, side_a)
	var angle_b = law_of_cos(side_c, side_a, side_b) + PI
	var angle_c = PI - angle_a - angle_b
 
 
	return {"A": angle_a, "B": angle_b, "C": angle_c}
	
 
func law_of_cos(a, b, c):
	if 2 * a * b == 0:
		return 0
	return acos((a * a + b * b - c * c) / (2 * a * b))
