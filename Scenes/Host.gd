extends Button

onready var Server = get_node("/root/Server");
onready var SceneSwitcher = get_node("/root/MainSceneSwitcher");

onready var address_input = get_parent().get_node("HostData/HAddress");
onready var port_input = get_parent().get_node("HostData/HPort");
onready var server_name_input = get_parent().get_node("HostData/ServerName");

func _ready():
	connect("pressed", self, "on_connect_press");
	pass # Replace with function body.

func on_connect_press():
	if address_input.text.length() != 0 && port_input.text.length() != 0:
		Server.create_server(address_input.text, port_input.text, server_name_input.text);
		SceneSwitcher.server_switch_scene(0);
