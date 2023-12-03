extends Area2D

var value : String
var parts = []

func _on_area_entered(area):
	if value == '*':
		parts.push_back(int(area.value))
#	C_.number_nearby.emit(area)


func _on_button_pressed():
	print(value)
