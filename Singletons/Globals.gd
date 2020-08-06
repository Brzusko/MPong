extends Node

var data = {
	"player_name": "",
	"master_url": ""
}

var server = "Pong";
var is_domian = false;

const file_path = "user://data.json";

onready var Server = get_node("/root/Server");
onready var Client = get_node("/root/Client");

func _ready():
	if(setup_file()):
		load_data();
	pass;


func load_data():
	var file_handle = File.new();
	var _err = file_handle.open(file_path, File.READ);
	
	if _err == OK:
		var data_as_text = file_handle.get_as_text();
		var data_as_dict = JSON.parse(data_as_text).result;
		data = data_as_dict;
	else:
		print("Couldnt load file");
	
	file_handle.close();
	pass;

func update_data(data_to_write: Dictionary):
	setup_file();
	var file_handle = File.new();
	var _err = file_handle.open(file_path, File.WRITE_READ);
	
	if _err == OK:
		var data_as_text = to_json(data_to_write);
		file_handle.store_string(data_as_text);
	
	data = data_to_write;
	file_handle.close();
	pass;
	
func setup_file() -> bool:
	var file_handle = File.new();
	
	if(!file_handle.file_exists(file_path)):
		var _err = file_handle.open(file_path, File.WRITE);
		
		if _err == OK:
			var data_to_write = to_json(data);
			file_handle.store_string(data_to_write);
			file_handle.close();
			return false;
		file_handle.close();
	return true;
