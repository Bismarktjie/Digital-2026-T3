extends CharacterBody2D

class_name Small_Bat

@onready var terget=$"../player"
@onready var collision = $hit_box
@onready var die = $"../player/attacking_col2"

var direction = Vector2.RIGHT

var speed=125
var knockback_timer := 0.0
var knockback_velocity := Vector2.ZERO

func _ready() -> void:
	#terget.connect(kill_bat)
	pass
	

func _physics_process(delta):
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity = knockback_velocity
		move_and_slide()
		return
	if is_instance_valid(self):
		direction=(terget.position-position).normalized()
		velocity=direction * speed
		#look_at(target.position)

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


func _on_child_entered_tree(_node: Node) -> void:
	pass

func _on_hit_box_area_entered(_area: Area2D) -> void:
	pass

func _on_collision_shape_2d_child_entered_tree(_node: Node) -> void:
	pass


func knockback(from_position: Vector2) -> void:
	var dir := (global_position - from_position).normalized()
	knockback_velocity = dir * 400
	knockback_timer = 0.25
