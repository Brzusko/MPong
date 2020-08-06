extends KinematicBody2D

export var max_speed = 40.0
var speed = 0.0;
var can_move = false;

master var motion = Vector2();
puppet var puppet_position = Vector2();

func _ready():
	pass;

func _physics_process(delta):
	if can_move:
		if(is_network_master()):
			var collision = move_and_collide(motion * speed);
			
			if collision:
				var normal = collision.collider.get("normal");
				motion = motion + normal;
			rset("puppet_position", position);
		else:
			position = puppet_position;
		
remotesync func reset(_position, _motion):
	position = _position;
	motion = _motion
	
remotesync func configure(_position, starting_dir):
	speed = 5.0;
	position = _position;
	can_move = true;
	motion = starting_dir;
	pass;
