extends BaseState


func enter():
	print ("Enter Jump State")
	state_machine.my_player.animationTree.set("parameters/conditions/Jump", true)
	if(state_machine.last_state == state_machine.idle_state):
		state_machine.my_player.set_upward_jump()
	elif(state_machine.last_state == state_machine.walk_state):
		state_machine.my_player.set_forward_jump()

func tick(delta):
	pass



func physics_tick(delta):
	state_machine.my_player.set_gravity(delta)
	
	if(Input.is_action_just_pressed("attack")):
		transition_to_attack()


func exit():
	state_machine.my_player.animationTree.set("parameters/conditions/Jump", false)
	print ("Exit Jump State")



func transition_to_attack():
	state_machine.change_state("Attack")

func transition_to_air():
	state_machine.change_state("Air")


func _on_Player_on_animation_ended() -> void:
	if(state_machine.current_state == state_machine.get_node("Jump")):
		transition_to_air()
