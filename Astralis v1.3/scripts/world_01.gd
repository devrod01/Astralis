extends CanvasItem  

var lineColor: Color = Color.DARK_ORANGE
var antialiased: bool = true

var connectionPointRadius: float = 20.0
var connectionPointColor: Color = Color.DARK_CYAN

var connectionPointsCount: int = 10
var connectionPoints: Array[Vector2] = []  

var currentLinePoints: Array[Vector2] = []  

func _ready():
	randomize()
	var bounds: Rect2 = get_viewport_rect()
	connectionPoints = generate_random_points(connectionPointsCount, bounds)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var clickedConnectionPoint: Vector2 = find_closest_connection_point_to(get_global_mouse_position(), connectionPointRadius)
			
			if clickedConnectionPoint == Vector2.ZERO:
				return
			update_current_line_with(clickedConnectionPoint)
			queue_redraw()

func _process(delta: float) -> void:
	if currentLinePoints.size() > 1:
		queue_redraw()

func _draw() -> void:
	
	for connectionPoint in connectionPoints:
		draw_circle(connectionPoint, connectionPointRadius, connectionPointColor)
	
	var lineWidth: float = connectionPointRadius

	
	if currentLinePoints.size() > 1:  
		for i in range(currentLinePoints.size() - 1):
			draw_line(currentLinePoints[i], currentLinePoints[i + 1], lineColor, lineWidth, antialiased)

func generate_random_points(count: int, bounds: Rect2) -> Array[Vector2]:
	var points: Array[Vector2] = []
	for i in count:
		var point: Vector2 = Vector2(
			randf_range(bounds.position.x, bounds.end.x),
			randf_range(bounds.position.y, bounds.end.y)
		)
		points.append(point)
	return points


func find_closest_connection_point_to(aPoint: Vector2, maxDistance: float) -> Vector2:
	var closestPoint: Vector2 = Vector2.ZERO  
	var closestDistance: float = INF
	for connectionPoint in connectionPoints:
		var distance: float = connectionPoint.distance_to(aPoint)
		if distance <= maxDistance:
			if closestPoint == Vector2.ZERO or distance < closestDistance:
				closestPoint = connectionPoint
				closestDistance = distance
	
	return closestPoint

func update_current_line_with(position: Vector2) -> void:
	
	if currentLinePoints.size() >= 11:
		currentLinePoints.clear()  

	currentLinePoints.append(position)  
