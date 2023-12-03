class_name NumberMarker
extends Area2D

var value : int

func _ready():
	var l = len(str(value))
	for i in range(l):
		var sprite = Sprite2D.new()
		sprite.texture = load("res://day-03/number.png")
		sprite.position = Vector2(i * C_.TILE_SIZE + 2, 2)
		add_child(sprite)
	var rect = RectangleShape2D.new()
	var rect_x = (l * C_.TILE_SIZE) + 2
	var rect_y = C_.TILE_SIZE + 2
	var pos_x = (l * C_.TILE_SIZE) / 2
	var pos_y = C_.TILE_SIZE / 2
	rect.size = Vector2(rect_x, rect_y)
	$CollisionShape2D.position = Vector2(pos_x, pos_y)
	$CollisionShape2D.shape = rect
	
