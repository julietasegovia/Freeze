extends Timer

signal second_ticked(seconds_left: int)
signal alarm_finished

@export var min_seconds: int = 10
@export var max_seconds: int = 30
@export var start_on_ready: bool = true

@onready var tick_player: AudioStreamPlayer = $TickPlayer
@onready var alarm_player: AudioStreamPlayer = $AlarmPlayer
var _last_whole_second: int = -1

func _ready() -> void:
	tick_player.finished.connect(_on_tick_audio_finished)
	alarm_player.finished.connect(func(): alarm_finished.emit())
	timeout.connect(_on_timer_timeout)
	
	if start_on_ready:
		start_random()

func start_random() -> void:
	wait_time = randi_range(min_seconds, max_seconds)
	_last_whole_second = int(wait_time)
	start()
	if tick_player.stream != null:
		tick_player.play()

func _process(_delta: float) -> void:
	if is_stopped():
		return
	
	var current_second: int = int(ceil(time_left))
	if current_second != _last_whole_second and current_second > 0:
		_last_whole_second = current_second
		second_ticked.emit(current_second)

func _on_tick_audio_finished() -> void:
	if not is_stopped():
		tick_player.play()

func _on_timer_timeout() -> void:
	tick_player.stop()
	if alarm_player.stream != null:
		alarm_player.play()

func get_time_left_formatted() -> String:
	return str(int(ceil(time_left)))
