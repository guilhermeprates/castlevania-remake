extends BaseState

func enter():
	print ("Enter Ducking State")
	state_machine.my_player.animationTree.set("parameters/conditions/Ducking", true)



func exit():
	print ("Exit Ducking State")
	state_machine.my_player.animationTree.set("parameters/conditions/Ducking", false)



func tick(delta):
	if(Input.is_action_just_released("ui_down")):
		transition_to_idle()
	if(Input.get_action_strength("attack")):
		transition_to_ducking_attack()


func physics_tick(delta):
	state_machine.my_player.set_gravity(delta)


func transition_to_idle():
	state_machine.change_state("Idle")

func transition_to_ducking_attack():
	state_machine.change_state("DuckingAttack")
