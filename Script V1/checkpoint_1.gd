extends Area2D

@export var green_flag_texture: Texture2D
@onready var flag: Sprite2D = $Sprite2D

var activated := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not activated:
		activated = true
		body.spawn_position = global_position
		flag.texture = green_flag_texture   # NEW
		print("checkpoint reached")
