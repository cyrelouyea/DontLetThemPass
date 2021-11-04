extends Node

var fname = "data.save"

func save_file(dict: Dictionary):
	var save_game = File.new()
	save_game.open("user://" + fname, File.WRITE)
	save_game.store_line(to_json(dict))
	
func load_file():
	var save_game = File.new()
	if not save_game.file_exists("user://" + fname):
		return
	save_game.open("user://" + fname, File.READ)
	if save_game.get_position() < save_game.get_len():
		return parse_json(save_game.get_line())
	else:
		return
