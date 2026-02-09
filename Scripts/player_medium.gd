extends CharacterBody2D

@export var move_speed : float = 100
@export var acceleration: float = 50 
@export var braking: float = 20
@export var gravity: float = 500
@export var jump_force : float = 200
@export var health: int = 3
@onready var sprite : Sprite2D = $Sprite
@onready var anim: AnimationPlayer = $AnimationPlayer
var move_input : float
var is_jumping: int = 0

#this callback only works when some action is done. 
func _physics_process(delta: float) -> void:
		# we apply when we are not in the floor
	if not is_on_floor():
		velocity.y += gravity*delta
	else:
		is_jumping = 0	
	move_input = Input.get_axis("move_left","move_right")
	# lerp function is a linear interpolation funcction
	#get the move of the input (so is the current movement, the other range and the interpolation formula))
	if move_input != 0:
		velocity.x = lerp(velocity.x, move_input*move_speed, acceleration*delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, braking*delta)

	#now for jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		if is_jumping==1:
			velocity.y = -jump_force*2
		else:	
			velocity.y = -jump_force
		is_jumping = 1
		
	move_and_slide()
# process function works allways for each frame. 	
func _process(delta: float) -> void:
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0
	_manage_animation()	
func _manage_animation():
	if not is_on_floor():
		anim.play("jump")
	elif move_input != 0:
		anim.play("move")
		#print("move")
	else:
		anim.play("idle")	
		#print("iddle")
func take_damage(amount: int):
	health -= amount
	
	if health <= 0:
		call_deferred("game_over")
func game_over():
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")	
func increase_score(amount: int):
	PlayerStats.score +=amount	
	print(PlayerStats.score)
			
