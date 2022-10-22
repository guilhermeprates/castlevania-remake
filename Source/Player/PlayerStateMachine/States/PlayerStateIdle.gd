extends BaseState

func enter():
	print ("Enter Idle State")
	state_machine.my_player._reset_velocity()

func exit():
	print ("Exit Idle State")

func input_handler(event: InputEvent):
	
