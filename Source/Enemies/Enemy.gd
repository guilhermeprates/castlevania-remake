class_name Enemy
extends KinematicBody2D

signal on_kill_enemy(position)

export(NodePath) var player: NodePath

var _dead = false

func _ready() -> void:
	add_to_group("Enemy")

func _process(delta: float) -> void:
	pass

func check_player_distance() -> void:
	pass
