extends Node

var network_peer: NetworkedMultiplayerPeer;
onready var globals = get_node("/root/Globals");
onready var server = get_node("/root/Server");

func connect_to_server(ip, port):
	var peer = NetworkedMultiplayerENet.new();
	peer.create_client(ip, port);
	get_tree().network_peer = peer;
	network_peer = peer;
	network_peer.connect("server_disconnected", self, "on_sever_disconnect")


remote func request_data_for_register():
	globals.load_data();
	var data_to_send = {
		"player_name": globals.data.player_name,
		"id": network_peer.get_unique_id(),
		"is_master": false
	};
	server.rpc_id(1, "register_player", data_to_send);
	pass;

remote func server_closed_connection():
	disconnect_client();

func on_sever_disconnect():
	disconnect_client();

func disconnect_client():
	get_tree().network_peer = null;
	get_node("/root/MainSceneSwitcher").server_switch_scene(1);
