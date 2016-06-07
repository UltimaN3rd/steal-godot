tool
extends Area2D

var switched = false

onready var sprite = get_child(0)
onready var parent = get_parent()
onready var color_on = parent.color.linear_interpolate(Color(1, 1, 1), 0.5)
onready var color_off = parent.color

func _ready():
	parent.switches.push_back(self)
	if(switched):
		sprite.set_modulate(color_on)
	else:
		sprite.set_modulate(color_off)

func _on_Switch_body_enter( body ):
	if(body.get_name() != "TileMap"):
		switched = true
		sprite.set_modulate(color_on)
		parent.check_switches()

func _on_Switch_body_exit( body ):
	switched = false
	sprite.set_modulate(color_off)
	parent.check_switches()