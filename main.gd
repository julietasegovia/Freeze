extends Node2D

@onready var timer: Timer = $RandomTimer
@onready var display: Label = $TimerDisplay
@onready var lose_label: Label = $LoseLabel
@onready var retry_button: Button = $RetryButton
@onready var tablet = $Tablet
@onready var monster_asleep: Sprite2D = $MonsterAsleep
@onready var monster_awake: Sprite2D = $MonsterAwake

var armed := false
var lost := false
var frozen_mouse := Vector2.ZERO
const MOVE_LIMIT := 6.0

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	timer.connect("timer_restarted", _on_timer_restarted)
	_show_asleep()

func _show_asleep() -> void:
	monster_asleep.show()
	monster_awake.hide()

func _show_awake() -> void:
	monster_asleep.hide()
	monster_awake.show()

func _on_timer_timeout() -> void:
	armed = true
	frozen_mouse = get_global_mouse_position()
	_show_awake()

func _on_timer_restarted(_new_seconds: int) -> void:
	if lost:
		return
	armed = false
	_show_asleep()

func _process(_delta: float) -> void:
	if lost or not armed:
		return
	if get_global_mouse_position().distance_to(frozen_mouse) <= MOVE_LIMIT:
		return
	lost = true
	call_deferred("_on_player_lost")

func _on_player_lost() -> void:
	timer.call("cancel_restart")
	display.call("hide_for_loss")
	display.text = ""
	display.visible = false
	display.set_process(false)
	lose_label.visible = true
	retry_button.visible = true
	_show_awake()
	tablet.call("slide_down")

func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()
