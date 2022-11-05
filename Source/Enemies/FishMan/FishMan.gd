class_name FishMan
extends Enemy

var _jump: bool = true
var _last_position: Vector2 

onready var collisionShape: CollisionShape2D = $CollisionShape2D
onready var position2D: Position2D = $Position2D
onready var hitbox: Area2D = $Position2D/Hitbox
onready var hitboxCollisionShape2D: CollisionShape2D = $Position2D/Hitbox/CollisionShape2D
onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animationPlayer.play("Walk")
	_last_position = position
	var _result = hitbox.connect("area_entered", self, "_on_area_entered")

func _physics_process(delta: float) -> void:
	if not _dead: 
		if not _moving:
			_look_for_player()
		else:
			if _jump:
				_jump()
			_move(delta)
	
func _move(delta: float) -> void:
#	if global_position.y > 700:
#		_enable_map_collision_mask()
	if is_on_floor():
		_velocity.x = SPEED * _move_direction
	_velocity.y += GRAVITY * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)

func _jump() -> void:
#	_disable_map_collision_mask()
	_jump = false
	_velocity.y += -1300
	print(_velocity.y)
	print(position.y)
	print(global_position.y)
	_velocity = move_and_slide(_velocity, Vector2.UP)

	
func _disable_map_collision_mask() -> void:
	set_collision_mask_bit(3, false)

func _enable_map_collision_mask() -> void:
	set_collision_mask_bit(3, true)

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
		_dead = true
		hitboxCollisionShape2D.set_deferred("disable", true)
		yield(get_tree().create_timer(0.2), "timeout")
#		animationPlayer.play("death")
		emit_signal("on_kill_enemy", position)
		yield(get_tree().create_timer(0.4), "timeout")
		queue_free()
