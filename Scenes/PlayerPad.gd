extends KinematicBody2D



var spawn_point;

puppet var puppet_motion = Vector2();
puppet var puppet_normal = Vector2();
var can_move = false;

var normal = Vector2();
var starting_normal = Vector2();

export var move_speed = 200.0; 


func _ready():
	pass # Replace with function body.

func _process(delta):
	if can_move:
		var motion = Vector2();
		
		if is_network_master() || get_tree().network_peer == null:
			if Input.is_action_pressed("move_up"):
				motion = Vector2.UP;
			if Input.is_action_pressed("move_down"):
				motion = Vector2.DOWN;
			
			normal = starting_normal + motion;
			
			rset("puppet_motion", motion);
			rset("puppet_normal", normal);
		else:
			motion = puppet_motion;
			normal = puppet_normal;
			
		move_and_slide(motion * move_speed);

remotesync func reset(_position):
	position = _position;

func configure(master_id, _position, _name, _normal):
	position = _position;
	name = _name;
	spawn_point = _position;
	normal = _normal;
	starting_normal = _normal;
	set_network_master(master_id, true);

remotesync func change_move_state(_can_move):
	can_move = true;
