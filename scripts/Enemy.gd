extends CharacterBody2D

signal health_changed(current, max_health)
signal score_changed(value)

const SPEED = 180.0
const ATTACK_DAMAGE = 30
const INVULNERABLE_TIME = 0.5

var max_health = 100
var health = 100
var attack_cooldown = 0.0
var invulnerable = 0.0
var score = 0
var facing = Vector2.RIGHT

@onready var attack_area = $AttackArea
@onready var attack_shape = $AttackArea/CollisionShape2D

func _ready():
    attack_area.monitoring = false
    attack_area.monitorable = false
    attack_shape.disabled = true
    health_changed.emit(health, max_health)
    score_changed.emit(score)

func _physics_process(delta):
    attack_cooldown = max(0.0, attack_cooldown - delta)
    invulnerable = max(0.0, invulnerable - delta)

    var direction = Vector2.ZERO
    direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

    if direction.length() > 0:
        direction = direction.normalized()
        facing = direction
        velocity = direction * SPEED
    else:
        velocity = Vector2.ZERO

    move_and_slide()

    if Input.is_action_just_pressed("attack") and attack_cooldown == 0.0:
        perform_attack()

func perform_attack():
    attack_cooldown = 0.45
    attack_area.position = facing * 28.0
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
    if invulnerable > 0:
        return

    invulnerable = INVULNERABLE_TIME
    health = max(0, health - amount)
    health_changed.emit(health, max_health)

    if health <= 0:
        get_tree().reload_current_scene()

func add_score(amount):
    score += amount
    score_changed.emit(score)
