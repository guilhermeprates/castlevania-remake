class_name Zombie 
extends Enemy

const SPEED: int = 150
const GRAVITY: int = 2500

export(int) var health_points: int = 1

var _velocity: Vector2 = Vector2.ZERO
var _move_direction = -1
var _player_node

onready var hitbox: Area2D = $Hitbox

func _ready() -> void:
	_player_node = get_node(player)
	var _result = hitbox.connect("area_entered", self, "_on_area_entered")

func _physics_process(delta: float) -> void:
#	var enemyToPlayer = _player_node.translation - translate()
#	_velocity.x = SPEED * _move_direction
#	_velocity.y += GRAVITY * delta
#	_velocity = move_and_slide(_velocity, Vector2.UP)
	pass

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Whip") and not _dead:
		_dead = true
#		yield(get_tree().create_timer(0.2), "timeout")
		$AnimationZombie.play("death")
		emit_signal("on_kill_enemy", position)
		yield(get_tree().create_timer(0.4), "timeout")
		queue_free() # inimigo vai morrer sem ter problemas na 
		get_node("Hitbox/CollisionHitbox").set_deferred("disable", true)
