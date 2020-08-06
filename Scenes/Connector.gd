extends Control

func _ready():
	pass # Replace with function body.


func _on_ServerList_pressed():
	$ServerList.fetch_servers();
	$ServerList.popup();
	pass # Replace with function body.
