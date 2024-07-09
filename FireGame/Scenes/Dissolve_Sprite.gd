extends Sprite2D

@export var lifetime : float = 1.0
 
var shader_material : ShaderMaterial
var fade_timer : float = 0.0
var is_appearing = true
var temp_sprite:Sprite2D = null
var is_changing_appearance = false

var randomv2: float

var appearance_queue: Array[Texture2D] = []

signal end_dissolve(Node2D)

func _ready():
	shader_material = material as ShaderMaterial

func _process(delta):
	update_dissolve(delta)

#starts the shader dissolving
func start_dissolve():
	is_appearing = false
	shader_material.set_shader_parameter("density", 0)
	fade_timer = 0.0
	update_dissolve(0)
	
func start_appear():
	is_appearing = true
	shader_material.set_shader_parameter("density", 1)
	fade_timer = 0.0
	update_dissolve(0)

#updates the fading shader
func update_dissolve(delta):
	if fade_timer < lifetime:
		fade_timer += delta
		if is_appearing:
			shader_material.set_shader_parameter("density",1-  fade_timer / lifetime)
			shader_material.set_shader_parameter("randomv2",randomv2)
		else:
			shader_material.set_shader_parameter("density",fade_timer / lifetime)
			shader_material.set_shader_parameter("randomv2",randomv2)
			
		
	
	else:
		if temp_sprite != null:
			temp_sprite.hide()
			
		
		if is_changing_appearance:
			is_changing_appearance = false
			if !is_appearing:
				texture = temp_sprite.texture
				shader_material.set_shader_parameter("density",0)
				
			
			if appearance_queue.size() > 0:
				var next_appearance = appearance_queue.pop_front()
				change_appearance(next_appearance)
				
			
		
		else:
			if !is_appearing:
				end_dissolve.emit(self)

func change_appearance(appearance: Texture2D):
	if is_changing_appearance:
		appearance_queue.append(appearance)
		return
	
	if temp_sprite == null:
		temp_sprite = Sprite2D.new()
		temp_sprite.z_index = -1
		add_child(temp_sprite)
	
	if appearance==null:
		start_dissolve()
		temp_sprite.hide()
	else:
		if appearance != null and texture != null and appearance.get_size() >= texture.get_size():
			start_appear()
			temp_sprite.texture = texture
			texture = appearance
			temp_sprite.show()
		else:
			start_dissolve()
			temp_sprite.texture = appearance
			temp_sprite.show()
	
	randomv2 =randf_range(0.0,1.1)
	is_changing_appearance = true
	
