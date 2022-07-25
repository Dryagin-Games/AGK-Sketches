
// ФУНКЦИИ

Function MinFloat(a As Float, b As Float)
	If a < b Then ExitFunction a
EndFunction b

Function AbsInteger(value As Integer)
	If value < 0 Then ExitFunction -value
EndFunction value

// Загрузка изображений

Function LoadResources()
	tileImage = LoadImage("tile.png")
	tileWidth = GetImageWidth(tileImage)
	tileHeight = GetImageHeight(tileImage)
	tileCenterX = tileWidth / 2
	tileCenterY = tileHeight / 2
	ballImage[0] = LoadImage("balls.png")
	ballImage[1] = LoadSubImage(ballImage[0], "blue")
	ballImage[2] = LoadSubImage(ballImage[0], "red")
	ballImage[3] = LoadSubImage(ballImage[0], "green")
	ballImage[4] = LoadSubImage(ballImage[0], "yellow")
	ballImage[5] = LoadSubImage(ballImage[0], "purple")
	ballImage[6] = LoadSubImage(ballImage[0], "brown")
EndFunction

// Загрузить карту игрового поля
//
// fileName - имя файла

Function LoadLevel(fileName As String)
	i As Integer
	j As Integer
	file As Integer
	line As String
	length As Integer
	file = OpenToRead(fileName)
	If file
		While Not FileEOF(file)
			line = ReadLine(file)
			If line <> ""
				If tile.length < i Then tile.length = i
				tile[i].length = Len(line) - 1
				If tile[i].length > length Then length = tile[i].length
				For j = 0 To tile[i].length
					tile[i, j].var = Val(Mid(line, j + 1, 1))
				Next j
			EndIf
			Inc i
		EndWhile
		CloseFile(file)
	EndIf
	levelWidth = (length + 1) * tileWidth
	levelHeight = (tile.length + 1) * tileHeight
	levelOffsetX = 0.0 - levelWidth * 0.5
	levelOffsetY = 0.0 - levelHeight * 0.5
	levelLeftX = levelOffsetX - tileCenterX
	levelRightX = levelOffsetX - tileCenterX + levelWidth
	levelTopY = levelOffsetY - tileCenterY
	levelBottomY = levelOffsetY - tileCenterY + levelHeight
	For i = 0 To tile.length
		For j = 0 To tile[i].length
			If tile[i, j].var
				tile[i, j].tileSprite = CreateSprite(tileImage)
				SetSpriteOffset(tile[i, j].tileSprite, tileCenterX, tileCenterY)
				SetSpritePositionByOffset(tile[i, j].tileSprite, levelOffsetX + j * tileWidth, levelOffsetY + i * tileHeight)
			EndIf
		Next j
	Next i
	SetViewZoom(MinFloat(1920.0 / levelWidth, 1080.0 / levelHeight))
	SetViewOffset(-960.0 / GetViewZoom() - tileCenterX, -540.0 / GetViewZoom() - tileCenterY)
EndFunction

// Определить тип шара (цвет)
//
// i, j - рамсположение шара

Function GetBallType(i As Integer, j As Integer)
	If i => 0 And i <= tile.length
		If j => 0 And j <= tile[i].length
			ExitFunction tile[i, j].ballType
		EndIf
	EndIf
EndFunction 0

// Удалить шар
//
// i, j - расположение шара

Function DeleteBall(i As Integer, j As Integer)
	If i => 0 And i <= tile.length
		If j => 0 And j <= tile[i].length
			If tile[i, j].ballType
				tile[i, j].ballType = 0
				DeleteSprite(tile[i, j].ballSprite)
				tile[i, j].ballSprite = 0
			EndIf
		EndIf
	EndIf
EndFunction

// Переместить шар
//
// fromI, fromJ - текущее расположение шара
// toI, toJ - будущее расположение шара
// Возвращает 1, если перемещение возможно, либо 0 - если нет

Function MoveBall(fromI As Integer, fromJ As Integer, toI As Integer, toJ As Integer)
	If fromI => 0 And fromI <= tile.length
		If fromJ => 0 And fromJ <= tile[fromI].length
			If toI => 0 And toI <= tile.length
				If toJ => 0 And toJ <= tile[toI].length
					If tile[fromI, fromJ].var = 1 And tile[toI, toJ].var = 1
						If GetBallType(fromI, fromJ) <> 0 And GetBallType(toI, toJ) = 0
							tile[toI, toJ].ballType = tile[fromI, fromJ].ballType
							tile[toI, toJ].ballSprite = tile[fromI, fromJ].ballSprite
							tile[toI, toJ].ballPrevI = fromI
							tile[toI, toJ].ballPrevJ = fromJ
							tile[fromI, fromJ].ballType = 0
							tile[fromI, fromJ].ballSprite = 0
							ExitFunction 1
						EndIf
					EndIF
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction 0

// Сбросить предыдущие координаты всех шаров

Function ResetPrev()
	i As Integer
	j As Integer
	For i = 0 To tile.length
		For j = 0 To tile[i].length
			tile[i, j].ballPrevI = -1
			tile[i, j].ballPrevJ = -1
		Next j
	Next i
EndFunction

// Выполнить шаг падения шаров

Function Fall()
	i As Integer
	j As Integer
	i0 As Integer
	j0 As Integer
	dir As Integer
	image As Integer
	sprite As Integer
	result As Integer
	ResetPrev()
	dir = 1
	For i = tile.length To 1 Step -1
		i0 = i - 1
		For j = 0 To tile[i].length
			If tile[i, j].var
				If tile[i, j].ballType = 0
					j0 = j
					If MoveBall(i0, j0, i, j) Then result = 1
					MoveBall(i0, j0, i, j)
				EndIf
			EndIf
		Next j
		For j = 0 To tile[i].length
			If tile[i, j].var
				If tile[i, j].ballType = 0
					dir = -1 * dir
					j0 = j + dir
					If MoveBall(i0, j0, i, j)
						result = 1
					Else
						dir = -1 * dir
						j0 = j + dir
						If MoveBall(i0, j0, i, j) Then result = 1
					EndIf
				EndIf
			EndIf
		Next j
	Next i
	For j = 0 To tile[0].length
		If tile[0, j].var
			If tile[0, j].ballType = 0
				tile[0, j].ballType = Random(1, numOfBallTypes)
				image = ballImage[ tile[0, j].ballType ]
				sprite = CreateSprite(image)
				tile[0, j].ballSprite = sprite
				tile[0, j].ballPrevI = -1
				tile[0, j].ballPrevJ = j
				SetSpriteOffset(sprite, GetImageWidth(image) * 0.5, GetImageHeight(image) * 0.5)
				result = 1
			EndIf
		EndIf
	Next j
EndFunction result

// Обновить состояния всех спрайтов шаров

Function UpdateSprites()
	i As Integer
	j As Integer
	sprite As Integer
	x As Float
	y As Float
	prevX As Float
	prevY As Float
	For i = 0 To killedBallSprite.length
		SetSpriteScaleByOffset(killedBallSprite[i], 1.0 - moveTime, 1.0 - moveTime)
		SetSpriteColorAlpha(killedBallSprite[i], 255 - Trunc(moveTime * 255))
	Next i
	For i = 0 To tile.length
		For j = 0 To tile[i].length
			If tile[i, j].var
				If tile[i, j].ballSprite
					sprite = tile[i, j].ballSprite
					If sprite
						If tile[i, j].ballPrevI = -1
							If tile[i, j].ballPrevJ = -1
								x = GetSpriteXByOffset(tile[i, j].tileSprite)
								y = GetSpriteYByOffset(tile[i, j].tileSprite)
								SetSpriteColorAlpha(sprite, 255)
							Else
								x = GetSpriteXByOffset(tile[i, j].tileSprite)
								y = GetSpriteYByOffset(tile[i, j].tileSprite) - tileHeight + moveTime * tileHeight
								SetSpriteColorAlpha(sprite, Trunc(moveTime * 255))
							EndIf
						Else
							prevX = GetSpriteXByOffset(tile[tile[i, j].ballPrevI, tile[i, j].ballPrevJ].tileSprite)
							prevY = GetSpriteYByOffset(tile[tile[i, j].ballPrevI, tile[i, j].ballPrevJ].tileSprite)
							x = (1.0 - moveTime) * prevX + moveTime * GetSpriteXByOffset(tile[i, j].tileSprite)
							y = (1.0 - moveTime) * prevY + moveTime * GetSpriteYByOffset(tile[i, j].tileSprite)
							SetSpriteColorAlpha(sprite, 255)
						EndIf
						SetSpritePositionByOffset(sprite, x, y)
					EndIf
				EndIf
			EndIf
		Next j
	Next i
EndFunction

// Пометить диапазон шаров к уничтожению
//
// minI, minJ, maxI, maxJ - границы диапазона

Function Explosion(minI As Integer, minJ As Integer, maxI As Integer, maxJ As Integer)
	i As Integer
	j As Integer
	For i = minI To maxI
		For j = minJ To maxJ
			If tile[i, j].ballType Then tile[i, j].explosion = 1
		Next j
	Next i
EndFunction

// Проверить игровое поле на последовательности шаров

Function Check()
	i As Integer
	j As Integer
	count As Integer
	start As Integer
	finish As Integer
	ballType As Integer
	length As Integer
	result As Integer
	result = 1
	For i = 0 To tile.length
		If tile[i].length > length Then length = tile[i].length
		count = 0
		start = -1
		ballType = -1
		For j = 0 To tile[i].length
			If tile[i, j].var
				If tile[i, j].ballType > 0
					If tile[i, j].ballType = ballType
						Inc count
					Else
						If count => 3
							Explosion(i, start, i, start + count - 1)
							result = 0
						EndIf
						count = 1
						start = j
						ballType = tile[i, j].ballType
					EndIf
				EndIf
			Else
				If count => 3
					Explosion(i, start, i, start + count - 1)
					result = 0
				EndIf
				count = 0
				start = -1
				ballType = -1
			EndIf
		Next j
		If count => 3
			Explosion(i, start, i, start + count - 1)
			result = 0
		EndIf
	Next i
	For j = 0 To length
		count = 0
		start = -1
		ballType = -1
		For i = 0 To tile.length
			If j <= tile[i].length
				If tile[i, j].var
					If tile[i, j].ballType > 0
						If tile[i, j].ballType = ballType
							Inc count
						Else
							If count => 3
								Explosion(start, j, start + count - 1, j)
								result = 0
							EndIf
							count = 1
							start = i
							ballType = tile[i, j].ballType
						EndIf
					EndIf
				Else
					If count => 3
						Explosion(start, j, start + count - 1, j)
						result = 0
					EndIf
					count = 0
					start = -1
					ballType = -1
				EndIf
			Else
				If count => 3
					Explosion(start, j, start + count - 1, j)
					result = 0
				EndIf
				count = 0
				start = -1
				ballType = -1
			EndIf
		Next i
		If count => 3
			Explosion(start, j, start + count - 1, j)
			result = 0
		EndIf
	Next j
	For i = 0 To tile.length
		For j = 0 To tile[i].length
			If tile[i, j].var
				If tile[i, j].explosion
					tile[i, j].ballType = 0
					If killedBallSprite.length = -1
						killedBallSprite.Insert(tile[i, j].ballSprite)
					Else
						killedBallSprite.Insert(tile[i, j].ballSprite, 0)
					EndIf
					SetSpritePositionByOffset(tile[i, j].ballSprite, GetSpriteXByOffset(tile[i, j].tileSprite), GetSpriteYByOffset(tile[i, j].tileSprite))
					tile[i, j].ballSprite = 0
					tile[i, j].explosion = 0
				EndIf
			EndIf
		Next j
	Next i
EndFunction result

// Заполнить поле случайными шарами

Function Fill()
	i As Integer
	j As Integer
	ballType As Integer
	For i = 0 To tile.length
		For j = 0 To tile[i].length
			If tile[i, j].var
				Do
					ballType = Random(1, numOfBallTypes)
					If GetBallType(i, j - 1) <> ballType
						If GetBallType(i - 1, j) <> ballType
							Exit
						ElseIf GetBallType(i - 2, j) <> ballType
							Exit
						EndIf
					ElseIf GetBallType(i, j - 2) <> ballType
						If GetBallType(i - 1, j) <> ballType
							Exit
						ElseIf GetBallType(i - 2, j) <> ballType
							Exit
						EndIf
					EndIf
				Loop
				tile[i, j].ballType = ballType
				tile[i, j].ballSprite = CreateSprite(ballImage[tile[i, j].ballType])
				tile[i, j].ballPrevI = 0
				tile[i, j].ballPrevJ = 0
				SetSpriteOffset(tile[i, j].ballSprite, GetImageWidth(ballImage[tile[i, j].ballType]) * 0.5, GetImageHeight(ballImage[tile[i, j].ballType]) * 0.5)
				SetSpritePositionByOffset(tile[i, j].ballSprite, GetSpriteXByOffset(tile[i, j].tileSprite), GetSpriteYByOffset(tile[i, j].tileSprite))
			EndIf		
		Next j
	Next i
EndFunction

// Поменять два шара местами
//
// i0, j0 - расположение первого шара
// i1, j1 - расположение второго шара

Function SwapBalls(i0 As Integer, j0 As Integer, i1 As Integer, j1 As Integer)
	ballType As Integer
	ballSprite As Integer
	ballType = tile[i0, j0].ballType
	ballSprite = tile[i0, j0].ballSprite
	tile[i0, j0].ballType = tile[i1, j1].ballType
	tile[i0, j0].ballSprite = tile[i1, j1].ballSprite
	tile[i0, j0].ballPrevI = i1
	tile[i0, j0].ballPrevJ = j1
	tile[i1, j1].ballType = ballType
	tile[i1, j1].ballSprite = ballSprite
	tile[i1, j1].ballPrevI = i0
	tile[i1, j1].ballPrevJ = j0
EndFunction

// Определить строку игрового поля, над которой находится указатель

Function GetPointerTileI()
	pointerY As Float
	pointerY = ScreenToWorldY(GetPointerY())
	If pointerY => levelTopY And pointerY < levelBottomY
		ExitFunction Trunc((pointerY - levelTopY) / tileHeight)
	EndIf
EndFunction -1

// Определить столбец игрового поля, над которым находится указатель

Function GetPointerTileJ()
	pointerX As Float
	pointerX = ScreenToWorldX(GetPointerX())
	If pointerX => levelLeftX And pointerX < levelRightX
		ExitFunction Trunc((pointerX - levelLeftX) / tileWidth)
	EndIf
EndFunction -1

// Определить, могуть ли располагаться шары в указанном расположении
//
// i, j - расположение преполагаемого места

Function IsTile(i As Integer, j As Integer)
	If i => 0 And i <= tile.length
		If j => 0 And j <= tile[i].length
			If tile[i, j].var
				ExitFunction 1
			EndIf
		EndIf
	EndIf
EndFunction 0
