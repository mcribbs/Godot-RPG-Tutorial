extends Node2D

func _ready():
	if Global.first_load == true:
		Global.first_load = false
		$player.position.x = Global.player_start_pos_x
		$player.position.y = Global.player_start_pos_y
	else:
		$player.position.x = Global.cliffside_exit_pos_x
		$player.position.y = Global.cliffside_exit_pos_y

func _process(delta):
	change_scene()

func _on_cliffside_transition_body_entered(body):
	if body.has_method("player"):
		Global.in_scene_transition = true

func _on_cliffside_transition_body_exited(body):
	if body.has_method("player"):
		Global.in_scene_transition = false

func change_scene():
	if Global.in_scene_transition:
		if Global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/cliffside.tscn")
			Global.finish_changeing_scene()
