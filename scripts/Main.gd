extends CharacterBody2D

var health = 40
var speed = 80.0
var damage_cooldown = 0.0
var player = null
var dead = false

func _ready():
    add_to_group("enemies")
    player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
    if dead:
        return

    if player == null or not is_instance_valid(player):
        return

    damage_cooldown = max(0.0, damage_cooldown - delta)
    var to_player = player.global_position - global_position
    var distance = to_player.length()

    if distance > 0:
        if distance < 160:
            var direction = to_player.normalized()
            velocity = direction * speed
            move_and_slide()
        else:
            velocity = Vector2.ZERO

    if distance < 22 and damage_cooldown == 0.0:
        if player.has_method("take_damage"):
            player.take_damage(12)
        damage_cooldown = 1.0

func damage(amount):
    if dead:
        return

    health -= amount
    if health <= 0:
        dead = true
        if player != null and player.has_method("add_score"):
            player.add_score(10)
        queue_free()
