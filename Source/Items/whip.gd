class_name Whip
extends Area2D

func _on_Whip_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.whip = true

func _on_Whip_body_exited(body: Node) -> void:
	queue_free()
