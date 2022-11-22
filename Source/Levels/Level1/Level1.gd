class_name Level1
extends Level

onready var stage1OST: AudioStreamPlayer = $Stage1OST
onready var bossFightOST: AudioStreamPlayer = $BossFightOST
onready var giantBat: GiantBat = $GiantBat
onready var bossEventArea: Area2D = $BossEventArea
onready var firstSavePoint: Area2D = $SavePoint
onready var player: Player = $Player

var last_savepoint_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	Game.player_life_points = 3
	last_savepoint_position = firstSavePoint.position
	stage1OST.play()
	bossEventArea.connect("body_entered", self, "_on_boss_event_body_entered")

func _process(_delta: float) -> void:
	if Game.is_game_over():
		Global.goto_scene("res://Source/GameOver/GameOver.tscn")
	if Game.is_player_dead():
		player.reset()
		player.position = last_savepoint_position
		player.health_points = 16
		Game.player_health_points = 16
		
		
func _on_boss_event_body_entered(body: Node2D) -> void:
	if body is Player:
		stage1OST.stop()
		if !giantBat.boss_event_trigged:
			bossFightOST.play()
		giantBat.boss_event_trigged = true
