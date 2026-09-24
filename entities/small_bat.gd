extends CharacterBody2D

class_name Small_Bat

@onready var terget=$"../player"
@onready var collision = $Area2D
@onready var die = $"../player/attacking_col2"


var speed=200


func _physics_process(delta):
	var direction=(terget.position-position).normalized()
	velocity=direction * speed
	#look_at(terget.position)
	
	for x in collision.get_overlapping_areas():
		if x == die:
			pass
	
	move_and_slide()


func _on_animated_sprite_2d_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("ouch, bad bat")
		body.respawn()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is sword_area:
		print("sword") # Replace with function body.
	


func _on_collision_shape_2d_child_entered_tree(node: Node) -> void:
		pass
func _on_hit_box_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
