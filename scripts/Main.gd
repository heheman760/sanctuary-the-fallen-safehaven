extends Node2D

@onready var story_label = $HUD/Panel/Story
@onready var quest_label = $HUD/Panel/Quest
@onready var health_label = $HUD/Panel/Health
@onready var player = $Player

var story_index = 0
var story_lines = [
    "The sanctuary has fallen. The Ashen Bell sleeps beneath the ruins.",
    "An oathkeeper remains. It is your duty to awaken the bell before night swallows the world.",
    "The abyss is hungry, and the old stones whisper your name.",
    "Defeat the wraiths, cross the Ember Gate, and ring the bell once more."
]

func _ready():
    player.add_to_group("player")
    player.health_changed.connect(_on_player_health_changed)
    show_story()
    quest_label.text = "Quest: Defeat the wraiths and restore the sanctuary."

func _process(_delta):
    if Input.is_action_just_pressed("ui_accept"):
        show_story()

func show_story():
    if story_index < story_lines.size():
        story_label.text = story_lines[story_index]
        story_index += 1
    else:
        story_label.text = "The bell is silent, but the vow remains. The dawn still waits."
    _on_player_health_changed(player.health, player.max_health)

func _on_player_health_changed(current, max_value):
    health_label.text = "Health: %d / %d" % [current, max_value]
