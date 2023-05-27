extends CharacterBody2D

@onready var animationPlayer = $AnimationPlayer
@onready var playerState = "move"

@export var speed = 1

const speedMultiplier = 3000
const zero = Vector2.ZERO

var stringDirection = "Down"
var vectorDirection = Vector2.ZERO
var movementTarget = self.position
var angle = 0

func _physics_process(delta: float) -> void:
	if playerState == "move":
		handleInput()
		calculateMovementAngle()
		updateAnimation()
		
		velocity = vectorDirection * delta * speedMultiplier
		print(position)
		move_and_slide()
	
func handleInput() -> void:
	vectorDirection = Vector2(Input.get_joy_axis(0, JOY_AXIS_LEFT_X), Input.get_joy_axis(0, JOY_AXIS_LEFT_Y))
	if zero.distance_to(abs(vectorDirection)) <= 0.4:
		vectorDirection = zero
	else:
		calculateStringDirection()
	
func updateAnimation() -> void:
	if zero.distance_to(abs(vectorDirection)) >= 0.4:
		animationPlayer.play("walk" + stringDirection)
	else:
		animationPlayer.play("idle" + stringDirection)

func calculateMovementAngle() -> void:
	var lenA = float(abs((velocity.x)))
	var lenB = float(abs((velocity.y)))
	var A = lenA/lenB
	var B = lenB/lenA
	var new_angleA = atan(A) * (180/PI)
	var new_angleB = atan(B) * (180/PI)
	
	if 0 < velocity.x and 0 < velocity.y:
		angle = new_angleA
	elif 0 < velocity.x and 0 > velocity.y:
		new_angleB += 90
		angle = new_angleB
	elif 0 > velocity.x and 0 > velocity.y:
		new_angleA += 180
		angle = new_angleA
	else:
		new_angleB += 270
		angle = new_angleB
		
func calculateStringDirection() -> void:
	stringDirection = "Up"
	if angle > 202.5 and angle < 337.5 : stringDirection = "Left"
	elif angle > 22.5 and angle < 157.5 : stringDirection = "Right"
	elif angle > 337.5 or angle < 22.5: stringDirection = "Down"
