extends BaseState

func enter():
	print ("Enter Ducking Attack State")
	state_machine.my_player.animationTree.set("parameters/conditions/DuckingAttack", true)
	state_machine.my_player.enable_short_hitboxes()


func exit():
	print ("Exit Ducking Attack State")
	state_machine.my_player.animationTree.set("parameters/conditions/DuckingAttack", false)
	state_machine.my_player.disable_whip_collision_shape()
	state_machine.my_player.disable_short_hitboxes()

func tick(delta):
	pass


func physics_tick(delta):
	state_machine.my_player.set_gravity(delta)


func transition_to_ducking():
	state_machine.change_state("Ducking")


func _on_Player_on_animation_ended() -> void:
	if(state_machine.current_state == state_machine.get_node("DuckingAttack")):
		transition_to_ducking()
