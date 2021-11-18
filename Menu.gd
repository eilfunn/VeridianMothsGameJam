extends Node2D

var selected_menu = 0

func change_menu_color():
	$NewGame.color = Color("#0b3c36")
	$LoadGame.color = Color("#0b3c36")
	$Quit.color = Color("#0b3c36")
	
	match selected_menu:
		0:
			$NewGame.color = Color.black
		1:
			$LoadGame.color = Color.black
		2:
			$Quit.color = Color.black

func _ready():
	change_menu_color()

func _input(event):
	if Input.is_action_just_pressed("ui_down"):
		selected_menu = (selected_menu + 1) % 3;
		change_menu_color()
	elif Input.is_action_just_pressed("ui_up"):
		if selected_menu > 0:
			selected_menu = selected_menu - 1
		else:
			selected_menu = 2
		change_menu_color()
	elif Input.is_action_just_pressed("ui_accept"):
		match selected_menu:
			0:
				# New game
				get_tree().change_scene("res://Scenes/WorldScenes/Mansion.tscn")
			1:
				# Load game
				var next_level_resource = load("res://Scenes/WorldScenes/Mansion.tscn");
				var next_level = next_level_resource.instance()
				next_level.load_saved_game = true
				get_tree().root.call_deferred("add_child", next_level)
				queue_free()
			2:
				# Quit game
				get_tree().quit()
