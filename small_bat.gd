extends CharacterBody2D

class_name Small_Bat

@onready var terget=$"../player"
@onready var collision = $Area2D
@onready var die = $"../player/attacking_col2"


var speed=150


func _physics_process(delta):
	var direction=(terget.position-position).normalized()
	velocity=direction * speed
	#look_at(terget.position)
	
	for x in collision.get_overlapping_areas():
		if x == die:
			print("thank you (your welcome) ")
	
	move_and_slide()


func _on_animated_sprite_2d_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("ouch")
		body.respawn()


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	
