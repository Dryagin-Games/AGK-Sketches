// -----------------------------------------------------------------------------
// Разные полезные функции, не входящие в стандартные библиотеки
// -----------------------------------------------------------------------------

// Большее из целых чисел
Function MaxInteger(a As Integer, b As Integer)
	If a > b Then ExitFunction a
EndFunction b

// Меньшее из целых чисел
Function MinInteger(a As Integer, b As Integer)
	If a < b Then ExitFunction a
EndFunction b

// Линейная интерполяция
Function Lerp(v0 As Float, v1 As Float, t As Float)
EndFunction v0 + t * (v1 - v0)

// Целочисленное значение в диапазоне между указанными нижней и верхней границами
Function ClampInteger(value As Integer, minValue As Integer, maxValue As Integer)
	If value < minValue Then ExitFunction minValue
	If value > maxValue Then ExitFunction maxValue
EndFunction value

// Знак числа с плавающей запятой
Function SignFloat(a As Float)
	If a = 0.0 Then ExitFunction 0.0
	If a < 0.0 Then ExitFunction -1.0
EndFunction 1.0

// Модуль целого числа
Function AbsInteger(a As Integer)
	If a < 0 Then ExitFunction -1 * a
EndFunction a

// Расстояние между двумя точками
Function Distance(x1 As Float, y1 As Float, x2 As Float, y2 As Float)
	dist As Float
	//dist = AbsInteger(x2 - x1) + AbsInteger(y2 - y1) // манхэттенское расстояние
	dist = Sqrt(Abs(x2 - x1) + Abs(y2 - y1)) // евклидово расстояние по прямой
EndFunction dist
