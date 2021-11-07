extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION = 500
const FRICTION = 500

#variable from jsalex7
const PLAYER_HOUSE_X = 250 #use this for set the spawning position when the player enters into a new place
const PLAYER_HOUSE_Y = 230

onready var Global = get_node("/root/GlobalsOfDoom")

var is_it_start = true
#end of jsalex7
var velocity = Vector2.ZERO

func _ready():
	var scene_name = get_tree().get_current_scene().get_name()
	if scene_name == "PlayerHouse" and !Global.is_it_start:
		self.position = Vector2(self.PLAYER_HOUSE_X, self.PLAYER_HOUSE_Y)
	Global.is_it_start = false

func _physics_process(delta):
	move_state(delta)
	pass

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity);

