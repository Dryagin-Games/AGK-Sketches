
// Путь

Type PathPointType
	pos As PointType  // Расположение точки пути
	distance As Float // Расстояние от начала
	angle As Float    // Угол к следующей точке
EndType

Type PathType
	distance As Float         // Полное расстояние пути
	point As PathPointType [] // Точки пути
EndType

Global path As PathType

// Добавить точку пути
//
// x, y - расположение точки

Function AddPathPoint(x As Float, y As Float)
	index0 As Integer
	index As Integer
	index0 = path.point.length
	index = index0 + 1
	path.point.length = index
	path.point[index].pos.x = x
	path.point[index].pos.y = y
	If index0 > -1
		path.point[index].distance = path.point[index0].distance + DistTwoPoints(path.point[index0].pos, path.point[index].pos)
		path.distance = path.point[index].distance
		path.point[index0].angle = ATan2(path.point[index].pos.y - path.point[index0].pos.y, path.point[index].pos.x - path.point[index0].pos.x)
	EndIf
EndFunction

// Определить идентификатор ближайшей пройденной точки пути, по расстоянию от начала
//
// distance - расстояние от начала
// Возвращает идентификатор точки пути

Function DistanceToPathPointIndex(distance As Float)
	pointIndex As Integer
	If distance < path.distance
		For pointIndex = 0 To path.point.length
			If path.point[pointIndex].distance > distance
				pointIndex = pointIndex - 1
				If pointIndex = -1
					ExitFunction -1
				Else
					ExitFunction pointIndex
				EndIf
			EndIf
		Next pointIndex
	Else
		ExitFunction path.point.length
	EndIf
EndFunction -1

// Определить расположение по расстоянию от начала пути
//
// distance - расстояние от начала пути
// point - расположение точки
// Возвращает 1, если расстояние находится в пределеах пути, либо -1, если вне

Function DistanceToPathPoint(distance As Float, point Ref As PointType)
	pointIndex As Integer
	If distance < 0.0
		point.x = path.point[0].pos.x
		point.y = path.point[0].pos.y
		ExitFunction -1
	ElseIf distance => path.distance
		point.x = path.point[ path.point.length ].pos.x
		point.y = path.point[ path.point.length ].pos.y
		ExitFunction -1
	Else
		pointIndex = DistanceToPathPointIndex(distance)
		If pointIndex > -1
			distance = distance - path.point[pointIndex].distance
			point.x = path.point[ pointIndex ].pos.x + Cos(path.point[ pointIndex ].angle) * distance
			point.y = path.point[ pointIndex ].pos.y + Sin(path.point[ pointIndex ].angle) * distance
			ExitFunction 1
		EndIf
	EndIf
EndFunction 0

// Загрузить путь из файла
//
// fileName - имя файла пути в текстовом формате

Function LoadPath(fileName As String)
	file As Integer
	line As String
	file = OpenToRead(fileName)
	If file
		While Not FileEOF(file)
			line = ReadLine(file)
			If CountStringTokens(line, ",") = 2
				AddPathPoint(ValFloat(GetStringToken(line, ",", 1)), ValFloat(GetStringToken(line, ",", 2)))
			EndIf
		EndWhile
		CloseFile(file)
	EndIf
EndFunction
