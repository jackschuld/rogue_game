extends RigidBody2D

@export var speed = 800
@export var damage: int = 34
var velocity = Vector2.ZERO

func _ready():
	add_to_group("bullet")
	linear_velocity = velocity
	# Ensure the bullet is moving in the right direction
	apply_impulse(Vector2.ZERO, linear_velocity.normalized() * speed)

func _physics_process(delta):
	# This ensures the bullet moves with the given velocity
	linear_velocity = velocity
	# Check for collisions
	var collision = move_and_collide(velocity * delta)
	if collision:
		# Handle collision
		print("Bullet collided with: ", collision.get_collider())
		var mob = collision.get_collider()
		mob.shot(damage)
		queue_free() 

func set_velocity(v):
	velocity = v
