// -----------------------------------------------------------------------------
// Поиск пути по алгоритму A*
// -----------------------------------------------------------------------------

Type NodeType // Вершина
	x As Integer
	y As Integer
	parent As Integer
	g As Float   // стоимость пути от начальной вершины
	h As Float   // эвристическая оценка расстояние до цели
	f As Float   // оценка (сумма стоимости пути и оценки расстояния), f = g + h
	c As Integer
EndType

// Найти порядковый номер вершины node в списке nodeList, если он входит в indexList, иначе вернуть -1
Function GetNode(nodeList Ref As NodeType [], indexList Ref As Integer [], node As NodeType)
	index As Integer
	For index = 0 To indexList.length
		If nodeList[indexList[index]].x = node.x And nodeList[indexList[index]].y = node.y
			ExitFunction index
		EndIf
	Next index
EndFunction -1

Function SearchPath(map Ref As MapType,
					limitX As Integer, limitY As Integer,
					startX As Integer, startY As Integer,
					goalX As Integer, goalY As Integer,
					result Ref As PointIntegerType [])
					
	distX As Integer
	distY As Integer
	minNodeX As Integer // Диапазон поиска пути
	minNodeY As Integer
	maxNodeX As Integer
	maxNodeY As Integer
	newNode As NodeType
	nodeList As NodeType []  // Множество вершин
	openList As Integer []   // Порядковые номера вершин, которые предстоит обработать
	closedList As Integer [] // Порядковые номера вершин, которые уже были обработаны
	complete As Integer = FALSE
	fMin As Float
	index As Integer
	index0 As Integer
	index1 As Integer
	weight As Float
	distX = AbsInteger(goalX - startX)
	distY = AbsInteger(goalY - startY)
	If distX < limitX And distY < limitY
		minNodeX = MaxInteger(MinInteger(startX, goalX) - Ceil((limitX - distX) / 2), 0)
		minNodeY = MaxInteger(MinInteger(startY, goalY) - Ceil((limitY - distY) / 2), 0)
		maxNodeX = MinInteger(MaxInteger(startX, goalX) + Ceil((limitX - distX) / 2), GetMaxX(map))
		maxNodeY = MinInteger(MaxInteger(startY, goalY) + Ceil((limitY - distY) / 2), GetMaxY(map))
		
		// Заполняем свойства начальной вершины
		newNode.x = startX
		newNode.y = startY
		newNode.parent = -1
		newNode.g = 0.0
		newNode.h = Distance(startX, startY, goalX, goalY)
		newNode.f = newNode.g + newNode.h
		NewNode.c = 0
		
		nodeList.Insert(newNode)
		openList.Insert(nodeList.length)
		
		While openList.length > -1 And Not complete
			
			// Находим вершину с самой низкой оценкой f
			fMin = 65535.0
			For index = 0 To openList.length
				If nodeList[ openList[index] ].f < fMin
					fMin = nodeList[ openList[index] ].f
					index0 = openList[index]
					index1 = index
				EndIf
			Next index
			closedList.Insert(index0) // Вершина пошла на обработку, а значит её следует удалить из очереди на обработку
			openList.Remove(index1)   // И добавить в список уже обработанных
			
			For index = 0 To 8 // Проверяем каждого соседа
				If index <> 4
					newNode.x = nodeList[index0].x + Mod(index, 3) - 1
					newNode.y = nodeList[index0].y + Trunc(index / 3) - 1
					
					If newNode.x => minNodeX And newNode.x <= maxNodeX And newNode.y => minNodeY And newNode.y <= maxNodeY
						If GetWeight(map, newNode.x, newNode.y) < 65535.0
							If complete
								Exit
							Else
								If newNode.x = goalX And newNode.Y = goalY Then complete = TRUE
							EndIf
							If GetNode(nodeList, closedList, newNode) = -1 // Пропускаем соседей из закрытого списка
								index1 = GetNode(nodeList, openList, newNode)
								weight = nodeList[index0].g + GetWeight(map, newNode.x, newNode.y) * Distance(nodeList[index0].x, nodeList[index0].y, newNode.x, newNode.y) // Вычисляем g для обрабатываемого соседа
								If index1 = -1 // Если сосед ещё не в открытом списке - добавим его туда
									newNode.parent = index0
									newNode.g = weight
									newNode.h = Distance(newNode.x, newNode.y, goalX, goalY)
									newNode.f = newNode.g + newNode.h
									newNode.c = nodeList[index0].c + 1
									nodeList.Insert(newNode)
									openList.Insert(nodeList.length)
								Else // Сосед был в открытом списке, а значит мы уже знаем его g, h и f
									index1 = openList[index1]
									If nodeList[index1].g > weight // Вычисленная g оказалась меньше, а значит нужно будет обновить g и f
										nodeList[index1].parent = index0
										nodeList[index1].g = weight
										nodeList[index1].f = nodeList[index1].g + nodeList[index1].h
										nodeList[index1].c = NodeList[index0].c + 1
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next index
		EndWhile
	EndIf
	
	index0 = nodeList.length
	If index0 > -1
		If nodeList[index0].x = goalX And nodeList[index0].y = goalY // Если последняя вершина добавленная в список была целью, то переносим результат
			result.length = nodeList[index0].c
			While index0 <> -1
				result[nodeList[index0].c].x = nodeList[index0].x
				result[nodeList[index0].c].y = nodeList[index0].y
				index0 = nodeList[index0].parent
			EndWhile
			ExitFunction
		EndIf
	EndIf
	result.length = -1
	
EndFunction
