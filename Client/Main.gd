extends Control

onready var status = get_node("VBox/Status")

func _ready():
	print("Client")
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	gamestate.connect("server_disconnected", self, "_on_server_disconnect")
#	gamestate.connect("players_updated", self, "update_players_list")
	
#	$VBox/JoinBu tton.disabled = true
	
	status.text = "Connecting..."
	status.modulate = Color.yellow


func _on_JoinButton_pressed():
#	gamestate.get_tree().connect("connected_to_server", self, "_connected_ok")
#	gamestate.get_tree().connect("connection_failed", self, "_connected_fail")
#	gamestate.get_tree().connect("server_disconnected", self, "_server_disconnected")
	#	print(get_tree().get_network_unique_id())
	# Try to connect right away
	gamestate.connect_to_server()
	gamestate.my_name = $VBox/HBox/LineEdit.text
#	gamestate.rpc_id(1, "register_player", gamestate.my_name) 
	# 1 is the server's ID
#	get_node("/root/Main").hide()
#	var world = load("res://Maps/" + "House" + ".tscn").instance()
#	get_tree().get_root().add_child(world)
#	gamestate.pre_start_game()
	$Timer.start()
	

func _on_Timer_timeout():
	gamestate.pre_start_game()

func _on_connection_success():
	$VBox/JoinButton.disabled = false
	
	status.text = "Connected"
	status.modulate = Color.green


func _on_connection_failed():
	$VBox/JoinButton.disabled = true
	
	status.text = "Connection Failed, trying again"
	status.modulate = Color.red


func _on_server_disconnect():
	$VBox/JoinButton.disabled = true
	
	status.text = "Server Disconnected, trying to connect..."
	status.modulate = Color.red


