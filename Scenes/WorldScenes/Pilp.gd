extends Area2D

var active = false

func _ready():
	connect("body_entered", self, "_on_Pilp_asked")
	connect("body_exited", self, "_on_Pilp_left")

func _input(event):
	if get_node_or_null("DailogNode") == null:
		if active:
			get_tree().paused = true
			var dialog = Dialogic.start("Greetings")
			dialog.pause_mode = Node.PAUSE_MODE_PROCESS
			dialog.connect("timeline_end", self, "unpause")
			add_child(dialog)

func unpaused(timeline_name):
	get_tree().paused = false

func _on_Pilp_asked(body):
	if body.name == "Player":
		active = true

func _on_Pilp_left(body):
	if body.name == "Player":
		active = false
