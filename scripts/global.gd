extends Node2D

var current_scene = "world"
var in_scene_transition = false

var first_load = true

var player_start_pos_x = 163
var player_start_pos_y = 115

var cliffside_exit_pos_x = 196
var cliffside_exit_pos_y = 10

var player_current_attack = false

func finish_changeing_scene():
	if in_scene_transition:
		in_scene_transition = false
		if current_scene == "world":
			current_scene = "cliffside"
		else:
			current_scene = "world"
