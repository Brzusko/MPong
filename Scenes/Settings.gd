extends Control

onready var globals = get_node("/root/Globals");
onready var scene_switcher = get_node("/root/MainSceneSwitcher");

func _ready():
	globals.load_data();
	update_ui();
	pass # Replace with function body.

func update_ui():
	var data = globals.data;
	$CenterContainer/MainContainer/Address.text = data.master_url;
	$CenterContainer/MainContainer/PlayerName.text = data.player_name;


func _on_Save_pressed():
	var data_to_save = {
		"player_name": $CenterContainer/MainContainer/PlayerName.text,
		"master_url": $CenterContainer/MainContainer/Address.text
	}
	globals.update_data(data_to_save);
	update_ui();


func _on_Back_pressed():
	scene_switcher.server_switch_scene(1);
	pass # Replace with function body.
