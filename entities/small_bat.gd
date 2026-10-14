extends CharacterBody2D

class_name Small_Bat

@onready var terget=$"../player"
@onready var collision = $hit_box
@onready var die = $"../player/attacking_col2"

var direction = Vector2.RIGHT

var speed=150

func _ready() -> void:
	#terget.connect(kill_bat)
	pass

func _physics_process(delta):
	if is_instance_valid(self):
		direction=(terget.position-position).normalized()
		velocity=direction * speed
		#look_at(terget.position)
		
		for x in collision.get_overlapping_areas():
			if x == die:
				pass
		
		move_and_slide()


func _on_animated_sprite_2d_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print ("ouch, bad bat")
		body.respawn()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is sword_area:
		print("sword") # Replace with function body.



func _on_hit_box_body_entered(body):
	if body is Player:
		#call_deferred("queue_free")
		pass
	print(collision.get_overlapping_areas())
	for x in collision.get_overlapping_areas():
		if x == die:
			queue_free()
