extends KinematicBody2D

const MAX_SPEED = 120
const ACCELERATION = 900
const FRICTION = 600
const MAX_PP = 8
const BLAST_PP = 4

#variable from jsalex7
#const PLAYER_HOUSE_X = 250 #use this for set the spawning position when the player enters into a new place
#const PLAYER_HOUSE_Y = 230

#onready var Global = get_node("/root/GlobalsOfDoom")
onready var Mansion = get_tree().get_root().get_node("Mansion")

var velocity = Vector2.ZERO

#func _ready():
#	var scene_name = get_tree().get_current_scene().get_name()
#	if scene_name == "PlayerHouse" and !Global.is_it_start:
#		self.position = Vector2(self.PLAYER_HOUSE_X, self.PLAYER_HOUSE_Y)
#	Global.is_it_start = false

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	move_state(delta)
	pp_counter()
	spell_state()
	
func pp_counter():
	yield(get_tree().create_timer(1.0), "timeout")
	if Mansion.player_pp < MAX_PP:
		Mansion.player_pp += 1
		#print(Mansion.player_pp)


func spell_state():
	if Input.is_action_just_pressed("ui_select") and Mansion.blast_visible == false and Mansion.player_pp >= BLAST_PP:
		Mansion.blast_visible = true
		Mansion.player_pp -= BLAST_PP
		yield(get_tree().create_timer(2.0), "timeout")
		Mansion.blast_visible = false

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if (input_vector.x < 0):
			$Sprite.flip_h = true;
		else:
			$Sprite.flip_h = false;
		
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity);

