
// Определить знак числа
//
// Возвращает 1, если число положительное, -1, если отрицательное, и 0, если число равно 0

Function Sign(value As Float)
	If value < 0.0
		ExitFunction -1.0
	ElseIf value > 0.0
		ExitFunction 1.0
	Else
		ExitFunction 0.0
	EndIf
EndFunction 0.0

// Точка

Type PointType
	x As Float
	y As Float
EndType

// Найти точку пересечния двух прямых, заданных точками
//
// p0, p1 - точки, через которые проходит первая прямая
// p2, p3 - точки, через которые проходит вторая прямая
// p - указатель на точку пересечения, куда будет записаны координаты, если прямые пересекаются
// Возвращает 0, если прямые не пересекаются (параллельны), или 1 - если пересекаются

Function InterOfTwoLines(p0 As PointType, p1 As PointType, p2 As PointType, p3 As PointType, p Ref As PointType)
	a01 As Float
	b01 As Float
	c01 As Float
	a23 As Float
	b23 As Float
	c23 As Float
	d As Float
	a01 = p0.y - p1.y
	b01 = p1.x - p0.x
	c01 = p0.x * p1.y - p1.x * p0.y
	a23 = p2.y - p3.y
	b23 = p3.x - p2.x
	c23 = p2.x * p3.y - p3.x * p2.y
	d = a01 * b23 - a23 * b01
	If d <> 0.0
		p.x = (b01 * c23 - b23 * c01) / d
		p.y = (a23 * c01 - a01 * c23) / d
		ExitFunction 1
	Else
		ExitFunction 0
	EndIf
EndFunction -1

// Расстояние между двумя точками
//
// p0, p1 - точки, между которым нужно найти расстояние
// Возвращает значение расстояния между двумя точками

Function DistTwoPoints(p0 As PointType, p1 As PointType)
	distance As Float
	distance = Sqrt(Pow(p1.y - p0.y, 2) + Pow(p1.x - p0.x, 2))
EndFunction distance
