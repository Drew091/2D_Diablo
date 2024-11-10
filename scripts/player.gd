extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var charge_cooldown = true
var charging = false
var health = 100

var charge_spell : ChargeSpell
var charge_just_invoked = false

var attack_ip = false

var speed = 100
var current_dir = "right"

func _ready():
	$AnimatedSprite2D.play("front_idle")
	charge_spell = ChargeSpell.new(self)
	charge_spell.set_anim(1)

func _physics_process(delta):
	player_movement()
	finalize_movement()
	enemy_attack()
	attack()
	current_camera()
	update_health()
	player_death()
	respawn()
	charge_spell.update()
	
	
func player_movement():
	if global.player_alive:
		if Input.is_action_pressed("ui_right"):
			current_dir ="right"
			play_anim(1)
			velocity.x = speed
			velocity.y = 0
		elif Input.is_action_pressed("ui_left"):
			current_dir ="left"
			play_anim(1)
			velocity.x = -speed
			velocity.y = 0
		elif Input.is_action_pressed("ui_down"):
			current_dir ="down"
			play_anim(1)
			velocity.y = speed
			velocity.x = 0
		elif Input.is_action_pressed("ui_up"):
			current_dir ="up"
			play_anim(1)
			velocity.y = -speed
			velocity.x = 0
		elif Input.is_action_just_pressed("spell_1"):
			print("player alive: ", global.player_alive)
			charge_spell.invoke()
		else:
			play_anim(0)


func finalize_movement():
	move_and_slide()
	velocity.x = 0
	velocity.y = 0
	
	
func play_anim(movement):
	if global.player_alive:
		var dir = current_dir
		var anim = $AnimatedSprite2D
	
		if dir == "right":
			anim.flip_h = false
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				if attack_ip == false:
					anim.play("side_idle")
		if dir == "left":
			anim.flip_h = true
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				if attack_ip == false:
					anim.play("side_idle")
			
		if dir == "down":
			anim.flip_h = true
			if movement == 1:
				anim.play("front_walk")
			elif movement == 0:
				if attack_ip == false:
					anim.play("front_idle")				
		if dir == "up":
			anim.flip_h = true
			if movement == 1:
				anim.play("back_walk")
			elif movement == 0:
				if attack_ip == false:
					anim.play("back_idle")
			
func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy") and global.enemy_alive:
		enemy_inattack_range = true
		
func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
func enemy_attack():
	if global.player_alive == true:
		if enemy_inattack_range and enemy_attack_cooldown == true:
			health = health - 20
			enemy_attack_cooldown = false
			$attack_cooldown.start()
			print(health)
			
func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	
	
func attack():
	var dir = current_dir
	if Input.is_action_just_pressed("attack") and global.player_alive:
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false
	
	
func current_camera():
	if global.current_scene == "world":
		$world_camera.enabled = true
		$cliffside_camera.enabled = false
	elif global.current_scene == "cliff_side":
		$world_camera.enabled = false
		$cliffside_camera.enabled = true
	
	
func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
	
	
func _on_regen_timer_timeout() -> void:
	if global.player_alive:
		health = health + 20
		if health > 100:
			health = 100
	else:
		health = 0
		
func player_death():
	if health <= 0:
		if global.player_alive:
			global.player_alive = false
			print("player has been killed")
			print(global.player_alive)
			health = 0
			
			var dir = current_dir
			
			if dir == "right":
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("death")
			if dir == "left":
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("death")
				
				
func respawn():
	if global.player_alive == false:
		if Input.is_action_just_pressed("respawn"):
			self.position.x = global.player_start_posx
			self.position.y = global.player_start_posy
			health = 100
			global.player_alive = true
			#self.queue_free()
