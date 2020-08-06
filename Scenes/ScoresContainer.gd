extends CenterContainer

var default_labels_name = [
	"Player 1 Score: ",
	"Player 2 Score: "
];

func _on_GameScene_score_reached(p1_score, p2_score):
	$PlayerScores/Player_Left.text = default_labels_name[0] + str(p2_score);
	$PlayerScores/Player_Right.text = default_labels_name[1] + str(p1_score);
	pass # Replace with function body.
