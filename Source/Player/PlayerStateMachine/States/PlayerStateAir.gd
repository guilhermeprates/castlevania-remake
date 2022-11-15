extends BaseState

func enter():
	print ("Enter Air State")
	state_machine.my_player.animationTree.set("parameters/conditions/Air", true)
	state_machine.my_player.set_movement_momentum()


func exit():
	print ("Exit Air State")
	state_machine.my_player.animationTree.set("parameters/conditions/Air", false)




func tick(delta):
	if(Input.is_action_just_pressed("attack")):
		transition_to_attack()


func physics_tick(delta):
	state_machine.my_player.set_gravity(delta)


func transition_to_idle():
	state_machine.change_state("Idle")

func transition_to_attack():
	state_machine.change_state("Attack")

func _on_Player_on_grounded_updated(is_grounded) -> void:
	if(state_machine.current_state == state_machine.get_node("Air")):
		print ("Grounded again")
		transition_to_idle()

