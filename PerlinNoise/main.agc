// -----------------------------------------------------------------------------
// Реализация алгоритма генерации трёхмерного шума Перлина
// -----------------------------------------------------------------------------

#Option_Explicit

#Constant FALSE 0
#Constant TRUE  1

#Constant ERRORMODE_IGNORE 0
#Constant ERRORMODE_REPORT 1
#Constant ERRORMODE_STOP   2

SetErrorMode(ERRORMODE_STOP)
SetWindowTitle("Perlin Noise")
SetWindowSize(1280, 720, FALSE)
SetWindowAllowResize(TRUE)
SetVirtualResolution(1280, 720)
UseNewDefaultFonts(TRUE)
SetClearColor(64, 128, 192)

#Include "perlinnoise.agc"

x As Integer
y As Integer
z As Integer
time As Float
Dim Noise [-1, -1, -1] As Float

Print("Начата генерация шума")
Print("Это может занят некоторое время, в зависимости от размера множества")
Print("Дождитесь окончания, чтобы увидеть результат")
Sync()

time = Timer()
InitPerlinNoise(64, 32, 0)
GeneratePerlinNoise(Noise)
time = Timer() - time
ResetTimer()

Do
	
	If Timer() > 0.1
		ResetTimer()
		z = z + 1
		If z > 63 Then z = 0
	EndIf
	
	DrawBox(384, 104, 896, 616, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, TRUE)
	For y = 0 To 63
		For x = 0 To 63
			If Noise[x, y, z] > 0.0
				DrawBox(x * 8 + 384, y * 8 + 104, x * 8 + 392, y * 8 + 112, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, TRUE)
			EndIf
		Next x
	Next y
	
	Print("Сгенерировано за " + Str(time) + " с")
	Print("FPS: " + Str(ScreenFPS()))
	Print("z = " + Str(z))
	
	Sync()
	
Loop
