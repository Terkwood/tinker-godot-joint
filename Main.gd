extends Spatial

const MOVE = 0.1
var movement = Vector2(0,0)
func _input(_event):
	if Input.is_action_just_pressed("ui_left"):
		movement = Vector2(-1.0 * MOVE, movement.y)
	if Input.is_action_just_pressed("ui_right"):
		movement = Vector2(MOVE, movement.y)
	if Input.is_action_just_pressed("ui_up"):
		movement = Vector2(movement.x, -1.0 * MOVE)
	if Input.is_action_just_pressed("ui_down"):
		movement = Vector2(movement.x, MOVE)

	if Input.is_action_just_released("ui_left") and !Input.is_action_pressed("ui_right"):
		movement = Vector2(0, movement.y)
	if Input.is_action_just_released("ui_right") and !Input.is_action_pressed("ui_left"):
		movement = Vector2(0, movement.y)
	if Input.is_action_just_released("ui_up") and !Input.is_action_just_released("ui_down"):
		movement = Vector2(movement.x, 0)
	if Input.is_action_just_released("ui_down") and !Input.is_action_just_released("ui_up"):
		movement = Vector2(movement.x, 0)

const _COEFF = -50.0
var _moving_foot = Foot.LEFT
enum Foot { LEFT, RIGHT }
var _step_progress = 0
const _MAX_STEP = 100
func _physics_process(_delta):
	var upper_body = $Player/KinUpperBody
	
	var v = Vector3(movement.x * _COEFF, 0, movement.y * _COEFF)
	upper_body.move_and_slide(v)
	
	_foot_node().move_and_slide(2.0 * v)
	_step_progress = (_step_progress + 1) % _MAX_STEP
	if _step_progress == 0:
		_change_foot()
func _change_foot():
	_moving_foot = Foot.RIGHT if _moving_foot == Foot.LEFT else Foot.LEFT

func _foot_node():
	if _moving_foot == Foot.LEFT:
		return $Player/LeftFoot
	else:
		return $Player/RightFoot
	
