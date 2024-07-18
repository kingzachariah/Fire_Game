extends Node

class_name PlayerCollisions

@onready var player = $".."

func check_for_collisions(delta:float) -> Array[KinematicCollision2D]:
	var collisions: Array[KinematicCollision2D] = []
	var test_velocity = player.velocity * delta * 1.5
	var remaining_velocity = test_velocity
	var max_iterations = 3
	var iteration = 0
	
	var collision = player.move_and_collide(test_velocity, true)
	
	while collision != null and iteration < max_iterations:
		collisions.append(collision)
		remaining_velocity = collision.get_remainder() 
		
		if remaining_velocity.length() <= 0.01:
			break
			
		
		collision = player.move_and_collide(remaining_velocity, true)
		iteration += 1
	
	return collisions
	

func handle_collision(collision: KinematicCollision2D):
	var colliding_object = collision.get_collider()
	
	if colliding_object is TileMap:
		var tilemap: TileMap = colliding_object as TileMap
		var collision_position = collision.get_position()
		var tile_position = tilemap.local_to_map(collision_position)
		
		var broke_block = player.interaction_system.handle_interaction(tilemap, tile_position, player.velocity)
		if broke_block:
			player.velocity *= 0.5
		
	
