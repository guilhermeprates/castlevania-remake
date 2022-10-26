class_name BaseState
extends Node

#Script de um estado genérico, herdado por todos os estados do jogo

var state_machine

#Método chamado logo que o estado for ativado
func enter() -> void:
	
	pass

#Método chamado logo antes de o estado acabar
func exit() -> void:
	pass

#Método chamado 1 vez por frame quando o estado está ativo
func tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func input_handler(event: InputEvent):
	pass
