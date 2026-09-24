extends Node2D

func _ready() -> void:
	$Ui.on_victory.connect(on_victory.bind())

func on_victory() -> void:
	$Confetti.emitting = true
	$Confetti2.emitting = true
