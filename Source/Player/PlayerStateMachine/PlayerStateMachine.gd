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
onready var stairway_state = $Stairway
onready var stairs_idle_state = $StairsIdle
onready var stairs_up_state = $StairsUp
onready var stairs_down_state = $StairsDown


onready var is_stairway_nearby = false
onready var up_input

func _ready() -> void:
	current_state = idle_state


func initialize_state_machine(player):
	my_player = player
	for child in get_children():
		child.state_machine = self
	current_state.enter()


func _process(delta: float) -> void:
	current_state.tick(delta)
	
	up_input = Input.is_action_pressed("ui_up")
	stairway_transition()


func _physics_process(delta: float) -> void:
	current_state.physics_tick(delta)



func stairway_transition():
	if(is_stairway_nearby && current_state != stairway_state):
		if(up_input):
			change_state("StairsUp")



func change_state(new_state_name: String):
	current_state.exit()
	last_state = current_state
	current_state = get_node(new_state_name)
	current_state.enter()

func _unhandled_input(event: InputEvent) -> void:
	current_state.input_handler(event)



func _on_Player_on_player_damaged() -> void:
	change_state("GetHit")
