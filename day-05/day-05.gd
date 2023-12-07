extends Node2D

@export_file("*.txt") var input_file
var total = 0
var minimum_location = INF

func _ready():
	var body = C_.load_file(input_file).strip_edges().split('\n\n')
	do_the_thing_quickly(body)

func do_the_thing_quickly(body):
	var seed_ranges = build_seed_range(Array(body[0].replace('seeds: ', '').split(' ')).map(func (n): return int(n)))
	var transformers = []
	for i in range(1, body.size()):
		var current = Array(body[i].split('\n'))
		current.pop_front()
		transformers.push_back(build_ranges(current))

	process_ranges(seed_ranges, transformers, 0)
	
	print(minimum_location)


# THIS IS THE WAY!!
func process_ranges(starting_ranges, transformers, iteration):
	for starting_range in starting_ranges:
		var next_range = []
		var min = starting_range[0]
		var max = starting_range[1]
		var ranges = transformers[iteration]
		for map_range in ranges:
			if map_range['max'] < min:
				continue
			if map_range['min'] > max:
				continue
			var new_min = max(min, map_range['min'])
			var new_max = min(max, map_range['max'])
			next_range.push_back([new_min + map_range['offset'], new_max + map_range['offset']])
		if iteration == transformers.size() - 1:
			var local_minimum = next_range.reduce(
				func r(acc, cur):
					return min(acc, cur[0]),
				INF
			)
			minimum_location = min(minimum_location, local_minimum)
		else:
			process_ranges(next_range, transformers, iteration + 1)
			


func build_ranges(mapping):
	var new_map = mapping.map(
		func d(e):
			var raw = e.split(' ')
			return {
				'min': int(raw[1]),
				'max': int(raw[1]) + int(raw[2]) - 1,
				'offset': int(raw[0]) - int(raw[1])
			}
	)
	new_map.sort_custom(
		func s(a, b):
			return a['min'] < b['min']
	)
	var final_map = []
	var last_number = -1
	for i in range(new_map.size()):
		if new_map[i]['min'] != last_number + 1:
			final_map.push_back({
				'min': last_number + 1,
				'max': new_map[i]['min'] - 1,
				'offset': 0,
			})
		final_map.push_back(new_map[i])
		last_number = new_map[i]['max']
	final_map.push_back({
		'min': last_number + 1,
		'max': INF,
		'offset': 0,
	})
	return final_map

func do_the_thing(body):
	var full_reverse_converter = build_full_reverse_converter(body)
	var seeds_definition = Array(body[0].replace('seeds: ', '').split(' ')).map(func (n): return int(n))
	var i = 0
	
	while true:
		var possible_seed = full_reverse_converter.call(i)
		if i % 1000 == 0:
			print('%s ----- %s' % [i, possible_seed])
		if is_valid_seed(possible_seed, seeds_definition):
			print(i)
			return
		i += 1
#	var seeds = build_seed_range(seeds_definition, full_converter)

#	print(seeds)
#	print(seeds.reduce(func (acc, cur): return min(acc, cur), INF))

func is_valid_seed(seed, definition):
	var start: int
	var list_of_lists = []
	var m = INF
	for i in range(definition.size()):
		if i % 2 == 0:
			start = definition[i]
		elif C_.between(seed, start, start + definition[i]):
			return true
	return false

func build_full_reverse_converter(body):
	var converters = []
	for i in range(1, body.size()):
		var current = Array(body[i].split('\n'))
		current.pop_front()
		converters.push_front(build_reverse_converter(current))
#
#		push front and build reverse converter
#
#		seeds = seeds.map(converter)
	return func full_reverse_converter(source):
		return converters.reduce(
			func (acc, current):
				return current.call(acc),
			source
		)

func build_full_converter(body):
	var converters = []
	for i in range(1, body.size()):
		var current = Array(body[i].split('\n'))
		current.pop_front()
		converters.push_back(build_converter(current))
#		seeds = seeds.map(converter)
	return func full_converter(source):
		return converters.reduce(
			func (acc, current):
				return current.call(acc),
			source
		)


func build_reverse_converter(input):
	var rules = input.map(rule_map)
	return func convert_to_source(destination):
		var rule = rules.filter(
			func rule_filter(n):
				return C_.between(destination, n['destination'], n['destination'] + n['range'])
		)
		
		if rule.size() == 0:
			return destination
		
		return destination - rule[0]['destination'] + rule[0]['source']

func build_converter(input):
	var rules = input.map(rule_map)
	return func convert_to_destination(source):
		var rule = rules.filter(
			func rule_filter(n):
				return C_.between(source, n['source'], n['source'] + n['range'])
		)
		
		if rule.size() == 0:
			return source
		
		return source - rule[0]['source'] + rule[0]['destination']
		

func build_seed_range(definition):
	var start: int
	var list_of_lists = []
	var m = INF
	for i in range(definition.size()):
		if i % 2 == 0:
			start = definition[i]
			print(definition[i])
		else:
			list_of_lists.push_back([start, start + definition[i] - 1])

	return list_of_lists

func rule_map(line):
	var d = line.split(' ')
	return {
		'destination': int(d[0]),
		'source': int(d[1]),
		'range': int(d[2]),
	}


