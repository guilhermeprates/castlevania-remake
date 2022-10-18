class_name Interactable extends Area2D

const SLICE = preload ("res://Source/HUD/Slice.tscn")
const HEARTZINHO = preload ("res://Source/HUD/Heartzinho.tscn")

export (int) var health
export (Array, String) var texture_list
export (Vector2) var offset

var can_interact
var invulnerability
var invulnerability_time 

func _ready() -> void:
	timer.set_wait_time(invulnerability_time) #script var

func _on_BoxType1_body_entered(body: Node) -> void:
	if can_process():
		update_health(body.object_damage)
		timer.start()
		can_interact = false

func update_health(damage: int) -> void:
	health -= damage
	animation.queue("SLICE")
	if health <= 0:
		spawn_heartzinho()
		spawn_slice()

func spawn_slice():
	for Texture in SLICE:
		var slice_to_spawn: Object = SLICE.instance()
		slice_to_spawn.global_position = global_position
	queue_free()

func _on_Timer_timeout() -> void:
	can_interact = true
