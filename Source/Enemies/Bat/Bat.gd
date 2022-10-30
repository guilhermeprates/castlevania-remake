class_name Bat
extends Enemy

enum MoveDirection { UP, DOWN }

onready var position2D: Position2D = $Position2D
onready var hitbox: Area2D = $Position2D/Hitbox
onready var tween: Tween = $Tween

var _direction = MoveDirection.DOWN
var _target = position.y + 10

func _ready() -> void:
	var _result = hitbox.connect("area_entered", self, "_on_area_entered")
	tween.connect("tween_completed", self, "_on_tween_completed")
	tween.interpolate_property(
		self, 
		"position:y", 
		position.y, 
		position.y - 10,
		0.5, 
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	tween.interpolate_property(
		self, 
		"position:y", 
		position.y - 5, 
		position.y + 10,
		0.5, 
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	tween.start()
	print(position.y)
	
func _physics_process(delta: float) -> void:
	if not _dead: 
		if not _moving:
			_look_for_player()
		else:
			_move(delta)
	print(position.y)

func _on_tween_completed(object, key) -> void:
	pass
#	if _direction == MoveDirection.DOWN:
#		_direction = MoveDirection.UP
#	else:
#		_direction = MoveDirection.DOWN

func _move(delta: float) -> void:
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
