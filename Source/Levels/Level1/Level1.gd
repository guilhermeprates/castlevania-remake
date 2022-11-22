class_name Level1
extends Level

onready var stage1OST: AudioStreamPlayer = $Stage1OST
onready var bossFightOST: AudioStreamPlayer = $BossFightOST
onready var giantBat: GiantBat = $GiantBat
onready var bossEventArea: Area2D = $BossEventArea
onready var firstSavePoint: Area2D = $SavePoint
onready var player: Player = $Player
onready var gameOverTimer: Timer = $GameOverTimer
onready var deathTimer: Timer = $DeathTimer

var last_savepoint_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	_set_connections()
	last_savepoint_position = firstSavePoint.position
	Game.last_savepoint_position = last_savepoint_position
	Game.player_life_points = 3
	stage1OST.play()
	
func _process(_delta: float) -> void:
	if Game.is_game_over():
		if gameOverTimer.is_stopped():
			gameOverTimer.start()
	elif Game.is_player_dead():
		if deathTimer.is_stopped():
			deathTimer.start()

func _on_gameover_timeout() -> void:
	Global.goto_scene("res://Source/Game Over/GameOver.tscn")

func _on_death_timeout() -> void:
	Game.player_life_points -= 1
	if Game.is_game_over(): return
	if player != null:
		player.reset()
		player.position = last_savepoint_position
		player.health_points = 16
		Game.player_health_points = 16
	

func _on_boss_event_body_entered(body: Node2D) -> void:
	if body is Player:
		stage1OST.stop()
		if giantBat != null:
			if !giantBat.boss_event_trigged:
				bossFightOST.play()
			giantBat.boss_event_trigged = true

func _set_connections() -> void:
	bossEventArea.connect("body_entered", self, "_on_boss_event_body_entered")
	gameOverTimer.connect("timeout", self, "_on_gameover_timeout")
	deathTimer.connect("timeout", self, "_on_death_timeout")
