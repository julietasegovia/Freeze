extends Control

@export var game_scene_path: String = "res://Freeze/main.tscn"

@onready var title_label: Label = $MenuLayout/TitleLabel
@onready var start_button: Button = $MenuLayout/StartButton
@onready var flicker_timer: Timer = $FlickerTimer
@onready var static_rect: ColorRect = $StaticOverlay
@onready var icicles: Polygon2D = $Icicles
@onready var scary_eyes: Sprite2D = $ScaryEyes

var _base_eye_pos: Vector2

func _ready() -> void:
	randomize()
	_base_eye_pos = scary_eyes.position
	start_button.grab_focus()
	start_button.pressed.connect(_on_start_pressed)
	start_button.mouse_entered.connect(_on_hover_enter)
	start_button.mouse_exited.connect(_on_hover_exit)
	flicker_timer.timeout.connect(_on_flicker_timeout)

func _on_hover_enter() -> void:
	start_button.text = ">> START"

func _on_hover_exit() -> void:
	start_button.text = "START"

func _on_flicker_timeout() -> void:
	var mat := static_rect.material as ShaderMaterial
	var surge := randf_range(0.08, 0.25)
	if mat != null:
		mat.set_shader_parameter("static_intensity", surge)
	
	title_label.modulate.a = randf_range(0.75, 1.0)
	start_button.modulate.a = randf_range(0.82, 1.0)
	icicles.modulate.a = randf_range(0.65, 0.95)
	
	var roll := randf()
	if roll < 0.12:
		scary_eyes.visible = false
	elif roll < 0.25:
		scary_eyes.visible = true
		scary_eyes.position = _base_eye_pos + Vector2(randf_range(-6.0, 6.0), randf_range(-4.0, 4.0))
		scary_eyes.modulate.a = randf_range(0.75, 1.0)
	else:
		scary_eyes.visible = true
		scary_eyes.position = _base_eye_pos
		scary_eyes.modulate.a = randf_range(0.45, 0.75)
	
	flicker_timer.wait_time = randf_range(0.06, 0.25)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(game_scene_path)
