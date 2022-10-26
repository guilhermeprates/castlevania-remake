class_name Collectable
extends RigidBody2D

signal on_touch_collectable

var item: Item

onready var sprite: Sprite = $Sprite
onready var collisionShape2D: CollisionShape2D = $CollisionShape2D
onready var touchHitBox: Area2D = $TouchArea

func _ready() -> void:
	var _result = touchHitBox.connect("body_entered", self, "_collectable_body_entered")

func _process(delta: float) -> void:
	pass
	
func _collectable_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_signal("on_touch_collectable")
		yield(get_tree().create_timer(0.1), "timeout")
		call_deferred("queue_free")
