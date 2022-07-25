
// Project: MatchThree 
// Created: 2022-06-17

#Option_Explicit

SetErrorMode(2)
SetWindowTitle("MatchThree")
SetWindowSize(1280, 720, 0)
SetWindowAllowResize(0)
SetVirtualResolution(1920, 1080)
SetOrientationAllowed(0, 0, 1, 1)
SetSyncRate(60, 0)
SetScissor(0, 0, 0, 0)
UseNewDefaultFonts(1)
SetClearColor(64, 128, 192)

frameTime As Float

// Сотояния игры
flag As Integer
checkFlag As Integer

fallSpeed As Float = 5.0 // Скорость падения шара

// Переменные для обмена местами
swapFlag As Integer      // Состояние
swapSpeed As Float = 5.0 // Скорость обмен шаров
startI As Integer        // Расположение первого шара
startJ As Integer
finishI As Integer       // Расположение второго шара
finishJ As Integer

#Insert "vars.agc"
#Include "funcs.agc"

LoadResources()
LoadLevel("level.txt")
Fill()
ResetPrev()

Do
	frameTime = GetFrameTime()
	Select flag
		Case 0 // Падение шаров (игрок находится в ожидании)
			moveTime = moveTime + frameTime * fallSpeed
			If moveTime => 1.0
				While killedBallSprite.length => 0
					DeleteSprite(killedBallSprite[0])
					killedBallSprite.Remove(0)
				EndWhile
				moveTime = 0.0
				If checkFlag
					flag = Check()
				EndIf
				checkFlag = 1 - Fall()
			EndIf
		EndCase
		Case 1 // Игрок может менять шары местами
			Select swapFlag
				Case 0 // Игрок указывает на шары, которые нужно поменять местами
					If GetPointerPressed()
						startI = GetPointerTileI()
						startJ = GetPointerTileJ()
					EndIf
					If GetPointerReleased()
						finishI = GetPointerTileI()
						finishJ = GetPointerTileJ()
						If IsTile(startI, startJ) And IsTile(finishI, finishJ)
							If AbsInteger(finishI - startI) + AbsInteger(finishJ - startJ) = 1
								swapFlag = 1
								moveTime = 0.0
								SwapBalls(startI, startJ, finishI, finishJ)
							EndIf
						EndIf
					EndIf
				EndCase
				Case 1 // Шары меняются местами
					moveTime = moveTime + frameTime * swapSpeed
					If moveTime => 1.0
						ResetPrev()
						swapFlag = 0
						moveTime = 0.0
						flag = 0
						If Check()
							SwapBalls(finishI, finishJ, startI, startJ)
						Else
							checkFlag = 0
						EndIf
					EndIf
				EndCase
			EndSelect
		EndCase
	EndSelect
	UpdateSprites()
	Sync()
Loop
