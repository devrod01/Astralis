extends AudioStreamPlayer

func _ready() -> void:
	stream = load("res://assets/music/MainMenuMusic.ogg")
	volume_db = -80
	var tweener = create_tween()
	tweener.tween_property(self,'volume_db',0, 1.0)
	#tweener.tween_property("volume_db", 80, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	play()
	

func _process(_delta):
	print("Current Volume: ", volume_db)
