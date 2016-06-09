
extends Area2D

export(int) var this_level = 0

var save_file = File.new()
var level_complete = [false, false, false, false, false, false] # B1/2, I1/2, E1/2

onready var the_light = get_node("Light")

func _ready():
	if(save_file.file_exists("user://save.txt")):
		save_file.open("user://save.txt", save_file.READ)
		var save_data = save_file.get_as_text()
		if(not save_data.empty()):
			for i in range(level_complete.size()):
				level_complete[i] = (save_data[i] == "1")
	else:
		save_file.open("user://save.txt", save_file.WRITE)
		for i in range(level_complete.size()):
			save_file.store_var(false)
	save_file.close()

func _on_Stairs_body_enter( body ):
	if(body.get_name() == "Player"):
		level_complete[this_level] = true
		
		save_file.open("user://save.txt", save_file.WRITE)
		for i in range(level_complete.size()):
			if(level_complete[i]):
				save_file.store_string("1")
			else:
				save_file.store_string("0")
		save_file.close()
		
		body.celebrate(self)
		set_pos(get_pos() + Vector2(0, -50))
		the_light.set_hidden(false)