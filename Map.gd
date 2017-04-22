extends Node2D
var size = Vector2(10,10)
onready var v = Vector2(50,0).rotated(-float(float(1)/float(3))*PI)
onready var Map = AStar.new()
func _ready():
	var _pre_y = 0
	var _start = Vector2(0,0)
	for y in range(size.y):
		for x in range(size.x):`
			Map.add_point(Map.get_available_point_id(),Vector3(x+_start.normalized().x/2,y,0))
		if y%2 == 0:
			_start += Vector2(v.x,0)
		else:
			_start += Vector2(-v.x,0)
		_pre_y += v.y
		set_process(true)
func _process(delta):
	update()
#	print(Vector3(floor(get_global_mouse_pos().x/50),floor(get_global_mouse_pos().y/v.y),0))
#	print(Map.get_closest_point(Vector3(to_fic_pos(Vector2(get_global_mouse_pos().x,get_global_mouse_pos().y)),0)))
func to_fic_pos(vector2):
	return(Vector2(floor(vector2.x/50),floor(vector2.y/v.y)))
func to_true_pos(vector2):
	var xx
	if vector2.y%2 == 0:
		xx = v.x
	else:
		xx = 0
	return(Vector2(vector2.x*50+xx,vector2.y*v.y))
func _draw():
	draw_rect(Rect2(Vector2(0,0),Vector2(10*50,10*v.y)),Color(1,1,1))
	var _pre_y = 0
	var _start = Vector2(0,0)
	for y in range(size.y):
		for x in range(size.x):
			draw_circle(Vector2(x*50+_start.x,_pre_y),5,Color(0,0,0))
		if y%2 == 0:
			_start += Vector2(v.x,0)
		else:
			_start += Vector2(-v.x,0)
		_pre_y += v.y
	_pre_y = 0
	var _starta = Vector2(0,0)
	var _startb = Vector2(0,0)
	for y in range(size.y):
		for x in range(size.x):
			draw_line(Vector2(Vector2(x*50+_start.x,_pre_y)),Vector2((x+1)*50+_start.x,_pre_y),Color(0,0,0),4)
#			Map.connect_points(Map.get_closest_point(Vector3(x,y,0)),Map.get_closest_point(Vector3(x+1,y,0)))
			if y%2 == 0:
				draw_line(Vector2(Vector2((x)*50+_start.x,_pre_y)),Vector2((x)*50-v.x,_pre_y+v.y),Color(0,0,0),4)
#				Map.connect_points(Map.get_closest_point(Vector3(x,y,0)),Map.get_closest_point(Vector3(x-1,y+1,0)))
				draw_line(Vector2(Vector2((x)*50+_start.x,_pre_y)),Vector2((x+1)*50-v.x,_pre_y+v.y),Color(0,0,0),4)
#				Map.connect_points(Map.get_closest_point(Vector3(x,y,0)),Map.get_closest_point(Vector3(x-1,y+1,0)))
			else:
				draw_line(Vector2(Vector2((x)*50+_start.x,_pre_y)),Vector2((x)*50,_pre_y+v.y),Color(0,0,0),4)
#				Map.connect_points(Map.get_closest_point(Vector3(x,y,0)),Map.get_closest_point(Vector3(x,y+1,0)))
				draw_line(Vector2(Vector2((x)*50+_start.x,_pre_y)),Vector2((x+1)*50,_pre_y+v.y),Color(0,0,0),4)
#				Map.connect_points(Map.get_closest_point(Vector3(x,y,0)),Map.get_closest_point(Vector3(x+1,y+1,0)))
		if y%2 == 0:
			_start += Vector2(v.x,0)
		else:
			_start += Vector2(-v.x,0)
		_pre_y += v.y
	
	var _a = Map.get_closest_point(Vector3(round(get_global_mouse_pos().x/50),round(get_global_mouse_pos().y/v.y),0))
	var _coppy = AStar.new()
	for i in range(Map.get_available_point_id()-1):
		_coppy.add_point(i,Map.get_point_pos(i))
	_coppy.remove_point(_a)
	var _b = _coppy.get_closest_point(Vector3(round(get_global_mouse_pos().x/50),round(get_global_mouse_pos().y/v.y),0))
	print(Map.get_point_pos(_a)," ",Map.get_point_pos(_b))

	_starta += Vector2(v.x,0)

	draw_line(Vector2(Map.get_point_pos(_a).x*50+_starta.x,Map.get_point_pos(_a).y*v.y),Vector2(Map.get_point_pos(_b).x*50,Map.get_point_pos(_b).y*v.y),Color(1,0,0),4)