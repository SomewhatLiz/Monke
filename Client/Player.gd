extends KinematicBody

const SPEED := 0.05
var velocity := Vector3()

var GRAVITY := 0.05
var JUMP := 5
var LERP := 0.5

var HEALTH := 100

var isOnFloor = false

onready var raycast = $Jump

puppet var puppet_trans := Vector3()
puppet var puppet_vel := Vector3()
puppet var puppet_rot := Vector3()
puppet var self_rotation : float = 0

var MOUSE_SENSITIVITY := 0.1

onready var rotation_helper = $Camera

# Called when the node enters the scene tree for the first time.
func _ready():
#	$Camera.set_as_toplevel(true)
#	$StaticBody.set_as_toplevel(true)
	$Hitbox.add_to_group(str(get_network_master()))
	if is_network_master():
		$NameLabel.text = str(get_network_master())
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$Camera.current = true
		$Hitbox.set_collision_layer_bit(2, true)
		$Hitbox.set_collision_mask_bit(2, true)
	else:
		$Hitbox.set_collision_layer_bit(3, true)
		$Hitbox.set_collision_mask_bit(3, true)
		$Camera.current = false
		var player_id = get_network_master()
#		$NameLabel.text = gamestate.players[player_id]
		$NameLabel.visible = false
		
#		puppet_trans = translation
		set_process_input(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewport = get_viewport()
	if is_network_master():
		var tz: Vector3 = transform.basis.z
		isOnFloor = is_on_floor()
		if Input.is_action_pressed("up"):
			
			translation -= transform.basis.z * SPEED
		if Input.is_action_pressed("down"):
			
			translation += transform.basis.z * SPEED
		if Input.is_action_pressed("left"):

			translation -= transform.basis.x * SPEED
		if Input.is_action_pressed("right"):

			translation += transform.basis.x * SPEED
		if not isOnFloor:
			velocity.y -= GRAVITY
		if Input.is_action_just_pressed("jump") and isOnFloor:
			velocity.y = 0
			velocity.y += JUMP
			
		if Input.is_action_just_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		move_and_slide(velocity, Vector3.UP)
		for pid in gamestate.players:
			if pid != get_network_master():
				rset_unreliable_id(pid, "puppet_trans", translation) #puppet_trans = transform on every other computer
				rset_unreliable_id(pid, "puppet_vel", velocity)
	else:
		# If we are not the ones controlling this player, 
		# sync to last known transform and velocity
		translation = puppet_trans
		velocity = puppet_vel
		rotation_helper.rotation_degrees = puppet_rot
		rotation.y = self_rotation
		puppet_trans = translation
#	transform += velocity * delta
	

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and is_network_master():
		rotation_helper.rotate_x(deg2rad(-event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -90, 90)
		rotation_helper.rotation_degrees = camera_rot
		for pid in gamestate.players:
			if pid != get_network_master():
				rset_unreliable_id(pid, "puppet_rot", camera_rot)
				rset_unreliable_id(pid, "self_rotation", self.rotation.y)



func _on_Hitbox_area_entered(area):
	if area is Bullet:
		HEALTH -= area.Damage
		if HEALTH < 1:
			queue_free() # TODO
	print(area.name, "HP: ", HEALTH)
	
