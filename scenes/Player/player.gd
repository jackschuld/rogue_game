extends Area2D
signal hit

@export var bullet_scene : PackedScene
@export var speed = 400
var screen_size
var game_over = true

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	if !game_over:
		var velocity = Vector2.ZERO
		detectMovement(velocity, delta)
		detectShooting(delta)

func _on_body_entered(body):
	if body.is_in_group("mob"): 
		handle_death()

func handle_death():
	hide()
	hit.emit()
	setGameOver()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	setGameOver()


func setGameOver():
	game_over = !game_over

func detectMovement(velocity, delta):
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	startOrStopSprite(velocity, delta)

func detectShooting(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot_bullet()

func shoot_bullet():
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	bullet.position = position
	
	var mouse_position = get_viewport().get_mouse_position()
	var direction = (mouse_position - position).normalized()
	
	if bullet.has_method("set_velocity"):
		bullet.set_velocity(direction * bullet.speed)

func startOrStopSprite(velocity, delta):
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	changePosition(velocity, delta)

func changePosition(velocity, delta):
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	animateMovement(velocity)

func animateMovement(velocity):
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
