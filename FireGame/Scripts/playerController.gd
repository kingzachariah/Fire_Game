extends CharacterBody2D

#MovementData

@export var movement_datas : Array[PlayerMovementData] = []
@onready var current_movement_data = movement_datas[0]

@onready var ground_horizontal_acceleration = current_movement_data.ground_max_move_speed / current_movement_data.floor_time_to_max_speed
@onready var air_horizontal_acceleration = current_movement_data.air_max_move_speed / current_movement_data.air_time_to_max_speed
@onready var stopping_horizontal_acceleration = current_movement_data.ground_max_move_speed / current_movement_data.floor_time_to_stop

@onready var jump_velocity : float = ((2.0 * current_movement_data.max_jump_height) / current_movement_data.jump_time_to_peak )* -1
@onready var max_jump_gravity : float = ((jump_velocity * jump_velocity) / (2.0 * current_movement_data.max_jump_height)) 
@onready var min_jump_gravity : float = ((jump_velocity * jump_velocity) / (2.0 * current_movement_data.min_jump_height)) 
@onready var fall_gravity : float = ((-2.0 * current_movement_data.max_jump_height) / (current_movement_data.jump_time_to_descent * current_movement_data.jump_time_to_peak)) * -1

@onready var fire_parent = $"Node/Fire Parent"

var interaction_system: TileInteractionSystem

var jump_buffer:bool = false
var coyote_time:bool = false
var can_jump = false

func _ready():
	interaction_system = get_node("/root/Main/TileInteractionSystem")
	if interaction_system == null:
		print("Error: TileInteractionSystem not found")
	else:
		print("TileInteractionSystem successfully assigned")
	
	
	var pickups = get_tree().get_nodes_in_group("pickups")
	for pickup in pickups:
		pickup.picked_up.connect(pickedup)

func _physics_process(delta):
	# Add the gravity.
	velocity.y += get_gravity() * delta
	#update movement data
	change_movement_data()
	
	if !fire_parent.is_dead:
		#handle movement and jump
		handle_horizontal_movement(delta,get_input_velocity())
		handle_jump()
	else:
		velocity = velocity - velocity*delta
	
	#check for collisions before moving
	var collisions = check_for_collisions(delta)
	for collision in collisions:
		handle_collision(collision)
		
	
	#other
	move_and_slide()
	
	queue_redraw()

func change_movement_data() -> void:
	var current_size = fire_parent.fires.size() - 1
	##print("current size: ", current_size)
	current_size = clamp(current_size ,0 ,fire_parent.fire_textures.size() -1)
	
	current_movement_data = movement_datas[current_size]
	
	ground_horizontal_acceleration = current_movement_data.ground_max_move_speed / current_movement_data.floor_time_to_max_speed
	air_horizontal_acceleration = current_movement_data.air_max_move_speed / current_movement_data.air_time_to_max_speed
	stopping_horizontal_acceleration = current_movement_data.ground_max_move_speed / current_movement_data.floor_time_to_stop

	jump_velocity = ((2.0 * current_movement_data.max_jump_height) / current_movement_data.jump_time_to_peak )* -1
	max_jump_gravity = ((jump_velocity * jump_velocity) / (2.0 * current_movement_data.max_jump_height)) 
	min_jump_gravity = ((jump_velocity * jump_velocity) / (2.0 * current_movement_data.min_jump_height)) 
	fall_gravity = ((-2.0 * current_movement_data.max_jump_height) / (current_movement_data.jump_time_to_descent * current_movement_data.jump_time_to_peak)) * -1

func get_gravity() -> float:
	if Input.is_action_pressed("jump") and velocity.y < 50:
		return max_jump_gravity
	elif velocity.y < 0:
		return min_jump_gravity
	else:
		return fall_gravity
		

func jump() -> void:
	velocity.y = jump_velocity
	can_jump = false

func handle_jump():
	var try_jump = false
	if is_on_floor():
		if coyote_time == false:
			coyote_time = true
			get_tree().create_timer(current_movement_data.coyote_timer).timeout.connect(on_coyote_timer_timeout)
		if jump_buffer == true:
			try_jump = true
	
	if Input.is_action_just_pressed("jump"):
		if coyote_time == true:
			try_jump = true
			coyote_time = false
		if jump_buffer == false:
			jump_buffer = true
			get_tree().create_timer(current_movement_data.jump_buffer_timer).timeout.connect(on_jump_buffer_timeout)
		
	if try_jump:
		jump()

#float for delta , horizontal input value
func handle_horizontal_movement(delta:float,horizontal_input:float):
	if is_on_floor():
		if velocity.x * horizontal_input < 0:
			velocity.x = move_toward(velocity.x, horizontal_input * current_movement_data.ground_max_move_speed, stopping_horizontal_acceleration * delta) 
		else :
			velocity.x = move_toward(velocity.x, horizontal_input * current_movement_data.ground_max_move_speed, ground_horizontal_acceleration * delta) 
	else:
		velocity.x = move_toward(velocity.x, horizontal_input * current_movement_data.air_max_move_speed, air_horizontal_acceleration * delta) 

func get_input_velocity()-> float:
	var horizontal := 0.0
	if Input.is_action_pressed("left"):
		horizontal -= 1.0
	elif Input.is_action_pressed("right"):
		horizontal += 1.0
	return horizontal

func on_jump_buffer_timeout() -> void:
	jump_buffer = false

func on_coyote_timer_timeout() -> void:
	coyote_time = false

func pickedup(_body):
	fire_parent.call_deferred("add_fire")
	

func check_for_collisions(delta:float) -> Array[KinematicCollision2D]:
	var collisions: Array[KinematicCollision2D] = []
	var test_velocity = velocity * delta * 1.5
	var remaining_velocity = test_velocity
	var max_iterations = 3
	var iteration = 0
	
	var collision = move_and_collide(test_velocity, true)
	
	while collision != null and iteration < max_iterations:
		collisions.append(collision)
		
		remaining_velocity = collision.get_remainder() 
		
		if remaining_velocity.length() <= 0.01:
			break
			
		
		collision = move_and_collide(remaining_velocity, true)
		iteration += 1
	
	return collisions
	

func handle_collision(collision: KinematicCollision2D):
	var colliding_object = collision.get_collider()
	
	if colliding_object is TileMap:
		var tilemap: TileMap = colliding_object as TileMap
		var collision_position = collision.get_position()
		var tile_position = tilemap.local_to_map(collision_position)
		
		if interaction_system.handle_interaction(tilemap, tile_position, velocity):
			velocity *= 0.5
		
	

