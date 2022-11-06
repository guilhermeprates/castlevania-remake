class_name FishMan
extends Enemy

export (int, 1000, 10000) var attack_speed: int = 1000
export (float, 0, 1) var attack_rate: float = 0.5

var _jump: bool = true

onready var collisionShape: CollisionShape2D = $CollisionShape2D
onready var position2D: Position2D = $Position2D
onready var hitbox: Area2D = $Position2D/Hitbox
onready var hitboxCollisionShape2D: CollisionShape2D = $Position2D/Hitbox/CollisionShape2D
onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animationPlayer.play("Walk")
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
	if is_on_floor():
		_velocity.x = SPEED * _move_direction
	_velocity.y += GRAVITY * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)

func _jump() -> void:
	_jump = false
	_velocity.y += -1300
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
