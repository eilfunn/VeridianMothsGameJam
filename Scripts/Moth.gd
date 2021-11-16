extends Node2D

onready var player = get_parent().get_node("YSort").get_node("Player")

func _physics_process(delta):
	global_position = global_position.linear_interpolate((player.get_global_position() + Vector2(-15,-15)), delta * 4)
