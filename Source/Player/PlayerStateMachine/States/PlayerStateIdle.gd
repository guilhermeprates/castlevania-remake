extends BaseState

func enter():
	print ("Enter Idle State")
	state_machine.my_player._reset_velocity()

func exit():
	print ("Exit Idle State")


func tick(_delta):
	if (state_machine.my_player._velocity.x > 0):
		transition_to_walk()

func input_handler(event: InputEvent):
	pass




func transition_to_walk():
	state_machine.change_state("walk")
