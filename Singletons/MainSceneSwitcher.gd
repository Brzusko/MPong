extends Node

onready var main_scenes = [
	preload("res://Scenes/Lobby.tscn"),
	preload("res://Scenes/Connector.tscn"),
	preload("res://Scenes/Settings.tscn"),
	preload("res://Scenes/GameScene.tscn")
];

var main_scene;

		
remote func server_switch_scene(which_scene):
	if(main_scene != null):
		get_tree().get_root().remove_child(main_scene);
		main_scene.call_deferred("queue_free");
		
	match which_scene:
		0:
			main_scene = main_scenes[which_scene].instance();
			get_tree().get_root().call_deferred("add_child", main_scene);
		1:
			main_scene = main_scenes[which_scene].instance();
			get_tree().get_root().call_deferred("add_child", main_scene);
		2:
			main_scene = main_scenes[which_scene].instance();
			get_tree().get_root().call_deferred("add_child", main_scene);
		3:
			main_scene = main_scenes[which_scene].instance();
			get_tree().get_root().call_deferred("add_child", main_scene);
	pass;


