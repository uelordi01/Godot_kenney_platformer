extends CharacterBody2D

signal OnUpdateHealth(health: int)
signal OnUpdateScore(score: int)

@export var move_speed: float = 100
@export var acceleration: float = 50 
@export var braking: float = 20
@export var gravity: float = 500
@export var jump_force: float = 200
@export var health: int = 3

@export var max_jumps: int = 2  # 2 = normal + double jump

@onready var sprite: Sprite2D = $Sprite
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var camera:Camera2D= $Camera2D
var move_input: float
var move_input_down_up: float
var jumps_done: int = 0
var acceleration_running_extra: int = 1
var accelerate: int = 2
var not_accelerate: int = 1

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jumps_done = 0  # reset jumps when touching the floor

	# horizontal movement
	move_input_down_up = Input.is_action_pressed("move_down")
	if move_input_down_up:
		camera.offset.y = lerp(-30.0, 0.0, 1.0)
	else:
		camera.offset.y = lerp(0.0, -30.0, 1.0)
	if Input.is_action_pressed("accelerate"):
		acceleration_running_extra =	accelerate
	else:
		acceleration_running_extra = not_accelerate	
	move_input = Input.get_axis("move_left", "move_right")
	if move_input != 0.0:
		velocity.x = lerp(velocity.x, move_input * move_speed*acceleration_running_extra, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, acceleration_running_extra*braking * delta)

	# jumping (single + double)
	if Input.is_action_just_pressed("jump") and jumps_done < max_jumps:
		velocity.y = -jump_force
		jumps_done += 1

	move_and_slide()
func _process(delta: float) -> void:
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0
	if global_position.y > 200:
		game_over()	
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
	OnUpdateHealth.emit(health)
	
	if health <= 0:
		call_deferred("game_over")
func game_over():
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)	
func increase_score(amount: int):
	PlayerStats.score +=amount	
	OnUpdateScore.emit(PlayerStats.score)
	print(PlayerStats.score)
			
func _damage_flash():
	sprite.modulate = Color.RED		
	await get_tree().create_timer(0.05).timeout
	sprite.modulate = Color.WHITE
