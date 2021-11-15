extends KinematicBody2D

const FRICTION = 500
const ACCELARATION = 200
const MAX_SPEED = 50

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO

# Starting state
var state = IDLE

# Get reference to Animation Tree node
onready var animationTree = $AnimationTree
onready var animationState = $AnimationTree.get("parameters/playback")

# Get reference to the Detection Zone node
onready var playerDetectionZone = $DetectionZone

func _physics_process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			animationTree.set("parameters/Idle/blend_position", velocity)
			animationState.travel("Idle")
			seek_player()
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				animationTree.set("parameters/AttackMode/blend_position", velocity)
				animationState.travel("AttackMode")
				
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELARATION * delta)
			else:
				state = WANDER # can also be changed to IDLE if we want the ghost to stop
	
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
