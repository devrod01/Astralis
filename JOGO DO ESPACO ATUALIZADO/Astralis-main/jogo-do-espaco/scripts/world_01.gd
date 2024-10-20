extends CanvasItem

var star_sprites: Array[Texture2D] = []  # Array que vai armazenar as texturas das 14 estrelas diferentes
var lineSprite: Texture2D  # Se quiser usar uma sprite para a linha (opcional)

var connectionPointSize: Vector2 = Vector2(64, 64)  # Ajuste para o tamanho do sprite
var maxConnectionPointsCount: int = 20  # Defina um máximo de pontos que podem ser gerados
var connectionPoints: Array[Dictionary] = []  # Vai armazenar a posição e o sprite para cada ponto

var currentLinePoints: Array[Vector2] = []

func _ready():
	randomize()

	# Carregar as texturas das 14 sprites de estrelas
	star_sprites.append(load("res://Estrelas/Estrela1.png"))
	star_sprites.append(load("res://Estrelas/Estrela2.png"))
	star_sprites.append(load("res://Estrelas/Estrela3.png"))
	star_sprites.append(load("res://Estrelas/Estrela4.png"))
	star_sprites.append(load("res://Estrelas/Estrela5.png"))
	star_sprites.append(load("res://Estrelas/Estrela6.png"))
	star_sprites.append(load("res://Estrelas/Estrela7.png"))
	star_sprites.append(load("res://Estrelas/Estrela8.png"))
	star_sprites.append(load("res://Estrelas/Estrela9.png"))
	star_sprites.append(load("res://Estrelas/Estrela10.png"))
	star_sprites.append(load("res://Estrelas/Estrela11.png"))
	star_sprites.append(load("res://Estrelas/Estrela12.png"))
	star_sprites.append(load("res://Estrelas/Estrela13.png"))
	star_sprites.append(load("res://Estrelas/Estrela14.png"))
	# Continue adicionando os outros sprites até ter 14
	
	lineSprite = load("res://Estrelas/Linha_Constelacao.png")  # Se necessário

	var bounds: Rect2 = get_viewport_rect()

	# Gera um número aleatório de pontos de conexão entre 5 e maxConnectionPointsCount
	var connectionPointsCount = randi_range(5, maxConnectionPointsCount)
	connectionPoints = generate_random_points(connectionPointsCount, bounds)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var clickedConnectionPoint: Vector2 = find_closest_connection_point_to(get_global_mouse_position(), connectionPointSize.x / 2)
			
			if clickedConnectionPoint == Vector2.ZERO:
				return
			update_current_line_with(clickedConnectionPoint)
			queue_redraw()

func _process(delta: float) -> void:
	if currentLinePoints.size() > 1:
		queue_redraw()

func _draw() -> void:
	# Desenhar os pontos de conexão como sprites
	for connectionPoint in connectionPoints:
		var point_position = connectionPoint["position"] - (connectionPointSize / 2)
		var sprite = connectionPoint["sprite"]
		draw_texture(sprite, point_position)
	
	# Desenhar a linha entre os pontos
	if currentLinePoints.size() > 1:
		for i in range(currentLinePoints.size() - 1):
			draw_line_between_points(currentLinePoints[i], currentLinePoints[i + 1])

# Gerar pontos de conexão aleatórios dentro dos limites da tela
# Cada ponto vai ter uma posição e um sprite associado
func generate_random_points(count: int, bounds: Rect2) -> Array[Dictionary]:
	var points: Array[Dictionary] = []
	for i in count:
		var point: Vector2 = Vector2(
			randf_range(bounds.position.x, bounds.end.x),
			randf_range(bounds.position.y, bounds.end.y)
		)
		var random_star_sprite = star_sprites[randi_range(0, star_sprites.size() - 1)]  # Escolher uma estrela aleatória
		points.append({"position": point, "sprite": random_star_sprite})  # Armazenar a posição e o sprite
	return points

# Encontrar o ponto de conexão mais próximo do clique
func find_closest_connection_point_to(aPoint: Vector2, maxDistance: float) -> Vector2:
	var closestPoint: Vector2 = Vector2.ZERO
	var closestDistance: float = INF
	for connectionPoint in connectionPoints:
		var distance: float = connectionPoint["position"].distance_to(aPoint)
		if distance <= maxDistance:
			if closestPoint == Vector2.ZERO or distance < closestDistance:
				closestPoint = connectionPoint["position"]
				closestDistance = distance
	
	return closestPoint

# Atualizar a linha atual com o novo ponto
func update_current_line_with(position: Vector2) -> void:
	if currentLinePoints.size() >= 11:
		currentLinePoints.clear()
	currentLinePoints.append(position)

# Desenhar a linha entre dois pontos (opcional, usando sprite para a linha)
func draw_line_between_points(start_point: Vector2, end_point: Vector2):
	var line_length: float = start_point.distance_to(end_point)
	var angle: float = start_point.angle_to_point(end_point)
	var line_scale: Vector2 = Vector2(line_length / lineSprite.get_width(), 1)

	# Desenhar a sprite da linha rotacionada e escalada
	draw_texture_rect_region(lineSprite, Rect2(start_point, line_scale), Rect2(Vector2(), lineSprite.get_size()))
