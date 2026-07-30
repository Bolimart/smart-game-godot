@tool

class_name Coin
extends Area2D
## Coin.gd
## Représente une pièce ou un billet dans la scène.
## Le nœud racine doit avoir un enfant Sprite2D (référencé via @onready ci-dessous).

# --- VARIABLES EXPORTÉES (= "public" et visibles dans l'Inspecteur) ---
# @export remplace le [SerializeField]/public de C#.
# Le "= MoneyType.Denomination.PIECE_1E" donne une valeur par défaut ET fixe le type (inférence statique).
@export var value: MoneyType.Denomination = MoneyType.Denomination.PIECE_1E:
	set(new_value):
		value = new_value
		# Le setter personnalisé permet de mettre à jour le sprite dès qu'on change
		# la valeur depuis l'Inspecteur en édition, pas seulement au runtime.
		_update_sprite()

# Array typé : Array[Texture2D] force Godot à n'accepter que des textures dans le slot Inspecteur.
# C'est l'équivalent d'un List<Texture2D> en C#.
@export var sprites: Array[Texture2D] = []
@export var shapes: Array[Shape2D] = []

# --- RÉFÉRENCE AU NŒUDS ENFANT ---
# @onready = "récupère ce nœud une fois qu'il est prêt", évalué juste avant _ready().
# Équivalent d'initialiser une ref dans Awake() en C#, mais en une ligne.
@export var sprite_node: Sprite2D
@export var collision_node: CollisionShape2D

@onready var _pickup_feedback = $PickupFeedback
@onready var _drop_feedback = $DropFeedback

var _hovered = false
var _picked = false
var _mouse_offset := Vector2(0, 0)
var _waiting_to_be_dropped = false
var _is_falling = false
var _base_scale : Vector2

# --- SIGNAL ---
# L'équivalent GDScript des events C# / delegates. Pas besoin de définir un type de délégué à part.
signal picked_up()
signal dropped()
signal ask_pickup()

func _ready() -> void:
	_update_sprite()
	add_to_group("coins")
	_base_scale = scale

func _process(_delta: float) -> void:
	if _picked:
		position = get_global_mouse_position() + _mouse_offset
	if _waiting_to_be_dropped and not _pickup_feedback.is_playing():
		_waiting_to_be_dropped = false
		_drop_feedback.play(self)

func _mouse_enter() -> void:
	_hovered = true
	
func _mouse_exit() -> void:
	_hovered = false
	
func _input(event) -> void:
	if event is InputEventMouseButton:
		if _hovered and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed and not (_drop_feedback.is_playing() or _pickup_feedback.is_playing()):
				ask_for_pickup()
			else:
				drop()

# Fonction "privée" par convention : le underscore préfixe indique "usage interne"
# (GDScript n'a pas de vrais modificateurs private/public sur les méthodes).
func _update_sprite() -> void:
	print("Nouvelle valeur: %s" % MoneyType.Denomination.keys()[value])
	if sprite_node == null:
		return
	# Petite sécurité : on vérifie que l'index existe avant d'aller piocher dans le tableau,
	# pour éviter un crash si sprites[] n'est pas encore rempli dans l'Inspecteur.
	var index := int(value)
	if index >= 0 and index < sprites.size():
		sprite_node.texture = sprites[index]
		collision_node.shape = shapes[index]
	else:
		push_warning("Coin: aucun sprite assigné pour la dénomination %s" % MoneyType.Denomination.keys()[index])

# --- MÉTHODE UTILITAIRE : renvoie la valeur monétaire réelle ---
# match = équivalent du switch C# mais plus proche d'un pattern matching (comme en Python 3.10+).
func get_monetary_value() -> float:
	return MoneyType.get_monetary_value(value)

func ask_for_pickup():
	ask_pickup.emit()

# Exemple d'utilisation du signal : à appeler quand le joueur ramasse la pièce.
func pick_up() -> void:
	print("Coin picked up")
	if not _is_falling:
		_picked = true
		_mouse_offset = position - get_global_mouse_position()
		_pickup_feedback.play(self)
		picked_up.emit()


func drop() -> void:
	print("Coin dropped")
	if not _is_falling and _picked:
		_is_falling = true
		_picked = false
		_waiting_to_be_dropped = true
		dropped.emit()

func _on_drop_feedback_tween_stop_running() -> void:
	_is_falling = false
	scale = _base_scale
