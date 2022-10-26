extends BaseState

var left
var right

func enter():
	print ("Enter Walk State")

func exit():
	print ("Exit Walk State")


func input_handler(event: InputEvent):
	right = Input.get_action_strength("ui_right")
	left = Input.get_action_strength("ui_left")


func physics_tick(_delta):
	state_machine.player.add_velocity(left, right, _delta)
