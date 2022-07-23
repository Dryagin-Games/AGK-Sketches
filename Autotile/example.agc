// -----------------------------------------------------------------------------
// Пример данных для демонстрации работы алгоритма
// -----------------------------------------------------------------------------

#Constant TILE_WIDTH    = 64.0
#Constant TILE_HEIGHT   = 64.0
#Constant TILE_CENTER_X = 32.0
#Constant TILE_CENTER_Y = 32.0

Type TileType
	var As Integer // Только 0, либо 1, иначе нужно переделать функцию GetTileMask и UpdateTileSprite в местах где используется GetTileVar
	spriteIndex As Integer
EndType

Type MapType
	tileset As Integer
	tile As TileType [-1, -1]
EndType

Global Dim tilesetImage [-1, -1] As Integer

// Загрузить изображения наборов плиток

Function LoadTilesetImages()
	tilesetIndex As Integer
	parentImage As Integer
	subImageIndex As Integer
	Dim numOfSubImages [4] As Integer = [1, 16, 17, 47, 47]
	tilesetImage.length = 4
	For tilesetIndex = 0 To 4
		tilesetImage[tilesetIndex].length = numOfSubImages[tilesetIndex] + 1
		parentImage = LoadImage("tileset" + Str(tilesetIndex) + ".png")
		tilesetImage[tilesetIndex, numOfSubImages[tilesetIndex] + 1] = parentImage
		For subImageIndex = 0 To numOfSubImages[tilesetIndex]
			tilesetImage[tilesetIndex, subImageIndex] = LoadSubImage(parentImage, Str(subImageIndex))
		Next subImageIndex
	Next tilesetIndex
EndFunction

// Установить значение отсутствия (0) или начилия (1) плитки с координатами x, y

Function SetTileVar(map Ref As MapType, x As Integer, y As Integer, var As Integer)
	If x > -1 And y > -1
		If map.tile.length < x Then map.tile.length = x
		If map.tile[x].length < y Then map.tile[x].length = y
		map.tile[x, y].var = var
	EndIf
EndFunction

// Определить отсутствие (0) или наличие (1) плитки с координатами x, y

Function GetTileVar(map Ref As MapType, x As Integer, y As Integer)
	If x > -1 And y > -1
		If map.tile.length => x
			If map.tile[x].length => y
				ExitFunction map.tile[x, y].var
			EndIf
		EndIf
	EndIf
EndFunction 0

// Рассчитать маску плитки с координатами x, y

Function GetTileMask(map Ref As MapType, x As Integer, y As Integer)
	mask As Integer
	mask = GetTileVar(map, x - 1, y - 1)
	mask = mask + 2 * GetTileVar(map, x, y - 1)
	mask = mask + 4 * GetTileVar(map, x + 1, y - 1)
	mask = mask + 8 * GetTileVar(map, x - 1, y)
	mask = mask + 16 * GetTileVar(map, x + 1, y)
	mask = mask + 32 * GetTileVar(map, x - 1, y + 1)
	mask = mask + 64 * GetTileVar(map, x, y + 1)
	mask = mask + 128 * GetTileVar(map, x + 1, y + 1)
EndFunction mask

// Обновить спрайт плитки с координатами x, y

Function UpdateTileSprite(map Ref As MapType, x As Integer, y As Integer)
	mask As Integer
	tilesetSubImage As Integer
	imageIndex As Integer
	If x > -1 And y > -1
		If map.tile.length < x Then map.tile.length = x
		If map.tile[x].length < y Then map.tile[x].length = y
		Select map.tileset
			Case 0
				If GetTileVar(map, x, y)
					mask = 0
				Else
					mask = -1
				EndIf
			EndCase
			Case 1, 4
				If GetTileVar(map, x, y)
					mask = GetTileMask(map, x, y)
				Else
					mask = -1
				EndIf
			EndCase
			Case 2, 3
				If GetTileVar(map, x, y)
					mask = -1
				Else
					mask = GetTileMask(map, x, y)
				EndIf
			EndCase
		EndSelect
		tilesetSubImage = Autotile(map.tileset, mask, 1)
		imageIndex = tilesetImage[map.tileset, tilesetSubImage]
		If Not map.tile[x, y].spriteIndex Or Not GetSpriteExists(map.tile[x, y].spriteIndex)
			map.tile[x, y].spriteIndex = CreateSprite(imageIndex)
			SetSpriteOffset(map.tile[x, y].spriteIndex, TILE_CENTER_X, TILE_CENTER_Y)
			SetSpritePositionByOffset(map.tile[x, y].spriteIndex, x * TILE_WIDTH, y * TILE_HEIGHT)
		Else
			SetSpriteImage(map.tile[x, y].spriteIndex, imageIndex)
		EndIf
	EndIf
EndFunction

// Обновить все спрайты плиток

Function UpdateAllTileSprites(map Ref As MapType)
	x As Integer
	y As Integer
	For x = 0 To map.tile.length
		For y = 0 To map.tile[x].length
			UpdateTileSprite(map, x, y)
		Next y
	Next x
EndFunction
