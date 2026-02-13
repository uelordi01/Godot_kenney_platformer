extends CharacterBody2D

@export var move_speed : float = 100
@export var acceleration: float = 50 
@export var braking: float = 20
@export var gravity: float = 500
@export var jump_force : float = 200
@export var health: int = 3
@onready var sprite : Sprite2D = $Sprite
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer2D
var take_damage_sfx : AudioStream = preload("res://Audio/take_damage.wav")
var take_coin_sfx : AudioStream = preload("res://Audio/coin.wav")
var move_input : float

#this callback only works when some action is done. 
func _physics_process(delta: float) -> void:
		# we apply when we are not in the floor
	if not is_on_floor():
		velocity.y += gravity*delta
	move_input = Input.get_axis("move_left","move_right")
	# lerp function is a linear interpolation funcction
	#get the move of the input (so is the current movement, the other range and the interpolation formula))
	if move_input != 0:
		velocity.x = lerp(velocity.x, move_input*move_speed, acceleration*delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, braking*delta)

	#now for jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		
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
	play_sound(take_damage_sfx)
	
	if health <= 0:
		call_deferred("game_over")
func game_over():
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")	
func increase_score(amount: int):
	PlayerStats.score +=amount	
	print(PlayerStats.score)
	play_sound(take_coin_sfx)
func play_sound(sound: AudioStream):
	audio.stream = sound
	audio.play()			
			
