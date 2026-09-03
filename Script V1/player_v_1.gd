extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 400.0
const JUMP_VELOCITY = -450.0
var start_position = Vector2(96,160)
@onready var camera = $Camera2D
@onready var background = "../Background"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	#handle run
	if is_on_floor():
		if velocity.x > 1 or velocity.x < -1:
			animated_sprite_2d.play("run")
		elif Input.is_action_just_pressed("attack_3"):
			animated_sprite_2d.play("attack_3")
		else:
			animated_sprite_2d.play("idle")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animated_sprite_2d.play("jump")
		velocity.y = JUMP_VELOCITY
	#if Input.is_action_just_pressed("attack") and is_on_floor():
		#animated_sprite_2d.pause()
		#animated_sprite_2d.play("attack_3")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		
	move_and_slide()
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true
	
	#background.position = camera.position


	if position.y > 30000:
		respawn()


func respawn():
	position = start_position 
	
