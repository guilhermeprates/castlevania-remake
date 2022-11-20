extends BaseState

func enter():
	print ("Enter Idle State")
	state_machine.my_player.animationTree.set("parameters/conditions/Idle", true)
	state_machine.my_player._reset_velocity()

func exit():
	print ("Exit Idle State")
	state_machine.my_player.animationTree.set("parameters/conditions/Idle", false)

func tick(delta):
	
	
	if (state_machine.my_player._velocity.x != 0):
		transition_to_walk()
	
	if(Input.is_action_just_pressed("jump")):
		transition_to_jump()
	
	if(Input.is_action_just_pressed("attack")):
		transition_to_attack()
	
	if(Input.get_action_strength("ui_down") && (!state_machine.stairway_bottom_nearby || !state_machine.stairway_top_nearby)):
		transition_to_ducking()
	
	if(Input.get_action_strength("ui_up") && (state_machine.stairway_bottom_nearby)):
		state_machine.climb_started_from = state_machine.STAIRWAY.BOTTOM
		state_machine.stairway_bottom_nearby = false
		transition_to_stairs_up()
	
	if(Input.get_action_strength("ui_down") && (state_machine.stairway_top_nearby)):
		state_machine.climb_started_from = state_machine.STAIRWAY.TOP
		state_machine.stairway_top_nearby = false
		transition_to_stairs_down()



func physics_tick(delta):
	state_machine.my_player.set_movement(delta)
	state_machine.my_player.set_gravity(delta)




func transition_to_walk():
	state_machine.change_state("Walk")

func transition_to_jump():
	state_machine.change_state("Jump")

func transition_to_attack():
	state_machine.change_state("Attack")

func transition_to_ducking():
	state_machine.change_state("Ducking")

func transition_to_stairs_up():
	state_machine.change_state("StairsUp")

func transition_to_stairs_down():
	state_machine.change_state("StairsDown")
