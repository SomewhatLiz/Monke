extends Node

# Default game port
const DEFAULT_PORT = 44444

# Max number of players
const MAX_PLAYERS = 12

# Players dict stored as id:name
var players = {}


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	
	create_server()


func create_server():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(host)


# Callback from SceneTree, called when client connects
func _player_connected(_id):
	print("Client ", _id, " connected")


# Callback from SceneTree, called when client disconnects
func _player_disconnected(id):
	print(players)
	if players.has(id):
		rpc("unregister_player", id)
		get_node("/root/World").rpc("remove_player", id)
#		rpc("remove_player", id)
		print(get_node("/root/World").get_children())
	print("Client ", id, " disconnected")


# Player management functions
remote func register_player(new_player_name: String):
	# We get id this way instead of as parameter, to prevent users from pretending to be other users
	var caller_id = get_tree().get_rpc_sender_id()
	
	# Add him to our list
	players[caller_id] = new_player_name
	print("register ", players)
	
	# Add everyone to new player:
	for p_id in players:
		rpc_id(caller_id, "register_player", p_id, players[p_id]) 
		# Send each player to new dude (the caller)
	
	rpc("register_player", caller_id, players[caller_id]) 
	# Send caller to all other people
	# NOTE: this means new player's register gets called twice, but fine as same info sent both times
	
	print("Client ", caller_id, " registered as ", new_player_name)


puppetsync func unregister_player(id):
	players.erase(id)
	
	print("Client ", id, " was unregistered")


remote func populate_world():
	var caller_id = get_tree().get_rpc_sender_id()
	var world = get_node("/root/World")
	var i = 0
#	print("Children at the start: ", world.get_node("Players").get_children())
	# Spawn all current players on new client
	for player in world.get_node("Players").get_children():
		
		i+=1
		print(i, "   ", player.get_network_master())
		
#		print(player.get_network_master(), "   ", caller_id)
		world.rpc_id(caller_id, "spawn_player", player.translation, player.get_network_master())
#	print("Children at the middle: ", world.get_node("Players").get_children())
	# Spawn new player everywhere
#	print(caller_id)
	world.rpc("spawn_player", Vector3(0, 10, 0), caller_id)
	i+=1
	print(i, "   ", caller_id)
		
#	world.spawn_player(Vector3(0, 10, 0), caller_id)
#	print("Children at the end: ", world.get_node("Players").get_children())


# Return random 2D vector inside bounds 0, 0, bound_x, bound_y
func random_vector2(bound_x, bound_y):
	return Vector2(randf() * bound_x, randf() * bound_y)
