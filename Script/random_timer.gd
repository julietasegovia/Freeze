extends Timer

@export var min_seconds: int = 10
@export var max_seconds: int = 30
@export var start_on_ready: bool = true

func _ready() -> void:
	if start_on_ready:
		start_random()

func start_random() -> void:
	# randi_range picks a random whole integer (inclusive of both 10 and 30)
	wait_time = randi_range(min_seconds, max_seconds)
	start()

func get_time_left_formatted() -> String:
	# ceil() rounds up so 9.8s displays as "10", 8.1s as "9", down to "1" and "0"
	return str(int(ceil(time_left)))
