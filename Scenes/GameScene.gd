extends Node2D

onready var PlayerPad = preload("res://Scenes/PlayerPad.tscn");
onready var Ball = preload("res://Scenes/Ball.tscn");

export var time_to_start = 5.0;

signal score_reached(p1_score, p2_score);

var players = [];
var ball = null;

var player_score_1 = 0;
var player_score_2 = 0;

func _ready():
	if(is_network_master()):
		spawn_players(get_node("/root/Server").clients);
		spawn_ball();
		$GameStart.start(time_to_start);
	else:
		get_node("/root/Server").rpc_id(1,"game_scane_loaded");
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("exit"):
		if(is_network_master()):
			get_node("/root/Server").clear_server();
			clear();
		else:
			clear();
			get_node("/root/Client").disconnect_client();
	pass;

remotesync func spawn_players(clients):
	
	for client in clients:
		var new_player = PlayerPad.instance();
		var pos = Vector2();
		var normal = Vector2();
		
		if str(client.id) == "1":
			pos = $Master.global_position;
			normal = Vector2.RIGHT;
		else:
			pos = $Slave.global_position;
			normal = Vector2.LEFT;
		
		normal = normal * 2;
		new_player.configure(int(client.id), pos, client.player_name + " " + str(client.id), normal);
		
		call_deferred("add_child", new_player);
		
		players.append(new_player);
		
remotesync func spawn_ball():
	ball = Ball.instance();
	call_deferred("add_child", ball);

func _on_GameStart_timeout():
	if is_network_master():
		for player in players:
			player.rpc("change_move_state", true);
	ball.rpc("configure", $Ball.global_position, Vector2.LEFT);
	$GameStart.stop();
	pass # Replace with function body.

remotesync func player_earn_score(who):
	var motion = Vector2();
	if(who == 0):
		player_score_2 += 1;
		motion = Vector2.RIGHT;
	else:
		player_score_1 += 1;
		motion = Vector2.LEFT;
	
	players[0].rpc("reset", $Master.position);
	players[1].rpc("reset", $Slave.position);	
	
	ball.rpc("reset", $Ball.position, motion);
	
	emit_signal("score_reached", player_score_1, player_score_2);

func clear():
	
	for player in players:
		player.queue_free();
	
	if(ball != null):
		ball.queue_free();
	

func _on_Left_player_score(who):
	rpc("player_earn_score", who);
	pass # Replace with function body.


func _on_Right_player_score(who):
	rpc("player_earn_score", who);
	pass # Replace with function body.
