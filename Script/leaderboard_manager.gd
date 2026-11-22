extends Node

const SAVE_PATH := "user://leaderboard.json"

var current_player_name: String = ""
var entries: Array = []

func _ready() -> void:
	load_leaderboard()

func set_player_name(raw_name: String) -> bool:
	var cleaned := raw_name.strip_edges().to_upper()
	var letters_only := ""
	for i in range(cleaned.length()):
		var ch := cleaned[i]
		if ch >= "A" and ch <= "Z":
			letters_only += ch
	if letters_only.length() != 3:
		return false
	current_player_name = letters_only
	return true

func submit_score(points: int) -> void:
	if current_player_name.length() != 3:
		return
	
	# Update existing player's high score or add a new entry
	var updated := false
	for entry in entries:
		if entry["name"] == current_player_name:
			if points > int(entry["score"]):
				entry["score"] = points
			updated = true
			break
	
	if not updated:
		entries.append({ "name": current_player_name, "score": points })
	
	entries.sort_custom(func(a, b): return int(a["score"]) > int(b["score"]))
	save_leaderboard()

func get_player_rank() -> int:
	for i in range(entries.size()):
		if entries[i]["name"] == current_player_name:
			return i + 1
	return -1

func save_leaderboard() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(entries))

func load_leaderboard() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		entries = []
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file != null:
		var parsed = JSON.parse_string(file.get_as_text())
		if parsed is Array:
			entries = parsed
