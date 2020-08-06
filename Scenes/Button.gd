extends Button


func _ready():
	connect("pressed", self,"_on_settings_press");
	pass # Replace with function body.

func _on_settings_press():
	get_node("/root/MainSceneSwitcher").server_switch_scene(2);
