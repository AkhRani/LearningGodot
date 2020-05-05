extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var arm = $arm
onready var arm_neutral = arm.rotation
onready var forearm = $arm/forearm
onready var forearm_neutral = forearm.rotation
onready var hand = $arm/forearm/hand

# Called when the node enters the scene tree for the first time.
func _ready():
    print ((hand.position*scale).length())
    print ((forearm.position*scale).length())
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var angle = get_angle_to(get_global_mouse_position())
    # print(arm.rotation)
    # print(forearm.rotation)
    # b^2 = a^2 + c^2 − 2ac * cos(th)
    # th = acos(-(b^2 - a^2 - c^2) / 2ac)
    # First find the angle of the shoulder.
    # b is the side opposite that angle, which is the length
    # of the remaining chain (in this case just the forearm) and
    # c is the distance between the shoulder and the target.
    # a is the length of the arm
    
    # the length of the forearm is the position of the hand
    var b = hand.position*scale
    var b_len = b.length()
    var a = forearm.position*scale
    var a_len = a.length()
    var c_len = get_global_mouse_position().distance_to(global_position)
    if c_len > a_len+b_len:
        arm.rotation = angle + arm_neutral
        forearm.rotation = forearm_neutral
    else:
        var c = get_global_mouse_position() - position
        var squares = -(b_len*b_len - a_len*a_len - c_len*c_len)
        var th = acos(squares / (2*a_len*c_len))
        # print(a.dot(c))
        # var th = acos(a.dot(c))
        print(th)
        arm.rotation = angle + arm_neutral + th
        # rule of cosines again
        squares = -(c_len*c_len - a_len*a_len - b_len*b_len)
        th = acos(squares / (2*a_len*b_len))
        forearm.rotation = forearm_neutral - (PI - th)
        
        
