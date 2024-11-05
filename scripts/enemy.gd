extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null

var health = 100
var player_inattack_zone = false
var can_take_damage = true

func _physics_process(delta: float) -> void:	
	deal_with_damage()
	update_health()
	chase_player()

func _on_detection_area_body_entered(body: Node2D) -> void:
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if global.enemy_alive:
		if player_inattack_zone and global.player_current_attack == true:
			if can_take_damage == true:
				health = health - 20
				$take_damage_cooldown.start()
				can_take_damage = false
				print("slime health = ", health)
				if health <=0:
					$AnimatedSprite2D.play("death")
					global.enemy_alive = false
					$healthbar.visible = false
					
func _on_animated_sprite_2d_animation_finished() -> void:
	if ($AnimatedSprite2D.animation == "death"):
		self.queue_free()

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
	
func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100 || global.enemy_alive == false:
		healthbar.visible = false
	else:
		healthbar.visible = true

func chase_player():
	if global.player_alive and global.enemy_alive:
		if player_chase:
			position += (player.position - position)/speed
		
			$AnimatedSprite2D.play("side_walk")
		
			if(player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.play("side_idle")
