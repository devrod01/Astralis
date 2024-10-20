extends Label

var page = 0 
# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		page += 1
		
		if page ==1:
			text = (str("Aperte de novo"))
		elif page ==2:
			get_tree().change_scene_to_file("res://scenes/aries.tscn")
