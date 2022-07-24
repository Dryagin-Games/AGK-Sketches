
// Шары

Type BallType
	
	sprite As Integer           // Идентификатор спрайта
	center As PointType         // Расположение центра шара
	colorIndex As Integer       // Идентификатор кода цвета
	bulletToBallFlag As Integer // Переключатель для выстреленых шаров, который означает соприкосновение с другим шаром
	
	// Параметры для шаров на пути
	pathPointIndex As Integer // Идентификатор пройденой точки пути
	distance As Float         // Расстояние от начала пути
	destroyFlag As Integer    // Переключатель уничтожения (нужен, чтобы стартовые шары в цепочке одного цвета не уничтожались сразу)
	
	// Параметры для выстреленых шаров
	angle As Float           // Угол
	speed As Float           // Скорость
	targetPoint As PointType // Точка, куда будет направлен выстреленный шар после столкновения
	targetDistance As Float  // Расстояние на пути
	
EndType

Dim ball [] As BallType

Global Dim ballColor [] As Integer = [0xFF0000FF, 0xFF00FFFF, 0xFF00FF00, 0xFFFF0000] // Цветовые коды шаров
Global ballSpeed As Float = 150.0       // Скорость перемещения шаров в напрвлении конца
Global ballReturnSpeed As Float = 450.0 // Скорость возврата шаров
Global ballDiameter As Float = 100.0    // Диаметр шара
Global ballRadius As Float = 50.0       // Радиус шара (половина диаметра)
Global destroyDistance As Float = 105.0 // Расстояние до соседа для уничтожения (диаметр + 5)

// Подсчитать количество шаров одного цвета подряд
//
// ballIndex - идентификатор шара, с которого начнётся подсчёт
// colorIndex - идентификатор кода цвета
// dir - направление перебора (1 - от начала в конец, -1 - от конца в начало)
// Возвращает количество шаров выбранного цвета

Function CheckLine(ballIndex As Integer, colorIndex As Integer, dir As Integer)
	result As Integer
	If ballIndex => 0 And ballIndex <= ball.length
		If colorIndex < 0 Then colorIndex = ball[ballIndex].colorIndex
		If ball[ballIndex].colorIndex = colorIndex
			Inc result
			result = result + CheckLine(ballIndex + dir, colorIndex, dir)
		EndIf
	EndIf
EndFunction result

// Проверить, выстроен ли ряд шаров одинакого цвета, указав только один из шаров в предполагаемом ряду
//
// ballIndex - идентификатор шара, от которого будет вестись проверка

Function CheckDestroy(ballIndex As Integer)
	numOfBallsBefore As Integer
	numOfBallsAfter As Integer
	destroyFirstBallIndex As Integer
	destroyLastBallIndex As Integer
	index As Integer
	numOfBallsBefore = CheckLine(ballIndex, -1, -1) - 1
	numOfBallsAfter = CheckLine(ballIndex, -1, 1) - 1
	If numOfBallsBefore + numOfBallsAfter => 2
		destroyFirstBallIndex = ballIndex - numOfBallsBefore
		destroyLastBallIndex = ballIndex + numOfBallsAfter
		For index = destroyFirstBallIndex To destroyLastBallIndex
			ball[index].destroyFlag = True
		Next index
	EndIf
EndFunction

// Проверить, выстроен ли ряд шаров одинакого цвета, указав точный диапазон шаров
//
// ballIndex0 - идентификатор первого шара в предполагаемом ряду
// ballIndex1 - идентификатор последнего шара в предполагаемом ряду

Function CheckDestroyExternal(ballIndex0 As Integer, ballIndex1 As Integer)
	numOfBallsBefore As Integer
	numOfBallsAfter As Integer
	destroyFirstBallIndex As Integer
	destroyLastBallIndex As Integer
	index As Integer
	If ballIndex0 => 0 And ballIndex0 <= ball.length And ballIndex1 => 0 And ballIndex1 <= ball.length
		If ball[ballIndex0].colorIndex = ball[ballIndex1].colorIndex
			numOfBallsBefore = CheckLine(ballIndex0, -1, -1)
			numOfBallsAfter = CheckLine(ballIndex1, -1, 1)
			If numOfBallsBefore > 0 And numOfBallsAfter > 0
				If numOfBallsBefore + numOfBallsAfter => 3
					destroyFirstBallIndex = ballIndex0 - numOfBallsBefore + 1
					destroyLastBallIndex = ballIndex1 + numOfBallsAfter - 1
					For index = destroyFirstBallIndex To ballIndex0
						ball[index].destroyFlag = True
					Next index
					For index = ballIndex1 To destroyLastBallIndex
						ball[index].destroyFlag = True
					Next index
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction

// Проверить шары на готовность к уничтожению (шары должны быть выстроены в ряд, т.е. идти друз за другом, и соприкосаться)

Function TryDestroy()
	Dim destroy [] As Integer
	index As Integer
	breakFlag As Integer
	count As Integer
	firstIndex As Integer
	lastIndex As Integer
	index0 As Integer
	For index = 0 To ball.length
		If ball[index].destroyFlag
			If count = 0
				firstIndex = index
			Else
				If ball[index - 1].colorIndex <> ball[index].colorIndex
					lastIndex = index - 1
					If count => 3 and Not breakFlag
						For index0 = firstIndex To lastIndex
							destroy.Insert(index0)
						Next index0
						CheckDestroyExternal(firstIndex - 1, lastIndex + 1)
					EndIf
					breakFlag = False
					firstIndex = index
				Else
					If DistTwoPoints(ball[index - 1].center, ball[index].center) > destroyDistance
						breakFlag = True
					EndIf
				EndIf
			EndIf
			Inc count
		Else
			lastIndex = index - 1
			If count => 3 and Not breakFlag
				For index0 = firstIndex To lastIndex
					destroy.Insert(index0)
				Next index0
				CheckDestroyExternal(firstIndex - 1, lastIndex + 1)
			EndIf
			count = 0
			breakFlag = False
		EndIf
	Next index
	If count => 3 and Not breakFlag
		lastIndex = index - 1
		For index0 = firstIndex To lastIndex
			destroy.Insert(index0)
		Next index0
		CheckDestroyExternal(firstIndex - 1, lastIndex + 1)
	EndIf
	For index = destroy.length To 0 Step -1
		DeleteBall(destroy[index])
	Next index
EndFunction

// Добавить шар
//
// distance - расстояние центра шара от начала пути
// colorIndex - идентификатор кода цвета

Function AddBall(distance As Float, colorIndex As Integer)
	ballIndex As Integer
	newBallIndex As Integer
	newBall As BallType
	newBallIndex = -1
	newBall.distance = distance
	newBall.colorIndex = colorIndex
	newBall.sprite = CreateSprite(ballImage[colorIndex])
	SetSpriteOffset(newBall.sprite, 50.0, 50.0)
	For ballIndex = 0 To ball.length
		If ball[ballIndex].distance > distance
			newBallIndex = ballIndex
			Exit
		EndIf
		
	Next ballIndex
	If newBallIndex = -1
		ball.Insert(newBall)
		newBallIndex = 0
	Else
		ball.Insert(newBall, ballIndex)
	EndIf
	UpdateBallPosition(ballIndex)
	CheckDestroy(ballIndex)
EndFunction

// Удалить шар
//
// index - идентификатор шара

Function DeleteBall(index As Integer)
	DeleteSprite(ball[index].sprite)
	AddExplosion(ball[index].center.x, ball[index].center.y)
	ball.Remove(index)
	Inc score
	SetTextString(scoreText, Str(score))
EndFunction

// Найти точки пересечений двух шаров
//
// ball0 - первый шар
// ball1 - второй шар
// point0 - указатель на первую предполагаемую точку пересечения
// point1 - указатель на вторую предполагаемую точку пересечения
// Возвращает количество точек пересечений

Function InterOfTwoBalls(ball0 As BallType, ball1 As BallType, point0 Ref As PointType, point1 Ref As PointType)
	x As Float
	y As Float
	f As Float
	a As Float
	b As Float
	c As Float
	d As Float
	x = ball1.center.x - ball0.center.x
	y = ball1.center.y - ball0.center.y
	f = x * x + y * y
	a = 4 * f
	If Abs(ball1.center.x - ball0.center.x) > Abs(ball1.center.y - ball0.center.y)
		b = -4 * y * f
		c = f * f - 4 * x * x * ballRadius * ballRadius
		d = b * b - 4 * a * c
		If d > 0.0
			d = Sqrt(d)
			point0.y = (-b - d) / (2 * a)
			point1.y = (-b + d) / (2 * a)
			point0.x = ball0.center.x + (f - 2 * y * point0.y) / (2 * x)
			point1.x = ball0.center.x + (f - 2 * y * point1.y) / (2 * x)
			point0.y = ball0.center.y + point0.y
			point1.y = ball0.center.y + point1.y
			ExitFunction 2
		ElseIf d = 0.0
			point0.y = -b / (2 * a)
			point0.x = ball0.center.x + (f - 2 * y * point0.y) / (2 * x)
			point0.y = ball0.center.y + point0.y
			ExitFunction 1
		Else
			ExitFunction 0
		EndIf
	Else
		b = -4 * x * f
		c = f * f - 4 * y * y * ballRadius * ballRadius
		d = b * b - 4 * a * c
		If d > 0.0
			d = Sqrt(d)
			point0.x = (-b - d) / (2 * a)
			point1.x = (-b + d) / (2 * a)
			point0.y = ball0.center.y + (f - 2 * x * point0.x) / (2 * y)
			point1.y = ball0.center.y + (f - 2 * x * point1.x) / (2 * y)
			point0.x = ball0.center.x + point0.x
			point1.x = ball0.center.x + point1.x
			ExitFunction 2
		ElseIf d = 0.0
			point0.x = -b / (2 * a)
			point0.y = ball0.center.y + (f - 2 * x * point0.x) / (2 * y)
			point0.x = ball0.center.x + point0.x
			ExitFunction 1
		Else
			ExitFunction 0
		EndIf
	EndIf
EndFunction -1

// Найти точки пересечений шара и прямой, заданной двумя точками
//
// ball - шар, для которого будут искаться точки пересечения
// linePoint0, linePoint1 - точки, через которые проходит прямая
// resultPoint0, resultPoint1 - указатели на предполагаемые точки пересечений
// Возвращает количество точек пересечений (0 - не пересекаются, 1 - касаются, 2 - пересекаются в двух точках)

Function InterOfBallAndLine(ball As BallType, linePoint0 As PointType, linePoint1 As PointType, resultPoint0 Ref As PointType, resultPoint1 Ref As PointType)
	lineA As Float
	lineB As Float
	lineC As Float
	a As Float
	b As Float
	c As Float
	d As Float
	lineA = linePoint0.y - linePoint1.y
	lineB = linePoint1.x - linePoint0.x
	lineC = linePoint0.x * linePoint1.y - linePoint1.x * linePoint0.y
	a = lineA * lineA + lineB * lineB
	If Abs(lineB) => Abs(lineA)
		b = 2 * (lineA * lineB * ball.center.y + lineA * lineC - lineB * lineB * ball.center.x)
		c = lineB * lineB * (ball.center.x * ball.center.x - ballRadius * ballRadius) + Pow(lineC + lineB * ball.center.y, 2)
		d = b * b - 4 * a * c
		If d > 0.0
			d = Sqrt(d)
			resultPoint0.x = (-b - d) / (2 * a)
			resultPoint1.x = (-b + d) / (2 * a)
			resultPoint0.y = (-lineA * resultPoint0.x - lineC) / lineB
			resultPoint1.y = (-lineA * resultPoint1.x - lineC) / lineB
			ExitFunction 2
		ElseIf d = 0.0
			resultPoint0.x = -b / (2 * a)
			resultPoint0.y = (-lineA * resultPoint0.x - lineC) / lineB
			ExitFunction 1
		Else
			ExitFunction 0
		EndIf
	Else
		b = 2 * (lineA * lineB * ball.center.x + lineB * lineC - lineA * lineA * ball.center.y)
		c = lineA * lineA * (ball.center.y * ball.center.y - ballRadius * ballRadius) + Pow(lineC + lineA * ball.center.x, 2)
		d = b * b - 4 * a * c
		If d > 0.0
			d = Sqrt(d)
			resultPoint0.y = (-b - d) / (2 * a)
			resultPoint1.y = (-b + d) / (2 * a)
			resultPoint0.x = (-lineB * resultPoint0.x - lineC) / lineA
			resultPoint1.x = (-lineB * resultPoint1.x - lineC) / lineA
			ExitFunction 2
		ElseIf d = 0.0
			resultPoint0.y = -b / (2 * a)
			resultPoint0.x = (-lineB * resultPoint0.x - lineC) / lineA
			ExitFunction 1
		Else
			ExitFunction 0
		EndIf
	EndIf
EndFunction -1

// Найти расстояние выталкивания одного шара другим
//
// ball0 - выталкивающий шар
// ball1 - выталкиваемый шар
// forcedSign - направление (указывается, когда нужно сохранить направление выталкивание после предыдущих итераций)
// Возвращает расстояние, на которое должен быть перемещён шар ball1, чтобы перестать пересекаться с ball0, вдоль участка пути, на котором он находился

Function DisplaceBall(ball0 As BallType, ball1 As BallType, forcedSign As Float)
	point0 As PointType
	point1 As PointType
	point2 As PointType
	point3 As PointType
	point4 As PointType
	point5 As PointType
	point6 As PointType
	point7 As PointType
	d0 As Float
	d1 As Float
	d2 As Float
	d3 As Float
	If ball1.pathPointIndex => 0 And ball1.pathPointIndex < path.point.length
		If InterOfTwoBalls(ball0, ball1, point0, point1) = 2
			If InterOfTwoLines(ball0.center, ball1.center, point0, point1, point2) = 1
				point3.x = point2.x + path.point[ ball1.pathPointIndex + 1 ].pos.x - path.point[ ball1.pathPointIndex ].pos.x
				point3.y = point2.y + path.point[ ball1.pathPointIndex + 1 ].pos.y - path.point[ ball1.pathPointIndex ].pos.y
				If InterOfBallAndLine(ball0, point2, point3, point4, point5) = 2 And InterOfBallAndLine(ball1, point2, point3, point6, point7) = 2
					d0 = DistTwoPoints(point4, point6)
					d1 = DistTwoPoints(point4, point7)
					d2 = DistTwoPoints(point5, point6)
					d3 = DistTwoPoints(point5, point7)
					//forcedSign = 0.0
					If d0 = 0.0
						If forcedSign = 0.0
							If Abs(point3.x - point2.x) => Abs(point3.y - point2.y)
								ExitFunction d2 * Sign(point3.x - point2.x) * Sign(point5.x - point6.x)
							Else
								ExitFunction d2 * Sign(point3.y - point2.y) * Sign(point5.y - point6.y)
							EndIf
						Else
							ExitFunction d2 * forcedSign
						EndIf
					ElseIf d2 = 0.0
						If forcedSign = 0.0
							If Abs(point3.x - point2.x) => Abs(point3.y - point2.y)
								ExitFunction d0 * Sign(point3.x - point2.x) * Sign(point4.x - point6.x)
							Else
								ExitFunction d0 * Sign(point3.y - point2.y) * Sign(point4.y - point6.y)
							EndIf
						Else
							ExitFunction d0 * forcedSign
						EndIf
					ElseIf d0 + d1 < d2 + d3 // point4 внутри, point5 снаружи
						If d0 + d2 < d1 + d3 // point6 внутри, point7 снаружи
							If Abs(point3.x - point2.x) => Abs(point3.y - point2.y)
								If forcedSign = 0.0
									ExitFunction d0 * Sign(point3.x - point2.x) * Sign(point4.x - point6.x)
								Else
									If Sign(point3.x - point2.x) * Sign(point4.x - point6.x) = forcedSign
										ExitFunction d0 * forcedSign
									Else
										ExitFunction d3 * forcedSign
									EndIf
								EndIf
							Else
								If forcedSign = 0.0
									ExitFunction d0 * Sign(point3.y - point2.y) * Sign(point4.y - point6.y)
								Else
									If Sign(point3.y - point2.y) * Sign(point4.y - point6.y) = forcedSign
										ExitFunction d0 * forcedSign
									Else
										ExitFunction d3 * forcedSign
									EndIf
								EndIf
							EndIf
						Else // point7 внутри, point6 снаружи
							If Abs(point3.x - point2.x) => Abs(point3.y - point2.y)
								If forcedSign = 0.0
									ExitFunction d1 * Sign(point3.x - point2.x) * Sign(point4.x - point7.x)
								Else
									If Sign(point3.x - point2.x) * Sign(point4.x - point7.x) = forcedSign
										ExitFunction d1 * forcedSign
									Else
										ExitFunction d2 * forcedSign
									EndIf
								EndIf
							Else
								If forcedSign = 0.0
									ExitFunction d1 * Sign(point3.y - point2.y) * Sign(point4.y - point7.y)
								Else
									If Sign(point3.y - point2.y) * Sign(point4.y - point7.y) = forcedSign
										ExitFunction d1 * forcedSign
									Else
										ExitFunction d2 * forcedSign
									EndIf
								EndIf
							EndIf
						EndIf
					Else // point5 внутри, point4 снаружи
						If d0 + d2 < d1 + d3 // point6 внутри, point7 снаружи
							If Abs(point3.x - point2.x) => Abs(point3.y - point2.y)
								If forcedSign = 0.0
									ExitFunction d2 * Sign(point3.x - point2.x) * Sign(point5.x - point6.x)
								Else
									If Sign(point3.x - point2.x) * Sign(point5.x - point6.x) = forcedSign
										ExitFunction d2 * forcedSign
									Else
										ExitFunction d1 * forcedSign
									EndIf
								EndIf
							Else
								If forcedSign = 0.0
									ExitFunction d2 * Sign(point3.y - point2.y) * Sign(point5.y - point6.y)
								Else
									If Sign(point3.y - point2.y) * Sign(point5.y - point6.y) = forcedSign
										ExitFunction d2 * forcedSign
									Else
										ExitFunction d1 * forcedSign
									EndIf
								EndIf
							EndIf
						Else // point7 внутри, point6 снаружи
							If Abs(point3.x - point2.x) => Abs(point3.y - point2.y)
								If forcedSign = 0.0
									ExitFunction d3 * Sign(point3.x - point2.x) * Sign(point5.x - point7.x)
								Else
									If Sign(point3.x - point2.x) * Sign(point5.x - point7.x) = forcedSign
										ExitFunction d3 * forcedSign
									Else
										ExitFunction d0 * forcedSign
									EndIf
								EndIf
							Else
								If forcedSign = 0.0
									ExitFunction d3 * Sign(point3.y - point2.y) * Sign(point5.y - point7.y)
								Else
									If Sign(point3.y - point2.y) * Sign(point5.y - point7.y) = forcedSign
										ExitFunction d3 * forcedSign
									Else
										ExitFunction d0 * forcedSign
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
					
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction 0.0

// Удалить все шары

Function DeleteAllBalls()
	index As Integer
	index = ball.length
	While index => 0
		DeleteBall(index)
		Dec index
	EndWhile
EndFunction

// Добавить стартовые шары
//
// numOfBalls - количество шаров

Function AddStarterBalls(numOfBalls As Integer)
	index As Integer
	If ball.length => 0
		DeleteAllBalls()
	EndIf
	For index = 0 To numOfBalls - 1
		AddBall(index * 100.0, Random(0, 3))
	Next index
	For index = 0 To ball.length
		ball[index].destroyFlag = False
	Next index
EndFunction

// Обновить расположение шара
//
// ballIndex - идентификатор шара

Function UpdateBallPosition(ballIndex As Integer)
	distance As Float
	ball[ballIndex].pathPointIndex = DistanceToPathPointIndex(ball[ballIndex].distance)
	If ball[ballIndex].pathPointIndex = -1
		ball[ballIndex].pathPointIndex = 0
		ball[ballIndex].distance = 0.0
		ball[ballIndex].center.x = path.point[0].pos.x
		ball[ballIndex].center.y = path.point[0].pos.y
	ElseIf ball[ballIndex].pathPointIndex => path.point.length
		ball[ballIndex].pathPointIndex = path.point.length - 1
		ball[ballIndex].distance = path.distance
		ball[ballIndex].center.x = path.point[ path.point.length ].pos.x
		ball[ballIndex].center.y = path.point[ path.point.length ].pos.y
	Else
		distance = ball[ballIndex].distance - path.point[ ball[ballIndex].pathPointIndex ].distance
		ball[ballIndex].center.x = path.point[ ball[ballIndex].pathPointIndex ].pos.x + Cos(path.point[ ball[ballIndex].pathPointIndex ].angle) * distance
		ball[ballIndex].center.y = path.point[ ball[ballIndex].pathPointIndex ].pos.y + Sin(path.point[ ball[ballIndex].pathPointIndex ].angle) * distance
	Endif
	SetSpritePositionByOffset(ball[ballIndex].sprite, ball[ballIndex].center.x, ball[ballIndex].center.y)
EndFunction

// Переместить шар вдоль пути
//
// ballIndex - идентификатор перемещаемого шара
// ditance - расстояние

Function MoveBall(ballIndex As Integer, distance As Float)
	nextBallIndex As Integer
	If ballIndex => 0 And ballIndex <= ball.length
		ball[ballIndex].distance = ball[ballIndex].distance + distance
		UpdateBallPosition(ballIndex)
		If distance > 0.0
			If ballIndex < ball.length
				nextBallIndex = ballIndex + 1
				distance = DisplaceBall(ball[ballIndex], ball[nextBallIndex], 1.0)
				MoveBall(nextBallIndex, distance)
			EndIf
		ElseIf distance < 0.0
			If ballIndex > 0
				nextBallIndex = ballIndex - 1 
				distance = DisplaceBall(ball[ballIndex], ball[nextBallIndex], -1.0)
				MoveBall(nextBallIndex, distance)
			EndIf
		EndIf
	EndIf
EndFunction
