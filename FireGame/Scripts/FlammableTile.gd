extends TileInteraction
class_name FlammableTile

var burn_speed: float


# Called when the node enters the scene tree for the first time.
func _init(_burn_speed: float):
	burn_speed = _burn_speed

func interact(tilemap: TileMap, tile_position: Vector2, velocity: Vector2, parent: Node) -> bool:
	
	return false
	
