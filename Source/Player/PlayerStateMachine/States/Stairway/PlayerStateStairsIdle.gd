extends BaseState

func enter():
	print ("Enter Stairs IDLE State")
	state_machine.my_player.animationTree.set("parameters/conditions/StairsIdle", true)



func exit():
	print ("Exit Stairs IDLE State")
	state_machine.my_player.animationTree.set("parameters/conditions/StairsIdle", false)
	state_machine.is_stairway_nearby = false


func tick(delta):
	if (state_machine.my_player._velocity.x == 0):
		transition_to_idle()

func physics_tick(delta):
	state_machine.my_player.set_stairway_movement(delta)


func transition_to_idle():
	state_machine.change_state("Idle")
