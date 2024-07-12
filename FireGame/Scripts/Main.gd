extends Node2D

func _ready() -> void:
	var tile_interaction_system = get_node("TileInteractionSystem")
	
	var breakable_interaction = BreakableTile.new(80)
	tile_interaction_system.register_interaction(0 , Vector2i(37,2), breakable_interaction) # Assuming tile ID 1 is breakable
	
