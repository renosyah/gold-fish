extends KinematicBody2D
class_name Fish

signal hit(fish)

export var speed : float = 225
export var margin : float = 25

export var move_to :Vector2
export var is_moving :bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = position.direction_to(move_to)
	on_move(direction, delta)
	
	if not is_moving:
		return
		
	var distance = position.distance_to(move_to)
	if distance < margin:
		is_moving = false
		return
		
	move_and_slide(direction * speed)
	
func on_move(direction :Vector2,delta :float):
	pass
	
