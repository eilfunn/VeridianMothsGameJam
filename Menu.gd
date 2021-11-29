extends Node2D

onready var selector_one = $VBoxContainer/Start/selector1
onready var selector_two = $VBoxContainer/Load/selector2
onready var selector_three = $VBoxContainer/Quit/selector3


var current_selection = 0

func _ready():
	set_current_selection(0)

func _process(delta):
	if Input.is_action_just_pressed("ui_down") and current_selection < 2:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_accept"):
		handle_selection(current_selection)
		
	if $AudioStreamPlayer2D.playing == false:
		$AudioStreamPlayer2D.play()
	pass

func _on_VideoPlayer_finished():
	if $VideoPlayer.playing == false:
		$VideoPlayer.play()
	pass

func handle_selection(_current_selection):
	if _current_selection == 0:
		get_tree().change_scene("res://Scenes/WorldScenes/Mansion.tscn")
		queue_free()
	elif _current_selection == 1:
		print("Add saved game!")
	elif _current_selection == 2:
		get_tree().quit()

func set_current_selection(_current_selection):
	selector_one.visible = false
	selector_two.visible = false
	selector_three.visible = false
	
	if _current_selection == 0:
		selector_one.visible = true
	elif _current_selection == 1:
		selector_two.visible = true
	elif _current_selection == 2:
		selector_three.visible = true
		

