#class_name Heart
extends Area2D

func _on_Heartzinho_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.heartzinho = true

func _on_Heartzinho_body_exited(body: Node) -> void:
	queue_free()

