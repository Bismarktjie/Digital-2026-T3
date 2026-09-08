extends CharacterBody2D
@onready var terget=$"../player"
var speed=100
func _physics_process(delta):
	var direction=(terget.psition-position).normalized()
	velocity=direction * speed
	#look_at(terget.position)
	move_and_slide()
