extends CharacterBody2D

signal health_changed(current, max_health)

const SPEED = 180.0
const ATTACK_DAMAGE = 20

var max_health = 100
var health = 100
var attack_cooldown = 0.0

@onready var attack_area = $AttackArea
@onready var attack_shape = $AttackArea/CollisionShape2D

func _ready():
    attack_area.monitoring = false
    attack_area.monitorable = false
    attack_shape.disabled = true
    health_changed.emit(health, max_health)

func _physics_process(delta):
    attack_cooldown = max(0.0, attack_cooldown - delta)

    var direction = Vector2.ZERO
    direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

    if direction.length() > 0:
        direction = direction.normalized()
        velocity = direction * SPEED
    else:
        velocity = Vector2.ZERO

    move_and_slide()

    if Input.is_action_just_pressed("attack") and attack_cooldown == 0.0:
        perform_attack()

func perform_attack():
    attack_cooldown = 0.45
    attack_area.monitoring = true
    attack_area.monitorable = true
    attack_shape.disabled = false

    var enemies = attack_area.get_overlapping_bodies()
    for enemy in enemies:
        if enemy.is_in_group("enemies"):
            enemy.damage(ATTACK_DAMAGE)

    await get_tree().create_timer(0.12).timeout

    attack_area.monitoring = false
    attack_area.monitorable = false
    attack_shape.disabled = true

func take_damage(amount):
    health = max(0, health - amount)
    health_changed.emit(health, max_health)
    if health <= 0:
        get_tree().reload_current_scene()
