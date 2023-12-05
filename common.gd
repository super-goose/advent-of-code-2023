extends Node

signal number_nearby(number)

const TILE_SIZE = 4
const NUMBERS = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

func load_file(file_name):
	var file = FileAccess.open(file_name, FileAccess.READ)
	var content = file.get_as_text()
	return content

func between(n, minimum, maximum):
	return n >= minimum and n <= maximum
