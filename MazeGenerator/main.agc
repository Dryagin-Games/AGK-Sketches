
// Project: Maze Generation: Eller's Algorithm
// Created: 2022-11-03

#Option_Explicit

SetErrorMode(2)
SetWindowTitle("Maze Generation: Eller's Algorithm")
SetWindowSize(1280, 720, 0)
SetWindowAllowResize(1)
SetVirtualResolution(1920, 1080)
SetOrientationAllowed(1, 1, 1, 1)
SetSyncRate(30, 0)
SetScissor(0, 0, 0, 0)
UseNewDefaultFonts(1)
SetClearColor(32, 64, 128)
SetPrintColor(255, 255, 255)
SetPrintSize(48.0)

oldPointerX As Float
oldPointerY As Float

Function Min(a As Float, b As Float)
	If a < b Then ExitFunction a
EndFunction b

Global cellSize
Global wallSize

Function DrawVertWall(i As Integer, j As Integer)
	If wallSize > 1.0
		DrawBox((j + 1.0) * cellSize - wallSize / 2 - GetViewOffsetX(),
				 i        * cellSize - wallSize / 2 - GetViewOffsetY(),
				(j + 1.0) * cellSize + wallSize / 2 - GetViewOffsetX(),
				(i + 1.0) * cellSize + wallSize / 2 - GetViewOffsetY(),
				0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 1)
	Else
		DrawLine((j + 1.0) * cellSize - GetViewOffsetX(),
				  i        * cellSize - GetViewOffsetY(),
				 (j + 1.0) * cellSize - GetViewOffsetX(),
				 (i + 1.0) * cellSize - GetViewOffsetY(),
				 0xFF, 0xFF, 0xFF)
	EndIf
EndFunction

Function DrawHorzWall(i As Integer, j As Integer)
	If wallSize > 1.0
		DrawBox( j * cellSize - wallSize / 2 - GetViewOffsetX(),
				(i + 1.0) * cellSize - wallSize / 2 - GetViewOffsetY(),
				(j + 1.0) * cellSize + wallSize / 2 - GetViewOffsetX(),
				(i + 1.0) * cellSize + wallSize / 2 - GetViewOffsetY(),
				0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 1)
	Else
		DrawLine( j * cellSize - GetViewOffsetX(),
				 (i + 1.0) * cellSize - GetViewOffsetY(),
				 (j + 1.0) * cellSize - GetViewOffsetX(),
				 (i + 1.0) * cellSize - GetViewOffsetY(),
				 0xFF, 0xFF, 0xFF)
	EndIf
EndFunction

Type CellType
	set As Integer
	vert As Integer
	horz As Integer
EndType

Global setCounter As Integer

Function AssignUniqueSet(cell Ref As CellType [])
	j As Integer
	For j = 0 To cell.length
		If cell[j].set = 0
			Inc setCounter
			cell[j].set = setCounter
		EndIf
	Next j
EndFunction

Function MergeSet(cell Ref As CellType [], index As Integer, element As Integer)
	j As Integer
	mutableSet As Integer
	mutableSet = cell[index + 1].set
	For j = 0 To cell.length
		If cell[j].set = mutableSet Then cell[j].set = element
	Next j
EndFunction

Function AddingVerticalWalls(cell Ref As CellType [])
	j As Integer
	For j = 0 To cell.length - 1
		If Random(0, 1) = 1 Or cell[j].set = cell[j + 1].set
			cell[j].vert = 1
		Else
			MergeSet(cell, j, cell[j].set)
		EndIf
	Next j
	cell[cell.length].vert = 1
EndFunction

Function CalculateUniqueSet(cell Ref As CellType [], element As Integer)
	j As Integer
	countUniqSet As Integer
	For j = 0 To cell.length
		If cell[j].set = element Then Inc countUniqSet
	Next j
EndFunction countUniqSet

Function AddingHorizontalWalls(cell Ref As CellType [])
	j As Integer
	For j = 0 To cell.length
		If Random(0, 1) = 1 And CalculateUniqueSet(cell, cell[j].set) <> 1 Then cell[j].horz = 1
	Next j
EndFunction

Function CalculateHorizontalWalls(cell Ref As CellType [], element As Integer)
	j As Integer
	countHorizontalWalls As Integer
	For j = 0 To cell.length
		If cell[j].set = element And cell[j].horz = 0 Then Inc countHorizontalWalls
	Next j
EndFunction countHorizontalWalls

Function CheckedHorizontalWalls(cell Ref As CellType [])
	j As Integer
	For j = 0 To cell.length
		If CalculateHorizontalWalls(cell, cell[j].set) = 0 Then cell[j].horz = 0
	Next j
EndFunction

Function PreparatingNewLine(sourceCell Ref As CellType [], destionationCell Ref As CellType [])
	j As Integer
	For j = 0 To sourceCell.length
		If sourceCell[j].horz = 0 Then destionationCell[j].set = sourceCell[j].set
	Next j
EndFunction

Function CheckedEndLine(cell Ref As CellType [])
	j As Integer
	For j = 0 To cell.length - 1
		If cell[j].set <> cell[j + 1].set
			cell[j].vert = 0
			MergeSet(cell, j, cell[j].set)
		EndIf
		cell[j].horz = 1
	Next j
	cell[cell.length].horz = 1
EndFunction

Function GenerateMaze(cell Ref As CellType [][], width As Integer, height As Integer, seed As Integer)
	i As Integer
	j As Integer
	SetRandomSeed(seed)
	setCounter = 0
	If cell.length <> height - 1
		cell.length = height - 1
	EndIf
	For i = 0 To cell.length
		cell[i].length = width - 1
	Next i
	For i = 0 To cell.length
		For j = 0 To cell[i].length
			cell[i, j].set = 0
			cell[i, j].vert = 0
			cell[i, j].horz = 0
		Next j
	Next i
	For i = 0 To cell.length
		AssignUniqueSet(cell[i])
		AddingVerticalWalls(cell[i])
		If i < cell.length
			AddingHorizontalWalls(cell[i])
			CheckedHorizontalWalls(cell[i])
			PreparatingNewLine(cell[i], cell[i + 1])
		Else
			CheckedEndLine(cell[i])
		EndIf
	Next i
EndFunction

i As Integer
j As Integer
width As Integer = 8
height As Integer = 8
seed As Integer = 0
updateFlag As Integer = 1
Dim cell [height - 1, width - 1] As CellType

Do
	
	If GetRawKeyPressed(33) = 1
		Dec seed
		updateFlag = 1
	EndIf
	If GetRawKeyPressed(34) = 1
		Inc seed
		updateFlag = 1
	EndIf
	
	If GetRawKeyPressed(37) = 1
		If width > 1
			Dec width
			updateFlag = 1
		EndIf
	EndIf
	If GetRawKeyPressed(39) = 1
		Inc width
		updateFlag = 1
	EndIf
	
	If GetRawKeyPressed(38) = 1
		If height > 1
			Dec height
			updateFlag = 1
		EndIf
	EndIf
	If GetRawKeyPressed(40) = 1
		Inc height
		updateFlag = 1
	EndIf
	
	If updateFlag = 1
		GenerateMaze(cell, width, height, seed)
		cellSize = Min(1840.0 / width, 1000.0 / height)
		If cellSize > 64.0 Then cellSize = 64.0
		wallSize = Trunc(cellSize / 2.0)
		If wallSize > 8.0 Then wallSize = 8.0
		SetViewOffset((cellSize * width - 1920.0) / 2, (cellSize * height - 1080.0) / 2)
		updateFlag = 0
	EndIf
	
	If GetPointerPressed() = 1
		oldPointerX = GetPointerX()
		oldPointerY = GetPointerY()
	EndIf
	If GetPointerState() = 1
		SetViewOffset(GetViewOffsetX() + oldPointerX - GetPointerX(),
		              GetViewOffsetY() + oldPointerY - GetPointerY())
		oldPointerX = GetPointerX()
		oldPointerY = GetPointerY()
	EndIf
	
	If cell.length > -1
		For j = 0 To cell[0].length
			DrawHorzWall(-1, j)
		Next j
	EndIf
	For i = 0 To cell.length
		DrawVertWall(i, -1)
		For j = 0 To cell[i].length
			If cell[i, j].vert = 1
				DrawVertWall(i, j)
			EndIf
			If cell[i, j].horz = 1
				DrawHorzWall(i, j)
			EndIf
		Next j
	Next i
	
	Print("Width (Left/Right): " + Str(width))
	Print("Height (Up/Down): " + Str(height))
	Print("Seed (PgUp/PgDn): " + Str(seed))
	Print("FPS: " + Str(ScreenFPS(), 1))
	
	Sync()
	
Loop
