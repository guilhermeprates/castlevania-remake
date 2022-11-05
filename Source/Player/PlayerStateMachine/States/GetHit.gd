extends BaseState

func enter():
	print ("Enter GetHit State")
	state_machine.my_player.animationTree.set("parameters/conditions/GetHit", true)
	state_machine.my_player.set_movement_momentum()


func exit():
	print ("Exit GetHit State")
	state_machine.my_player.animationTree.set("parameters/conditions/GetHit", false)



func tick(delta):
	pass


func physics_tick(delta):
	state_machine.my_player.set_gravity(delta)


func transition_to_idle():
	state_machine.change_state("Idle")
