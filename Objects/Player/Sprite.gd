
extends Sprite

var parent_moved = true

const move_factor = 0.5
const closeness_threshold = 0.05

onready var parent = get_parent()
onready var current_position = get_global_pos()
onready var target_position = parent.get_global_pos()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if(parent_moved):
		target_position = parent.get_global_pos()
	
	current_position = current_position.linear_interpolate(target_position, move_factor)
	set_global_pos(current_position)
	
	if(abs(target_position.x - current_position.x) < closeness_threshold and abs(target_position.y - current_position.y) < closeness_threshold):
		parent_moved = false