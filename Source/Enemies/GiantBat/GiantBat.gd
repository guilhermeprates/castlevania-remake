class_name GiantBat
extends Boss

var _trigged: bool = false
var _time: int = 0

onready var position2D: Position2D = $Position2D
onready var hitbox: Area2D = $Position2D/Hitbox
onready var hitboxCollisionShape2D: CollisionShape2D = $Position2D/Hitbox/CollisionShape2D
onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animationPlayer.play("Idle") 
	var _result = hitbox.connect("area_entered", self, "_on_area_entered")
	
func _physics_process(delta: float) -> void:
	if _trigged:
		_trigged = false
		animationPlayer.play("Flying") 
	if not _dead and boss_event_trigged:
		_trigged = true
		_look_for_player()
		_move(delta)

func _move(delta: float) -> void:
	_velocity = move_and_slide(_velocity, Vector2.UP)

func _attack(delta: float) -> void:
	_velocity = _player_node.position - position
	_velocity = move_and_slide(_velocity, Vector2.UP)

func _look_for_player() -> void:
	if _player_node.position.x < position.x:
		position2D.scale.x = -1
		_move_direction = -1
	else:
		position2D.scale.x = 1
		_move_direction = 1
	_moving = distance_to_player() < target_distance

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Whip") and not _dead:
		health_points =- 1
		if health_points == 0:
			_dead = true
			hitboxCollisionShape2D.set_deferred("disable", true)
			yield(get_tree().create_timer(0.2), "timeout")
	#		animationPlayer.play("death")
			emit_signal("on_kill_boss", position)
			yield(get_tree().create_timer(0.4), "timeout")
			queue_free()
