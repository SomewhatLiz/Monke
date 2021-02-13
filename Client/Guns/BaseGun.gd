extends Spatial

onready var BulletArea := $Bullet
onready var CurrentAmmoText := $Pistol/AmmoView/Viewport/VBoxContainer/CurrentAmmo
onready var ClipSizeText := $Pistol/AmmoView/Viewport/VBoxContainer/ClipSize

onready var world : GameWorld = get_node('/root/World')

var Ammo := 16
var MaxClip := 16

func _ready():
	CurrentAmmoText.text = str(Ammo)
	ClipSizeText.text = str(MaxClip)
	BulletArea.monitorable = false
	BulletArea.visible = false
	set_network_master(get_parent().get_network_master())
	if get_parent().is_network_master():
		set_process_input(true)
		$Bullet.set_collision_layer_bit(3, true)
		$Bullet.set_collision_mask_bit(3, true)
	else:
		$Bullet.set_collision_layer_bit(2, true)
		$Bullet.set_collision_mask_bit(2, true)

remote func fire():
	var particle : Particles = world.SpawnParticle()
	particle.global_transform = $Muzzle.global_transform
#	particle.global_transform.origin = $Muzzle.global_transform.origin
#	particle.rotation = get_parent().global_transform.basis.get_euler()
#	particle.rotation.z += get_parent().rotation.x
#	particle.rotate_x(-PI/2)
	particle.emitting = true
	BulletArea.monitorable = true
	BulletArea.visible = true
	get_parent().add_stress(0.3)
	$Anim.play("Fire")
	$Anim.seek(0)
	$BulletTime.start() 
	$Firerate.start()

func _input(event):
	if Ammo > 0:
		var Clicked : bool = event is InputEventMouseButton and (event as InputEventMouseButton).button_index == 1
		var AmmoChecks : bool = $Firerate.is_stopped() and $Reload.is_stopped()
		if Clicked and AmmoChecks:
			rpc("fire")
			fire()
			print("fire")
	if event is InputEventKey and (event as InputEventKey).scancode == KEY_R:
		$Reload.start()
		$Anim.play("Reloading")




func _on_BulletTime_timeout():
	Ammo -= 1
	CurrentAmmoText.text = str(Ammo)
	BulletArea.monitorable = false
	BulletArea.visible = false


func _on_Reload_timeout():
	Ammo = MaxClip
	CurrentAmmoText.text = str(Ammo)
