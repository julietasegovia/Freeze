extends Control

@export var game_scene_path: String = "res://Freeze/main.tscn"

@onready var title_label: Label = $MenuLayout/TitleLabel
@onready var start_button: Button = $MenuLayout/StartButton
@onready var leaderboard_button: Button = $MenuLayout/LeaderboardButton
@onready var flicker_timer: Timer = $FlickerTimer
@onready var static_rect: ColorRect = $StaticOverlay
@onready var icicles: Polygon2D = $Icicles
@onready var scary_eyes: Sprite2D = $ScaryEyes

@onready var name_panel: PanelContainer = $NamePromptPanel
@onready var name_input: LineEdit = $NamePromptPanel/VBox/NameInput
@onready var name_error: Label = $NamePromptPanel/VBox/ErrorLabel
@onready var confirm_name_btn: Button = $NamePromptPanel/VBox/Buttons/ConfirmButton
@onready var cancel_name_btn: Button = $NamePromptPanel/VBox/Buttons/CancelButton

@onready var leaderboard_panel: PanelContainer = $LeaderboardPanel
@onready var rank_summary: Label = $LeaderboardPanel/VBox/YourRankLabel
@onready var entries_label: RichTextLabel = $LeaderboardPanel/VBox/EntriesText
@onready var close_lb_btn: Button = $LeaderboardPanel/VBox/CloseLeaderboardButton

var _base_eye_pos: Vector2

func _ready() -> void:
	randomize()
	_base_eye_pos = scary_eyes.position
	name_panel.hide()
	leaderboard_panel.hide()
	name_error.text = ""
	
	start_button.grab_focus()
	start_button.pressed.connect(_on_start_pressed)
	leaderboard_button.pressed.connect(_on_leaderboard_pressed)
	
	start_button.mouse_entered.connect(func(): start_button.text = ">> START")
	start_button.mouse_exited.connect(func(): start_button.text = "START")
	leaderboard_button.mouse_entered.connect(func(): leaderboard_button.text = ">> LEADERBOARD")
	leaderboard_button.mouse_exited.connect(func(): leaderboard_button.text = "LEADERBOARD")
	
	name_input.text_changed.connect(_on_name_text_changed)
	name_input.text_submitted.connect(func(_t): _on_confirm_name())
	confirm_name_btn.pressed.connect(_on_confirm_name)
	cancel_name_btn.pressed.connect(func(): name_panel.hide())
	close_lb_btn.pressed.connect(func(): leaderboard_panel.hide())
	
	flicker_timer.timeout.connect(_on_flicker_timeout)

func _on_name_text_changed(new_text: String) -> void:
	var filtered := ""
	for i in range(new_text.length()):
		var ch := new_text[i].to_upper()
		if ch >= "A" and ch <= "Z" and filtered.length() < 3:
			filtered += ch
	if filtered != new_text:
		name_input.text = filtered
		name_input.caret_column = filtered.length()
	name_error.text = ""

func _on_start_pressed() -> void:
	leaderboard_panel.hide()
	name_error.text = ""
	if has_node("/root/LeaderboardManager"):
		var saved_name: String = get_node("/root/LeaderboardManager").current_player_name
		if saved_name.length() == 3:
			name_input.text = saved_name
	name_panel.show()
	name_input.grab_focus()
	name_input.caret_column = name_input.text.length()

func _on_confirm_name() -> void:
	var valid := false
	if has_node("/root/LeaderboardManager"):
		valid = get_node("/root/LeaderboardManager").set_player_name(name_input.text)
	else:
		valid = (name_input.text.length() == 3)
	
	if not valid:
		name_error.text = "ENTER EXACTLY 3 LETTERS (A-Z)"
		return
	
	get_tree().change_scene_to_file(game_scene_path)

func _on_leaderboard_pressed() -> void:
	name_panel.hide()
	_refresh_leaderboard_ui()
	leaderboard_panel.show()

func _refresh_leaderboard_ui() -> void:
	if not has_node("/root/LeaderboardManager"):
		rank_summary.text = "YOUR RANK: UNRANKED"
		entries_label.text = "No scores recorded yet."
		return
	
	var lb := get_node("/root/LeaderboardManager")
	lb.load_leaderboard()
	
	var rank: int = lb.get_player_rank()
	if rank > 0:
		rank_summary.text = "YOUR PLACE (%s): #%d OF %d" % [lb.current_player_name, rank, lb.entries.size()]
	elif lb.current_player_name.length() == 3:
		rank_summary.text = "PLAYER (%s): PLAY A ROUND TO RANK" % lb.current_player_name
	else:
		rank_summary.text = "YOUR PLACE: ENTER INITIALS & PLAY"
	
	if lb.entries.is_empty():
		entries_label.text = "[color=#9ab0c4]NO SURVIVORS RECORDED YET.[/color]"
		return
	
	var lines: Array[String] = []
	for i in range(lb.entries.size()):
		var entry = lb.entries[i]
		var row_text := "#%d   %s   -   %d PTS" % [i + 1, entry["name"], int(entry["score"])]
		if entry["name"] == lb.current_player_name:
			lines.append("[color=#7dff9b]>> " + row_text + " (YOU)[/color]")
		else:
			lines.append("[color=#d8e8f5]   " + row_text + "[/color]")
	entries_label.text = "\n".join(lines)

func _on_flicker_timeout() -> void:
	var mat := static_rect.material as ShaderMaterial
	var surge := randf_range(0.08, 0.25)
	if mat != null:
		mat.set_shader_parameter("static_intensity", surge)
	
	title_label.modulate.a = randf_range(0.75, 1.0)
	start_button.modulate.a = randf_range(0.82, 1.0)
	leaderboard_button.modulate.a = randf_range(0.82, 1.0)
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
