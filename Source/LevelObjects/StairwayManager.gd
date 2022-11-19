extends Node


func _on_BottomDetector_body_entered(body: Node) -> void:
	if (body.is_in_group("Player")):
		print("aCHOU PLAYER por baixo")
		get_tree().call_group("Player", "stairway_bottom_found")


func _on_TopDetector_body_entered(body: Node) -> void:
	if (body.is_in_group("Player")):
		print("aCHOU PLAYER por cima")
		get_tree().call_group("Player", "stairway_top_found")


func _on_BottomDetector_body_exited(body: Node) -> void:
	get_tree().call_group("Player", "stairway_bottom_top_exited")


func _on_TopDetector_body_exited(body: Node) -> void:
	get_tree().call_group("Player", "stairway_bottom_top_exited")



func _on_MiddleDetector_body_exited(body: Node) -> void:
	get_tree().call_group("Player", "stairway_exited")
