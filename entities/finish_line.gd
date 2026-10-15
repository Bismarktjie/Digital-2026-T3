extends Area2D

var finished := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not finished:
		finished = true
		show_mission_complete(body)

func show_mission_complete(player: Player) -> void:
	var layer := CanvasLayer.new()
	layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(layer)

	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	layer.add_child(box)

	var label := Label.new()
	label.text = "MISSION COMPLETE!\n" + player.timer_label.text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 48)
	box.add_child(label)

	var button := Button.new()
	button.text = "Back to Menu"
	button.pressed.connect(_on_menu_pressed)
	box.add_child(button)

	get_tree().paused = true

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://entities/StartMenu.tscn")
