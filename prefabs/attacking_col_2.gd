extends Area2D

class_name sword_area

# Called when the node enters the scene tree for the first time.

func KillEnemies() -> void:
	for Ent in get_overlapping_bodies():
		if Ent is SmallDemonBat:
			Ent.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _ready():
	add_to_group("player")
