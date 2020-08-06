extends Node2D

func _ready():
	get_node("/root/MainSceneSwitcher").server_switch_scene(1);
	call_deferred("free");
	pass # Replace with function body.

