extends BaseState


func enter():
	print ("Enter Stairs UP State")
	state_machine.my_player.animationTree.set("parameters/conditions/StairsUp", true)
	state_machine.my_player.set_collision_mask_bit(4, true)
#	state_machine.stairway_bottom_nearby = false
#	state_machine.stairway_top_nearby = false


func exit():
	print ("Exit Stairs UP State")
	state_machine.my_player.animationTree.set("parameters/conditions/StairsUp", false)
#	state_machine.is_stairway_nearby = false
#	state_machine.my_player.set_collision_mask_bit(4, false)
#	state_machine.stairway_bottom_nearby = false
#	state_machine.stairway_top_nearby = false


func tick(delta):
	if (state_machine.my_player._velocity.x == 0):
		transition_to_stairs_idle()
	
	if(Input.is_action_just_pressed("attack")):
		transition_to_attack()
	
	state_machine.my_player.flip_sprite()
	
	if(state_machine.stairway_exited):
		state_machine.my_player.set_collision_mask_bit(4, false)
		state_machine.stairway_exited = false
		transition_to_idle()
	

func physics_tick(delta):
	state_machine.my_player.set_stairway_movement(delta)


func transition_to_stairs_idle():
	state_machine.change_state("StairsIdle")

func transition_to_idle():
	state_machine.climb_started_from = state_machine.STAIRWAY.FINISHED
	state_machine.change_state("Idle")

func transition_to_attack():
	state_machine.my_player._reset_velocity()
	state_machine.change_state("Attack")
