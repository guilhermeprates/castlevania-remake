extends BaseState

func enter():
	print ("Enter Ducking State")
	state_machine.my_player.animationTree.set("parameters/conditions/Ducking", true)
	state_machine.my_player._reset_velocity()
	state_machine.my_player.enable_short_hitboxes()



func exit():
	print ("Exit Ducking State")
	state_machine.my_player.animationTree.set("parameters/conditions/Ducking", false)
	state_machine.my_player.disable_short_hitboxes()



func tick(delta):
	if(!Input.is_action_pressed("ui_down")):
		transition_to_idle()
	if(Input.get_action_strength("attack")):
		transition_to_ducking_attack()


func physics_tick(delta):
	state_machine.my_player.set_gravity(delta)


func transition_to_idle():
	state_machine.change_state("Idle")

func transition_to_ducking_attack():
	state_machine.change_state("DuckingAttack")
