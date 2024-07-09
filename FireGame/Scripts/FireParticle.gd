extends RigidBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export_node_path("Marker2D") var foo_node_path
@onready var parentparticle = get_node(foo_node_path) as Marker2D
@export var flSpeed = 600

@onready var sprite_2d = $Sprite2D

var flLength: float

# Called when the node enters the scene tree for the first time.
func _ready():
	var startOffset = global_position - parentparticle.global_position
	flLength =startOffset.length()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	FirePos(delta)

func FirePos(delta):
	global_position.y -= delta *50
	var direction: Vector2 = global_position - parentparticle.global_position
	if direction.length() >= flLength:
		global_position = parentparticle.global_position + direction.normalized() * flLength
		
func kill():
	sprite_2d.kill()
