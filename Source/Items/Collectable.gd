class_name Collectable
extends RigidBody2D

var item: Item

onready var sprite: Sprite = $Sprite
onready var collisionShape2D: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	pass
