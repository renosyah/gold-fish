extends Fish
class_name PufferFish

onready var sprite = $Sprite

func on_move(direction :Vector2, delta:float):
	.on_move(direction, delta)
	var x_dir = 1 if direction.x > 0 else -1
	sprite.scale.x = lerp(sprite.scale.x, x_dir, 5 * delta)
