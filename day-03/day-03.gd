extends Node2D


const SHORT_DELAY = .005
const LONG_DELAY = 1

var symbol_node = load("res://day-03/symbol.tscn")
var number_node = load("res://day-03/number.tscn")

@export_file("*.txt") var input_file
var total = 0

var parts = []
var symbols = []
var numbers = []

# Called when the node enters the scene tree for the first time.
func _ready():
	C_.number_nearby.connect(number_nearby_handler)
	do_the_thing()
	populate_screen()
#	do_the_thing_boring()
#
#func do_the_thing_boring():
#	var input = load_file(input_file).strip_edges().split('\n')
#	for y in range(len(input)):
#		var line = input[y].split('')
#		var starting_x: int
#		var working_number = ''
#		for x in range(len(line)):
#			if line[x] in C_.NUMBERS:
#				if working_number == '':
#					starting_x = x
#				working_number += line[x]
#			else:
#				if working_number != '':
#					add_number(starting_x, y, working_number)
#					working_number = ''
#				if line[x] != '.':
#					add_symbol(x, y, line[x])


func populate_screen():
#	print(symbols.size())
#	print(numbers.size())
	await get_tree().create_timer(LONG_DELAY).timeout
	for s in symbols:
		add_child(s)
		await get_tree().create_timer(SHORT_DELAY).timeout

	await get_tree().create_timer(LONG_DELAY).timeout
	for n in numbers:
		add_child(n)
		await get_tree().create_timer(SHORT_DELAY).timeout

	await get_tree().create_timer(LONG_DELAY).timeout
	var running_total = 0
	for s in symbols:
		if s.parts.size() == 2:
			running_total = running_total + (s.parts[0] * s.parts[1])
	print(running_total)

func do_the_thing():
	var input = load_file(input_file).strip_edges().split('\n')
	for y in range(len(input)):
		var line = input[y].split('')
		var starting_x: int
		var working_number = ''
		for x in range(len(line)):
			if line[x] in C_.NUMBERS:
				if working_number == '':
					starting_x = x
				working_number = working_number + line[x]
			else:
				if working_number != '':
					add_number(starting_x, y, working_number)
					working_number = ''
				if line[x] != '.':
					add_symbol(x, y, line[x])
		if working_number != '':
			add_number(starting_x, y, working_number)
			working_number = ''

func add_symbol(x, y, value):
	var s = symbol_node.instantiate()
	s.value = value
	s.position = Vector2(x * C_.TILE_SIZE, y * C_.TILE_SIZE)
	symbols.push_back(s)

func add_number(x, y, value):
	var n = number_node.instantiate()
	n.value = value
	n.position = Vector2(x * C_.TILE_SIZE, y * C_.TILE_SIZE)
	numbers.push_back(n)

func load_file(file_name):
	var file = FileAccess.open(file_name, FileAccess.READ)
	var content = file.get_as_text()
	return content

func number_nearby_handler(num: NumberMarker):
	if parts.find(num) == -1:
#		print('number_nearby...%s' % num.value)
		parts.push_front(num)
#		total += num.value
#	else:
#		print('  one number hitting multiple symbols')
#	total += int(num.value)
#	print('  %s' % num.value)
#	print(total)
