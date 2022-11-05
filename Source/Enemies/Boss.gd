class_name Boss
extends KinematicBody2D

signal on_kill_boss(position)

const SPEED: int = 150
const GRAVITY: int = 2500

export(NodePath) var player: NodePath
export(int) var target_distance: int = 500
export(int) var health_points: int = 1
export(int) var points: int = 0

var _player_node: Node2D
var _dead: bool = false
var _moving: bool = false
var _velocity: Vector2 = Vector2.ZERO
var _move_direction = -1

func _ready() -> void:
	add_to_group("Boss")
	_player_node = get_node(player)

func distance_to_player() -> float:
	var direction_to_target = _player_node.position - position
	return direction_to_target.length()