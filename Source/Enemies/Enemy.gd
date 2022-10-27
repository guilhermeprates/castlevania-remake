class_name Enemy
extends KinematicBody2D

signal on_kill_enemy(position)

export(NodePath) var player: NodePath
export(int) var target_distance: int = 500

var _player_node: Node2D
var _dead: bool = false
var _moving: bool = false

func _ready() -> void:
	add_to_group("Enemy")
	_player_node = get_node(player)

func distance_to_player() -> float:
	var direction_to_target = _player_node.position - position
	return direction_to_target.length()
