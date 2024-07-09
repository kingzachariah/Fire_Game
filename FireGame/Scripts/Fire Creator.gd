extends Node2D

const FIRE_1 = preload("res://Tilesets/Fire1.png")
const FIRE_2 = preload("res://Tilesets/Fire2.png")
const FIRE_3 = preload("res://Tilesets/Fire3.png")
const FIRE_4 = preload("res://Tilesets/Fire4.png")

var fire_textures: Array[Texture2D] = [FIRE_1,FIRE_2,FIRE_3,FIRE_4]
var fire_sizes: Array[float] = [2,3,5,7]

@onready var fire_aim_point = $"../../FireAimPoint"
@onready var sprite_2d = $"../../Sprite2D"
@onready var collision_shape_2d = $"../../CollisionShape2D"

const FIRE_BODY = preload("res://Scenes/fire_body.tscn")

var fires:Array[Node2D] = []
var remove_queue: Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	add_fire()

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		queue_remove_fire()
	elif Input.is_action_just_pressed("ui_up"):
		add_fire()

#adds a fire to the front of the queue
func add_fire()->Node2D:
	var fire_body:Node2D
	if fires.size() == 0:
		# Create the first fire with a CollisionShape2D
		fire_body = create_fire(fire_aim_point)
	else:
		# Create subsequent fires, targeting the first fire in the array
		fire_body = create_fire(fires[0])
	fires.insert(0,fire_body)
	update_fire_data()
	return fire_body

# Function to remove a fire from the back of the array and destroy it
func queue_remove_fire() -> void:
	if fires.size() > 0:
		var fire = fires.pop_back()
		remove_queue.append(fire)
		if remove_queue.size() == 1:
			start_next_fire_removal()

func start_next_fire_removal() -> void:
	if remove_queue.size() > 0:
		var fire = remove_queue[0]
		var sprite = fire.get_node("Sprite2D")
		sprite.end_dissolve.connect(_on_fire_dissolve_completed)
		sprite.start_dissolve()

func _on_fire_dissolve_completed(fire: Node2D) -> void:
	fire.queue_free()
	remove_queue.pop_front()
	update_fire_data()
	start_next_fire_removal() 

#creates the fire object and stores it in an array
func create_fire(target:Node2D) -> Node2D:
	var fire_body: Node2D
	fire_body = FIRE_BODY.instantiate() as Node2D
	fire_body.global_position = fire_aim_point.global_position
	fire_body.set_name("fireBody")
	
	add_child(fire_body)
	fire_body.set_fire_parent(target)
	return fire_body

#updates all aim points of fires after adding or removing fires
func update_fire_data():
	var fire_count = fires.size()
	var texture_count = fire_textures.size()
	
	if fire_count < texture_count:
		sprite_2d.change_appearance(fire_textures[fire_count])
		collision_shape_2d.shape.radius = fire_sizes[fire_count]
	else:
		sprite_2d.change_appearance(fire_textures[texture_count-1])
		collision_shape_2d.shape.radius = fire_sizes[texture_count-1]
		
	for i in range(fire_count):
		var texture_index = min(fire_count-i-1, texture_count-1)
		if i == 0:
			fires[i].set_fire_parent(fire_aim_point)
			fires[i].change_appearance(fire_textures[texture_index])
		else:
			fires[i].set_fire_parent(fires[i-1])
			fires[i].change_appearance(fire_textures[texture_index])
