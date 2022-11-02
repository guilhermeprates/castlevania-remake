extends BaseState

func enter():
	print ("Enter Idle State")
#	state_machine.my_player.playback.travel("Idle")
	state_machine.my_player.animationTree.set("parameters/conditions/Idle", true)
	state_machine.my_player._reset_velocity()

func exit():
	print ("Exit Idle State")
	state_machine.my_player.animationTree.set("parameters/conditions/Idle", false)

func tick(delta):
	state_machine.my_player.set_movement(delta)
	
	if (state_machine.my_player._velocity.x != 0):
		transition_to_walk()
	
	if(Input.get_action_strength("jump")):
		transition_to_jump()



func transition_to_walk():
	state_machine.change_state("Walk")

func transition_to_jump():
	state_machine.change_state("Jump")
