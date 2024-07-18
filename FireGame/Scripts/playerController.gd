extends CharacterBody2D

var interaction_system: TileInteractionSystem

@onready var fire_parent = $"FireRoot/Fire Parent"
@onready var player_collisions = $PlayerCollisions
@onready var player_state = $PlayerState

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
	player_state.change_movement_data()
	
	if !fire_parent.is_dead:
		#handle movement and jump
		handle_horizontal_movement(delta,get_input_velocity())
		handle_jump()
	else:
		velocity = velocity - velocity*delta
	
	#check for collisions before moving
	var collisions = player_collisions.check_for_collisions(delta)
	for collision in collisions:
		player_collisions.handle_collision(collision)
		
	
	#other
	move_and_slide()
	queue_redraw()


func get_gravity() -> float:
	if Input.is_action_pressed("jump") and velocity.y < 50:
		return player_state.max_jump_gravity
	elif velocity.y < 0:
		return player_state.min_jump_gravity
	else:
		return player_state.fall_gravity

func jump() -> void:
	velocity.y = player_state.jump_velocity
	can_jump = false

func handle_jump():
	var try_jump = false
	if is_on_floor():
		if player_state.coyote_time == false:
			player_state.enable_coyote_time()
		if player_state.jump_buffer == true:
			try_jump = true
	
	if Input.is_action_just_pressed("jump"):
		if player_state.coyote_time == true:
			try_jump = true
			player_state.coyote_time = false
		if player_state.jump_buffer == false:
			player_state.enable_jump_buffer()
		
	if try_jump:
		jump()

#float for delta , horizontal input value
func handle_horizontal_movement(delta:float,horizontal_input:float):
	if is_on_floor():
		if velocity.x * horizontal_input < 0:
			velocity.x = move_toward(velocity.x, horizontal_input * player_state.current_movement_data.ground_max_move_speed, player_state.stopping_horizontal_acceleration * delta) 
		else :
			velocity.x = move_toward(velocity.x, horizontal_input * player_state.current_movement_data.ground_max_move_speed, player_state.ground_horizontal_acceleration * delta) 
	else:
		velocity.x = move_toward(velocity.x, horizontal_input * player_state.current_movement_data.air_max_move_speed, player_state.air_horizontal_acceleration * delta) 

func get_input_velocity()-> float:
	var horizontal := 0.0
	if Input.is_action_pressed("left"):
		horizontal -= 1.0
	elif Input.is_action_pressed("right"):
		horizontal += 1.0
	return horizontal

func pickedup(_body):
	fire_parent.call_deferred("add_fire")
	
