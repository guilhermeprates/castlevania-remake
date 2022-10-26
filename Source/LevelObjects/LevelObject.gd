class_name LevelObject
extends Area2D

signal on_break_level_object(position)

var _broke = false

func _ready() -> void:
	add_to_group("LevelObject")
	var _result = connect("area_entered", self, "_level_object_area_entered")

func _process(delta: float) -> void:
	pass
	
func _level_object_area_entered(area: Area2D) -> void:
	if area.is_in_group("Whip") and not _broke:
		_broke = true
		emit_signal("on_break_level_object", position)
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()
