class_name PlayerCamera 
extends Camera2D

enum FACING { NONE = 0, LEFT = -1, RIGHT = 1 }

const LOOK_AHEAD_FACTOR = 0.2
const SHIFT_TRANS = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 1.0

var facing = FACING.NONE

onready var previous_camera_position: Vector2 = get_camera_position()
onready var tween: Tween = $ShiftTween

func _ready() -> void:
	_set_connections()

func _process(_delta: float) -> void:
	_check_facing()
	previous_camera_position = get_camera_position()

func _check_facing() -> void:
	var new_facing = sign(get_camera_position().x - previous_camera_position.x)
	if new_facing != FACING.NONE && new_facing != facing:
		facing = new_facing
		var target_offset = get_viewport_rect().size.x * LOOK_AHEAD_FACTOR * facing
		# warning-ignore:return_value_discarded
		tween.interpolate_property(
			self, 
			"position:x", 
			position.x, 
			target_offset,
			SHIFT_DURATION, 
			SHIFT_TRANS,
			SHIFT_EASE
		)
		# warning-ignore:return_value_discarded
		tween.start()
		
func _on_player_grounded_updated(is_grounded) -> void:
	drag_margin_v_enabled = !is_grounded
 
func _set_connections() -> void:
	var player = get_parent()
	player.connect("on_grounded_updated", self, "_on_player_grounded_updated")
