// -----------------------------------------------------------------------------
// Реализация алгоритма полигонизации скалярного поля
// -----------------------------------------------------------------------------
// Источник: http://paulbourke.net/geometry/polygonise/

#Option_Explicit

#Constant FALSE 0
#Constant TRUE  1

#Constant ERRORMODE_IGNORE 0
#Constant ERRORMODE_REPORT 1
#Constant ERRORMODE_STOP   2

#Constant KEY_SPACE       32
#Constant KEY_A           65
#Constant KEY_D           68
#Constant KEY_S           83
#Constant KEY_W           87
#Constant KEY_LEFT_SHIFT 257
#Constant KEY_LEFT_CTRL  259

SetErrorMode(ERRORMODE_STOP)
SetWindowTitle("Polygonising a scalar field")
SetWindowSize(1280, 720, FALSE)
SetWindowAllowResize(TRUE)
SetVirtualResolution(1280, 720)
UseNewDefaultFonts(TRUE)
SetClearColor(64, 128, 192)

#Insert "polygonise.agc"

speed As Float
diffx As Float
diffy As Float
startx As Float
starty As Float
newx As Float
angx As Float
angy As Float

Function ClampFloat(value As Float, min As Float, max As Float)
	If value < min Then ExitFunction min
	If value > max Then ExitFunction max
EndFunction value

Function CloseBorders(array Ref As Float [][][], size As Integer, value As Float)
	i As Integer
	j As Integer
	max As Integer
	max = size - 1
	For i = 0 To max
		For j = 0 To max
			array[i, j, 0] = value
			array[0, i, j] = value
			array[i, 0, j] = value
			array[i, j, max] = value
			array[max, i, j] = value
			array[i, max, j] = value
		Next j
	Next i
EndFunction

scalarField As Float [63, 63, 63]
SetRandomSeed(1)
Noise(64, 32, scalarField)
CloseBorders(scalarField, 64, 0.0)
Polygonise(scalarField, 64, 0.0, 1.0)

Do
	If GetRawKeyState(KEY_LEFT_SHIFT)
		speed = 5.0
	Else
		speed = 1.0
	EndIf
	If GetRawKeyState(KEY_W) Then MoveCameraLocalZ(1, speed)
	If GetRawKeyState(KEY_S) Then MoveCameraLocalZ(1, -speed)
	If GetRawKeyState(KEY_A) Then MoveCameraLocalX(1, -speed)
	If GetRawKeyState(KEY_D) Then MoveCameraLocalX(1, speed)
	If GetRawKeyState(KEY_LEFT_CTRL) Then MoveCameraLocalY(1, -speed)
	If GetRawKeyState(KEY_SPACE) Then MoveCameraLocalY(1, speed)
	If GetPointerPressed()
		startx = GetPointerX()
		starty = GetPointerY()
		angx = GetCameraAngleX(1)
		angy = GetCameraAngleY(1)
	EndIf
	If GetPointerState()
		diffx = (GetPointerX() - startx) / 4.0
		diffy = (GetPointerY() - starty) / 4.0
		newx = ClampFloat(angx + diffy, -89.0, 89.0)
		SetCameraRotation(1, newx, angy + diffx, 0)
	EndIf
	Print(ScreenFPS())
	Sync()
Loop
