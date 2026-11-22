extends Node2D

signal solved

@onready var fire: Sprite2D = $Fire
@onready var heat_bar: Sprite2D = $HeatBar
@onready var hold_button: Button = $HoldButton

const HOLD_TIME := 10.0
const DRAIN_PER_SECOND := 0.5
var charge := 0.0
var done := false
var fire_start: Vector2
var bar_full: Vector2

func _ready() -> void:
	fire_start = fire.scale
	bar_full = heat_bar.scale
	heat_bar.scale = Vector2(bar_full.x, 0.0)
	hold_button.focus_mode = Control.FOCUS_NONE

func _process(delta: float) -> void:
	if done or not visible:
		return
	if hold_button.button_pressed:
		charge = min(charge + delta, HOLD_TIME)
	else:
		charge = max(charge - delta * DRAIN_PER_SECOND, 0.0)
	var step := mini(int(charge / 2.0), 5)
	fire.scale = fire_start * (1.0 + step * 0.75)
	heat_bar.scale = Vector2(bar_full.x, bar_full.y * (charge / HOLD_TIME))
	if charge >= HOLD_TIME:
		done = true
		solved.emit()

func reset_puzzle() -> void:
	done = false
	charge = 0.0
	fire.scale = fire_start
	heat_bar.scale = Vector2(bar_full.x, 0.0)
