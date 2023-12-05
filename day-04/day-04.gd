extends Node2D

@export_file("*.txt") var input_file
var total = 0

func _ready():
	var body = C_.load_file(input_file).strip_edges().split('\n')
	do_the_thing2(body)

func do_the_thing2(body):
	var winners = process_cards(body)
	print(process_winners(winners, 0, winners.size()))

func process_cards(body):
	return Array(body).map(
		func m(line):
			var card_data = line.split(': ')
			var numbers = card_data[1].split(' | ')
			var winning_numbers = Array(numbers[0].split(' ')).filter(func f(e): return e)
			var your_numbers = Array(numbers[1].split(' ')).filter(func f(e): return e)#.map(as_integer)
			var your_winning_numbers = your_numbers.filter(func f(n):
				return winning_numbers.find(n) != -1
			)
			return your_winning_numbers.size()
	)

func process_winners(cards, start_i, total):
	var running_total = 0
	for i in range(start_i, min(total, cards.size())):
		running_total += process_winners(cards, i + 1, i + 1 + cards[i]) + 1
	return running_total

func process_cards_bck(body, start_i, total):
	var running_total = 0
	for i in range(start_i, min(total, body.size())):
		var line = body[i]

		var card_data = line.split(': ')
		var numbers = card_data[1].split(' | ')
		var winning_numbers = Array(numbers[0].split(' ')).filter(filter_numbers).map(as_integer)
		var your_numbers = Array(numbers[1].split(' ')).filter(filter_numbers).map(as_integer)
		var your_winning_numbers = your_numbers.filter(func f(n):
			return winning_numbers.find(n) != -1
		)
		running_total += process_cards_bck(body, i + 1, i + 1 + your_winning_numbers.size()) + 1
	return running_total

func do_the_thing(body):
	
#	print(body)
	for line in body:
		var card_data = line.split(': ')
		var numbers = card_data[1].split(' | ')
		var winning_numbers = Array(numbers[0].split(' ')).filter(filter_numbers).map(as_integer)
		var your_numbers = Array(numbers[1].split(' ')).filter(filter_numbers).map(as_integer)
		var your_winning_numbers = your_numbers.filter(func f(n):
			return winning_numbers.find(n) != -1
		)
		if your_winning_numbers.size():
			total += pow(2, your_winning_numbers.size() - 1)
	print(total)

func filter_numbers(n):
#	print('"%s"' % n)
	return n

func as_integer(n):
	return int(n)
