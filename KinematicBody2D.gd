extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()
var ballistic = true
const GRAVITY = 980
const FRICTION = 980

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _process(delta):
    var arm = $gBot_hip/gBot_body/gBot_arm_r
    var angle = arm.get_angle_to(get_global_mouse_position())
    arm.rotate(angle - PI/2)

func _physics_process(delta):
    var MAX_VEL = 200
    var ACCEL = MAX_VEL / 30
    velocity.y += GRAVITY * delta
    if not ballistic:        
        if Input.is_action_pressed("ui_right"):
            $gBot_hip.scale = Vector2(1, 1)
            velocity.x += ACCEL
        elif Input.is_action_pressed("ui_left"):
            $gBot_hip.scale = Vector2(-1, 1)
            velocity.x -= ACCEL
        else:
            var new_x = max(abs(velocity.x) - FRICTION, 0)
            velocity.x = sign(velocity.x) * new_x
        velocity.x = clamp(velocity.x, -MAX_VEL, MAX_VEL)
    
        if velocity.x != 0:
            $AnimationPlayer.play("Walk", -1, 4*abs(velocity.x)/MAX_VEL)
        else:
            $AnimationPlayer.play("Idle2")
        
        if  Input.is_action_just_pressed("ui_up"):
            velocity.y = -1 * GRAVITY/3
    var old_vel = velocity
    velocity = move_and_slide(old_vel);
    ballistic = old_vel == velocity
    if position.y > 2000:
        get_tree().reload_current_scene()

