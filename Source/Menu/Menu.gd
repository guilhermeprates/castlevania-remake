class_name Menu
extends Control

var blink = 0

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		$TimerBlink.start()

func _on_Start_pressed() -> void:
	$TimerBlink.start()


func _on_TimerBlink_timeout() -> void:
	blink += 1
	$Start.visible = not $Start.visible
	if blink > 15:
		get_tree().change_scene("res://Source/Levels/CutScene/CutScene.tscn")
