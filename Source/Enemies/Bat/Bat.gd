class_name Bat
extends Enemy


onready var position2D: Position2D = $Position2D
onready var hitbox: Area2D = $Position2D/Hitbox
onready var tween: Tween = $Tween

var _time = 0

func _ready() -> void:
	var _result = hitbox.connect("area_entered", self, "_on_area_entered")
	
func _physics_process(delta: float) -> void:
	if not _dead: 
		if not _moving:
			_look_for_player()
		else:
			_move(delta)

func _move(delta: float) -> void:
	_time += delta
	var movement = cos(_time * 5) * 500
	_velocity.y += movement * delta
	_velocity.x = SPEED * _move_direction
	_velocity = move_and_slide(_velocity, Vector2.UP)

func _look_for_player() -> void:
	if _player_node.position.x < position.x:
		position2D.scale.x = 1
		_move_direction = -1
	else:
		position2D.scale.x = -1
		_move_direction = 1
	_moving = distance_to_player() < target_distance

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Whip") and not _dead:
		_dead = true
		get_node("Position2D/Hitbox/CollisionShape2D").set_deferred("disable", true)
		yield(get_tree().create_timer(0.2), "timeout")
#		$AnimationZombie.play("death")
		emit_signal("on_kill_enemy", position)
		yield(get_tree().create_timer(0.4), "timeout")
		queue_free()
