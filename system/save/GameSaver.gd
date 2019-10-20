extends Node

const SaveGame = preload('res://system/save/SaveGame.gd')
const SAVE_FOLDER = "res://debug/save"
const SAVE_NAME = "savegame.tres"

func save_game():
	"""
	Passes a SaveGame resource to all nodes to save data from
	and writes it to the disk
	"""
	var save_game = SaveGame.new()
	for node in get_tree().get_nodes_in_group('save'):
		node.save_game(save_game)

	var directory = Directory.new()
	if not directory.dir_exists(SAVE_FOLDER):
		directory.make_dir_recursive(SAVE_FOLDER)
	
	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME)
	var error = ResourceSaver.save(save_path, save_game)
	if error != OK:
		print('There was an issue writing the save to %s' % [save_path])

func load_game():
	"""
	Reads a saved game from the disk and delegates loading
	to the individual nodes to load
	"""
	var save_file_path = SAVE_FOLDER.plus_file(SAVE_NAME)
	var file = File.new()
	if not file.file_exists(save_file_path):
		print("Save file %s doesn't exist" % save_file_path)
		return

	var save_game = load(save_file_path)
	for node in get_tree().get_nodes_in_group('save'):
		node.load_game(save_game)

func delete_save():
	var save_file_path = SAVE_FOLDER.plus_file(SAVE_NAME)
	var directory = Directory.new()
	if directory.file_exists(save_file_path):
		directory.remove(save_file_path)

func save_exists():
	var save_file_path = SAVE_FOLDER.plus_file(SAVE_NAME)
	var directory = Directory.new()
	return directory.file_exists(save_file_path)