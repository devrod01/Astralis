#Constelação 2

extends CanvasItem

var star_sprites: Array[Texture2D] = []  # Array que vai armazenar as texturas das 14 estrelas diferentes
var lineSprite: Texture2D  # Sprite da linha
var backgroundTexture: Texture2D  # Textura do fundo

var connectionPointSize: Vector2 = Vector2(64, 64)  # Ajuste para o tamanho do sprite
var maxConnectionPointsCount: int = 60  # Defina um máximo de pontos que podem ser gerados
var connectionPoints: Array[Dictionary] = []  # Vai armazenar a posição e o sprite para cada ponto

var currentLinePoints: Array[Vector2] = []  # Armazena os pontos que estão sendo conectados

func _ready():
	randomize()

	# Carregar as texturas das 14 sprites de estrelas
	star_sprites.append(load("res://Estrelas/Estrela1.png"))
	star_sprites.append(load("res://Estrelas/Estrela5.png"))
	star_sprites.append(load("res://Estrelas/Estrela6.png"))
	star_sprites.append(load("res://Estrelas/Estrela7.png"))
	star_sprites.append(load("res://Estrelas/Estrela8.png"))
	star_sprites.append(load("res://Estrelas/Estrela9.png"))
	star_sprites.append(load("res://Estrelas/Estrela10.png"))

	# Carregar a textura da linha
	lineSprite = load("res://Estrelas/Linha_Constelacao.png")

	# Carregar a textura do fundo
	backgroundTexture = load("res://assets/Sky.png")  # Substitua pelo caminho correto da sua textura

	var bounds: Rect2 = get_viewport_rect()

	# Gera um número aleatório de pontos de conexão entre 20 e maxConnectionPointsCount
	var connectionPointsCount = randi_range(20, maxConnectionPointsCount)
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
	# Desenhar o fundo do céu estrelado com o tamanho de 1280x720
	draw_texture_rect(backgroundTexture, Rect2(Vector2.ZERO, Vector2(1280, 720)), false)  # Desenha o fundo na posição (0,0) com tamanho 1280x720

	# Desenhar os pontos de conexão como sprites
	for connectionPoint in connectionPoints:
		var point_position = connectionPoint["position"] - (connectionPointSize / 2)
		var sprite = connectionPoint["sprite"]
		draw_texture(sprite, point_position)

	# Desenhar a linha entre os pontos usando a sprite de linha
	if currentLinePoints.size() > 1:
		for i in range(currentLinePoints.size() - 1):
			draw_line_between_points(currentLinePoints[i], currentLinePoints[i + 1])

# Gerar pontos de conexão aleatórios dentro dos limites da tela
func generate_random_points(count: int, bounds: Rect2,  margin: float = 50.0) -> Array[Dictionary]:
	var points: Array[Dictionary] = []
	var min_distance: float = 100.0  # Defina o espaçamento mínimo entre as estrelas

	while points.size() < count:
		var point: Vector2 = Vector2(
			randf_range(bounds.position.x + margin, bounds.end.x - margin),
			randf_range(bounds.position.y + margin, bounds.end.y - margin)
		)
		var is_valid_point: bool = true

		# Verificar a distância do novo ponto em relação aos pontos já gerados
		for existing_point in points:
			if existing_point["position"].distance_to(point) < min_distance:
				is_valid_point = false
				break
		
		if is_valid_point:
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
		currentLinePoints.clear()  # Limitar a 11 pontos conectados
	currentLinePoints.append(position)

# Desenhar a linha entre dois pontos usando a função draw_line
func draw_line_between_points(start_point: Vector2, end_point: Vector2):
	# Desenhar uma linha diretamente entre os pontos
	draw_line(start_point, end_point, Color(1, 1, 1), 5)  # Cor branca e largura 5
