extends Spatial
class_name GameWorld

onready var Player = load("res://Player.tscn")
var CachedParticles = 60
var GunFire = []
var x = 0
# your id = 23
# enemy id = 4

func _ready():
	var BasicFire = load("res://Art/VFX/BasicGunFire.tscn")
	for i in range(CachedParticles):
		var ParticleInstance = BasicFire.instance()
		GunFire.append(ParticleInstance)
		add_child(ParticleInstance)

func SpawnParticle() -> Particles:
	x = (x + 1) % CachedParticles

	return GunFire[x]


remote func spawn_player(spawn_trans : Vector3, id: int):
	var player = Player.instance()
	
	player.translation = spawn_trans
	player.name = String(id) # Important
	print("id", id)
	player.set_network_master(id) # Important
#	if player.is_network_master():
#		player.get_node("Camera").current = true
	print(get_tree().get_rpc_sender_id())
	$Players.add_child(player)
	for child in $Players.get_children():
		if child is KinematicBody:
			print(child.name)

puppet func remove_player(id):
	$Players.get_node(String(id)).queue_free()
