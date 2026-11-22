extends Control

signal word_found(word: String)

const KEYWORDS: Array[String] = ["HALT", "MELT", "FROST", "SOFTEN", "REHEAT"]
const GRID_SIZE: int = 6
const ALPHABET: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

var target_word: String = ""
var grid_letters: Array = []
var cell_buttons: Array = []
var selected_cells: Array[Vector2i] = []
var locked_direction: Vector2i = Vector2i.ZERO

@onready var prompt_label: Label = $VBox/PromptLabel
@onready var grid_container: GridContainer = $VBox/GridContainer

func _ready() -> void:
	randomize()
	grid_container.columns = GRID_SIZE
	start_new_puzzle()

func start_new_puzzle() -> void:
	target_word = KEYWORDS.pick_random()
	prompt_label.text = "FIND: " + target_word
	selected_cells.clear()
	locked_direction = Vector2i.ZERO
	
	grid_letters.clear()
	for r in range(GRID_SIZE):
		var row: Array[String] = []
		row.resize(GRID_SIZE)
		row.fill("")
		grid_letters.append(row)
	
	_place_word(target_word)
	
	for r in range(GRID_SIZE):
		for c in range(GRID_SIZE):
			if grid_letters[r][c] == "":
				grid_letters[r][c] = ALPHABET[randi() % ALPHABET.length()]
	
	_build_grid_buttons()

func _place_word(word: String) -> void:
	var directions: Array[Vector2i] = [
		Vector2i(1, 0),   # Horizontal (left to right)
		Vector2i(0, 1),   # Vertical (top to bottom)
		Vector2i(1, 1),   # Diagonal (top-left to bottom-right)
		Vector2i(1, -1)   # Diagonal (bottom-left to top-right)
	]
	
	var dir: Vector2i = directions.pick_random()
	var min_col: int = 0
	var max_col: int = GRID_SIZE - word.length() if dir.x > 0 else GRID_SIZE - 1
	var min_row: int = word.length() - 1 if dir.y < 0 else 0
	var max_row: int = GRID_SIZE - word.length() if dir.y > 0 else GRID_SIZE - 1
		
	var start_col: int = randi_range(min_col, max_col)
	var start_row: int = randi_range(min_row, max_row)
	
	for i in range(word.length()):
		grid_letters[start_row + i * dir.y][start_col + i * dir.x] = word[i]

func _build_grid_buttons() -> void:
	for child in grid_container.get_children():
		child.queue_free()
	cell_buttons.clear()
	
	for r in range(GRID_SIZE):
		var btn_row: Array[Button] = []
		for c in range(GRID_SIZE):
			var btn := Button.new()
			btn.text = grid_letters[r][c]
			btn.custom_minimum_size = Vector2(66, 52)
			btn.add_theme_font_size_override("font_size", 30)
			btn.pressed.connect(_on_cell_pressed.bind(Vector2i(c, r)))
			grid_container.add_child(btn)
			btn_row.append(btn)
		cell_buttons.append(btn_row)

func _on_cell_pressed(pos: Vector2i) -> void:
	if pos in selected_cells:
		return
	
	var clicked_letter: String = grid_letters[pos.y][pos.x]
	var expected_index: int = selected_cells.size()
	var valid_step := false
	
	if expected_index == 0:
		valid_step = (clicked_letter == target_word[0])
	elif expected_index == 1:
		var diff: Vector2i = pos - selected_cells[0]
		if abs(diff.x) <= 1 and abs(diff.y) <= 1 and clicked_letter == target_word[1]:
			locked_direction = diff
			valid_step = true
	else:
		var diff: Vector2i = pos - selected_cells[expected_index - 1]
		if diff == locked_direction and clicked_letter == target_word[expected_index]:
			valid_step = true
	
	if valid_step:
		selected_cells.append(pos)
		cell_buttons[pos.y][pos.x].modulate = Color(0.3, 1.0, 0.4)
		
		if selected_cells.size() == target_word.length():
			prompt_label.text = "FOUND: " + target_word
			word_found.emit(target_word)
	else:
		for cell in selected_cells:
			cell_buttons[cell.y][cell.x].modulate = Color(1, 1, 1)
		selected_cells.clear()
		locked_direction = Vector2i.ZERO
