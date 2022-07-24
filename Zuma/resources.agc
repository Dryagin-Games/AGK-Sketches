
// Загрузка изображений

Global ballImages As Integer
Global Dim ballImage [3] As Integer
Global back As Integer
Global explosionImage As Integer
Global playerImage As Integer
Global Dim replayImage [2] As Integer

Function LoadImages()
	ballImages = LoadImage("balls.png")
	ballImage[0] = LoadSubImage(ballImages, "red")
	ballImage[1] = LoadSubImage(ballImages, "yellow")
	ballImage[2] = LoadSubImage(ballImages, "green")
	ballImage[3] = LoadSubImage(ballImages, "blue")
	back = LoadSprite("back.jpg")
	explosionImage = LoadImage("explosion.png")
	playerImage = LoadImage("player.png")
	replayImage[0] = LoadImage("replay.png")
	replayImage[1] = LoadSubImage(replayImage[0], "1")
	replayImage[2] = LoadSubImage(replayImage[0], "2")
EndFunction
