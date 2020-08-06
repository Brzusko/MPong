extends WindowDialog
class_name ServerList

#Ten node wymaga w Globalsach informacji o master serverze

signal fetched_servers(_servers);
signal fetched_details(detailed_server);
signal fetched_basic(basic_server);
signal error(error_message);

var servers = []

const URLS = [
	'/servers/$server',
	'/servers/detailed_info/$server/$address/$port',
	'/servers/basic_info/$server/$address/$port'
];

var request_triggered = false;

onready var globals = get_node("/root/Globals");

func _ready():
	$API_GETTER.use_threads = true;
	pass # Replace with function body.

func fetch_servers():
	if request_triggered:
		return;
		
	request_triggered = true;
	generate_base_url();
	var fetch_address = globals.data.master_url + URLS[0].replace("$server", globals.server);
	$API_GETTER.request(fetch_address);

func generate_base_url():
	globals.load_data();
	
func _on_API_GETTER_request_completed(_result, _response_code, _headers, body):
	var json = JSON.parse(body.get_string_from_utf8());
	if json.error != OK:
		print("something goes wrong");
		return;
	
	var response = json.result;
	
	print(_response_code);
	
	match response.message:
		"SUCCESSFULLY_FOUNDED_SERVERS":
			servers = response.data;
			emit_signal("fetched_servers", servers);
		"SUCCESSFULLY_FOUNDED_DETAILS":
			emit_signal("fetched_details", response.data);
		"SUCCESSFULLY_FOUNDED_BASIC":
			emit_signal("fetched_basic", response.data);
		_:
			var error_message = {
				"code": response.code,
				"error": response.message
			}
			emit_signal("error", error_message);
	request_triggered = false;

func _on_Refresh_pressed():
	fetch_servers();
	pass # Replace with function body.
