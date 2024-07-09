extends Node2D
class_name Pickup

signal picked_up

func _ready():
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("picked_up", self)
		queue_free()
