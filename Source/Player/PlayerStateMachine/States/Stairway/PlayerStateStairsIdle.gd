extends BaseState

func enter():
	print ("Enter Stairs IDLE State")
	state_machine.my_player.animationTree.set("parameters/conditions/StairsIdle", true)	
	if(state_machine.last_state == state_machine.get_node("StairsUp")):
		state_machine.my_player.animationTree.set("parameters/Stairs-Idle/blend_position", 1)
	elif(state_machine.last_state == state_machine.get_node("StairsDown")):
		state_machine.my_player.animationTree.set("parameters/Stairs-Idle/blend_position", -1)
	
	
	state_machine.my_player._reset_velocity()



func exit():
	print ("Exit Stairs IDLE State")
	state_machine.my_player.animationTree.set("parameters/conditions/StairsIdle", false)



func tick(delta):
	if (state_machine.my_player._velocity.x != 0):
		transition_to_stairs_walk()
	if(Input.is_action_just_pressed("attack")):
		transition_to_attack()
		

func physics_tick(delta):
	state_machine.my_player.set_stairway_movement(delta)


func transition_to_stairs_walk():
	if(state_machine.climb_started_from == state_machine.STAIRWAY.BOTTOM):
		if(state_machine.my_player._velocity.y < 0):
			state_machine.change_state("StairsUp")
		if(state_machine.my_player._velocity.y > 0):
			state_machine.change_state("StairsDown")
	elif(state_machine.climb_started_from == state_machine.STAIRWAY.TOP):
		if(state_machine.my_player._velocity.y > 0):
			state_machine.change_state("StairsDown")
		if(state_machine.my_player._velocity.y < 0):
			state_machine.change_state("StairsUp")

func transition_to_attack():
	state_machine.my_player._reset_velocity()
	state_machine.change_state("Attack")
