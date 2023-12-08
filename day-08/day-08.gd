extends Node2D

@export_file("*.txt") var input_file
var total = 0

func _ready():
	var input = C_.load_file(input_file).strip_edges().split('\n\n')
	var directions = input[0]
	var body = input[1]
	# [11309, 19199, 12361, 16043, 13939, 18673]
#	print('26 ->')
#	print(aggregate_numbers(find_prime_factors(26)))
#	print('55 ->')
#	print(aggregate_numbers(find_prime_factors(55)))
#	print('100 ->')
#	print(aggregate_numbers(find_prime_factors(100)))
#	print('256 ->')
#	print(aggregate_numbers(find_prime_factors(256)))
#	print('2 ->')
#	print(aggregate_numbers(find_prime_factors(2)))
	do_the_thing2(directions, body)

func do_the_thing2(directions, body):
	var desert_map = Array(body.split('\n')).reduce(
		func m(acc, cur):
			var line = cur.split(' = ')
			var name = line[0]
			var d = line[1].rstrip(')').lstrip('(').split(', ')
			var left = d[0]
			var right = d[1]
			acc[name] = { 'L': left, 'R': right }
			return acc,
			{}
	)

	var current_location = desert_map.keys().filter(func f(coord): return coord[2] == 'A')
	print('current_location.size(): %s' % current_location.size())
	var i = 0
	var l = len(directions)

	while not all_nodes_end_in_z(current_location):
		var direction = directions[i % l]
		current_location = current_location.map(
			func clm(loc):
				if loc is int:
					return loc
				var next_node = desert_map[loc][direction]
				if next_node[2] == 'Z':
					return i + 1
				return next_node
		)
#		print('  '.join(current_location))
		i = i + 1

	print(current_location)
	print(find_least_common_multiple(current_location))

func find_least_common_multiple(numbers):
	var data = {}
	for number in numbers:
		var factors = find_prime_factors(number)
		var aggregated = aggregate_numbers(factors)
		for key in aggregated:
			if key in data:
				data[key] = max(data[key], aggregated[key])
			else:
				data[key] = aggregated[key]

	var product = 1
	for key in data:
		product *= pow(key, data[key])

	return product

func aggregate_numbers(numbers):
	var data = {}
	for i in numbers:
		if i not in data:
			data[i] = 0
		data[i] += 1
	return data

func find_prime_factors(number) -> Array:
	if number == 4:
		return [2, 2]
	for i in range(2, int(number / 2)):
		if number % i == 0:
			var new_number = number / i
			var arr = find_prime_factors(new_number)
			arr.append(i)
			return arr
	return [number]

func all_nodes_end_in_z(current_locations):
	for loc in current_locations:
#		if loc[2] != 'Z':
		if not loc is int:
			return false
	return true

func do_the_thing(directions, body):
	var desert_map = Array(body.split('\n')).reduce(
		func m(acc, cur):
			var line = cur.split(' = ')
			var name = line[0]
			var d = line[1].rstrip(')').lstrip('(').split(', ')
			var left = d[0]
			var right = d[1]
			acc[name] = { 'L': left, 'R': right }
			return acc,
			{}
	)
	var current_location = 'AAA'
	var i = 0
	var l = len(directions)
	while current_location != 'Z':
		var direction = directions[i % l]
		current_location = current_location.map(
			func clm(loc):
				return desert_map[loc][direction]
		)
		i = i + 1
	print(i)

'''
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
'''
