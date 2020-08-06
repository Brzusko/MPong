extends Label
class_name PlayerLabel

func init(PlayerName, is_master):
	var player_name = PlayerName;
	
	if(is_master):
		player_name += " [*]";
	text = player_name;
