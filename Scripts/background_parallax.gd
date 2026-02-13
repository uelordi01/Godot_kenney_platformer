extends Node2D

var parallax : float = 0.7
@onready var player = $"../Player_medium"

func _process (delta):
	global_position = player.global_position*parallax
