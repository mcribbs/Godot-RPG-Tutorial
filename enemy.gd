extends CharacterBody2D

const SPEED = 40
var is_chasing = false
var player = null

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	if is_chasing:
		position += (player.position - position) / SPEED
		
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body):
	player = body
	is_chasing = true

func _on_detection_area_body_exited(body):
	player = null
	is_chasing = false
