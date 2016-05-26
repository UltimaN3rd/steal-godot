
extends KinematicBody2D

const GRID_STEP = 50
const movement_time = 0.2

var moved = false
var last_movement = Vector2()
var move_next_frame = -1
var next_target = Vector2()
var directions = [false, false, false, false] #Up, Down, Left, Right
var movement_timer = 0

onready var target_position = get_pos()
onready var last_position = get_pos()
onready var sprite = get_child(0)

func _ready():
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	if(event.is_action_pressed("room_reset")):
		get_tree().reload_current_scene()
	elif(event.is_action_pressed("ui_cancel")):
		get_tree().quit()
	elif(event.is_action_released("ui_up")):
		directions[0] = false
		movement_timer = movement_time
	elif(event.is_action_released("ui_down")):
		directions[1] = false
		movement_timer = movement_time
	elif(event.is_action_released("ui_left")):
		directions[2] = false
		movement_timer = movement_time
	elif(event.is_action_released("ui_right")):
		directions[3] = false
		movement_timer = movement_time
	elif(event.is_action_pressed("ui_up")):
		directions[0] = true
	elif(event.is_action_pressed("ui_down")):
		directions[1] = true
	elif(event.is_action_pressed("ui_left")):
		directions[2] = true
	elif(event.is_action_pressed("ui_right")):
		directions[3] = true

func _fixed_process(delta):
	movement_timer += delta
	if(movement_timer >= movement_time):
		if(directions[0] and not directions[1] and not directions[2] and not directions[3]):
			move(Vector2(0, -GRID_STEP))
			sprite.parent_moved = false
			movement_timer = 0
		elif(directions[1] and not directions[0] and not directions[2] and not directions[3]):
			move(Vector2(0, GRID_STEP))
			sprite.parent_moved = false
			movement_timer = 0
		elif(directions[2] and not directions[0] and not directions[1] and not directions[3]):
			move(Vector2(-GRID_STEP, 0))
			sprite.parent_moved = false
			movement_timer = 0
		elif(directions[3] and not directions[0] and not directions[1] and not directions[2]):
			move(Vector2(GRID_STEP, 0))
			sprite.parent_moved = false
			movement_timer = 0
	
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
						hit.collider.move(target_position - last_position) # Move boulders
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
		target_position = vector
		moved = true

func move_to(target):
	if(target != last_position):
		target_position = target
		moved = true
		move_next_frame = -1

func delayed_move_to(target, delay = 1):
	move_next_frame = delay
	next_target = target