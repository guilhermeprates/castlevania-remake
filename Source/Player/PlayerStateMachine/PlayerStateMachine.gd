class_name PlayerStateMachine
extends Node


onready var current_state: BaseState
onready var last_state: BaseState
onready var my_player
onready var idle_state = $Idle
onready var walk_state = $Walk
onready var jump_state = $Jump
onready var attack_state = $Attack
onready var air_state = $Air
onready var get_hit_state = $GetHit
onready var death_state = $Death
onready var ducking_state = $Ducking
onready var ducking_attack_state = $DuckingAttack
onready var stairs_idle_state = $StairsIdle
onready var stairs_up_state = $StairsUp
onready var stairs_down_state = $StairsDown

enum STAIRWAY {TOP, BOTTOM, FINISHED}

onready var stairway_bottom_nearby = false
onready var stairway_top_nearby = false
onready var stairway_exited = false
onready var up_input
onready var down_input
onready var climb_started_from

func _ready() -> void:
	current_state = idle_state


func initialize_state_machine(player):
	my_player = player
	for child in get_children():
		child.state_machine = self
	current_state.enter()


func _process(delta: float) -> void:
	current_state.tick(delta)
#	print("bottom nearby " + str(stairway_bottom_nearby))
#	print("top nearby " + str(stairway_top_nearby))
	up_input = Input.is_action_pressed("ui_up")
	down_input = Input.is_action_pressed("ui_down")
#	stairway_transition()


func _physics_process(delta: float) -> void:
	current_state.physics_tick(delta)



#func stairway_transition():
#	if(stairway_bottom_nearby && current_state == idle_state):
#		if(up_input):
#			climb_started_from = STAIRWAY.BOTTOM
#			stairway_bottom_nearby = false
#			change_state("StairsUp")
#	if(stairway_top_nearby && current_state == idle_state):
#		if(down_input):
#			climb_started_from = STAIRWAY.TOP
#			stairway_top_nearby = false
#			change_state("StairsDown")
#	if((stairway_bottom_nearby || stairway_top_nearby) && (current_state == stairs_down_state || current_state == stairs_up_state)):
##		my_player.set_collision_mask_bit(4, false)
#		change_state("Idle")



func change_state(new_state_name: String):
	current_state.exit()
	last_state = current_state
	current_state = get_node(new_state_name)
	current_state.enter()


func _unhandled_input(event: InputEvent) -> void:
	current_state.input_handler(event)



func _on_Player_on_player_damaged() -> void:
	change_state("GetHit")


func _on_Player_on_stairway_bottom_found() -> void:
#	if(last_state != stairs_down_state):
	stairway_bottom_nearby = true
#	stairway_exited = false


func _on_Player_on_stairway_top_found() -> void:
#	if(last_state != stairs_up_state):
	stairway_top_nearby = true
#	stairway_exited = false


func _on_Player_on_stairway_bottom_top_exited() -> void:
	stairway_bottom_nearby = false
	stairway_top_nearby = false


func _on_Player_on_stairway_exited() -> void:
	print("stairway exited")
	stairway_exited = true
