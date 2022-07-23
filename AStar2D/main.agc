// -----------------------------------------------------------------------------
// Реализация алгоритм поиска A* для двухмерной тайловой карты с весами
// -----------------------------------------------------------------------------

#Option_Explicit

#Constant FALSE 0
#Constant TRUE  1

#Constant ERRORMODE_IGNORE 0
#Constant ERRORMODE_REPORT 1
#Constant ERRORMODE_STOP   2

#Constant MINVIEWZOOMINDEX 0
#Constant MAXVIEWZOOMINDEX 5

frameTime As Float
viewZoomIndex As Integer = 3
viewZoom As Float
viewZoomDest As Float = 1.0
pointerScreen As PointFloatType
pointerWorld As PointFloatType
viewOffsetStart As PointFloatType
pointerStart As PointFloatType
viewOffsetDest As PointFloatType

#Constant MODE_START -2
#Constant MODE_GOAL  -1
#Constant MODE_WATER  0
#Constant MODE_GRASS  1
#Constant MODE_GROUND 2
#Constant MODE_STONE  3

mode As Integer
pointerTile As PointIntegerType

#Include "funcs.agc"
#Include "example.agc"
#Include "findpath.agc"

SetErrorMode(ERRORMODE_STOP)
SetWindowTitle("A*")
SetWindowSize(1280, 720, FALSE)
SetWindowAllowResize(TRUE)
SetVirtualResolution(1280, 720)
UseNewDefaultFonts(TRUE)
SetClearColor(64, 128, 196)

LoadImages()

testMap As MapType
InitMap(testMap, 8, 6)

findPathLimit As PointIntegerType
findPathLimit.x = 16
findPathLimit.y = 12
SetStart(testMap, 0, 0)
SetGoal(testMap, 7, 5)
SearchPath(testMap, findPathLimit.x, findPathLimit.y, testMap.start.x, testMap.start.y, testMap.goal.x, testMap.goal.y, testMap.path)
UpdateArrows(testMap)

SetViewOffset(-435.0, -215.0)

Do
	
	frameTime = GetFrameTime()
	viewZoom = GetViewZoom()
	pointerScreen.x = GetRawMouseX()
	pointerScreen.y = GetRawMouseY()
	pointerWorld.x = ScreenToWorldX(pointerScreen.x)
	pointerWorld.y = ScreenToWorldY(pointerScreen.y)
	
	If pointerWorld.x => -tileCenterX And pointerWorld.x < testMap.max.x * tileWidth + tileCenterX And pointerWorld.y => -tileCenterY And pointerWorld.y < testMap.max.y * tileHeight + tileCenterY
		pointerTile.x = Trunc((pointerWorld.x + tileCenterX) / tileWidth)
		pointerTile.y = Trunc((pointerWorld.y + tileCenterY) / tileHeight)
	Else
		pointerTile.x = -1
		pointerTile.y = -1
	EndIf
	
	If GetRawMouseLeftPressed()
		If pointerTile.x > -1 And pointerTile.y > -1
			If pointerTile.x = testMap.start.x And pointerTile.y = testMap.start.y
				mode = MODE_START
			ElseIf pointerTile.x = testMap.goal.x And pointerTile.y = testMap.goal.y
				mode = MODE_GOAL
			Else
				mode = testMap.tile[pointerTile.x, pointerTile.y].var + 1
				If mode > 3 Then mode = 0
			EndIf
		EndIf
	EndIf
	
	If GetRawMouseLeftState()
		If pointerTile.x > -1 And pointerTile.y > -1
			Select mode
				Case MODE_START
					SetStart(testMap, pointerTile.x, pointerTile.y)
				EndCase
				Case MODE_GOAL
					SetGoal(testMap, pointerTile.x, pointerTile.y)
				EndCase
				Case MODE_WATER, MODE_GRASS, MODE_GROUND, MODE_STONE
					SetTile(testMap, pointerTile.x, pointerTile.y, mode)
				EndCase
			EndSelect
		EndIf
	EndIf
	
	If GetRawMouseLeftReleased()
		SearchPath(testMap, findPathLimit.x, findPathLimit.y, testMap.start.x, testMap.start.y, testMap.goal.x, testMap.goal.y, testMap.path)
		UpdateArrows(testMap)
	EndIf
	
	If GetRawMouseWheelDelta() <> 0.0
		viewZoomIndex = ClampInteger(viewZoomIndex + SignFloat(GetRawMouseWheelDelta()), MINVIEWZOOMINDEX, MAXVIEWZOOMINDEX)
		viewZoomDest = 0.125 * Pow(2, viewZoomIndex)
	EndIf
	If viewZoom <> viewZoomDest
		SetViewZoom(Lerp(viewZoom, viewZoomDest, frameTime * 10.0))
		SetViewOffset(pointerWorld.x - pointerScreen.x / GetViewZoom(), pointerWorld.y - pointerScreen.y / GetViewZoom())
	EndIf
	
	If GetRawMouseRightPressed()
		viewOffsetStart.x = GetViewOffsetX()
		viewOffsetStart.y = GetViewOffsetY()
		pointerStart.x = pointerScreen.x
		pointerStart.y = pointerScreen.y
	EndIf
	If GetRawMouseRightState()
		viewOffsetDest.x = viewOffsetStart.x + (pointerStart.x - pointerScreen.x) / viewZoom
		viewOffsetDest.y = viewOffsetStart.y + (pointerStart.y - pointerScreen.y) / viewZoom
		SetViewOffset(Lerp(GetViewOffsetX(), viewOffsetDest.x, frameTime * 10.0), Lerp(GetViewOffsetY(), viewOffsetDest.y, frameTime * 10.0))
	EndIf
	
	Print(ScreenFPS())
	
	Sync()
Loop
