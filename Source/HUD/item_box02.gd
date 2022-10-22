class_name ItemBox2
extends Node2D

signal on_break_object

export(String, "Whip") var item = "Whip" #colocar nos () os itens possiveis; var item = o que vai aparecer em cada box/padrao

onready var sprite: AnimatedSprite = $sprite

var open = false #se a box esta quebrada ou nao
var on_box = false #player na area2d
#var timer = $Timer as Timer

func _process(delta: float) -> void:
	if not (on_box and !open) and Input.is_action_just_pressed("ui_open"):
		$Sprite.play("off")
		emit_signal("on_break_object", position)
#	if not on_box and Input.is_action_just_pressed("ui_open"):
##		sprite.play("off")
#		emit_signal("on_break_object", position)

#func _on_Timer_timeout() -> void:
#	print("timer")

func _on_area_body_entered(body: Node) -> void: #player entrou na area2d
	if body.is_in_group("Player"):
		self.on_box = true
#		timer.start()

func _on_area_body_exited(body: Node) -> void: #player saiu na area 2d
	#if sprite.get_current_animation() == "off":
	if body.is_in_group("Player"):
		self.on_box = false

func _on_sprite_animation_finished():
	if $Sprite.get_animation() == "off":
		open = true
		#queue_free()

