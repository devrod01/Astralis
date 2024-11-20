extends Control
var video = false

@onready var music_player = $MainMenuMusic
func _ready() -> void:
	$CanvasLayer/VBoxContainer/PlayButton.grab_focus()
	# Inicia a música
	music_player.play()
	var tween = get_tree().create_tween()
	# Anima o volume de -80 dB para 0 dB (volume normal)
	tween.interpolate_value(
		music_player, "volume_db", 
		-80, 0, 
		3,  # Duração em segundos
		tween.TRANS_LINEAR
	)
	tween.play()
	
func _on_play_button_pressed() -> void:
	if video == false:
		get_tree().change_scene_to_file("res://main_intro.tscn")
		video = true
	else:
		get_tree().change_scene_to_file("res://scenes/aries.tscn")

func _on_config_button_pressed() -> void:
	get_tree().change_scene_to_file("res://config_menu.tscn")
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()
