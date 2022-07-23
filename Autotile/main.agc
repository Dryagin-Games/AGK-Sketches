// -----------------------------------------------------------------------------
// Алгоритм автоматического подбора спрайта плитки в зависимости от соседних
// -----------------------------------------------------------------------------

#Option_Explicit

Type PointInteger
	x As Integer
	y As Integer
EndType

SetErrorMode(2)
SetWindowTitle("Autotiles")
SetWindowSize(1280, 720, 0)
SetWindowAllowResize(1)
SetVirtualResolution(1280, 720)
UseNewDefaultFonts(1)

SetClearColor(64, 128, 192)

#Include "autotile.agc"
#Include "example.agc"

LoadTilesetImages()

testMap As MapType
x As Integer
y As integer

// Создание демонстрационной карты
For y = 0 To 31
	For x = 0 To 31
		If Sqrt(Pow(x - 15.5, 2) + Pow(y - 15.5, 2)) <= 14.5
			SetTileVar(testMap, x, y, 1)
		Else
			SetTileVar(testMap, x, y, 0)
		EndIf
	Next x
Next y

UpdateAllTileSprites(testMap)

#Constant BUTTON_PEN       1
#Constant BUTTON_ERASER    2
#Constant BUTTON_TILESET0 10
#Constant BUTTON_TILESET1 11
#Constant BUTTON_TILESET2 12
#Constant BUTTON_TILESET3 13
#Constant BUTTON_TILESET4 14

AddVirtualButton(BUTTON_PEN, 40.0, 40.0, 64.0)
AddVirtualButton(BUTTON_ERASER, 112.0, 40.0, 64.0)
AddVirtualButton(BUTTON_TILESET0, 200.0, 40.0, 64.0)
AddVirtualButton(BUTTON_TILESET1, 272.0, 40.0, 64.0)
AddVirtualButton(BUTTON_TILESET2, 344.0, 40.0, 64.0)
AddVirtualButton(BUTTON_TILESET3, 416.0, 40.0, 64.0)
AddVirtualButton(BUTTON_TILESET4, 488.0, 40.0, 64.0)
SetVirtualButtonText(BUTTON_PEN, "[Рисовать]")
SetVirtualButtonText(BUTTON_ERASER, "Стирать")
SetVirtualButtonText(BUTTON_TILESET0, "[ 0 ]")
SetVirtualButtonText(BUTTON_TILESET1, "1")
SetVirtualButtonText(BUTTON_TILESET2, "2")
SetVirtualButtonText(BUTTON_TILESET3, "3")
SetVirtualButtonText(BUTTON_TILESET4, "4")

#Constant MODE_PEN    1
#Constant MODE_ERASER 0

mode As Integer = MODE_PEN

pointerStart As PointInteger
viewOffsetStart As PointInteger
pointerWorld As PointInteger
pointerTile As PointInteger
viewZoomIndex As Integer = 3

index As Integer
index0 As Integer

Do
	
	If GetVirtualButtonPressed(BUTTON_PEN)
		If mode <> MODE_PEN
			mode = MODE_PEN
			SetVirtualButtonText(BUTTON_PEN, "[Рисовать]")
			SetVirtualButtonText(BUTTON_ERASER, "Стирать")
		EndIf	
	EndIf
	
	If GetVirtualButtonPressed(BUTTON_ERASER)
		If mode <> MODE_ERASER
			mode = MODE_ERASER
			SetVirtualButtonText(BUTTON_PEN, "Рисовать")
			SetVirtualButtonText(BUTTON_ERASER, "[Стирать]")
		EndIf	
	EndIf
	
	For index = 0 To 4
		If GetVirtualButtonPressed(10 + index)
			If testMap.tileset <> index
				testMap.tileset = index
				For index0 = 0 To 4
					If index = index0
						SetVirtualButtonText(10 + index0, "[ " + Str(index0) + " ]")
					Else
						SetVirtualButtonText(10 + index0, Str(index0))
					EndIf
				Next index0
				UpdateAllTileSprites(testMap)
			EndIf	
		EndIf
	Next index
	
	// Масштабирование
	If GetRawMouseWheelDelta() <> 0.0
		pointerWorld.x = ScreenToWorldX(GetRawMouseX())
		pointerWorld.y = ScreenToWorldY(GetRawMouseY())
		If GetRawMouseWheelDelta() < 0.0
			viewZoomIndex = viewZoomIndex - 1
		Else
			viewZoomIndex = viewZoomIndex + 1
		EndIf
		If viewZoomIndex < 0 Then viewZoomIndex = 0
		If viewZoomIndex > 5 Then viewZoomIndex = 5
		SetViewZoom(0.125 * Pow(2, viewZoomIndex))
		SetViewOffset(pointerWorld.x - GetRawMouseX() / GetViewZoom(), pointerWorld.y - GetRawMouseY() / GetViewZoom())
	EndIf
	
	// Смещение
	If GetRawMouseRightPressed()
		viewOffsetStart.x = GetViewOffsetX()
		viewOffsetStart.y = GetViewOffsetY()
		pointerStart.x = GetRawMouseX()
		pointerStart.y = GetRawMouseY()
	EndIf
	If GetRawMouseRightState()
		SetViewOffset(viewOffsetStart.x + (pointerStart.x - GetRawMouseX()) / GetViewZoom(), viewOffsetStart.y + (pointerStart.y - GetRawMouseY()) / GetViewZoom())
	EndIf
	
	If ScreenToWorldX(GetRawMouseX()) => -TILE_CENTER_X And ScreenToWorldY(GetRawMouseY()) => -TILE_CENTER_Y
		pointerTile.x = Trunc((ScreenToWorldX(GetRawMouseX()) + TILE_CENTER_X) / TILE_WIDTH)
		pointerTile.y = Trunc((ScreenToWorldY(GetRawMouseY()) + TILE_CENTER_Y) / TILE_HEIGHT)
	Else
		pointerTile.x = -1
		pointerTile.y = -1
	EndIf
	
	If GetRawMouseLeftState()
		If pointerTile.x > -1 And pointerTile.y > -1
			If mode = MODE_ERASER And testMap.tileset = 2
				For index = 0 To 8
					SetTileVar(testMap, pointerTile.x + Mod(index, 3) - 1, pointerTile.y + Trunc(index / 3) - 1, mode)
				Next index
				For index = 0 To 24
					UpdateTileSprite(testMap, pointerTile.x + Mod(index, 5) - 2, pointerTile.y + Trunc(index / 5) - 2)
				Next index
			Else
				SetTileVar(testMap, pointerTile.x, pointerTile.y, mode)
				For index = 0 To 8
					UpdateTileSprite(testMap, pointerTile.x + Mod(index, 3) - 1, pointerTile.y + Trunc(index / 3) - 1)
				Next index
			EndIf
		EndIf
	EndIf
	
	Sync()
	
Loop
