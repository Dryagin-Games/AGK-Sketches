
// Игрок

Type PlayerType
	sprite As Integer // Идентификатор спрайта
	x As Float        // Расположение по оси X
	y As Float        // Расположение по оси Y
	angle As Float    // Угол поворота
	
	bulletSprite As Integer     // Идентификатор спрайта шара для выстрела
	bulletColorIndex As Integer // Идентификатор кода цвета шара для следующего выстрела
	shotTimer As Float          // Таймер для следующего выстрела
	shotDelay As Float          // Задержка между выстрелами
	bulletSpeed As Float        // Скорость перемещения выстреленого шара
EndType

Global player As PlayerType

// Подготовить игрока, задав стандартные значения и создав спрайты

Function InitPlayer()
	player.x = 960.0
	player.y = 540.0
	player.shotDelay = 1.0
	player.bulletSpeed = 1000.0
	player.bulletColorIndex = RandomColorIndex()
	player.sprite = CreateSprite(playerImage)
	SetSpriteOffset(player.sprite, 75.0, 75.0)
	SetSpritePositionByOffset(player.sprite, player.x, player.y)
	player.bulletSprite = CreateSprite(ballImage[player.bulletColorIndex])
	SetSpriteOffset(player.bulletSprite, 50.0, 50.0)
	SetSpritePositionByOffset(player.bulletSprite, player.x, player.y)
EndFunction
