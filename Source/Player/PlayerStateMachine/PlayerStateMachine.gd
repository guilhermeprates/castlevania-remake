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

func _ready() -> void:
	current_state = idle_state


func initialize_state_machine(player):
	my_player = player
	for child in get_children():
		child.state_machine = self
	current_state.enter()


func _process(delta: float) -> void:
	current_state.tick(delta)


func _physics_process(delta: float) -> void:
	current_state.physics_tick(delta)

func change_state(new_state_name: String):
	current_state.exit()
	last_state = current_state
	current_state = get_node(new_state_name)
	current_state.enter()

func _unhandled_input(event: InputEvent) -> void:
	current_state.input_handler(event)

