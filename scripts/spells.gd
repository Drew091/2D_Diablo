extends Node
var current_dir = "none"
var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func charge():
	#if Input.is_action_just_pressed("spell_1"):
		print("valami")
		if current_dir == "right":
			self.velocity.x = 300
			self.velocity.y = 0
		
