class_name MoneyType

# --- ENUM ---
# En GDScript, un enum crée à la fois un type ET une "namespace" implicite.
# Denomination.PIECE_1E vaut 0, PIECE_2E vaut 1, etc. (auto-incrémenté)
enum Denomination {
	PIECE_1C,
	PIECE_2C,
	PIECE_5C,
	PIECE_10C,
	PIECE_20C,
	PIECE_50C,
	PIECE_1E,
	PIECE_2E,
	BILLET_5E,
	BILLET_10E,
	BILLET_20E,
	BILLET_50E,
	BILLET_100E,
	BILLET_200E,
	BILLET_500E
}

static func get_monetary_value(denomination: Denomination) -> float:
	match denomination:
		Denomination.PIECE_1C: return 0.01
		Denomination.PIECE_2C: return 0.02
		Denomination.PIECE_5C: return 0.05
		Denomination.PIECE_10C: return 0.10
		Denomination.PIECE_20C: return 0.20
		Denomination.PIECE_50C: return 0.50
		Denomination.PIECE_1E: return 1.0
		Denomination.PIECE_2E: return 2.0
		Denomination.BILLET_5E: return 5.0
		Denomination.BILLET_10E: return 10.0
		Denomination.BILLET_20E: return 20.0
		Denomination.BILLET_50E: return 50.0
		Denomination.BILLET_100E: return 100.0
		Denomination.BILLET_200E: return 200.0
		Denomination.BILLET_500E: return 500.0
		_: return 0.0
