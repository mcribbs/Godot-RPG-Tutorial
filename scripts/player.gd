extends CharacterBody2D

enum DIRECTION {RIGHT, LEFT, UP, DOWN}

const SPEED = 100
var current_direction

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		current_direction = DIRECTION.RIGHT
		play_move_amination(true)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_direction = DIRECTION.LEFT
		play_move_amination(true)
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_direction = DIRECTION.DOWN
		play_move_amination(true)
		velocity.x = 0
		velocity.y = SPEED
	elif Input.is_action_pressed("ui_up"):
		current_direction = DIRECTION.UP
		play_move_amination(true)
		velocity.x = 0
		velocity.y = -SPEED
	else:
		play_move_amination(false)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()

func play_move_amination(is_moving):
	var dir = current_direction
	var anim = $AnimatedSprite2D
	
	match dir:
		DIRECTION.RIGHT:
			anim.flip_h = false
			if is_moving:
				anim.play("side_walk") 
			else:
				anim.play("side_idle")
		DIRECTION.LEFT:
			anim.flip_h = true
			if is_moving:
				anim.play("side_walk")
			else:
				anim.play("side_idle")
		DIRECTION.UP:
			if is_moving:
				anim.play("back_walk")
			else:
				anim.play("back_idle")
		DIRECTION.DOWN:
			if is_moving:
				anim.play("front_walk")
			else:
				anim.play("front_idle")
