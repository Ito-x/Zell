extends Polygon2D

@export var rotation_speed: float = 0.15
@export var randomize_speed: bool = true

func _ready() -> void:
	if randomize_speed:
		rotation_speed *= randf_range(0.4, 1.6)
		if randf() < 0.5:
			rotation_speed = -rotation_speed

func _process(delta: float) -> void:
	rotation += rotation_speed * delta
