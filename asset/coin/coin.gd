extends KinematicBody2D
class_name Coin

onready var collision_shape_2d = $CollisionShape2D
onready var timer = $Timer
onready var audio_stream_player = $AudioStreamPlayer
onready var sprite = $Sprite

signal on_pickup(coin)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func display():
	timer.start()
	visible = true
	
func pick():
	if not visible:
		return
		
	emit_signal("on_pickup", self)
	
	position = Vector2(-100, -100)
	visible = false
	audio_stream_player.play()
	
	timer.stop()

	
func _on_Timer_timeout():
	position = Vector2(-100, -100)
	visible = false
