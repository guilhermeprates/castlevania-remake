extends BaseState

var count = 0

func enter():
	print ("Enter GetHit State")
	state_machine.my_player.animationTree.set("parameters/conditions/GetHit", true)
	state_machine.my_player.take_damage()
	state_machine.my_player.set_knockback()
	


func exit():
	print ("Exit GetHit State")
	state_machine.my_player.back_from_hit()
	state_machine.my_player.animationTree.set("parameters/conditions/GetHit", false)
	count = 0



func tick(delta):
	count += delta
	if(count > 2):
		if(Game.player_health_points <= 0):
			transition_to_death()
		else: 
			transition_to_idle()


func physics_tick(delta):
	state_machine.my_player.set_gravity(delta)


func transition_to_idle():
	state_machine.change_state("Idle")

func transition_to_death():
	state_machine.change_state("Death")

func _on_Player_on_grounded_updated(is_grounded) -> void:
	if(count > 0.1):
		if(Game.player_health_points <= 0):
			transition_to_death()
		else: 
			transition_to_idle()
