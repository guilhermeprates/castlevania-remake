extends BaseState

func enter():
	print ("Enter Death State")
	state_machine.my_player.animationTree.set("parameters/conditions/Death", true)
	state_machine.my_player._reset_velocity()
#	state_machine.my_player.enable_short_hitboxes()


func exit():
	print ("Exit Death State")
	state_machine.my_player.animationTree.set("parameters/conditions/Death", false)
#	state_machine.my_player.disable_short_hitboxes()


func tick(delta):
	pass

func physics_tick(delta):
	state_machine.my_player.set_gravity(delta)
