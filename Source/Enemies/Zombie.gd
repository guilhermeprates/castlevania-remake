class_name Zombie 
extends Enemy

const SPEED: int = 150
const GRAVITY: int = 2500

export(int) var health_points: int = 1

var _velocity: Vector2 = Vector2.ZERO
var _move_direction = -1

onready var hitbox: Area2D = $Hitbox

func _ready() -> void:
	var _result = hitbox.connect("area_entered", self, "_on_area_entered")

func _physics_process(delta: float) -> void:
	_velocity.x = SPEED * _move_direction
	_velocity.y += GRAVITY * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)

func _on_area_entered(area: Area2D) -> void:
	if not _dead:
		_dead = true
		$AnimationZombie.play("death")
		emit_signal("on_kill_enemy", position)
		yield(get_tree().create_timer(0.4), "timeout")
		queue_free()
		get_node("Hitbox/CollisionHitbox").set_deferred("disable", true) # inimigo vai morrer sem ter problemas na colisão
