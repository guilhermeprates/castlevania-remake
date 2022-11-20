extends BaseState

func enter():
	print ("Enter Attack State")
	state_machine.my_player.animationTree.set("parameters/conditions/Attack", true)
	state_machine.my_player.set_movement_momentum()


func exit():
	print ("Exit Attack State")
	state_machine.my_player.animationTree.set("parameters/conditions/Attack", false)
	state_machine.my_player.disable_whip_collision_shape()


func tick(delta):
	pass


func physics_tick(delta):
	state_machine.my_player.set_gravity(delta)


func transition_to_idle():
	state_machine.change_state("Idle")

func transition_to_air():
	state_machine.change_state("Air")


func _on_Player_on_animation_ended() -> void:
	if(state_machine.current_state == state_machine.get_node("Attack")):
		if(state_machine.my_player.is_on_floor()):
			if(state_machine.last_state == state_machine.stairs_idle_state):
				state_machine.change_state("StairsIdle")
			elif(state_machine.last_state == state_machine.stairs_up_state):
				state_machine.change_state("StairsIdle")
			elif(state_machine.last_state == state_machine.stairs_down_state):
				state_machine.change_state("StairsIdle")
			else:
					transition_to_idle()
		else:
			transition_to_air()
#		if((state_machine.last_state == state_machine.get_node("Idle")) || (state_machine.last_state == state_machine.get_node("Walk"))):
#			transition_to_idle()
#		if(state_machine.last_state == state_machine.get_node("Air")):
#			transition_to_air()
