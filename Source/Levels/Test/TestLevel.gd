class_name TestLevel 
extends Level

onready var giantBat: GiantBat = $GiantBat
onready var bossEventArea: Area2D = $BossEventArea

func _ready() -> void:
	bossEventArea.connect("body_entered", self, "_on_boss_event_body_entered")
	pass

func _on_boss_event_body_entered(body: Node2D) -> void:
	if body is Player:
		print("BOSS EVENT AREA")
		giantBat.boss_event_trigged = true
