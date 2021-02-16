extends Spatial

onready var _walking = preload("res://walking.gd").new()

onready var _right_foot = $RightFoot
onready var _left_foot = $LeftFoot
onready var _kin_upper_body = $KinUpperBody

func _input(_event):
	if Input.is_action_just_pressed("ui_up"):
		_walking.motion_z = _walking.Motion.Incr
	if Input.is_action_just_pressed("ui_down"):
		_walking.motion_z = _walking.Motion.Decr
	if Input.is_action_just_pressed("ui_left"):
		pass #movement = Vector2(-1.0 * MOVE, movement.y)
	if Input.is_action_just_pressed("ui_right"):
		pass #movement = Vector2(MOVE, movement.y)

	if Input.is_action_just_released("ui_up") and !Input.is_action_just_released("ui_down"):
		_walking.motion_z = _walking.Motion.None
	if Input.is_action_just_released("ui_down") and !Input.is_action_just_released("ui_up"):
		_walking.motion_z = _walking.Motion.None
	if Input.is_action_just_released("ui_left") and !Input.is_action_pressed("ui_right"):
		pass # movement = Vector2(0, movement.y)
	if Input.is_action_just_released("ui_right") and !Input.is_action_pressed("ui_left"):
		pass #movement = Vector2(0, movement.y)


const _COEFF = 3.0

func _physics_process(_delta):
	var move_z = _convert(_walking.motion_z)
	
	var v = Vector3(0, 0, move_z * _COEFF)
	_kin_upper_body.move_and_slide(v)	
	_foot_node().move_and_slide(2.0 * v)


func _foot_node():
	if _walking.moving_foot == _walking.Foot.Left:
		return _left_foot
	else:
		return _right_foot

func _convert(walk_motion) -> int:
	if walk_motion == _walking.Motion.Decr:
		return 1
	if walk_motion == _walking.Motion.Incr:
		return -1
	return 0


func _on_FrontBoundary_body_entered(body):
	_handle_foot(body)



func _on_BackBoundary_body_entered(body):
	_handle_foot(body)
	
func _handle_foot(body: PhysicsBody):
	if body == _left_foot or body == _right_foot:
		_walking.moving_foot = _walking.other_foot()
