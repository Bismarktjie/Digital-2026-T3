extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var background = $"../Background" # Fixed node reference
@onready var attacking_col = $attacking_col2/attacking_col
@onready var attack_col_pos = attacking_col.position.x

const SPEED = 400.0
const JUMP_VELOCITY = -450.0
var start_position = Vector2(96, 160)

var attacking = false
var can_attack = true


func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

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
	print(body)
	if body is SmallDemonBat and attacking: #player is swinging at bat
		print("bat has been hit") # Replace with function body.
	elif body is SmallDemonBat and not attacking: #player not attacking, player has been hit
		print("demon has hit player")
	#respawn()


func _on_attacking_col_2_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
