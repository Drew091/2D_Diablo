extends Node

var player_alive = true
var enemy_alive = true
var player_current_attack = false

var current_scene = "world" #world cliff_side
var transition_scene = false

var player_exit_cliffside_posx = 199
var player_exit_cliffside_posy = 29
var player_start_posx = 137
var player_start_posy = 128

var game_first_loadin = true

func finish_changescenes():
	print(current_scene)
	print(transition_scene)
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "cliff_side"
		else: 
			current_scene = "world"
