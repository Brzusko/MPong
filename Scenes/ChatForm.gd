extends HBoxContainer

onready var ChatContainer = $"./../ChatContainer";

func _on_SendButton_pressed():
	if($InputField.text.length() > 0):
		var message = get_node("/root/Globals").data.player_name + " says: " + $InputField.text + '\n';
		ChatContainer.rpc("send_message", message);
		ChatContainer.send_message(message);
		$InputField.text = "";
	pass # Replace with function body.
