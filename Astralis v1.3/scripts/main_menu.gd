extends Control
var video = false
func _ready() -> void:
	$CanvasLayer/VBoxContainer/PlayButton.grab_focus()
	

func _on_play_button_pressed() -> void:
	if video == false:
		get_tree().change_scene_to_file("res://scenes/main_intro.tscn")
		video = true
	else:
		get_tree().change_scene_to_file("res://scenes/aries.tscn")

func _on_config_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/config_menu.tscn")
	#get_tree().change_scene_to_file("res://menu_config.tscn")
func _on_exit_button_pressed() -> void:
	get_tree().quit()
	
