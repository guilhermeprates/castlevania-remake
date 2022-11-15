extends Sprite

var positions = []
var index = 0

func _ready() -> void:
	for node in get_parent().get_children():
		if node is Button:
			print(node.name, node.rect_position) #posição das opções
			positions.append(node)
	set_selection(0)
	#0 - continue; 1 - end;
	
func set_selection(new_index):
	if 0 <= new_index and new_index < len(positions):
		index = new_index
		var selected_node = positions[index]
		
		#alinhar icone com as opções
		position = Vector2(
			selected_node.rect_position.x - (get_rect().size.x * 6)/2, 
			selected_node.rect_position.y + selected_node.rect_size.y/2)
	else:
		print("Invalid index")
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		move_up()
	elif Input.is_action_just_pressed("ui_down"):
		move_down()

func move_up():
	set_selection(index - 1)
# se tiver som:
#	if set_selection_entry(index -1):
#		$Sound/xxxxxxxxx.play()

func move_down():
	set_selection(index + 1)
