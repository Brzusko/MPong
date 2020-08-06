extends Area2D

signal player_score(who);

export var which_player = 0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ScoreArea_body_entered(body):
	if(is_network_master()):
		emit_signal("player_score", which_player);
	pass # Replace with function body.
