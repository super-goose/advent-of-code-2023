extends Node2D

@export_file("*.txt") var input_file
var total = 0

'''
Time:      7  15   30
Distance:  9  40  200
'''
func _ready():
	var body = C_.load_file(input_file).strip_edges().split('\n')
#	var times = body[0].replace('Time:', '').strip_edges().split(' ', false)
#	var dist = body[1].replace('Distance:', '').strip_edges().split(' ', false)
	var times = ''.join(body[0].replace('Time:', '').strip_edges().split(' ', false))
	var dist = ''.join(body[1].replace('Distance:', '').strip_edges().split(' ', false))
	print(get_ways_to_win({
		'time': int(times),
		'dist': int(dist),
	}))
#	var data = []
#
#	for i in range(times.size()):
#		data.push_back({ 'time': int(times[i]), 'dist': int(dist[i]) })
#
#	do_the_thing(data)

func do_the_thing(data):
	var ways_to_win = data.reduce(
		func r(acc, cur):
			var w2w = get_ways_to_win(cur)
			print(w2w)
			return acc * w2w,
		1
	)
	print(ways_to_win)

func get_ways_to_win(race):
	for i in range(0, int(race['time'] / 2)):
		var going = race['time'] - i
		var d = going * i
		if d > race['dist']:
			return race['time'] + 1 - (i * 2)
