class_name Projectile
extends Area2D

var _end: bool = false
var _start: bool = false

var player_direction: int = 0

onready var position2d: Position2D = $Position2D
onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	position2d.scale.x = player_direction
	animationPlayer.play("Start")

func _physics_process(delta: float) -> void:
	if not _end:
		position.x -= 3.5
		if !_start:
			yield(get_tree().create_timer(0.1), "timeout")
			animationPlayer.play("Default")
			_start = true
		
func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("Enemy"):
		_end = true
		animationPlayer.play("End")
		yield(get_tree().create_timer(0.4), "timeout")
		queue_free()
