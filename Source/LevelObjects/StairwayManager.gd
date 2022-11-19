extends Node

onready var playerDetector: Area2D = $PlayerDetector



func _ready() -> void:
	pass # Replace with function body.



func _on_PlayerDetector_body_entered(body: Node) -> void:
	if (body.is_in_group("Player")):
		print("aCHOU PLAYER")
		get_tree().call_group("Player", "stairway_found")



