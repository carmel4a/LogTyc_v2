###################
#                 #
#  Main camera    #
#                 #
###################
extends Camera2D

# Camera control settings: 
# key - by keyboard
# drag - by right mouse button;
# edge - by moving mouse to the window edge
# wheel zoom in/out by mouse wheel
export (bool) var key = true
export (bool) var drag = true
export (bool) var edge = false
export (bool) var wheel = true
export (int) var zoom_out_limit = 100
# Initial zoom value taken from Editor.
var camera_zoom = get_zoom()

# Value meaning how near to the window frame (in px) the mouse must be, to shift a view.
const camera_margin = 50

# Camera speed in px/s. It is changing in the code by zoom, to keep const. speed value.
var camera_speed = 450 

# It changes a camera zoom value in ?units, but it works... (x, y) (ps. prob. in view multiples ).
const camera_zoom_speed = Vector2(0.5, 0.5)

# Vector of actual position of camera.
var camera_movement = Vector2()

# Previouse mouse position used to count delta of the mouse movement.
var prev_mouse_pos = null

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	# Set camera movement to zero, and update camera speed.
	camera_speed = 450
	camera_movement = Vector2(0,0)
	
	# Control by keyboard handled by @ImputMap.
	if key == true:
		if Input.is_action_pressed("ui_up"):
			camera_movement.y -= camera_speed * delta
		if Input.is_action_pressed("ui_down"):
			camera_movement.y += camera_speed * delta
		if Input.is_action_pressed("ui_left"):
			camera_movement.x -= camera_speed * delta
		if Input.is_action_pressed("ui_right"):
			camera_movement.x += camera_speed * delta
	
	# Control by mouse when it is in the margin (defined by camera_margin).
	if edge == true:
		if get_viewport().get_rect().size.x - get_viewport().get_mouse_pos().x < camera_margin:
			camera_movement.x += camera_speed * delta
		if get_viewport().get_mouse_pos().x < camera_margin:
			camera_movement.x -= camera_speed * delta
		if get_viewport().get_rect().size.y - get_viewport().get_mouse_pos().y < camera_margin:
			camera_movement.y += camera_speed * delta
		if get_viewport().get_mouse_pos().y < camera_margin:
			camera_movement.y -= camera_speed * delta
	
	# Control by right mouse button; draging. Have no idea how it is working.
	if drag == true:
		if Input.is_mouse_button_pressed(BUTTON_RIGHT):
			camera_movement = prev_mouse_pos - get_viewport().get_mouse_pos()
	
	# Update position of the camera.
	set_pos(get_pos() + camera_movement * get_zoom())
	prev_mouse_pos = get_viewport().get_mouse_pos()

func _input(event):
#	[!]Checking if user used mouse wheel. ! not handled by @ImputMap.
	if (event.type == InputEvent.MOUSE_BUTTON) and (wheel == true):
		# Checing if potential zoom won't zoom under 0; in that cause Engine'll flip screen.
		if ((event.button_index == BUTTON_WHEEL_UP) and ((camera_zoom.x - camera_zoom_speed.x) > 0) and ((camera_zoom.y - camera_zoom_speed.y) > 0)):
			camera_zoom -= camera_zoom_speed
			set_zoom(camera_zoom)
		if event.button_index == BUTTON_WHEEL_DOWN and ((camera_zoom.x + camera_zoom_speed.x) < zoom_out_limit) and ((camera_zoom.y + camera_zoom_speed.y) < zoom_out_limit):
			camera_zoom += camera_zoom_speed
			set_zoom(camera_zoom)
