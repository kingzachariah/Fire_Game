class_name PlayerMovementData
extends Resource

@export_category("movement variables")
@export_subgroup("speeds")
##time to get to max speed on the floor
@export var floor_time_to_max_speed: float = 0.3 
##time to stop from max speed on the floor
@export var floor_time_to_stop: float = 0.05
##time to get to max speed in the air
@export var air_time_to_max_speed: float = 1
@export var ground_max_move_speed = 300
@export var air_max_move_speed = 400

#variables to control jump
@export_category("Jump variables")
@export_subgroup("jump values")
@export var max_jump_height : float = 50
@export var min_jump_height : float = 30
@export var jump_time_to_peak : float = 0.7
@export var jump_time_to_descent : float = 0.3

@export_subgroup("timers")
##time to keep the jump input
@export var jump_buffer_timer:float = 0.2
##time allow player jump after leaving floor
@export var coyote_timer:float = 0.1

