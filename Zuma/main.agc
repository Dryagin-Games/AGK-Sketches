
// Project: Zooma 
// Created: 2022-06-01

#Option_Explicit

#Constant False = 0
#Constant True  = 1

SetErrorMode(2)
SetWindowTitle("Zuma")
SetWindowSize(1280, 720, 0)
SetWindowAllowResize(False)
SetVirtualResolution(1920, 1080)
SetOrientationAllowed(False, False, True, True)
SetSyncRate(30, 0)
SetScissor(0, 0, 0, 0)
UseNewDefaultFonts(True)
SetClearColor(64, 128, 192)

#Insert "math.agc"
#Insert "resources.agc"
#Insert "explosion.agc"
#Insert "path.agc"
#Insert "balls.agc"
#Insert "player.agc"
#Insert "bullet.agc"

#Constant GameState_Playing  = 0
#Constant GameState_GameOver = 1

Global frameTime As Float
Global scoreText As Integer
Global score As Integer
Global gameState As Integer
Global gameOverText As Integer
Global replayButton As Integer
lastDistance As Float

Function GameOver(winFlag As Integer)
	gameState = GameState_GameOver
	If winFlag
		gameOverText = CreateText("ВЫИГРАЛ! ^.^")
	Else
		gameOverText = CreateText("ПРОИГРАЛ :,(")
	EndIf
	SetTextSize(gameOverText, 200.0)
	SetTextAlignment(gameOverText, 1)
	SetTextPosition(gameOverText, 960.0, 150.0)
	SetTextSpacing(gameOverText, 20.0)
	AddVirtualButton(replayButton, 960.0, 830.0, 0.0)
	SetVirtualButtonSize(replayButton, 400.0, 200.0)
	SetVirtualButtonImageUp(replayButton, replayImage[1])
	SetVirtualButtonImageDown(replayButton, replayImage[2])
	SetVirtualButtonAlpha(replayButton, 255)
EndFunction

scoreText = CreateText("0")
SetTextSize(scoreText, 100.0)
SetTextAlignment(scoreText, 1)
SetTextPosition(scoreText, 960.0, 20.0)
replayButton = 1

LoadImages()
InitPlayer()
LoadPath("path.txt")
AddStarterBalls(40)

Do
	
	Select gameState
		
		Case GameState_Playing
			// Обновление времени кадра
			frameTime = GetFrameTime()
			If frameTime > 0.04 Then frameTime = 0.04
			// Уничтожаем готовые к уничтожению шары
			TryDestroy()
			// Поворот игрока
			player.angle = ATan2(GetPointerY() - player.y, GetPointerX() - player.x)
			SetSpriteAngle(player.sprite, player.angle)
			// Выстрел
			If GetPointerState()
				If Timer() => player.shotTimer
					player.shotTimer = Timer() + player.shotDelay
					AddBullet()
					player.bulletColorIndex = RandomColorIndex()
					SetSpriteImage(player.bulletSprite, ballImage[player.bulletColorIndex])
				EndIf
			EndIf
			// Движение шаров
			If ball.length > -1
				lastDistance = ball[ball.length].distance
				MoveBall(0, frameTime * ballSpeed)
				If lastDistance = ball[ball.length].distance
					MoveBall(ball.length, -frameTime * ballReturnSpeed)
				EndIf
				If ball[ball.length].distance => path.distance
					GameOver(False)
				EndIf
			Else
				GameOver(True)
			EndIf
		EndCase
		
		Case GameState_GameOver
			If GetVirtualButtonState(replayButton)
				AddStarterBalls(40)
				DeleteText(gameOverText)
				DeleteVirtualButton(replayButton)
				gameState = GameState_Playing
				score = 0
				SetTextString(scoreText, "0")
			EndIf
		EndCase
		
	EndSelect
	
	UpdateBullets()
	UpdateExplosions()
	
	Sync()
	
Loop

