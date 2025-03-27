extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var score = get_parent().get_parent().load_from_file()
	if score:
		self.text = "HIGH SCORE: " + str(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
