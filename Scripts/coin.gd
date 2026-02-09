extends Area2D

var rotate_speed : float = 3.0
var bob_height : float = 5.0
var bob_speed : float = 5.0

@onready var start_pos : Vector2 = global_position
@onready var sprite = $coin
func _physics_process(delta: float) -> void:
	var time = Time.get_unix_time_from_system()#we take the timestamp
	sprite.scale.x = sin(time*rotate_speed)
	# we are gona rotate
	var y_pos = ((1+sin(time*bob_speed))/2)*bob_height
	global_position.y = start_pos.y - y_pos
	# we are gona move the coin


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	body.increase_score(1)
	queue_free()
