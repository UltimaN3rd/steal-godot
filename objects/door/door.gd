tool
extends KinematicBody2D

var open = false
var switches = []

export var color = Color(1, 1, 1)

onready var sprite = get_child(0)

func _ready():
	sprite.set_modulate(color)

func check_switches():
	var all_are_switched = true
	for s in switches:
		if(s.switched == false):
			all_are_switched = false
			break
	if(all_are_switched):
		open()
	else:
		close()

func open():
	open = true
	sprite.set_opacity(0.2)

func close():
	open = false
	sprite.set_opacity(1)