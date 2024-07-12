extends TileInteraction
class_name BreakableTile

var speed_threshold: float

# Called when the node enters the scene tree for the first time.
func _init(threshold: float):
	speed_threshold = threshold

func interact(tilemap: TileMap, tile_position: Vector2, velocity: Vector2) -> void:
	print("velocity:", velocity.length())
	if velocity.length() > speed_threshold:
		tilemap.erase_cell(0,tile_position)
		# Add more logic here, like playing a breaking animation or sound
