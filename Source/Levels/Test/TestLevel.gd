class_name TestLevel 
extends Level

onready var giantBat: GiantBat = $GiantBat
onready var bossEventArea: Area2D = $BossEventArea

func _ready() -> void:
	var _result = bossEventArea.connect("area_entered", self, "_on_boss_event_area_entered")

func _on_boss_event_area_entered(area: Area2D) -> void:
	print("Boss Event")
	if area.is_in_group("Player"):
		giantBat.boss_event_trigged = true
