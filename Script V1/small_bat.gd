extends CharacterBody2D

class_name Small_Bat

@onready var terget=$"../player"
@onready var collision = $hit_box
@onready var die = $"../player/attacking_col2"


var direction = Vector2.RIGHT

var speed=125
var knockback_timer := 0.0
var knockback_velocity := Vector2.ZERO
var health: int = 30
@onready var start_position := global_position
var dying := false

func _ready() -> void:
	add_to_group("enemies")

		
func take_damage(amount: int, from_position: Vector2) -> void:
	if dying:
		return
	health -= amount
	knockback(from_position)
	print("bat hp: ", health)
	if health <= 0:
		if terget.has_method("heal"):
			terget.heal(5)
		play_death()
	else:
		play_hurt()

func _physics_process(delta):
	if dying:
		return
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity = knockback_velocity
		move_and_slide()
		return
	if is_instance_valid(self):
		direction=(terget.position-position).normalized()
		velocity=direction * speed
		#look_at(target.position)


		move_and_slide()
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.has_method("take_hit"):
			body.take_hit(global_position, 10)
		else:
			print("ouch, bad bat")
			body.respawn()



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is sword_area:
		print("sword") # Replace with function body.



func _on_hit_box_body_entered(body):
	if body is Player:
		#call_deferred("queue_free")
		pass


func _on_child_entered_tree(_node: Node) -> void:
	pass

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area == die and knockback_timer <= 0.0:
		take_damage(15, terget.global_position)

func _on_collision_shape_2d_child_entered_tree(_node: Node) -> void:
	pass


func knockback(from_position: Vector2) -> void:
	var dir := (global_position - from_position).normalized()
	knockback_velocity = dir * 700
	knockback_timer = 0.15

func disable_enemy() -> void:
	hide()
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	$hit_box.set_deferred("monitoring", false)
	$hit_box.set_deferred("monitorable", false)

func reset_enemy() -> void:
	global_position = start_position
	health = 30
	knockback_timer = 0.0
	velocity = Vector2.ZERO
	show()
	dying = false
	$AnimatedSprite2D.play("flying")
	
	set_physics_process(true)
	$CollisionShape2D.set_deferred("disabled", false)
	$hit_box.set_deferred("monitoring", true)
	$hit_box.set_deferred("monitorable", true)
	
func play_death() -> void:
	dying = true
	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)
	$hit_box.set_deferred("monitoring", false)
	$hit_box.set_deferred("monitorable", false)
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	if dying:
		disable_enemy()


func play_hurt() -> void:
	$AnimatedSprite2D.play("hurt")
	await $AnimatedSprite2D.animation_finished
	if not dying:
		$AnimatedSprite2D.play("flying")
