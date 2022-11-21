class_name Level1
extends Level

onready var stage1OST: AudioStreamPlayer = $Stage1OST
onready var giantBat: GiantBat = $GiantBat
onready var bossEventArea: Area2D = $BossEventArea

func _ready() -> void:
	stage1OST.play()
	bossEventArea.connect("body_entered", self, "_on_boss_event_body_entered")

func _on_boss_event_body_entered(body: Node2D) -> void:
	if body is Player:
		stage1OST.stop()
		giantBat.boss_event_trigged = true
