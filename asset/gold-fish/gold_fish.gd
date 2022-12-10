extends Fish

onready var sprite = $Sprite
onready var area_2d = $Area2D
onready var audio_stream_player = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func on_move(direction :Vector2, delta:float):
	.on_move(direction, delta)
	var x_dir = 1 if direction.x > 0 else -1
	sprite.scale.x = lerp(sprite.scale.x, x_dir, 5 * delta)

func _on_Area2D_body_entered(body):
	if body == self:
		return
		
	if body is Coin:
		body.pick()
		
	if body is PufferFish:
		audio_stream_player.play()
		emit_signal("hit", self)
