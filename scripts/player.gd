extends CharacterBody2D

enum DIRECTION {RIGHT, LEFT, UP, DOWN}

const SPEED = 100
const MAX_HEALTH = 200
var current_direction

var enemy_in_range = false
var enemy_out_of_cooldown = true
var health = MAX_HEALTH
var alive = true

var is_attack_in_progress = false

func _ready():
	$AnimatedSprite2D.play("front_idle")
	$health_bar.max_value = MAX_HEALTH

func _physics_process(delta):
	player_movement(delta)
	handle_enemy_attack()
	attack()
	current_camera()
	update_healthbar()
	
	if health <= 0:
		alive = false
		health = 0
		print("PLayer has been killed")
		# TODO Handle death
		self.queue_free()

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
				if not is_attack_in_progress:
					anim.play("side_idle")
		DIRECTION.LEFT:
			anim.flip_h = true
			if is_moving:
				anim.play("side_walk")
			else:
				if not is_attack_in_progress:
					anim.play("side_idle")
		DIRECTION.UP:
			if is_moving:
				anim.play("back_walk")
			else:
				if not is_attack_in_progress:
					anim.play("back_idle")
		DIRECTION.DOWN:
			if is_moving:
				anim.play("front_walk")
			else:
				if not is_attack_in_progress:
					anim.play("front_idle")

func player():
	pass #used to identy that this entity is the player

func _on_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_range = true

func _on_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_range = false

func handle_enemy_attack():
	if enemy_in_range and enemy_out_of_cooldown:
		health = health - 20
		enemy_out_of_cooldown = false
		$enemy_attack_cooldown.start()
		print("Player health = ", health)

func _on_enemy_attack_cooldown_timeout():
	enemy_out_of_cooldown = true

func attack():
	var dir = current_direction
	
	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true
		is_attack_in_progress = true
		match dir:
			DIRECTION.RIGHT:
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("side_attack")
				$attack_timer.start()
			DIRECTION.LEFT:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("side_attack")
				$attack_timer.start()
			DIRECTION.DOWN:
				$AnimatedSprite2D.play("front_attack")
				$attack_timer.start()
			DIRECTION.UP:
				$AnimatedSprite2D.play("back_attack")
				$attack_timer.start()

func _on_attack_timer_timeout():
	$attack_timer.stop()
	Global.player_current_attack = false
	is_attack_in_progress = false

func current_camera():
	if Global.current_scene == "world":
		$world_camera.enabled = true
		$cliffside_camera.enabled = false
	elif Global.current_scene == "cliffside":
		$world_camera.enabled = false
		$cliffside_camera.enabled = true

func update_healthbar():
	var healthbar = $health_bar
	healthbar.value = health
	
	if health >= MAX_HEALTH:
		healthbar.visible = false
	else:
		healthbar.visible = true


func _on_regen_timer_timeout():
	if health < MAX_HEALTH:
		health = health + 20
	if health > MAX_HEALTH:
		health = MAX_HEALTH
	if health <= 0:
		health = 0
