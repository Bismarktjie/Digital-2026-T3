extends CharacterBody2D
@onready var terget=$"../player"
var speed=150
func _physics_process(delta):
	var direction=(terget.position-position).normalized()
	velocity=direction * speed
	look_at(terget.position)
	move_and_slide()


func _on_animated_sprite_2d_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("ouch")
		body.respawn()
