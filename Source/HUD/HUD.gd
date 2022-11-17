extends CanvasLayer

var _timer = 300

onready var playerHeartsLabel = $Control/HBoxContainer/HeartsLabel
onready var playerHealthPointsLabel = $Control/HBoxContainer2/LifePointsLabel
onready var playerScoreLabel = $Control/HBoxContainer3/ScoreLabel
onready var timerLabel = $Control/HBoxContainer4/TimerLabel
onready var playerHealthBar = $Control/PlayerHealthBar
onready var bossHealthBar = $Control/BossHealthBar

func _process(delta: float) -> void:
	playerHeartsLabel.text = "-" + str(Game.player_hearts)
	playerHealthPointsLabel.text = "P-" + str(Game.player_life_points)
	playerScoreLabel.text = "SCORE-"+ str(Game.player_score)
	playerHealthBar.value = Game.player_health_points
	bossHealthBar.value = Game.boss_health_points

func _on_Timer_timeout() -> void:
	_timer -= 1
	timerLabel.text = "TIME 0" + str(_timer)



