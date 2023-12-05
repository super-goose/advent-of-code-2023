extends Node2D

@export_file("*.txt") var input_file
var total = 0

func _ready():
	var body = C_.load_file(input_file).strip_edges().split('\n\n')
	do_the_thing(body)

func do_the_thing(body):
	var full_converter = build_full_converter(body)
	var seeds_definition = Array(body[0].replace('seeds: ', '').split(' ')).map(func (n): return int(n))
	var seeds = build_seed_range(seeds_definition, full_converter)

	print(seeds)
#	print(seeds.reduce(func (acc, cur): return min(acc, cur), INF))

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
		

func build_seed_range(definition, converter):
	var start: int
	var list_of_lists = []
	var m = INF
	for i in range(definition.size()):
		if i % 2 == 0:
			start = definition[i]
			print(definition[i])
		else:
			for j in range(8700000, 9000000):
				var newest = converter.call(start + definition[i] - j)
				if m > newest:
					m = newest
				else:
					print(m)
					print(newest)
					breakpoint
#				print('  %s' % converter.call(start + definition[i] - j))
#			print('  %s' % converter.call(start))
#			print('  %s' % converter.call(start + definition[i] - 10000000))
#			print('  %s' % converter.call(start + definition[i] - 9000000))
#			print('  %s' % converter.call(start + definition[i] - 8700000))
#			print('  %s' % converter.call(start + definition[i] - 8000000))
#			print('  %s' % converter.call(start + definition[i] - 7500000))
#			print('  %s' % converter.call(start + definition[i]))
#	return m                                                      67911591

func rule_map(line):
	var d = line.split(' ')
	return {
		'destination': int(d[0]),
		'source': int(d[1]),
		'range': int(d[2]),
	}


