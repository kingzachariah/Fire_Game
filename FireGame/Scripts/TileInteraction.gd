extends RefCounted

# Base class for tile interactions
class_name TileInteraction

# Called when the node enters the scene tree for the first time.
func interact(tilemap: TileMap, tile_position: Vector2, velocity: Vector2, parent: Node):
	pass
