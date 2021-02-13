extends Area
class_name Bullet

var Damage := 5

func _ready():
	add_to_group(str(get_parent().get_network_master()))
	
