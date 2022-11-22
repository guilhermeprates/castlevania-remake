extends Node

var current_stage: int = 1
var player_health_points: int = 14
var player_hearts: int = 0
var player_life_points: int = 3
var player_score: int = 0
var boss_health_points: int = 12
var last_savepoint_position: Vector2 = Vector2.ZERO

func is_game_over() -> bool:
	return player_life_points < 1

func is_player_dead() -> bool:
	return player_health_points < 1
