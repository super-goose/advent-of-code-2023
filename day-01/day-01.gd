extends Control

const SHORT_DELAY = .01
const LONG_DELAY = .02
const NUMBERS = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
const WORDS = [
	'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', #'zero'
]
var WORD_MAP = {
	'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9,
}

@export_file("*.txt") var input_file
var total = 0

func _ready():
	var body = load_file(input_file)
	$Input.text = body
	$Total.text = str(total)
	$Working.text = ''

func do_the_thing():
	while len($Input.text):
		await process_line_1() # <<<<<<<<<
		$Total.text = str(total)
		await get_tree().create_timer(LONG_DELAY).timeout
	print('total: %s' % total)

func process_line_1():
	var input_body = $Input.text.split('\n')
	var working_text = input_body[0]
	input_body.remove_at(0)
	$Input.text = '\n'.join(input_body)
	$Working.text = working_text
	await get_tree().create_timer(SHORT_DELAY).timeout
	
	while working_text[0] not in NUMBERS or working_text[len(working_text) - 1] not in NUMBERS:
		if working_text[0] not in NUMBERS:
			working_text = working_text.substr(1, len(working_text) - 1)
			$Working.text = working_text
#			await get_tree().create_timer(SHORT_DELAY).timeout
		if working_text[len(working_text) - 1] not in NUMBERS:
			working_text = working_text.substr(0, len(working_text) - 1)
			$Working.text = working_text
#			await get_tree().create_timer(SHORT_DELAY).timeout

	var current_number = "%s%s" % [working_text[0], working_text[len(working_text) - 1]]
	await get_tree().create_timer(SHORT_DELAY).timeout
	$Working.text = current_number
	total += int(current_number)

func process_line_2():
	var input_body = $Input.text.split('\n')
	var working_text = input_body[0]
	input_body.remove_at(0)
	$Input.text = '\n'.join(input_body)
	$Working.text = working_text
	await get_tree().create_timer(SHORT_DELAY).timeout
	
	while working_text[0] not in NUMBERS or working_text[len(working_text) - 1] not in NUMBERS:
		working_text = massage_working_text(working_text)
		$Working.text = working_text
#		await get_tree().create_timer(SHORT_DELAY).timeout
		if working_text[0] not in NUMBERS:
			working_text = working_text.substr(1, len(working_text) - 1)
			$Working.text = working_text
#			await get_tree().create_timer(SHORT_DELAY).timeout
		if working_text[len(working_text) - 1] not in NUMBERS:
			working_text = working_text.substr(0, len(working_text) - 1)
			$Working.text = working_text
#			await get_tree().create_timer(SHORT_DELAY).timeout

	var current_number = "%s%s" % [working_text[0], working_text[len(working_text) - 1]]
	await get_tree().create_timer(SHORT_DELAY).timeout
	$Working.text = current_number
	total += int(current_number)

func massage_working_text(line: String):
	for word in WORDS:
		if line.find(word) == 0:
			line = "%s%s" % [WORD_MAP[word], line.substr(len(word))]
		if line.rfind(word) == len(line) - len(word) and line.rfind(word) != -1:
			line = "%s%s" % [line.substr(0, len(line) - len(word)), WORD_MAP[word]]
	return line


func load_file(file_name):
	var file = FileAccess.open(file_name, FileAccess.READ)
	var content = file.get_as_text()
	return content

func _on_button_pressed():
	do_the_thing()
