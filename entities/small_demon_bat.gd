extends CharacterBody2D

class_name SmallDemonBat

@onready var terget=$"../player"
var speed=100
func _physics_process(delta):
	var direction=(terget.position-position).normalized()
	velocity=direction * speed
	#look_at(terget.position)
	move_and_slide()


func _on_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.
