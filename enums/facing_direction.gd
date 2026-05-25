extends RefCounted
class_name FacingDirectionEnum

enum FacingDirection {
	UP,
	UP_RIGHT,
	RIGHT,
	DOWN_RIGHT,
	DOWN,
	DOWN_LEFT,
	LEFT,
	UP_LEFT
}

const FACING_DIRECTION_MAP := {
	Vector2(0, -1): FacingDirection.UP,
	Vector2(1, -1): FacingDirection.UP_RIGHT,
	Vector2(1, 0): FacingDirection.RIGHT,
	Vector2(1, 1): FacingDirection.DOWN_RIGHT,
	Vector2(0, 1): FacingDirection.DOWN,
	Vector2(-1, 1): FacingDirection.DOWN_LEFT,
	Vector2(-1, 0): FacingDirection.LEFT,
	Vector2(-1, -1): FacingDirection.UP_LEFT,
}
