
// ТИПЫ

Type TileType
	
	var As Integer        // Могут ли шары распологаться на этой плитке 
	
	tileSprite As Integer // Спрайт плитки
	
	ballType As Integer   // Код типа
	ballSprite As Integer // Спрайт шара
	// Предыдущее расположение шара
	ballPrevI As Integer
	ballPrevJ As Integer
	
	explosion As Integer // Переключатель уничтожения
	
EndType

// ПЕРЕМЕННЫЕ

// Плитка игрового поля
Global tileImage As Integer
Global tileWidth As Float
Global tileHeight As Float
Global tileCenterX As Float
Global tileCenterY As Float

Global numOfBallTypes As Integer = 4 // Количество вариантов типов шаров
Global Dim ballImage [6] As Integer  // Изображения шаров по типам

Global Dim tile [0, 0] As TileType // Игровое поле

// Параметры игрового поля в пикселях
Global levelWidth As Float   // Размеры
Global levelHeight As Float
Global levelOffsetX As Float // Смещения
Global levelOffsetY As Float
Global levelTopY As Float    // Границы
Global levelBottomY As Float
Global levelLeftX As Float
Global levelRightX As Float

Global Dim killedBallSprite [] As Integer // Идентификаторы уничтожаемых шаров

Global moveTime As Float // Время перемещения (падения или обмена)
