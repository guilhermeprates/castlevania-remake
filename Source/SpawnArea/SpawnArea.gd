class_name SpawnArea
extends Area2D

signal on_spawn_enemy(enemy)

export(NodePath) var player
export(PackedScene) var enemy
export(int) var target_distance: int = 1000

var _player: Player
var _enemy: Enemy

func _ready() -> void:
	add_to_group("Enemy")
	_player = get_node(player)
	
func _process(delta: float) -> void:
	if (is_instance_valid(_enemy)): return
	if distance_to_player() < target_distance:
		var enemy_instance = enemy.instance()
		enemy_instance.position = position
		_enemy = enemy_instance
		enemy_instance.player = player
		emit_signal("on_spawn_enemy", enemy_instance)
		
func distance_to_player() -> float:
	var direction_to_target = _player.position - position
	return direction_to_target.length()

func player_direction() -> int:
	if _player.position.x < position.x:
		return -1
	else:
		return 1
