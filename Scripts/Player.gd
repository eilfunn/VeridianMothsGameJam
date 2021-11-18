extends KinematicBody2D

const MAX_SPEED = 120
const ACCELERATION = 900
const FRICTION = 600
const MAX_PP = 8
const BLAST_PP = 4
const BOLT_PP = 1

#onready var Global = get_node("/root/GlobalsOfDoom")
onready var Mansion = get_tree().get_root().get_node("Mansion")

# VARIABLES FOR THE MAGIC-POWER TIMER - Saultoons
var power_timer = null

var velocity = Vector2.ZERO

func _ready():
	create_power_timer() # Creating the power timer

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	move_state(delta)
	spell_state()

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

#Saul's timer for PP-meter, use this as a reference to other timers
func create_power_timer(): # Create a timer for the player's power meter
	power_timer = Timer.new() # Create the new timer
	power_timer.set_wait_time(1.0) # Will go off ever 1 second
	power_timer.connect("timeout",self,"_on_power_timer_timeout") # Connect the timer to process
	add_child(power_timer) # Add this as child node to player
	power_timer.start() # Start the timer

func _on_power_timer_timeout(): # Called when the timer goes off
	if Mansion.player_pp < MAX_PP: # If players power is less than max power
		Mansion.player_pp += 1 # Add 1 to players power 



