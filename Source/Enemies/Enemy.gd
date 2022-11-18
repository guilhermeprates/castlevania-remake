class_name Enemy
extends KinematicBody2D

# warning-ignore:unused_signal
signal on_kill_enemy(position)

const SPEED: int = 150
const GRAVITY: int = 2500

export(NodePath) var player: NodePath
export(int) var target_distance: int = 500
export(int) var health_points: int = 1

var _experience: int = 0
var _attack: int = 2
var _dead: bool = false
var _moving: bool = false
var _velocity: Vector2 = Vector2.ZERO
var _move_direction = -1
var _player_node: Node2D

func _ready() -> void:
	add_to_group("Enemy")
	_player_node = get_node(player)

func distance_to_player() -> float:
	if (_player_node == null): return 0.0
	var direction_to_target = _player_node.position - position
	return direction_to_target.length()

func player_direction() -> int:
	if (_player_node == null): return 0
	if _player_node.position.x < position.x:
		return -1
	else:
		return 1
