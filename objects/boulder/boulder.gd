
extends KinematicBody2D

const GRID_STEP = 50

var moved = false
var last_movement = Vector2()
var move_next_frame = -1
var next_target = Vector2()

onready var last_position = get_pos()
onready var target_position = get_pos()
onready var sprite = get_child(0)

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if(target_position != last_position):
		moved = true
		sprite.parent_moved = false
	if(move_next_frame > 0):
		move_next_frame -= 1
	elif(move_next_frame == 0):
		move_next_frame -= 1
		move_to(next_target)
	
	if(moved):
		last_position = get_pos()
		moved = false
		var move_test = get_world_2d().get_direct_space_state().intersect_point(target_position)
		
		var collided = false
		
		# Check what we hit
		if(!move_test.empty()):
			collided = false # Default to non-solid collision
			
			for hit in move_test:
				var hit_name = hit.collider.get_name()
				if(hit_name == "TileMap"):
					var tile_index = hit.collider.get_cellv(target_position / GRID_STEP)
					if(tile_index == 0): #Blue
						collided = true
					elif(tile_index == 1): #Ice
						delayed_move_to(target_position + target_position - last_position)
				else:
					var hit_group = hit.collider.get_parent().get_name()
					if(hit_group == "Boulders"):
						#hit.collider.move(target_position - last_position) # Move boulders
						collided = true
					elif(hit_group == "Doors"):
						if(hit.collider.open == false):
							collided = true
					elif(hit_group == "FlipSwitches"):
						hit.collider.flip()
						collided = true
		
		if(collided):
			target_position = last_position # Since we collided, don't move
			move_next_frame = -1
		else:
			last_movement = target_position - last_position
			last_position = target_position
			set_pos(target_position) # Move and notify sprite
			sprite.parent_moved = true

func move(vector):
	vector += last_position
	if(vector != last_position):
		moved = true
		target_position = vector

func move_to(target):
	if(target != last_position):
		moved = true
		target_position = target
		move_next_frame = -1

func delayed_move_to(target, delay = 2):
	move_next_frame = delay
	next_target = target