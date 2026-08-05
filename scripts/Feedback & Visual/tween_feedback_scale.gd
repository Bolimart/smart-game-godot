extends Node2D

## tween_feedback_scale.gd
## Composant réutilisable : joue un tween
## sur n'importe quel Node2D cible. Instanciable dans n'importe quelle scène.

@export var scale_multiplier: float = 1.4
@export var duration: float = 1.4
@export var trans_type: Tween.TransitionType = Tween.TRANS_BACK
@export var ease_type : Tween.EaseType = Tween.EASE_OUT

var _tween: Tween

signal tween_stop_running()

## Joue l'animation de pop sur le nœud donné.
## target: le nœud à animer (ex: un Sprite2D, un TextureRect, etc.)
func play(target: Node2D) -> void:
	# On ne lance pas de tween si il n'a pas de cible
	if target == null:
		push_warning("PickupFeedback: target is null, animation ignored")
		return
	
	# Si le tween exist déjà et tourne, on le tue
	if _tween and _tween.is_running():
		_tween.kill()
	
	var base_scale := target.scale
	var target_scale := base_scale * scale_multiplier
	
	_tween = create_tween()
	_tween.set_trans(trans_type)
	_tween.set_ease(ease_type)
	_tween.tween_property(target, "scale", target_scale, duration)
	_tween.connect("finished", stop_running)


func stop_running() -> void:
	tween_stop_running.emit()


func is_playing() -> bool:
	return _tween != null and _tween.is_running()
