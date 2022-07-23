// Проект: MahjongSolitair 
// Создан: 20-06-20

#Option_Explicit

#Constant False 0
#Constant True  1

#Constant ErrorMode_Ignore 0
#Constant ErrorMode_Report 1
#Constant ErrorMode_Stop   2

#Constant SyncMode_SaveBattery 0
#Constant SyncMode_Intensive   1

SetErrorMode(ErrorMode_Stop) // Показывать все ошибки

SetWindowTitle("MahjongSolitair")
SetWindowSize(1280, 720, False)
SetWindowAllowResize(False)
SetOrientationAllowed(False, False, True, True)
SetScissor(0, 0, 0, 0)
SetVirtualResolution(1920, 1080)
UseNewDefaultFonts(True)
SetPrintSize(32)

BackgroundSprite As Integer
BackgroundSprite = LoadSprite("Background.png")
FixSpriteToScreen(BackgroundSprite, True)

Global ZOffsetX As Float = -100.0
Global ZOffsetY As Float = 100.0

Global TileSpriteWidth As Float
Global TileSpriteHeight As Float

Global Tile_Grey As Integer
Tile_Grey = LoadImage("Grey.png")

#Constant Tile_Simple_Dots_1 1
#Constant Tile_Simple_Dots_2 2
#Constant Tile_Simple_Dots_3 3
#Constant Tile_Simple_Dots_4 4
#Constant Tile_Simple_Dots_5 5
#Constant Tile_Simple_Dots_6 6
#Constant Tile_Simple_Dots_7 7
#Constant Tile_Simple_Dots_8 8
#Constant Tile_Simple_Dots_9 9

#Constant Tile_Simple_Bamboo_1 10
#Constant Tile_Simple_Bamboo_2 11
#Constant Tile_Simple_Bamboo_3 12
#Constant Tile_Simple_Bamboo_4 13
#Constant Tile_Simple_Bamboo_5 14
#Constant Tile_Simple_Bamboo_6 15
#Constant Tile_Simple_Bamboo_7 16
#Constant Tile_Simple_Bamboo_8 17
#Constant Tile_Simple_Bamboo_9 18

#Constant Tile_Simple_Characters_1 19
#Constant Tile_Simple_Characters_2 20
#Constant Tile_Simple_Characters_3 21
#Constant Tile_Simple_Characters_4 22
#Constant Tile_Simple_Characters_5 23
#Constant Tile_Simple_Characters_6 24
#Constant Tile_Simple_Characters_7 25
#Constant Tile_Simple_Characters_8 26
#Constant Tile_Simple_Characters_9 27

#Constant Tile_Honor_Wind_East  28
#Constant Tile_Honor_Wind_South 29
#Constant Tile_Honor_Wind_West  30
#Constant Tile_Honor_Wind_North 31

#Constant Tile_Honor_Dragon_Red   32
#Constant Tile_Honor_Dragon_Green 33
#Constant Tile_Honor_Dragon_White 34

#Constant Tile_Bonus_Flower_PlumBlossom   35
#Constant Tile_Bonus_Flower_Orchid        36
#Constant Tile_Bonus_Flower_Chrysanthemum 37
#Constant Tile_Bonus_Flower_Bamboo        38

#Constant Tile_Bonus_Season_Spring 39
#Constant Tile_Bonus_Season_Summer 40
#Constant Tile_Bonus_Season_Autumn 41
#Constant Tile_Bonus_Season_Winter 42

Global Dim Tile_Image[42]

Tile_Image[0] = LoadImage("MJd3e.png")

TileSpriteWidth = GetImageWidth(Tile_Image[0])
TileSpriteHeight = GetImageHeight(Tile_Image[0])

Tile_Image[Tile_Simple_Dots_1] = LoadImage("MJt1.png")
Tile_Image[Tile_Simple_Dots_2] = LoadImage("MJt2.png")
Tile_Image[Tile_Simple_Dots_3] = LoadImage("MJt3.png")
Tile_Image[Tile_Simple_Dots_4] = LoadImage("MJt4.png")
Tile_Image[Tile_Simple_Dots_5] = LoadImage("MJt5.png")
Tile_Image[Tile_Simple_Dots_6] = LoadImage("MJt6.png")
Tile_Image[Tile_Simple_Dots_7] = LoadImage("MJt7.png")
Tile_Image[Tile_Simple_Dots_8] = LoadImage("MJt8.png")
Tile_Image[Tile_Simple_Dots_9] = LoadImage("MJt9.png")

Tile_Image[Tile_Simple_Bamboo_1] = LoadImage("MJs1.png")
Tile_Image[Tile_Simple_Bamboo_2] = LoadImage("MJs2.png")
Tile_Image[Tile_Simple_Bamboo_3] = LoadImage("MJs3.png")
Tile_Image[Tile_Simple_Bamboo_4] = LoadImage("MJs4.png")
Tile_Image[Tile_Simple_Bamboo_5] = LoadImage("MJs5.png")
Tile_Image[Tile_Simple_Bamboo_6] = LoadImage("MJs6.png")
Tile_Image[Tile_Simple_Bamboo_7] = LoadImage("MJs7.png")
Tile_Image[Tile_Simple_Bamboo_8] = LoadImage("MJs8.png")
Tile_Image[Tile_Simple_Bamboo_9] = LoadImage("MJs9.png")

Tile_Image[Tile_Simple_Characters_1] = LoadImage("MJw1.png")
Tile_Image[Tile_Simple_Characters_2] = LoadImage("MJw2.png")
Tile_Image[Tile_Simple_Characters_3] = LoadImage("MJw3.png")
Tile_Image[Tile_Simple_Characters_4] = LoadImage("MJw4.png")
Tile_Image[Tile_Simple_Characters_5] = LoadImage("MJw5.png")
Tile_Image[Tile_Simple_Characters_6] = LoadImage("MJw6.png")
Tile_Image[Tile_Simple_Characters_7] = LoadImage("MJw7.png")
Tile_Image[Tile_Simple_Characters_8] = LoadImage("MJw8.png")
Tile_Image[Tile_Simple_Characters_9] = LoadImage("MJw9.png")

Tile_Image[Tile_Honor_Wind_East]  = LoadImage("MJf1.png")
Tile_Image[Tile_Honor_Wind_South] = LoadImage("MJf2.png")
Tile_Image[Tile_Honor_Wind_West]  = LoadImage("MJf3.png")
Tile_Image[Tile_Honor_Wind_North] = LoadImage("MJf4.png")

Tile_Image[Tile_Honor_Dragon_Red]   = LoadImage("MJd1.png")
Tile_Image[Tile_Honor_Dragon_Green] = LoadImage("MJd2.png")
Tile_Image[Tile_Honor_Dragon_White] = LoadImage("MJd3.png")

Tile_Image[Tile_Bonus_Flower_PlumBlossom]   = LoadImage("MJh5.png")
Tile_Image[Tile_Bonus_Flower_Orchid]        = LoadImage("MJh6.png")
Tile_Image[Tile_Bonus_Flower_Chrysanthemum] = LoadImage("MJh7.png")
Tile_Image[Tile_Bonus_Flower_Bamboo]        = LoadImage("MJh8.png")

Tile_Image[Tile_Bonus_Season_Spring] = LoadImage("MJh1.png")
Tile_Image[Tile_Bonus_Season_Summer] = LoadImage("MJh2.png")
Tile_Image[Tile_Bonus_Season_Autumn] = LoadImage("MJh3.png")
Tile_Image[Tile_Bonus_Season_Winter] = LoadImage("MJh4.png")

Index As Integer

SetClearColor(128, 192, 255)

Type Tile
	X As Integer
	Y As Integer
	Z As Integer
	
	SpriteID As Integer
	
	TileType As Integer
	
	IsOnBoard As Integer
	IsAvailable As Integer
	
	IsChecked As Integer
EndType

Global Dim Tile[144] As Tile

Function LoadPuzzle(Filename As String)
	FileID As Integer
	Index As Integer
	Line As String
	FileID = OpenToRead(Filename)
	Index = 1
	While Not FileEOF(FileID)
		Line = ReadLine(FileID)
		Tile[Index].X = Val(GetStringToken2(Line, ",", 1))
		Tile[Index].Y = Val(GetStringToken2(Line, ",", 2))
		Tile[Index].Z = Val(GetStringToken2(Line, ",", 3))
		Inc Index
		If Index > 144 Then Exit
	EndWhile
	CloseFile(FileID)
EndFunction

Function RandomizePuzzle()
	TileIndex As Integer
	TileLeftIndex As Integer
	TileLeftIndex2 As Integer
	TileLeftIndex = 1
	Repeat
		TileLeftIndex2 = 4
		Repeat
			TileIndex = Random(1, 144)
			If Tile[TileIndex].TileType = 0
				Tile[TileIndex].TileType = TileLeftIndex
				Dec TileLeftIndex2
			EndIf
		Until TileLeftIndex2 = 0
		Inc TileLeftIndex
	Until TileLeftIndex = 35
	Repeat
		Do
			TileIndex = Random(1, 144)
			If Tile[TileIndex].TileType = 0
				Tile[TileIndex].TileType = TileLeftIndex
				Exit
			EndIf
		Loop
		Inc TileLeftIndex
	Until TileLeftIndex = 43
EndFunction

Function InitSprites()
	TileIndex As Integer
	For TileIndex = 1 To 144
		Tile[TileIndex].SpriteID = CreateSprite(Tile_Image[Tile[TileIndex].TileType])
		SetSpriteOffset(Tile[TileIndex].SpriteID, TileSpriteWidth * 0.5, TileSpriteHeight * 0.5)
		SetSpritePositionByOffset(Tile[TileIndex].SpriteID, Tile[TileIndex].X * TileSpriteWidth * 0.5 + Tile[TileIndex].Z * ZOffsetX, Tile[TileIndex].Y * TileSpriteHeight * 0.5 + Tile[TileIndex].Z * ZOffsetY)
	Next TileIndex
EndFunction

Function CheckAvailable()
	Index As Integer
	Index2 As Integer
	LeftFlag As Integer
	RightFlag As Integer
	For Index = 1 To 144
		If Tile[Index].IsOnBoard
			Tile[Index].IsAvailable = True
			LeftFlag = False
			RightFlag = False
			For Index2 = 1 To 144
				If Index <> Index2 And Tile[Index2].IsOnBoard
					// Проверяем, не лежит ли плитка Index2 над проверяемой плиткой Index
					If Tile[Index2].Z > Tile[Index].Z
						If Tile[Index2].X - 1 <= Tile[Index].X And Tile[Index2].X + 1 => Tile[Index].X And Tile[Index2].Y - 1 <= Tile[Index].Y And Tile[Index2].Y + 1 => Tile[Index].Y Then Tile[Index].IsAvailable = False
					ElseIf Tile[Index2].Z = Tile[Index].Z
						// Проверяем, не зажимает ли плитка Index2 слева плитку Index
						If Tile[Index2].X = Tile[Index].X - 2 And Tile[Index2].Y - 1 <= Tile[Index].Y And Tile[Index2].Y + 1 => Tile[Index].Y Then LeftFlag = True
						// Проверяем, не зажимает ли плитка Index2 справа плитку Index
						If Tile[Index2].X = Tile[Index].X + 2 And Tile[Index2].Y - 1 <= Tile[Index].Y And Tile[Index2].Y + 1 => Tile[Index].Y Then RightFlag = True
					EndIf
				EndIf
			Next Index2
			If LeftFlag = True And RightFlag = True Then Tile[Index].IsAvailable = False
			If Tile[Index].IsAvailable
				SetSpriteColor(Tile[Index].SpriteID, 255, 255, 255, 255)
			Else
				SetSpriteColor(Tile[Index].SpriteID, 64, 64, 64, 255)
			EndIf
		EndIf
	Next Index
EndFunction

Function ResedTileIsChecked()
	Index As Integer
	For Index = 1 To 144
		Tile[Index].IsChecked = False
	Next Index
EndFunction

Function CheckMatch(Index1 As Integer, Index2 As Integer)
	Result As Integer = False
	If (Tile[Index1].TileType => 1 And Tile[Index1].TileType <= 34 And Tile[Index1].TileType = Tile[Index2].TileType) Or (Tile[Index1].TileType => 35 And Tile[Index1].TileType <= 38 And Tile[Index2].TileType => 35 And Tile[Index2].TileType <= 38) Or (Tile[Index1].TileType => 39 And Tile[Index1].TileType <= 42 And Tile[Index2].TileType => 39 And Tile[Index2].TileType <= 42)
		Result = True
	EndIf
EndFunction Result

Global NumMatchesText As Integer
NumMatchesText = CreateText("")
FixTextToScreen(NumMatchesText, True)
SetTextSize(NumMatchesText, 200.0)
SetTextPosition(NumMatchesText, 50.0, 50.0)

Function CountMatches()
	NumMatches As Integer
	Index As Integer
	Index2 As Integer
	ResedTileIsChecked()
	For Index = 1 To 144
		For Index2 = 1 To 144
			If Index <> Index2 And Tile[Index].IsOnBoard And Tile[Index2].IsOnBoard And Tile[Index].IsAvailable And Tile[Index2].IsAvailable And Tile[Index].IsChecked = False And Tile[Index2].IsChecked = False
				If CheckMatch(Index, Index2)
					Inc NumMatches
					Tile[Index].IsChecked = True
					Tile[Index2].IsChecked = True
				EndIf
			EndIf
		Next Index2
	Next Index
	SetTextString(NumMatchesText, Str(NumMatches))
	If NumMatches = 0
		SetTextColor(NumMatchesText, 255, 0, 0, 255)
	ElseIf NumMatches => 1 And NumMatches <= 2
		SetTextColor(NumMatchesText, 255, 128, 0, 255)
	ElseIf NumMatches => 3 And NumMatches <= 5
		SetTextColor(NumMatchesText, 255, 255, 0, 255)
	Else
		SetTextColor(NumMatchesText, 0, 255, 0, 255)
	EndIf
EndFunction

LoadPuzzle("turtle.txt")
RandomizePuzzle()
InitSprites()
For Index = 1 To 144
	Tile[Index].IsOnBoard = True
Next Index
CheckAvailable()

SetViewZoom(0.2)
SetViewOffset(-4800, -2700)

SpriteID As Integer
SelectedTile As Integer

CountMatches()

Do
	
	If GetPointerPressed()
		SpriteID = GetSpriteHit(ScreenToWorldX(GetPointerX()), ScreenToWorldY(GetPointerY()))
		For Index = 1 To 144
			If Tile[Index].SpriteID = SpriteID
				If Tile[Index].IsAvailable
					If SelectedTile = 0
						SelectedTile = Index
						SetSpriteColor(Tile[Index].SpriteID, 255, 255, 0, 255)
					ElseIf SelectedTile <> Index
						If CheckMatch(SelectedTile, Index)
							DeleteSprite(Tile[SelectedTile].SpriteID)
							Tile[SelectedTile].IsOnBoard = False
							DeleteSprite(Tile[Index].SpriteID)
							Tile[Index].IsOnBoard = False
							CheckAvailable()
							CountMatches()
						Else
							SelectedTile = Index
							CheckAvailable()
							SetSpriteColor(Tile[Index].SpriteID, 255, 255, 0, 255)
						EndIf
					EndIf
					
				EndIf
			EndIf
		Next Index
	EndIf
	
	Sync()
Loop
