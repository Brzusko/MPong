extends Button

onready var client = get_node("/root/Client");
onready var globals = get_node("/root/Globals");

func _ready():
	connect("pressed", self, "_on_connect_press");
	pass # Replace with function body.

func _on_connect_press():
	client.connect_to_server();
	print("connect");
