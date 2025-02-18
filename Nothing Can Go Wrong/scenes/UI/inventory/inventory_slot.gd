extends Panel

var item_manager
var item_type = null
var interactable : bool = false

var button_showing : bool = false

func _ready():
	connect_to_item_manager()
	set_process_unhandled_input(true)


func _input(event):
	if interactable == false:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			var mouse_pos = get_global_mouse_position()
			
			if get_global_rect().has_point(mouse_pos):
				if button_showing == false:
					button_showing = true
					$AnimationPlayer.play("button_pop_up")
			else:
				if button_showing == true:
					button_showing = false
					$AnimationPlayer.play("button_remove")



func set_type(item_type):
	self.item_type = item_type
	if item_manager.ITEM_TYPE[item_type] in item_manager.interactable_items:
		interactable = true
		set_button_message()
	
	set_image(item_type)


func set_button_message():
	var message = item_manager.items_to_interaction_message[item_manager.ITEM_TYPE[(self.item_type)]]
	$Button.text = " " + message + " "


func set_image(item_type):
	var item_key = item_manager.ITEM_TYPE[item_type]
	var item_image = item_manager.item_to_icon[item_key]
	%ItemDisplay.texture = item_image


func set_quantity(item_quantity : int):
	%QuantityLabel.text = str(item_quantity)


func remove_type():
	self.item_type = null
	interactable = false
	remove_image()


func remove_image():
	%ItemDisplay.texture = null


func remove_quantity():
	%QuantityLabel.text = ""


func connect_to_item_manager():
	item_manager = get_tree().get_first_node_in_group("item_manager")
