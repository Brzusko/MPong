extends Node
class_name PongServer

const server_port = 7171;
const max_slots = 2;

signal created_server;

remote var clients = [];

var server_peer: NetworkedMultiplayerPeer;

onready var Globals = get_node("/root/Globals");
onready var client = get_node("/root/Client");
onready var scene_switcher = get_node("/root/MainSceneSwitcher");

var Lobby_scene = preload("res://Scenes/Lobby.tscn");
var server_created = false;
var http_client: HTTPRequest;
var register_path = "/servers/register/Pong"
var update_path = "/servers/update_server/Pong/"
var header = ["Content-Type: application/json"];

var is_http_busy = false;

var ip = "";
var port = "";
var server_name = "";

var timer: Timer = null;
var timer_interval = 5;

func create_server(public_ip, _port, _server_name):
	var peer = NetworkedMultiplayerENet.new();
	peer.create_server(server_port, max_slots);
	server_peer = peer;
	get_tree().network_peer = peer;
	var player_dict = {
		"id": str(peer.get_unique_id()),
		"player_name": Globals.data.player_name,
		"is_master": true
	}
	clients.append(player_dict);
	register_signals(peer);
	server_created = true;
	http_client = HTTPRequest.new();
	http_client.use_threads = true;
	http_client.connect("request_completed", self, "on_http_request");
	add_child(http_client);
	ip = public_ip;
	port = _port;
	server_name = _server_name;
	timer = Timer.new();
	add_child(timer);
	timer.connect("timeout", self, 'on_timer_tick');
	
	register_server();
	
func register_signals(peer: NetworkedMultiplayerPeer):
	peer.connect("peer_connected", self, "on_player_connect");
	peer.connect("peer_disconnected", self, "on_player_disconnect");


func on_player_connect(peerId):
	client.rpc_id(peerId, "request_data_for_register");

func on_player_disconnect(peerId):
	print(peerId);
	var client_to_remove = null;
	for client in clients:
		if str(client.id) == str(peerId):
			client_to_remove = client;
	
	clients.erase(client_to_remove);
	
	if(scene_switcher.main_scene.name == "Lobby"):
		scene_switcher.main_scene.rpc("clear", client_to_remove);
		return;
	else:
		scene_switcher.main_scene.clear();
		scene_switcher.server_switch_scene(0);
	pass;
	
func clear_server():
	get_tree().network_peer = null;
	server_peer = null;
	clients.clear();
	scene_switcher.server_switch_scene(1);
	server_created = false;
	http_client.disconnect("request_completed", self, "on_http_request");
	http_client.queue_free();
	http_client = null;
	timer.stop();
	timer.queue_free();
	timer = null;


remote func get_player_list_to_lobby():
	var peer_id = get_tree().get_rpc_sender_id();
	get_node("/root/MainSceneSwitcher").main_scene.rpc_id(peer_id, "create_player_label", clients);
	pass;

remote func register_player(player_data: Dictionary):
	clients.append(player_data);
	scene_switcher.rpc_id(player_data.id, "server_switch_scene", 0);
	
	for client in clients:
		if str(client.id) != "1" && str(client.id) != str(player_data.id):
			scene_switcher.main_scene.rpc_id(int(client.id), "create_player_label", clients);
	
	scene_switcher.main_scene.create_player_label(clients);
	pass;

remote func game_scane_loaded():
	var peer_id = get_tree().get_rpc_sender_id();
	scene_switcher.main_scene.rpc_id(peer_id ,"spawn_players", clients);
	scene_switcher.main_scene.rpc_id(peer_id ,"spawn_ball");
	
func start_game():
	for client in clients:
		if str(client.id) != str(1):
			scene_switcher.rpc_id(int(client.id), "server_switch_scene", 3);
	scene_switcher.server_switch_scene(3)
	pass;

func register_server():
	if http_client != null && is_http_busy == false:
		Globals.load_data();
		var url = Globals.data.master_url + register_path;
		var register_data = {
			"server_name": server_name,
			"address": ip,
			"max_count": 10,
			"max_players": 2,
			"port": port
		}
		is_http_busy = true;
		http_client.request(url, header, false, HTTPClient.METHOD_POST, JSON.print(register_data));

func update_server():
	if http_client != null && is_http_busy == false && server_peer != null:
		var update_data = {
			"players": clients
		}
		var url = Globals.data.master_url + update_path + ip + "/" + port
		print(update_data.players);
		http_client.request(url, header, false, HTTPClient.METHOD_POST, JSON.print(update_data));

func on_http_request(result, _response_code, _headers, body):
	is_http_busy = false;
	var data = JSON.parse(body.get_string_from_utf8());
	if data.error != OK:
		print("Something goes wrong with parsing data");
		return;
	
	var parsed_data = data.result;
	
	print(parsed_data.message);
	
	match parsed_data.message:
		"ADDED":
			update_server();
			pass;
		"SERVER_UPDATED":
			if timer.is_stopped():
				timer.start(timer_interval);
			pass;
		_:
			pass;
	
	pass;

func on_timer_tick():
	update_server();
	pass;

