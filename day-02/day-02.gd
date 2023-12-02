extends Control

const MAX_BLUE_COUNT = 14
const MAX_GREEN_COUNT = 13
const MAX_RED_COUNT = 12

const SHORT_DELAY = .05
const LONG_DELAY = .1

@export_file("*.txt") var input_file
var total = 0

func _ready():
	var body = load_file(input_file)
	$Input.text = body
	$Total.text = str(total)
	$Working.text = ''

func do_the_thing():
	while len($Input.text):
		await process_line_2() # <<<<<<<<<
		$Total.text = str(total)
		await get_tree().create_timer(LONG_DELAY).timeout
	print('total: %s' % total)

func process_line_2():
	var input_body = $Input.text.split('\n')
	var working_text = input_body[0]
	input_body.remove_at(0)
	$Input.text = '\n'.join(input_body)
	$Working.text = working_text
	await get_tree().create_timer(SHORT_DELAY).timeout
	
	var game_and_data = working_text.split(': ')
	var game_id = int(game_and_data[0].substr(5))
	var game_records = game_and_data[1].split('; ')

	var running_totals = extract_color_count('')
	for game_record in game_records:
		var counts = extract_color_count(game_record)
		for color in ['red', 'blue', 'green']:
			running_totals[color] = max(running_totals[color], counts[color])

	total += running_totals['red'] * running_totals['blue'] * running_totals['green']


func process_line_1():
	var input_body = $Input.text.split('\n')
	var working_text = input_body[0]
	input_body.remove_at(0)
	$Input.text = '\n'.join(input_body)
	$Working.text = working_text
	await get_tree().create_timer(SHORT_DELAY).timeout
	
	var game_and_data = working_text.split(': ')
	var game_id = int(game_and_data[0].substr(5))
	var game_records = game_and_data[1].split('; ')
	for game_record in game_records:
		var counts = extract_color_count(game_record)
		if counts['red'] > MAX_RED_COUNT or counts['blue'] > MAX_BLUE_COUNT or counts['green'] > MAX_GREEN_COUNT:
			return
	
	total += game_id

func extract_color_count(record: String):
	var counts = {
		'red': 0,
		'blue': 0,
		'green': 0,
	}
	
	if len(record):
		for color_count in record.split(', '):
			var cc = color_count.split(' ')
			counts[cc[1]] += int(cc[0])

	return counts;

func load_file(file_name):
	var file = FileAccess.open(file_name, FileAccess.READ)
	var content = file.get_as_text()
	return content

func _on_button_pressed():
	do_the_thing()
