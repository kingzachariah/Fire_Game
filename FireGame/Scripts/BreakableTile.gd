extends TileInteraction
class_name BreakableTile

var speed_threshold: float
const BREAK_BLOCK_PARTICLES = preload("res://FireGame/Scenes/break_block_particles.tscn")

# Called when the node enters the scene tree for the first time.
func _init(threshold: float):
	speed_threshold = threshold

func interact(tilemap: TileMap, tile_position: Vector2, velocity: Vector2, parent: Node) -> bool:
	#print("velocity:", velocity.length())
	if velocity.length() > speed_threshold:
		tilemap.erase_cell(0,tile_position)
		
		# Instantiate particle system at this location
		var particles_instance = BREAK_BLOCK_PARTICLES.instantiate()
		parent.add_child(particles_instance)
		
		var global_position = tilemap.map_to_local(tile_position) + tilemap.position
		
		particles_instance.global_position = global_position
		particles_instance.rotation =  velocity.angle()
		particles_instance.emitting=true
		
		return true
	return false
	
