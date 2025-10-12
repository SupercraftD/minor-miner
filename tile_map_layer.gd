extends TileMapLayer

# Configuration parameters
@export var fill_percent := 45  # Initial random fill percentage
@export var smoothing_iterations := 4  # How many times to smooth the cave
@export var min_cave_size := 50  # Minimum size of cave regions to keep
@export var room_radius := 4  # Radius of open spaces around start/end

# Map settings
@export var map_width := 40
@export var map_height := 40
@export var max_generation_attempts := 1  # Maximum attempts to generate a valid map

@export var should_be_closed := true

# Tile IDs
const WALL_TILE := 0
const EMPTY := -1

var _map := {}  # Dictionary to store our map data
var _start_point: Vector2
var _end_point: Vector2

func generate_level(start: Vector2, end: Vector2, worldData):
	_start_point = start
	_end_point = end
	
	var attempt := 0
	var valid_map := false
	
	while !valid_map and attempt < max_generation_attempts:
		attempt += 1
		
		# Clear existing tiles
		clear()
		_map.clear()
		
		# Generate a new map
		_initialize_map(attempt * randi())  # Pass attempt as seed
		
		# Smooth the map multiple times using cellular automata
		for i in smoothing_iterations:
			_smooth_map()
		
		# Create rooms at start and end points
		_create_room(_start_point, room_radius)
		_create_room(_end_point, room_radius)
		
		# Validate path existence
		valid_map = _check_path_exists()
	
	#if !valid_map:
		#push_error("Failed to generate a valid map after %d attempts" % max_generation_attempts)
	
	# Force walls on the map edges
	if should_be_closed:
		_force_walls()
	
	# Apply the final map to tilemap
	var ppos = map_to_local(_apply_to_tilemap(worldData))
	print("returning",ppos)
	return ppos

func _initialize_map(seed_value: int) -> void:
	seed(seed_value)  # Set the random seed for reproducibility
	for x in range(map_width):
		for y in range(map_height):
			var pos := Vector2i(x, y)
			# Fill edges with walls
			if x == 0 || x == map_width - 1 || y == 0 || y == map_height - 1:
				_map[pos] = true
			else:
				_map[pos] = randf() * 100 < fill_percent

func _smooth_map() -> void:
	var new_map := {}
	for x in range(map_width):
		for y in range(map_height):
			var pos := Vector2i(x, y)
			var wall_count := _get_surrounding_wall_count(pos)
			
			# Apply cellular automata rules
			if wall_count > 4:
				new_map[pos] = true
			elif wall_count < 4:
				new_map[pos] = false
			else:
				new_map[pos] = _map[pos]
	
	_map = new_map

func _get_surrounding_wall_count(pos: Vector2i) -> int:
	var wall_count := 0
	for x in range(-1, 2):
		for y in range(-1, 2):
			var check_pos := Vector2i(pos.x + x, pos.y + y)
			if check_pos != pos:
				if _map.get(check_pos, true):  # Default to wall if outside bounds
					wall_count += 1
	return wall_count

func _create_room(center: Vector2, radius: int) -> void:
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			@warning_ignore("narrowing_conversion")
			var pos := Vector2i(center.x + x, center.y + y)
			if pos.x >= 0 && pos.x < map_width && pos.y >= 0 && pos.y < map_height:
				if Vector2i(x, y).length() <= radius:
					_map[pos] = false

func _check_path_exists() -> bool:
	var astar := AStar2D.new()
	
	# Add all empty points to AStar
	for x in range(map_width):
		for y in range(map_height):
			var pos := Vector2i(x, y)
			if !_map[pos]:  # If it's an empty space
				var point_id := _get_point_id(pos)
				astar.add_point(point_id, pos)
	
	# Connect neighboring points
	for x in range(map_width):
		for y in range(map_height):
			var pos := Vector2i(x, y)
			if !_map[pos]:
				var point_id := _get_point_id(pos)
				
				# Connect to orthogonal neighbors
				for neighbor in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
					var next_pos :Vector2 = pos + neighbor
					if _is_valid_empty_pos(next_pos):
						var next_id := _get_point_id(next_pos)
						if !astar.are_points_connected(point_id, next_id):
							astar.connect_points(point_id, next_id)
	
	# Check if path exists between start and end
	var start_id := _get_point_id(_start_point)
	var end_id := _get_point_id(_end_point)
	
	return astar.has_point(start_id) && astar.has_point(end_id) && \
		   astar.get_point_path(start_id, end_id).size() > 0

func _is_valid_empty_pos(pos: Vector2i) -> bool:
	return pos.x >= 0 && pos.x < map_width && \
		   pos.y >= 0 && pos.y < map_height && \
		   !_map[pos]

func _get_point_id(pos: Vector2) -> int:
	return int(pos.x + pos.y * map_width)


func _force_walls() -> void:
	if not should_be_closed:
		return
		
	# Create walls on top and bottom edges
	for x in range(map_width):
		_map[Vector2i(x, 0)] = true              # Top wall
		_map[Vector2i(x, map_height - 1)] = true # Bottom wall
	
	# Create walls on left and right edges
	for y in range(map_height):
		_map[Vector2i(0, y)] = true              # Left wall
		_map[Vector2i(map_width - 1, y)] = true  # Right wall

func _apply_to_tilemap(worldData) -> Vector2:
	var closestToCenter = Vector2i(-1,-1)
	var closestDist = 1.0/0
	@warning_ignore("integer_division")
	var center = Vector2(map_width/2, map_height/2)
	
	for x in range(map_width):
		for y in range(map_height):
			var pos := Vector2i(x, y)
			if _map[pos]:
				set_cell(pos, 0, Vector2i(0,0))  # Set wall tile
				worldData[pos] = Stone.new()
			else:
				set_cell(pos, -1)  # Clear tile (empty space)
				var d = pos.distance_squared_to(center)
				if d < closestDist:
					closestDist = d
					closestToCenter = pos
				worldData[pos] = Air.new()
	return closestToCenter

func generate_ores(worldData):
	print("generating ores")
	var tileCount = map_width * map_height

	@warning_ignore("integer_division")
	var oreParams = [
		{"ore":Coal, "amount": tileCount / 100, "vein_min":2, "vein_max":12},
		{"ore":Copper, "amount":tileCount/150, "vein_min":4, "vein_max":8}
	]
	
	for ore in oreParams:
		for x in range(ore.amount):
			var spot = Vector2i(randi_range(0,map_width-1), randi_range(0,map_height-1))
			while worldData[spot].type != "Stone":
				spot = Vector2i(randi_range(0,map_width-1), randi_range(0,map_height-1))
			
			var branches = [spot]
			var count=0
			var oreCount = randi_range(ore.vein_min, ore.vein_max)
			while len(branches)>0 and count<oreCount:
				var pos = branches.pop_front()
				worldData[pos] = ore.ore.new()
				set_cell(pos, ore.ore.tileIndex, Vector2i(0,0))
				
				count+=1
				
				for hDisp in [-1,-1,-1,0,0,1,1,1]:
					for vDisp in [-1,0,1,1,-1,1,0,-1]:
						var tp = Vector2i(pos.x+hDisp, pos.y+vDisp)
						if worldData.has(tp) and worldData[tp].type == "Stone":
							branches.push_back(tp)
				
