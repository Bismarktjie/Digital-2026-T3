extends CharacterBody2D

class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var background = $"../Background" # Fixed node reference
@onready var attacking_col = $attacking_col2/attacking_col
@onready var attack_col_pos = attacking_col.position.x
@onready var bat = $"../small bat v1/hit_box"
@onready var timer_label = $Camera2D/CanvasLayer/TimerLabel

const SPEED = 400.0
const JUMP_VELOCITY = -450.0
var start_position = Vector2(96, 160)

var attacking = false
var can_attack = true
var knockback_timer := 0.0
var run_time: float = 0.0

signal kill_bat

func _physics_process(delta: float) -> void:
	run_time += delta
	var minutes := int(run_time) / 60
	var seconds := int(run_time) % 60
	var millis := int((run_time - int(run_time)) * 1000)
	timer_label.text = "Time: %02d:%02d:%03d" % [minutes, seconds, millis]

	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	if knockback_timer > 0:
		knockback_timer -= delta
		move_and_slide()
		return

	# Handle attack input
	if Input.is_action_just_pressed("attack_3") and not attacking and can_attack:
		attacking_col.disabled = false
		attacking = true
		can_attack = false
		animated_sprite_2d.play("attack_3")
		$attacking.start()
		$attacking_col2.KillEnemies()
		#$attack_again.start()
		

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	# Handle movement
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite_2d.flip_h = (direction < 0)
		if direction < 0:
			attacking_col.position.x = -attack_col_pos #change position of attacking collision box
		else:
			attacking_col.position.x = attack_col_pos
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle ground animations (only play when not attacking)
	if not attacking: #and not is_on_floor():
		if not is_on_floor():
			animated_sprite_2d.play("jump")
		elif abs(velocity.x) > 1:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")

	move_and_slide()
	
	#if velocity.x >= 1 or velocity.x <= -1:
		#animated_sprite_2d.play("run")
	#else:
		#animated_sprite_2d.play("idle")

	if position.y > 30000:
		respawn()

func respawn():
	position = start_position

# Signal callbacks connected to $attack_timer and $attack_again_timer


func _on_attack_again_timer_timeout() -> void:
	can_attack = true


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "attack_3":
		#animated_sprite_2d.play("idle")
		attacking_col.disabled = true
		can_attack = true



func _on_attacking_timeout() -> void:
	attacking = false # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("bat has entered player attack")
	if body is Small_Bat and attacking: #player is swinging at bat
		print("bat has been hit") # Replace with function body.
	if body is Small_Bat and not attacking: #player not attacking, player has been hit
		print("demon has hit player")
		#respawn()


func _on_attacking_col_2_body_entered(body: Node2D) -> void:
	print("bat has collided with player")
	if body is Small_Bat and attacking: #player is swinging at bat
		print("bat has been hit") 
		#queue_free()# Replace with function body.
	elif body is Small_Bat and not attacking: #player not attacking, player has been hit
		print("demon has hit player")
	
		#respawn() # Replace with function body.


func _on_player_hit_box_area_entered(area: Area2D) -> void:
	print(attacking)
	if area.get_parent() is Small_Bat and attacking: #player is swinging at bat
		print("bat has been hit") # Replace with function body.
		kill_bat.emit()
	elif area.get_parent() is Small_Bat and not attacking: #player not attacking, player has been hit
		print("demon has hit player")
		(area.get_parent() as Small_Bat).knockback(global_position)
		take_hit(area.global_position)
	#respawn() # Replace with function body. # Replace with function body.

signal health_changed(new_health: int)

@export var max_health: int = 100
var health: int = max_health:
	set(value):
		health = clampi(value, 0, max_health)
		health_changed.emit(health)
func take_hit(from_position: Vector2, amount: int = 10, knock_h: float = 100.0, knock_v: float = -250.0) -> void:
	health -= amount
	print("take_hit called, health is now ", health)
	health_bar.set_health(health)
	if health <= 0:
		health = 100
		health_bar.set_health(health)
		run_time = 0.0
		respawn()
	var dir := signf(global_position.x - from_position.x)
	velocity = Vector2(dir * knock_h, knock_v)
	knockback_timer = 0.5


@onready var health_bar = $Camera2D/CanvasLayer/ProgressBar
