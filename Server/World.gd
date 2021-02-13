extends Spatial

onready var Player = load("res://Player.tscn")

onready var rotation_helper = $Camera

var MOUSE_SENSITIVITY := 0.1

func _ready():
	print("Server")
#	gamestate.players[1] = "Name"
#	spawn_player(Vector3.ZERO, 1)
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_process_input(false)

#func _physics_process(delta):
#	if Input.is_action_just_pressed("ui_cancel"):
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


puppetsync func spawn_player(spawn_pos: Vector3, id: int) -> void:
	var player = Player.instance()
	
	player.translation = spawn_pos
	player.name = String(id) # Important
	player.set_network_master(id) # Important
	
	$Players.add_child(player)


puppetsync func remove_player(id: int):
	$Players.get_node(String(id)).queue_free()

#func _input(event):
#	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#		rotation_helper.rotate_x(deg2rad(-event.relative.y * MOUSE_SENSITIVITY))
#		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
#
#		var camera_rot = rotation_helper.rotation_degrees
#		camera_rot.x = clamp(camera_rot.x, -70, 70)
#		rotation_helper.rotation_degrees = camera_rot
