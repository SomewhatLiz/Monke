extends Spatial

const SPEED := 0.05
var velocity := Vector3()

var GRAVITY := 0.05
var JUMP := 5
var LERP := 0.5

var isOnFloor = false


#onready var raycast = $RayCast

puppet var puppet_rot
puppet var puppet_trans := Vector3()
puppet var puppet_vel := Vector3()
puppet var self_rotation : float = 0

var MOUSE_SENSITIVITY := 0.1

#onready var rotation_helper = $Camera

# Called when the node enters the scene tree for the first time.
#func _ready():
#	var player_id = get_network_master()
#
#	$NameLabel.text = gamestate.players[player_id]
#
#	puppet_trans = translation


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	transform = puppet_trans
#
#	velocity = puppet_vel
#
#	puppet_trans = transform

#func _input(event):
#	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#		rotation_helper.rotate_x(deg2rad(-event.relative.y * MOUSE_SENSITIVITY))
#		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
#
#		var camera_rot = rotation_helper.rotation_degrees
#		camera_rot.x = clamp(camera_rot.x, -70, 70)
#		rotation_helper.rotation_degrees = camera_rot

