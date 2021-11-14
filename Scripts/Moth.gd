extends Node2D

onready var moth = get_parent().get_node("Moth")
onready var player = get_parent().get_node("Player")

func _physics_process(delta):
	moth.global_position = moth.global_position.linear_interpolate((player.get_global_position() + Vector2(-15,-15)), delta * 4)
