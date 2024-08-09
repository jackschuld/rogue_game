extends RigidBody2D

signal died

var health: int

# Called when the node enters the scene tree for the first time.
func _ready():
	health = randf_range(25, 100)
	setHealth()
	add_to_group("mob")
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])


# Deletes self when hits end of screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func setHealth():
	setHealthMax()
	setHealthBar()


func setHealthMax():
	$HealthBar.max_value = health


func setHealthBar():
	$HealthBar.value = health


# Called when a bullet hits the mob
func shot(damage: int):
	$HealthBar.show()
	health -= damage
	setHealthBar()
	if health <= 0:
		died.emit()
		queue_free()
