extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var background = $"../Background" # Fixed node reference

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
		attacking = true
		can_attack = false
		animated_sprite_2d.play("attack_3")
		$attacking.start()
		$attack_again.start()

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle movement
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite_2d.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle ground animations (only play when not attacking)
	if not attacking:
		if not is_on_floor():
			animated_sprite_2d.play("jump")
		elif abs(velocity.x) > 1:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")

	move_and_slide()

	if position.y > 30000:
		respawn()

func respawn():
	position = start_position

# Signal callbacks connected to $attack_timer and $attack_again_timer
func _on_attack_timer_timeout() -> void:
	attacking = false

func _on_attack_again_timer_timeout() -> void:
	can_attack = true
