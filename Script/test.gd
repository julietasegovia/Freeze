extends Node

var last_printed: String = ""

func _ready() -> void:
	var timer = load("res://random_timer.tscn").instantiate()
	add_child(timer)
	timer.timeout.connect(_on_timer_done)
	print("Timer started! Picked random whole time: %d seconds" % timer.wait_time)

func _process(_delta: float) -> void:
	var timer = get_child(0)
	if not timer.is_stopped():
		var current = timer.get_time_left_formatted()
		if current != last_printed:
			print("Time left: %s" % current)
			last_printed = current

func _on_timer_done() -> void:
	print("Time left: 0")
	print("ALARM! Time is up!")
	get_tree().quit()
