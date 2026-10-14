extends ProgressBar

@export var player: Player

func _ready() -> void:
	max_value = player.max_health
	value = player.health
	player.health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(new_health: int) -> void:
	value = new_health
