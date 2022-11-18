class_name Bat
extends Enemy

var _time: float = 0
var _amplitude: int = 300
var _frequency: int = 5

onready var position2D: Position2D = $Position2D
onready var hitbox: Area2D = $Position2D/Hitbox
onready var hitboxCollisionShape2D: CollisionShape2D = $Position2D/Hitbox/CollisionShape2D
onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_experience = 200
	animationPlayer.play("Flying")
	var _result = hitbox.connect("area_entered", self, "_on_area_entered")
	
func _physics_process(delta: float) -> void:
	if not _dead: 
		if not _moving:
			_look_for_player()
		else:
			_move(delta)

func _move(delta: float) -> void:
	_time += delta
	_velocity.y = cos(_time * _frequency) * _amplitude
	_velocity.x = SPEED * _move_direction
	_velocity = move_and_slide(_velocity, Vector2.UP)

func _look_for_player() -> void:
	if (_player_node == null): 
		return
	if _player_node.position.x < position.x:
		position2D.scale.x = -1
		_move_direction = -1
	else:
		position2D.scale.x = 1
		_move_direction = 1
	_moving = distance_to_player() < target_distance

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Whip") and not _dead:
		Game.player_score += _experience
		_dead = true
		hitboxCollisionShape2D.set_deferred("disable", true)
		yield(get_tree().create_timer(0.2), "timeout")
		animationPlayer.play("Death")
		emit_signal("on_kill_enemy", position)
		yield(get_tree().create_timer(0.4), "timeout")
		queue_free()
