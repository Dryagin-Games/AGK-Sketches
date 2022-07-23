// -----------------------------------------------------------------------------
// Генерация трёхмерного шума Перлина
// -----------------------------------------------------------------------------

Type Point3DFloatType
  x As Float
  y As Float
  z As Float
EndType

Type PerlinNoiseType
	size As Integer
	interval As Integer
	vectorArraySize As Integer
	vector As Point3DFloatType [-1, -1, -1]
EndType

Global perlinNoise As PerlinNoiseType

// Скалярное произведение векторов
Function Dot(a As Point3DFloatType, b As Point3DFloatType)
EndFunction a.x * b.x + a.y * b.y + a.z * b.z

// Затухание
Function Fade(t As Float)
EndFunction t * t * t * (t * (t * 6.0 - 15.0) + 10.0)

// Линейная интерполяция
Function Lerp(v0 As Float, v1 As Float, t As Float)
EndFunction v0 + t * (v1 - v0)


// Подготовить данные к генерации шума
//
// size - размер генерируемого множества, должен быть равен степени двойки, например 32
// interval - детальность шума, должна быть равна степени двойки и меньше размера size, например 16
// seed - зерно для генерации

Function InitPerlinNoise(size As Integer, interval As Integer, seed As Integer)
	x As Integer
	y As Integer
	z As Integer
	perlinNoise.size = size
	perlinNoise.interval = interval
	perlinNoise.vectorArraySize = size / interval
	SetRandomSeed(seed)
	perlinNoise.vector.length = perlinNoise.vectorArraySize
	For x = 0 To perlinNoise.vectorArraySize
		perlinNoise.vector[x].length = perlinNoise.vectorArraySize
		For y = 0 To perlinNoise.vectorArraySize
			perlinNoise.vector[x, y].length = perlinNoise.vectorArraySize
			For z = 0 To perlinNoise.vectorArraySize
				perlinNoise.vector[x, y, z].x = (Random(0, 1000) - 500) * 0.002
				perlinNoise.vector[x, y, z].y = (Random(0, 1000) - 500) * 0.002
				perlinNoise.vector[x, y, z].z = (Random(0, 1000) - 500) * 0.002
			Next z
		Next y
	Next x
EndFunction

// Сгенерировать шум
//
// result - множество, в котором будет храниться шум
//
//  Можно увеличить скорость выполнения данной функции примерно в два раза, если
// заменить участки кода в которых происходит вызов функций Dot, Fade и Lerp, на
// те, что были закомментированы

Function GeneratePerlinNoise(result Ref As Float [][][])
	
	size As Integer
	
	x As Integer
	y As Integer
	z As Integer
	
	gridX0 As Integer
	gridY0 As Integer
	gridZ0 As Integer
	gridX1 As Integer
	gridY1 As Integer
	gridZ1 As Integer
	
	localX As Float
	localY As Float
	localZ As Float
	
	distanceX0Y0Z0 As Point3DFloatType
	distanceX1Y0Z0 As Point3DFloatType
	distanceX0Y1Z0 As Point3DFloatType
	distanceX1Y1Z0 As Point3DFloatType
	distanceX0Y0Z1 As Point3DFloatType
	distanceX1Y0Z1 As Point3DFloatType
	distanceX0Y1Z1 As Point3DFloatType
	distanceX1Y1Z1 As Point3DFloatType
	
	dotX0Y0Z0 As Float
	dotX1Y0Z0 As Float
	dotX0Y1Z0 As Float
	dotX1Y1Z0 As Float
	dotX0Y0Z1 As Float
	dotX1Y0Z1 As Float
	dotX0Y1Z1 As Float
	dotX1Y1Z1 As Float
	
	resultX0Y0 As Float
	resultX1Y0 As Float
	resultX0Y1 As Float
	resultX1Y1 As Float
	resultX0 As Float
	resultX1 As Float
	
	size = perlinNoise.size - 1
	
	result.length = size
	For x = 0 To size
		result[x].length = size
		For y = 0 To size
			result[x, y].length = size
			For z = 0 To size
				
				gridX0 = Trunc(x / perlinNoise.interval) : gridX1 = gridX0 + 1
				gridY0 = Trunc(y / perlinNoise.interval) : gridY1 = gridY0 + 1
				gridZ0 = Trunc(z / perlinNoise.interval) : gridZ1 = gridZ0 + 1
				
				localX = Mod(x, perlinNoise.interval) : localX = localX / perlinNoise.interval
				localY = Mod(y, perlinNoise.interval) : localY = localY / perlinNoise.interval
				localZ = Mod(z, perlinNoise.interval) : localZ = localZ / perlinNoise.interval
				
				distanceX0Y0Z0.x = localX     : distanceX0Y0Z0.y = localY     : distanceX0Y0Z0.z = localZ
				distanceX1Y0Z0.x = localX - 1 : distanceX1Y0Z0.y = localY     : distanceX1Y0Z0.z = localZ
				distanceX0Y1Z0.x = localX     : distanceX0Y1Z0.y = localY - 1 : distanceX0Y1Z0.z = localZ
				distanceX1Y1Z0.x = localX - 1 : distanceX1Y1Z0.y = localY - 1 : distanceX1Y1Z0.z = localZ
				distanceX0Y0Z1.x = localX     : distanceX0Y0Z1.y = localY     : distanceX0Y0Z1.z = localZ - 1
				distanceX1Y0Z1.x = localX - 1 : distanceX1Y0Z1.y = localY     : distanceX1Y0Z1.z = localZ - 1
				distanceX0Y1Z1.x = localX     : distanceX0Y1Z1.y = localY - 1 : distanceX0Y1Z1.z = localZ - 1
				distanceX1Y1Z1.x = localX - 1 : distanceX1Y1Z1.y = localY - 1 : distanceX1Y1Z1.z = localZ - 1
				
				dotX0Y0Z0 = Dot(perlinNoise.vector[gridX0, gridY0, gridZ0], distanceX0Y0Z0)
				dotX1Y0Z0 = Dot(perlinNoise.vector[gridX1, gridY0, gridZ0], distanceX1Y0Z0)
				dotX0Y1Z0 = Dot(perlinNoise.vector[gridX0, gridY1, gridZ0], distanceX0Y1Z0)
				dotX1Y1Z0 = Dot(perlinNoise.vector[gridX1, gridY1, gridZ0], distanceX1Y1Z0)
				dotX0Y0Z1 = Dot(perlinNoise.vector[gridX0, gridY0, gridZ1], distanceX0Y0Z1)
				dotX1Y0Z1 = Dot(perlinNoise.vector[gridX1, gridY0, gridZ1], distanceX1Y0Z1)
				dotX0Y1Z1 = Dot(perlinNoise.vector[gridX0, gridY1, gridZ1], distanceX0Y1Z1)
				dotX1Y1Z1 = Dot(perlinNoise.vector[gridX1, gridY1, gridZ1], distanceX1Y1Z1)
				/*dotX0Y0Z0 = perlinNoise.vector[gridX0, gridY0, gridZ0].x * distanceX0Y0Z0.x + perlinNoise.vector[gridX0, gridY0, gridZ0].y * distanceX0Y0Z0.y + perlinNoise.vector[gridX0, gridY0, gridZ0].z * distanceX0Y0Z0.z // Dot(perlinNoise.vector[gridX0, gridY0, gridZ0], distanceX0Y0Z0)
				dotX1Y0Z0 = perlinNoise.vector[gridX1, gridY0, gridZ0].x * distanceX1Y0Z0.x + perlinNoise.vector[gridX1, gridY0, gridZ0].y * distanceX1Y0Z0.y + perlinNoise.vector[gridX1, gridY0, gridZ0].z * distanceX1Y0Z0.z // Dot(perlinNoise.vector[gridX1, gridY0, gridZ0], distanceX1Y0Z0)
				dotX0Y1Z0 = perlinNoise.vector[gridX0, gridY1, gridZ0].x * distanceX0Y1Z0.x + perlinNoise.vector[gridX0, gridY1, gridZ0].y * distanceX0Y1Z0.y + perlinNoise.vector[gridX0, gridY1, gridZ0].z * distanceX0Y1Z0.z // Dot(perlinNoise.vector[gridX0, gridY1, gridZ0], distanceX0Y1Z0)
				dotX1Y1Z0 = perlinNoise.vector[gridX1, gridY1, gridZ0].x * distanceX1Y1Z0.x + perlinNoise.vector[gridX1, gridY1, gridZ0].y * distanceX1Y1Z0.y + perlinNoise.vector[gridX1, gridY1, gridZ0].z * distanceX1Y1Z0.z // Dot(perlinNoise.vector[gridX1, gridY1, gridZ0], distanceX1Y1Z0)
				dotX0Y0Z1 = perlinNoise.vector[gridX0, gridY0, gridZ1].x * distanceX0Y0Z1.x + perlinNoise.vector[gridX0, gridY0, gridZ1].y * distanceX0Y0Z1.y + perlinNoise.vector[gridX0, gridY0, gridZ1].z * distanceX0Y0Z1.z // Dot(perlinNoise.vector[gridX0, gridY0, gridZ1], distanceX0Y0Z1)
				dotX1Y0Z1 = perlinNoise.vector[gridX1, gridY0, gridZ1].x * distanceX1Y0Z1.x + perlinNoise.vector[gridX1, gridY0, gridZ1].y * distanceX1Y0Z1.y + perlinNoise.vector[gridX1, gridY0, gridZ1].z * distanceX1Y0Z1.z // Dot(perlinNoise.vector[gridX1, gridY0, gridZ1], distanceX1Y0Z1)
				dotX0Y1Z1 = perlinNoise.vector[gridX0, gridY1, gridZ1].x * distanceX0Y1Z1.x + perlinNoise.vector[gridX0, gridY1, gridZ1].y * distanceX0Y1Z1.y + perlinNoise.vector[gridX0, gridY1, gridZ1].z * distanceX0Y1Z1.z // Dot(perlinNoise.vector[gridX0, gridY1, gridZ1], distanceX0Y1Z1)
				dotX1Y1Z1 = perlinNoise.vector[gridX1, gridY1, gridZ1].x * distanceX1Y1Z1.x + perlinNoise.vector[gridX1, gridY1, gridZ1].y * distanceX1Y1Z1.y + perlinNoise.vector[gridX1, gridY1, gridZ1].z * distanceX1Y1Z1.z // Dot(perlinNoise.vector[gridX1, gridY1, gridZ1], distanceX1Y1Z1)*/
				
				localX = Fade(localX)
				localY = Fade(localY)
				localZ = Fade(localZ)
				/*localX = localX * localX * localX * (localX * (localX * 6.0 - 15.0) + 10.0)
				localY = localY * localY * localY * (localY * (localY * 6.0 - 15.0) + 10.0)
				localZ = localZ * localZ * localZ * (localZ * (localZ * 6.0 - 15.0) + 10.0)*/
				
				resultX0Y0 = Lerp(dotX0Y0Z0, dotX0Y0Z1, localZ)
				resultX1Y0 = Lerp(dotX1Y0Z0, dotX1Y0Z1, localZ)
				resultX0Y1 = Lerp(dotX0Y1Z0, dotX0Y1Z1, localZ)
				resultX1Y1 = Lerp(dotX1Y1Z0, dotX1Y1Z1, localZ)
				resultX0 = Lerp(resultX0Y0, resultX0Y1, localY)
				resultX1 = Lerp(resultX1Y0, resultX1Y1, localY)
				result[x, y, z] = Lerp(resultX0, resultX1, localX)
				/*resultX0Y0 = dotX0Y0Z0 + localZ * (dotX0Y0Z1 - dotX0Y0Z0)
				resultX1Y0 = dotX1Y0Z0 + localZ * (dotX1Y0Z1 - dotX1Y0Z0)
				resultX0Y1 = dotX0Y1Z0 + localZ * (dotX0Y1Z1 - dotX0Y1Z0)
				resultX1Y1 = dotX1Y1Z0 + localZ * (dotX1Y1Z1 - dotX1Y1Z0)
				resultX0 = resultX0Y0 + localY * (resultX0Y1 - resultX0Y0)
				resultX1 = resultX1Y0 + localY * (resultX1Y1 - resultX1Y0)
				result[x, y, z] = resultX0 + localX * (resultX1 - resultX0)*/
				
			Next z
		Next y
	Next x
	
EndFunction
