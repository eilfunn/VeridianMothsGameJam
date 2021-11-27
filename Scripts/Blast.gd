extends Node2D

onready var Mansion = get_tree().get_root().get_node("Mansion")
onready var player = get_tree().get_root().get_node("Mansion/YSort/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.visible = Mansion.blast_visible
	if self.visible:
		self.global_position = player.global_position
		if Mansion.player_aim == "Up":
			self.set_rotation_degrees(0)
		elif Mansion.player_aim == "Right":
			self.set_rotation_degrees(90)
		elif Mansion.player_aim == "Down":
			self.set_rotation_degrees(180)
		elif Mansion.player_aim == "Left":
			self.set_rotation_degrees(270)
pass
