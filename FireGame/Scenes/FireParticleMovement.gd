extends RigidBody2D

@onready var sprite_2d = $Sprite2D

@export var flSpeed: float = 3000
@export var acceleration_multiplier: float = 2

#physics variables
var velocity: Vector2 = Vector2(0, 0)
var aim_pos : Node2D

var temp_sprite:Sprite2D = null

var waiting_to_die : bool = false

func _physics_process(delta):
	FirePos(delta)

func set_fire_parent(aim_pos_node: Node2D):
	aim_pos = aim_pos_node

func FirePos(delta):
	if !aim_pos:
		return
	
	global_position += velocity * delta
	var target_vector: Vector2 = global_position - aim_pos.global_position
	velocity = -(target_vector*target_vector.length()* acceleration_multiplier)
	velocity.y -= flSpeed*delta

func change_appearance(appearance:Texture2D):
	sprite_2d.change_appearance(appearance)

func kill():
	waiting_to_die = true
	sprite_2d.change_appearance(null)

#func _on_sprite_2d_end_dissolve(object:Node2D):
#	if object == sprite_2d:
#		if waiting_to_die:
#			queue_free()
	
