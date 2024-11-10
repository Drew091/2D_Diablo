extends Object

class_name ChargeSpell

var entity : CharacterBody2D
var charge_cooldown = true
var charging = false
var charge_duration_timer : Timer
var charge_cooldown_timer : Timer
var charge_just_invoked = false
var animation = -1

func _init(entity) -> void:
	self.entity = entity
	initialize_timers()
	
	
func initialize_timers() -> void:
	charge_duration_timer = Timer.new()
	charge_cooldown_timer = Timer.new()
	entity.add_child(charge_duration_timer)
	entity.add_child(charge_cooldown_timer)
	charge_duration_timer.connect("timeout",_on_charge_duration_timeout)
	charge_cooldown_timer.connect("timeout",_on_charge_cooldown_timer_timeout)
	charge_duration_timer.one_shot = true
	charge_cooldown_timer.one_shot = true
	charge_duration_timer.wait_time	= 0.15
	charge_cooldown_timer.wait_time = 2
	
	
func invoke() -> void:
	charge_just_invoked = true
	
	
func set_anim(animation) -> void:
	self.animation = animation
	
	
func update() -> void:	
	if charge_just_invoked and charge_cooldown:
		charge_just_invoked = false
		charge_cooldown = false
		charging = true
		charge_duration_timer.start()
		charge_cooldown_timer.start()
		print("Charging: ",charging)
		print("chargeCD: ",charge_cooldown)
			
	if charging:
		entity.velocity.x =  4 * entity.speed
		entity.velocity.y = 0
		if animation != -1:
			entity.play_anim(animation)
	
	
func _on_charge_duration_timeout() -> void:
	charging = false
	print("Charging: ", charging)


func _on_charge_cooldown_timer_timeout() -> void:
	charge_cooldown = true
	print("chargeCD: ", charge_cooldown)
