extends Area2D

func _on_body_entered(body):
	if body is Player:
		var players:Array[Node] = get_tree().get_nodes_in_group("Players")
		for player in players:
			if player is Player:
				player.revive()
