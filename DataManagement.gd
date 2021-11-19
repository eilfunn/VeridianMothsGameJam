extends Node

# ELLY
#const file_name = "save.data"
#var data = {}
#
#func _ready():
#	load_data()
#
#func load_data():
#	var file = File.new()
#	if file.file_exists("user://"+file_name):
#		file.open("user://"+file_name, File.READ)
#		data = file.get_var()
#		file.close()
#
#func save_data():
#	var file = File.new()
#	file.open("user://"+file_name, File.WRITE)
#	file.store_var(data)
#	file.close()

# SAULTOONS
onready var save_nodes = get_tree().get_nodes_in_group("Persist")
onready var player = get_node("YSort/Player")

func _process(delta):
	if Input.is_key_pressed(KEY_O):
		print("Saving Game")
		for i in save_nodes:
			save_game()
	if Input.is_key_pressed(KEY_P):
		print("Loading Game")
		load_game()

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.filename.empty():
			print("persistent node '%s' is not instanced scene, skipped" % node.name)
			continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		
		save_game.store_line(to_json(node_data))
	save_game.close()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	# We need to revert the game state so we're not cloning objects during loading. This will vary wildly depending on the needs of a project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()
	# Load the file line by line and process that dictionary to restore the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
	save_game.close()
