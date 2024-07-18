extends Node

class_name PlayerState

@onready var player = $".."

#MovementData
@export var movement_datas : Array[PlayerMovementData] = []
@onready var current_movement_data = movement_datas[0]

@onready var ground_horizontal_acceleration : float
@onready var air_horizontal_acceleration : float
@onready var stopping_horizontal_acceleration : float

@onready var jump_velocity : float
@onready var max_jump_gravity : float
@onready var min_jump_gravity : float
@onready var fall_gravity : float 

var jump_buffer: bool = false
var coyote_time: bool = false
var can_jump: bool = false

@export var coyote_timer: float = 0.2
@export var jump_buffer_timer: float = 0.2

func change_movement_data() -> void:
	var current_size = player.fire_parent.fires.size() - 1
	##print("current size: ", current_size)
	current_size = clamp(current_size ,0 ,player.fire_parent.fire_textures.size() -1)
	
	current_movement_data = movement_datas[current_size]
	
	ground_horizontal_acceleration = current_movement_data.ground_max_move_speed / current_movement_data.floor_time_to_max_speed
	air_horizontal_acceleration = current_movement_data.air_max_move_speed / current_movement_data.air_time_to_max_speed
	stopping_horizontal_acceleration = current_movement_data.ground_max_move_speed / current_movement_data.floor_time_to_stop

	jump_velocity = ((2.0 * current_movement_data.max_jump_height) / current_movement_data.jump_time_to_peak )* -1
	max_jump_gravity = ((jump_velocity * jump_velocity) / (2.0 * current_movement_data.max_jump_height)) 
	min_jump_gravity = ((jump_velocity * jump_velocity) / (2.0 * current_movement_data.min_jump_height)) 
	fall_gravity = ((-2.0 * current_movement_data.max_jump_height) / (current_movement_data.jump_time_to_descent * current_movement_data.jump_time_to_peak)) * -1

func enable_coyote_time():
	coyote_time = true
	get_tree().create_timer(coyote_timer).timeout.connect(on_coyote_timer_timeout)

func enable_jump_buffer():
	jump_buffer = true
	get_tree().create_timer(jump_buffer_timer).timeout.connect(on_jump_buffer_timeout)

func on_jump_buffer_timeout() -> void:
	jump_buffer = false

func on_coyote_timer_timeout() -> void:
	coyote_time = false
