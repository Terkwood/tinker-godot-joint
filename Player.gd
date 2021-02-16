extends Spatial

onready var _walking = preload("res://walking.gd").new()

onready var _right_foot = $RFoot
onready var _left_foot = $LFoot
onready var _kin_upper_body = $KinUpperBody

onready var _left_boundary = $KinUpperBody/LeftBoundary
onready var _right_boundary = $KinUpperBody/RightBoundary

func _input(_event):
	if Input.is_action_just_pressed("ui_up"):
		_walking.motion_z = _walking.Motion.Incr
	if Input.is_action_just_pressed("ui_down"):
		_walking.motion_z = _walking.Motion.Decr
	if Input.is_action_just_pressed("ui_right"):
		_walking.motion_x = _walking.Motion.Incr
	if Input.is_action_just_pressed("ui_left"):
		_walking.motion_x = _walking.Motion.Decr

	if Input.is_action_just_released("ui_up") or Input.is_action_just_released("ui_down"):
		_walking.stop_z()
	if Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		_walking.stop_x()


const _Z_COEFF = 3.0
const _X_COEFF = 5.0
const _EPSILON = 0.001
func _physics_process(_delta):
	var move_z = _convert(_walking.motion_z) * _Z_COEFF
	var move_x = _convert(_walking.motion_x) * _X_COEFF
	
	_kin_upper_body.move_and_slide(Vector3(move_x,0,move_z))
	_foot_node_z().move_and_slide(2.0 * Vector3(0,0,move_z))
	_foot_node_x().move_and_slide(2.0 * Vector3(move_x,0,0))


func _foot_node_x():
	if _walking.moving_foot_x == _walking.Foot.Left:
		return _left_foot
	else:
		return _right_foot
func _foot_node_z():
	if _walking.moving_foot_z == _walking.Foot.Left:
		return _left_foot
	else:
		return _right_foot

func _convert(walk_motion) -> int:
	if walk_motion == _walking.Motion.Decr:
		return 1
	if walk_motion == _walking.Motion.Incr:
		return -1
	return 0

func _handle_foot_x(body: PhysicsBody):
	if body == _foot_node_x():
		_walking.moving_foot_x = _walking.other_foot_x()

func _handle_foot_z(body: PhysicsBody):
	if body == _foot_node_z():
		_walking.moving_foot_z = _walking.other_foot_z()


func _on_LeftBoundary_body_entered(body):
	_handle_foot_x(body)


func _on_RightBoundary_body_entered(body):
	_handle_foot_x(body)


func _on_FrontBoundary_body_entered(body):
	_handle_foot_z(body)

func _on_BackBoundary_body_entered(body):
	_handle_foot_z(body)
	
