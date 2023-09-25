extends CharacterBody2D

const SPEED = 40
var is_chasing = false
var player = null

var player_in_range = false
var health = 100
var alive = true
var can_take_damage = true

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	
	handle_attack()
	
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

func enemy():
	pass #used to identy that this entity is an enemy

func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_range = true

func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_range = false

func handle_attack():
	if player_in_range and global.player_current_attack and can_take_damage:
		health = health - 20
		$hitbox/take_damage_cooldown.start()
		can_take_damage = false
		print("Slime health = ", health)
		if health <= 0:
			self.queue_free()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true
