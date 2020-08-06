extends VBoxContainer

onready var client = get_node("/root/Client");

func _on_ConnectBtn_pressed():
	var address = $ConnectForm/Address.text;
	var port = int($ConnectForm/Port.text);
	
	if(address.length() != 0 && $ConnectForm/Port.text.length() != 0):
		client.connect_to_server(address, port);

