extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("oops, thats hot")
		body.respawn()
