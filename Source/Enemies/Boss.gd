class_name Boss
extends KinematicBody2D

signal on_kill_boss(position)

const SPEED: int = 100
const GRAVITY: int = 2500

export(NodePath) var player: NodePath
export(int) var target_distance: int = 1000
export(int) var health_points: int = 12

var _experience: int = 0
var _attack: int = 2
var _player_node: Node2D
var _center_node: Node2D
var _dead: bool = false
var _moving: bool = false
var _velocity: Vector2 = Vector2.ZERO
var _move_direction = -1

var boss_event_trigged: bool = false

func _ready() -> void:
	Game.boss_health_points = health_points
	add_to_group("Boss")
	_player_node = get_node(player)

func distance_to_player() -> float:
	var direction_to_target = _player_node.position - position
	return direction_to_target.length()
