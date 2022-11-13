class_name BlackPanther
extends Enemy

var _jump_area_entered: bool = false
var _look_for_player_on_ground: bool = false

onready var position2D: Position2D = $Position2D
onready var hitbox: Area2D = $Position2D/Hitbox
onready var hitboxCollisionShape2D: CollisionShape2D = $Position2D/Hitbox/CollisionShape2D
onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_experience = 200
	animationPlayer.play("Idle")
	var _result = hitbox.connect("area_entered", self, "_on_area_entered")
	
func _physics_process(delta: float) -> void:
	if not _dead: 
		if not _moving:
			_look_for_player()
		else:
			_move(delta)
			if _jump_area_entered:
				_jump(delta)

func _move(delta: float) -> void:
	_velocity.x = SPEED * _move_direction
	_velocity.y += GRAVITY * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)

func _jump(delta: float) -> void:
	if !is_on_floor():
		_velocity.y -= 40
		_velocity = move_and_slide(_velocity, Vector2.UP)
		animationPlayer.play("Jump")
		_look_for_player_on_ground = true
	else:
		animationPlayer.play("Run")
		if _look_for_player_on_ground:
			_look_for_player_on_ground = false
			if _player_node.position.x < position.x:
				position2D.scale.x = -1
				_move_direction = -1
			else:
				position2D.scale.x = 1
				_move_direction = 1

func _look_for_player() -> void:
	if _player_node.position.x < position.x:
		position2D.scale.x = -1
		_move_direction = -1
	else:
		position2D.scale.x = 1
		_move_direction = 1
	_moving = distance_to_player() < target_distance
	if _moving:
		animationPlayer.play("Run")

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("JumpArea") and not _dead:
		_jump_area_entered = true
	if area.is_in_group("Whip") and not _dead:
		Game.player_score += _experience
		_dead = true
		hitboxCollisionShape2D.set_deferred("disable", true)
		yield(get_tree().create_timer(0.2), "timeout")
		animationPlayer.play("Death")
		emit_signal("on_kill_enemy", position)
		yield(get_tree().create_timer(0.4), "timeout")
		queue_free()

