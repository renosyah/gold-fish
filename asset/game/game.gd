extends Node

onready var _coin_spawn_timer = $coin_spawn_timer
onready var _gold_fish = $YSort/gold_fish
onready var _y_sort = $YSort
onready var _screen_size = get_viewport().get_visible_rect().size
onready var _score = $CanvasLayer/ui_panel/MarginContainer3/score
onready var _ui_hp = $CanvasLayer/ui_panel/center/ui_hp
onready var _hurt = $CanvasLayer/hurt

onready var _game_over_panel = $CanvasLayer/game_over_panel
onready var _ui_panel = $CanvasLayer/ui_panel
onready var _click_point = $click_point

var score : int = 0
var is_dead :bool = false

var coin_particle_pools :Array = []
var coin_pools :Array = []
var puffer_fish_pools :Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	_ui_hp.hp = 3
	_ui_hp.max_hp = 3
	
	_gold_fish.position = _screen_size / 2
	
	_game_over_panel.visible = false
	_ui_panel.visible = true
	
	pooling_coin()
	pooling_puffer_fish()
	pooling_coin_particle()
	
	_coin_spawn_timer.wait_time = rand_range(0.5, 1.5)
	_coin_spawn_timer.start()
	display_score()

func get_random_y(_spawn_point :Control):
	var x = _spawn_point.rect_global_position.x
	var y = _spawn_point.rect_global_position.y
	var y_size = _spawn_point.rect_size.y
	y = rand_range(y + 50 , y + y_size - 50)
	return Vector2(x , y)
	
func _on_coin_spawn_timer_timeout():
	spawn_coin()
	
	_coin_spawn_timer.wait_time = rand_range(0.5, 1.5)
	_coin_spawn_timer.start()
	
func _on_pufferfish_spawn_timer_timeout():
	spawn_puffer_fish()
	
func pooling_coin():
	for i in range(10):
		var coin = preload("res://asset/coin/coin.tscn").instance()
		coin.position = Vector2(-100, -100)
		coin.connect("on_pickup", self ,"on_coin_pickup")
		coin.visible = false
		_y_sort.add_child(coin)
		coin_pools.append(coin)
		
func pooling_coin_particle():
	for i in range(20):
		var coin = preload("res://asset/coin/coin_particle.tscn").instance()
		coin.position = Vector2(-100, -100)
		_y_sort.add_child(coin)
		coin_particle_pools.append(coin)
		
func pooling_puffer_fish():
	for i in range(5):
		var fish = preload("res://asset/puffer-fish/puffer_fish.tscn").instance()
		fish.position = Vector2(-500, -500)
		fish.is_moving = false
		_y_sort.add_child(fish)
		puffer_fish_pools.append(fish)
	
func spawn_puffer_fish():
	var _spawn_point_a = $CanvasLayer/spawn_point_1
	var _spawn_point_b = $CanvasLayer/spawn_point_2
	
	if randf() > 0.5:
		_spawn_point_a = $CanvasLayer/spawn_point_2
		_spawn_point_b = $CanvasLayer/spawn_point_1
		
	var pos = get_random_y(_spawn_point_a)
	var to = get_random_y(_spawn_point_b)
	
	for puffer_fish_pool in puffer_fish_pools:
		if not puffer_fish_pool.is_moving:
			puffer_fish_pool.position = pos
			puffer_fish_pool.move_to = to
			puffer_fish_pool.is_moving = true
			return
			
func spawn_coin():
	var x = rand_range(40, _screen_size.x - 40)
	var y = rand_range(120, _screen_size.y - 120)
	for coin_pool in coin_pools:
		if not coin_pool.visible:
			coin_pool.position = Vector2(x, y)
			coin_pool.display()
			return
		
func on_coin_pickup(coin):
	score += 1
	display_score()
	
	for coin_particle_pool in coin_particle_pools:
		if not coin_particle_pool.is_emitting():
			coin_particle_pool.position = coin.position
			coin_particle_pool.display()
			return
			
func display_score():
	_score.text = "Score : " + str(score)
	_ui_hp.display()
	
func _on_click_area_gui_input(event):
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		_gold_fish.move_to = event.position
		_gold_fish.is_moving = true
		_click_point.position = event.position
		_click_point.click()
		
func _on_pause_pressed():
	get_tree().change_scene("res://asset/menu/menu.tscn")
	
func _on_gold_fish_hit(fish):
	if is_dead:
		return
		
	_ui_hp.hp -= 1
	_hurt.show_hurt()
	
	if _ui_hp.hp < 1:
		WebGameModule.update_scoreboard(score)
		is_dead = true
		_gold_fish.visible = false
		_gold_fish.position = Vector2(-500, -500)
		_game_over_panel.visible = true
		_ui_panel.visible = false
		
	display_score()
	
func _on_play_again_pressed():
	is_dead = false
	_gold_fish.visible = true
	_gold_fish.position = _screen_size / 2
	_game_over_panel.visible = false
	_ui_panel.visible = true
	score = 0
	_ui_hp.reset()
	display_score()
	


