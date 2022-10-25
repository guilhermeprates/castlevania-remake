class_name Enemies 
extends KinematicBody2D

const SPEED: int = 150
const GRAVITY: int = 2500

export(int) var health_points: int = 1

var _velocity: Vector2 = Vector2.ZERO
var _move_direction = -1
var hitted = false #quando inimigo for acertado

onready var hitbox: Area2D = $Hitbox

func _ready() -> void:
	add_to_group("Enemy")
	var _result = hitbox.connect("area_entered", self, "_on_area_entered")

func _physics_process(delta: float) -> void:
	_velocity.x = SPEED * _move_direction
	_velocity = move_and_slide(_velocity, Vector2.UP)
	_set_animation()

func _set_animation():
	var anim = "run"
	if hitted == true:
		anim = "death"

func _on_area_entered(area: Area2D) -> void:
	print("Player")
	hitted = true #colidiu
	health_points -= 1
	yield(get_tree().create_timer(0.2), "timeout") #quando der o timeout, outra linha vai começar:
	hitted = false
	if health_points <1:
		$AnimationZombie.play("death")
		yield(get_tree().create_timer(0.4), "timeout")
		queue_free()
		get_node("Hitbox/CollisionHitbox").set_deferred("disable", true) #inimigo vai morrer sem ter problemas na colisão

