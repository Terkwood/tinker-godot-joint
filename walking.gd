extends Object

enum Motion {
	None,
	Incr,
	Decr
}

enum Foot { Left, Right }

var motion_x = Motion.None
var motion_z = Motion.None
var moving_foot = Foot.Left

func other_foot():
	return Foot.Right if moving_foot == Foot.Left else Foot.Left
