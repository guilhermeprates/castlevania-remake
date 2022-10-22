class_name ItemBox
extends Node2D

signal on_break_object

export(String, "Heartzinho") var item = "Heartzinho" # colocar nos () os itens possiveis; var item = o que vai aparecer em cada box/padrao

onready var sprite: AnimatedSprite = $Sprite

var open = false # se a box esta quebrada ou nao
var on_box = false # player na area2d

func _process(delta: float) -> void:
	pass

func _on_Area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Whip"):
		self.on_box = true
		$Sprite.play("off")


func _on_Sprite_animation_finished() -> void:
	if $Sprite.animation == "off":
		emit_signal("on_break_object", position)
