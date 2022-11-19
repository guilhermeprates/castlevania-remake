extends BaseState


func enter():
	print ("Enter Stairs UP State")
	state_machine.my_player.animationTree.set("parameters/conditions/StairsUp", true)



func exit():
	print ("Exit Stairs UP State")
	state_machine.my_player.animationTree.set("parameters/conditions/StairsUp", false)
	state_machine.is_stairway_nearby = false


func tick(delta):
	if (state_machine.my_player._velocity.x == 0):
		transition_to_idle()

func physics_tick(delta):
	state_machine.my_player.set_stairway_movement(delta)


func transition_to_idle():
	state_machine.change_state("Idle")
