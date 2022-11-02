extends BaseState

func enter():
	print ("Enter Walk State")
#	state_machine.my_player.playback.travel("Walk")
	state_machine.my_player.animationTree.set("parameters/conditions/Walk", true)

func exit():
	print ("Exit Walk State")
	state_machine.my_player.animationTree.set("parameters/conditions/Walk", false)

func tick(delta):
	state_machine.my_player.set_movement(delta)
	state_machine.my_player.flip_sprite()
	
	if (state_machine.my_player._velocity.x == 0):
		transition_to_idle()
	
	if(Input.get_action_strength("jump")):
		transition_to_jump()



func transition_to_idle():
	state_machine.change_state("Idle")


func transition_to_jump():
	state_machine.change_state("Jump")
