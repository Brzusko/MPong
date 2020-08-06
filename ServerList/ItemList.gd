extends ItemList

var _servers = [];
var selected_item = -1;

onready var client = get_node("/root/Client");

func _ready():
	pass # Replace with function body.


func _on_ServerList_fetched_servers(servers):
	selected_item = -1;
	clear();
	_servers = [] + servers;
	for server in servers:
		var parsed_server = JSON.parse(server).result;
		var text = "Server address: " + parsed_server.address + ":" + str(parsed_server.port);
		text += ", Server name: " + parsed_server.server_name + ", Slots: " + str(parsed_server.player_count) + "/" + str(parsed_server.max_players);
		add_item(text);
	pass # Replace with function body.


func _on_Servers_item_selected(index):
	selected_item = index;


func _on_Connect_pressed():
	if selected_item == -1:
		return;
	
	var selected_server = JSON.parse(_servers[select_mode]).result;
	client.connect_to_server(selected_server.address, int(selected_server.port));
