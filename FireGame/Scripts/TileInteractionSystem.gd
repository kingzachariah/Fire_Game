extends Node
class_name TileInteractionSystem

# A dictionary to hold different types of tile interactions
var interactions = {}

# Register a new interaction type
func register_interaction(tile_id: int, atlas_coords: Vector2i, interaction: TileInteraction) -> void:
	interactions[atlas_coords] = interaction

# Handle the interaction based on tile ID
func handle_interaction(tilemap: TileMap, tile_position: Vector2, velocity: Vector2) -> bool:
	var tile_id = tilemap.get_cell_atlas_coords(0, tile_position)

	##print(tile_id)
	if tile_id in interactions:
		return interactions[tile_id].interact(tilemap, tile_position, velocity)
	return false
