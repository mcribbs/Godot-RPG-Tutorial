extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scene()


func _on_world_transition_body_entered(body):
	if body.has_method("player"):
		Global.in_scene_transition = true


func _on_world_transition_body_exited(body):
	if body.has_method("player"):
		Global.in_scene_transition = false


func change_scene():
	if Global.in_scene_transition:
		if Global.current_scene == "cliffside":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			Global.finish_changeing_scene()
