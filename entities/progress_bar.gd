extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = 100
	value = 100
	
func set_health(current: int) -> void:
	print("bar set to ", current)
	value = current


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
