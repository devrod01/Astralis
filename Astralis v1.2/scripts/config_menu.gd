extends Control

func _ready() -> void:
	$CanvasLayer/VBoxContainer/Voltar.grab_focus()

func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_audio_pressed() -> void:
	pass # Replace with function body.

func _on_video_pressed() -> void:
	pass # Replace with function body.

func _on_controles_pressed() -> void:
	pass # Replace with function body.

func _on_idiomas_pressed() -> void:
	pass # Replace with function body.
