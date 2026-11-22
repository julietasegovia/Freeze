extends Node2D

@onready var timer: Timer = $RandomTimer
@onready var display: Label = $TimerDisplay

var armed := false
var lost := false
var frozen_mouse := Vector2.ZERO
const MOVE_LIMIT := 6.0

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	timer.connect("timer_restarted", _on_timer_restarted)

func _on_timer_timeout() -> void:
	armed = true
	frozen_mouse = get_global_mouse_position()

func _on_timer_restarted(_new_seconds: int) -> void:
	if lost:
		return
	armed = false

func _process(_delta: float) -> void:
	if lost or not armed:
		return
	if get_global_mouse_position().distance_to(frozen_mouse) <= MOVE_LIMIT:
		return
	lost = true
	display.text = "You lose"
	display.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
