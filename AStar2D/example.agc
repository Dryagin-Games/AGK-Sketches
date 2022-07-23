// -----------------------------------------------------------------------------
// Вариант хранения данных игровой карты
// -----------------------------------------------------------------------------

// Типы плиток

#Constant TILE_WATER  0
#Constant TILE_GRASS  1
#Constant TILE_GROUND 2
#Constant TILE_STONE  3

// Размеры и координаты центров изображений плиток

#Constant tileWidth   64.0
#Constant tileHeight  64.0
#Constant tileCenterX 32.0
#Constant tileCenterY 32.0

Type PointIntegerType
	x As Integer
	y As Integer
EndType

Type PointFloatType
	x As Float
	y As Float
EndType

// Загрузить изображения для спрайтов

Function LoadImages()
	Global imageStart As Integer
	Global imageGoal As Integer
	Global Dim imageTile[4] As Integer
	Global Dim imageArrow[9] As Integer
	index As Integer
	imageStart = LoadImage("Start.png")
	imageGoal = LoadImage("Goal.png")
	imageTile[4] = LoadImage("Tiles.png")
	For index = 0 To 3
		imageTile[index] = LoadSubImage(imageTile[4], Str(index))
	Next index
	imageArrow[9] = LoadImage("Arrows.png")
	For index = 0 To 8
		imageArrow[index] = LoadSubImage(imageArrow[9], Str(index))
	Next index
EndFunction

// Плитка

Type TileType
	var As Integer // Тип плитки (TILE_WATER - вода, TILE_GRASS - трава, TILE_GROUND - земля, TILE_STONE - камень)
	spriteId As Integer
	
	weight As Float // Величина "стоимости" прохода по данной плитке, может быть обратной множителю скорости
EndType

// Объекты отправления и назначения

Type ObjectType
	spriteId As Integer
	
	x As Integer
	y As Integer
EndType

// Карта

Type MapType
	max As PointIntegerType // Максимальные значения координат
	
	textXId As Integer [-1] // Подписи по оси абсцисс
	textYId As Integer [-1] // Подписи по оси ординат
	
	tile As TileType [-1, -1] // Массив плиток
	
	start As ObjectType // Пункт отправления
	goal As ObjectType  // Пункт назначения
	
	path As PointIntegerType [-1] // Путь
	arrowSpriteId As Integer [-1] // Спрайты стрелок пути
EndType

// Подготовить карту к работе
//
// map - ссылка на данные карты
// width, height - размеры карты

Function InitMap(map Ref As MapType, width As Integer, height As Integer)
	x As Integer
	y As Integer
	map.max.x = width - 1
	map.max.y = height - 1
	map.textXId.length = map.max.x
	For x = 0 To map.max.x
		map.textXId[x] = CreateText(Str(x))
		SetTextSize(map.textXId[x], 32)
		SetTextAlignment(map.textXId[x], 1)
		SetTextPosition(map.textXId[x], x * tileWidth, -80.0)
	Next x
	map.textYId.length = map.max.y
	For y = 0 To map.max.y
		map.textYId[y] = CreateText(Str(y))
		SetTextSize(map.textYId[y], 32)
		SetTextAlignment(map.textYId[y], 2)
		SetTextPosition(map.textYId[y], -64.0, y * tileHeight - 16.0)
	Next y
	map.tile.length = map.max.x
	For x = 0 To map.max.x
		map.tile[x].length = map.max.y
		For y = 0 To map.max.y
			SetTile(map, x, y, TILE_GROUND)
		Next y
	Next x
EndFunction

// Задать пункт отправления
//
// map - ссылка на данные карты
// x, y - координаты пункта отправления

Function SetStart(map Ref As MapType, x As Integer, y As Integer)
	map.start.x = x
	map.start.y = y
	If Not map.start.spriteId
		map.start.spriteId = CreateSprite(imageStart)
		SetSpriteOffset(map.start.spriteId, tileCenterX, tileCenterY)
	EndIf
	SetSpritePositionByOffset(map.start.spriteId, x * tileWidth, y * tileHeight)
EndFunction

// Задать пункт назначения
//
// map - ссылка на данные карты
// x, y - координаты пункта назначения

Function SetGoal(map Ref As MapType, x As Integer, y As Integer)
	map.goal.x = x
	map.goal.y = y
	If Not map.goal.spriteId
		map.goal.spriteId = CreateSprite(imageGoal)
		SetSpriteOffset(map.goal.spriteId, tileCenterX, tileCenterY)
	EndIf
	SetSpritePositionByOffset(map.goal.spriteId, x * tileWidth, y * tileHeight)
EndFunction

// Задать тип плитки на карте
//
// map - ссылка на данные карты
// x, y - координаты изменяемой плитки
// var - тип плитки (TILE_WATER - вода, TILE_GRASS - трава, TILE_GROUND - земля, TILE_STONE - камень)

Function SetTile(map Ref As MapType, x As Integer, y As Integer, var As Integer)
	If Not map.tile[x, y].spriteId
		map.tile[x, y].spriteId = CreateSprite(imageTile[var])
		SetSpriteOffset(map.tile[x, y].spriteId, tileCenterX, tileCenterY)
		SetSpritePositionByOffset(map.tile[x, y].spriteId, x * tileWidth, y * tileHeight)
	Else
		SetSpriteImage(map.tile[x, y].spriteId, imageTile[var])
	EndIf
	Select var
		Case TILE_WATER  : map.tile[x, y].weight = 65535.0 : EndCase
		Case TILE_GRASS  : map.tile[x, y].weight =     2.0 : EndCase
		Case TILE_GROUND : map.tile[x, y].weight =     1.0 : EndCase
		Case TILE_STONE  : map.tile[x, y].weight =     0.5 : EndCase
	EndSelect
	map.tile[x, y].var = var
EndFunction

// Обновить спрайты стрелок
//
// map - ссылка на данные карты

Function UpdateArrows(map Ref As MapType)
	index As Integer
	dx As Integer
	dy As Integer
	arrow As Integer
	While map.arrowSpriteId.length > -1
		DeleteSprite(map.arrowSpriteId[map.arrowSpriteId.length])
		map.arrowSpriteId.Remove(map.arrowSpriteId.length)
	EndWhile
	If map.path.length > -1
		map.arrowSpriteId.length = map.path.length - 1
		For index = 0 To map.arrowSpriteId.length
			dx = map.path[index + 1].x - map.path[index].x
			dy = map.path[index + 1].y - map.path[index].y
			arrow = dx + 3 * dy + 4
			map.arrowSpriteId[index] = CreateSprite(imageArrow[arrow])
			SetSpriteOffset(map.arrowSpriteId[index], (1 - dx) * tileCenterX, (1 - dy) * tileCenterY)
			SetSpritePositionByOffset(map.arrowSpriteId[index], map.path[index].x * tileWidth, map.path[index].y * tileHeight)
		Next index
	EndIf
EndFunction

// -----------------------------------------------------------------------------
// Функции, связывающие данные о карте и поиск пути
// -----------------------------------------------------------------------------

Function GetWeight(map Ref As MapType, x As Integer, y As Integer)
EndFunction map.tile[x, y].weight

Function GetMaxX(map Ref As MapType)
EndFunction map.max.x

Function GetMaxY(map Ref As MapType)
EndFunction map.max.y
