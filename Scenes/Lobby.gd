extends Control

var my_player = preload("res://Scenes/PlayerLabel.tscn");
onready var Globals = get_node("/root/Globals");

func _ready():
	if(get_tree().is_network_server()):
		var server = get_node("/root/Server");
		create_player_label(server.clients);
	else:
		get_node("/root/Server").rpc_id(1, "get_player_list_to_lobby");
	pass # Replace with function body.

remote func create_player_label(player_names: Array):
	for child in $PlayerList.get_children():
		child.free();
	
	for player in player_names:
		var player_label = my_player.instance();
		player_label.init(player.player_name, player.is_master);
		$PlayerList.add_child(player_label);
	pass

remotesync func clear(playerToClear):
	for player_label in $PlayerList.get_children():
		if(player_label.text == playerToClear.player_name):
			player_label.queue_free();

func _on_StartButton_pressed():
	if(is_network_master() && $PlayerList.get_child_count() >= 1):
		Server.start_game();
	pass # Replace with function body.


func _on_Back_pressed():
	if(is_network_master()):
		get_node("/root/Server").clear_server();
	else:
		get_node("/root/Client").disconnect_client();
