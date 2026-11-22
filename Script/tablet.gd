extends Node2D

@export var up_position: Vector2 = Vector2(0, -200)
@export var down_position: Vector2 = Vector2(0, 200)
@export var slide_time: float = 0.35

var is_up := false
var slide: Tween

func _on_up_down_pressed() -> void:
	is_up = not is_up
	var target := up_position if is_up else down_position
	if slide:
		slide.kill()
	slide = create_tween()
	slide.set_trans(Tween.TRANS_CUBIC)
	slide.set_ease(Tween.EASE_OUT)
	slide.tween_property(self, "position", target, slide_time)
