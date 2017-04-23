extends Node2D
var map_size = Vector2(10,10)

var nodes = []
var node_layer = AStar.new()

var _update = []
var _scale = 500
onready var _hv = Vector2(1,0).rotated(-float(float(1)/float(3))*PI)

func _ready():
	make_grid()
	draw_grid()
	set_process(true)

func _process(delta):
	draw_connection()

func draw_grid():
	if !_update.has("Grid"):
		_update.append("Grid")
	update()
func draw_connection():
	if !_update.has("Connection"):
		_update.append("Connection")
	update()

func make_grid():
	nodes.clear()
	node_layer.clear()
	for x in range(map_size.x):
		nodes.append([])
		for y in range(map_size.y):
			nodes[x].append([])
			nodes[x][y] = {}
			node_layer.add_point(node_layer.get_available_point_id(), _v2_t_AS(Vector2(x,y)))
	for x in range(map_size.x):
		for y in range(map_size.y):
			if x < map_size.x-1:
				node_layer.get_closest_point(_v2_t_AS(Vector2(x,y)))
				node_layer.connect_points(node_layer.get_closest_point(_v2_t_AS(Vector2(x,y))),\
					node_layer.get_closest_point(_v2_t_AS(Vector2(x+1,y))))
			if y < map_size.y-1:
				node_layer.get_closest_point(_v2_t_AS(Vector2(x,y)))
				node_layer.connect_points(node_layer.get_closest_point(_v2_t_AS(Vector2(x,y))),\
					node_layer.get_closest_point(_v2_t_AS(Vector2(x,y+1))))
				if x < map_size.x-1:
					node_layer.get_closest_point(_v2_t_AS(Vector2(x,y)))
					node_layer.connect_points(node_layer.get_closest_point(_v2_t_AS(Vector2(x,y))),\
						node_layer.get_closest_point(_v2_t_AS(Vector2(x+1,y+1))))
			
			
#			var _a 
#			var _copy = AStar.new()
#			for i in node_layer.get_available_point_id()-1:
#				_copy.add_point(i,node_layer.get_point_pos(i))
#			_copy.remove_point(_a)
#			var _b


func _draw():
	for x in range(map_size.x):
		for y in range(map_size.y):
			if _update.has("Grid")or true:
				draw_circle(_v2_t_rp(Vector2(x,y),_scale),30,Color(0,0,0))
#				_update.remove("Grid")
	
func _v2_t_AS(vector):
	if int(vector.y)%2 == 0:
		return(Vector3(vector.x,vector.y*_hv.y,0))
	else:
		return(Vector3(vector.x+_hv.x,vector.y*_hv.y,0))

func _v2_t_rp(vector,scale):
	if int(vector.y)%2 == 0:
		return(Vector2(vector.x,vector.y*_hv.y)*scale)
	else:
		return(Vector2(vector.x+_hv.x,vector.y*_hv.y)*scale)