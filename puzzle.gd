extends Node2D

@onready var equation_label: Label = $Equation
@onready var buttons: Array[Button] = [
	$"Equation/Answer1",
	$"Equation/Answer2",
	$"Equation/Answer3",
]

var correct_answer: int
var finished := false

func _ready() -> void:
	for button in buttons:
		button.pressed.connect(_on_answer_pressed.bind(button))
	new_equation()

func new_equation() -> void:
	var a := randi_range(1, 20)
	var b := randi_range(1, 20)
	var c := randi_range(1, 20)
	correct_answer = a + b - c
	equation_label.text = "%d + %d - %d =" % [a, b, c]

	var choices: Array[int] = [correct_answer]
	while choices.size() < 3:
		var decoy := randi_range(2, 18)
		if decoy != correct_answer and decoy not in choices:
			choices.append(decoy)
	choices.shuffle()

	for i in buttons.size():
		buttons[i].text = str(choices[i])
		buttons[i].disabled = false

func _on_answer_pressed(button: Button) -> void:
	if finished:
		return
	if int(button.text) == correct_answer:
		finished = true
		equation_label.text = "Right!"
		for answer_button in buttons:
			answer_button.disabled = true
	else:
		new_equation()
