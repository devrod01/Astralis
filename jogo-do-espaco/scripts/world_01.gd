extends CanvasItem  # Em Godot 4, CanvasItem é mais adequado para manipulações gráficas 2D

var lineColor: Color = Color.DARK_ORANGE
var antialiased: bool = true

var connectionPointRadius: float = 20.0
var connectionPointColor: Color = Color.DARK_CYAN

var connectionPointsCount: int = 10
var connectionPoints: Array[Vector2] = []  # Lista de pontos de conexão

var currentLinePoints: Array[Vector2] = []  # Lista que armazenará os dois pontos clicados

func _ready():
	randomize()
	var bounds: Rect2 = get_viewport_rect()
	connectionPoints = generate_random_points(connectionPointsCount, bounds)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var clickedConnectionPoint: Vector2 = find_closest_connection_point_to(get_global_mouse_position(), connectionPointRadius)
			if clickedConnectionPoint == null:
				return
			update_current_line_with(clickedConnectionPoint)
			queue_redraw()

func _process(delta: float) -> void:
	# Requere a atualização visual apenas se houver 2 pontos na lista
	if currentLinePoints.size() == 2:
		queue_redraw()

func _draw() -> void:
	# Desenha os pontos de conexão
	for connectionPoint in connectionPoints:
		draw_circle(connectionPoint, connectionPointRadius, connectionPointColor)
	
	var lineWidth: float = connectionPointRadius

	# Desenha a linha se dois pontos tiverem sido clicados
	if currentLinePoints.size() == 2:
		draw_line(currentLinePoints[0], currentLinePoints[1], lineColor, lineWidth, antialiased)

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
	var closestPoint: Vector2 = Vector2.ZERO  # Inicializa com um valor padrão
	var closestDistance: float = INF
	for connectionPoint in connectionPoints:
		var distance: float = connectionPoint.distance_to(aPoint)
		if distance <= maxDistance:
			if closestPoint == Vector2.ZERO or distance < closestDistance:
				closestPoint = connectionPoint
				closestDistance = distance
	return closestPoint

# Atualiza a lista de pontos clicados
func update_current_line_with(position: Vector2) -> void:
	# Se já houver dois pontos, reseta a lista
	if currentLinePoints.size() >= 2:
		currentLinePoints.clear()
	# Adiciona o ponto clicado à lista
	currentLinePoints.append(position)
