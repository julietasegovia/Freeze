extends Label

@export var timer: Timer
@export var tablet: Node2D

func _ready() -> void:
	if timer != null:
		setup(timer)

func setup(target_timer: Timer) -> void:
	timer = target_timer
	update_display(int(ceil(timer.wait_time)))
	
	if timer.has_signal("second_ticked"):
		timer.second_ticked.connect(update_display)
	if timer.has_signal("timer_restarted"):
		timer.timer_restarted.connect(update_display)
	timer.timeout.connect(_on_timer_finished)

func _process(_delta: float) -> void:
	if text == "You lose":
		visible = true
		return
	if tablet != null and "is_up" in tablet:
		visible = not tablet.is_up

func update_display(seconds_left: int) -> void:
	if text == "You lose":
		return
	text = "00:%02d" % seconds_left

func _on_timer_finished() -> void:
	text = "00:00"
