
// Выстреливаемые шары

Global Dim bullet [] As BallType

// Максимальный шаг перемещения выстреленного шара
Global bulletStep As Float = 15.0
// Предыдущее значение сгенерированного идентификатора кода цвета шара для выстрела
Global prevRandomColorIndex As Integer = -1
// Количество повторений расчётов выталкиваний шаров на пути выстреленным шаром
#Constant NumOfIterations = 2
// Границы экрана для удаления вылетевших шаров
Global bulletMinX As Float = -50.0  // 0.0 - ballRadius
Global bulletMaxX As Float = 1970.0 // 1920.0 + ballRadius
Global bulletMinY As Float = -50.0  // 0.0 - ballRadius
Global bulletMaxY As Float = 1130.0 // 1080 + ballRadius

// Сгенерировать случайный идентификатор кода цвета шара

Function RandomColorIndex()
	Dim count [] As Integer
	index As Integer
	counter As Integer
	For index = 0 To ball.length
		If count.length < ball[index].colorIndex Then count.length = ball[index].colorIndex
		Inc count[ ball[index].colorIndex ]
	Next index
	counter = Random(1, ball.length + 1)
	For index = 0 To count.length
		counter = counter - count[ index ]
		If counter <= 0
			prevRandomColorIndex = index
			ExitFunction index
		EndIf
	Next index
	index = Random(0, ballColor.length)
	prevRandomColorIndex = index
EndFunction index

// Добавить выстреленный шар (выстрелить)
//
// Возвращает идентификатор выстреленного шара

Function AddBullet()
	index As Integer
	index = bullet.length + 1
	bullet.length = index
	bullet[index].center.x = player.x
	bullet[index].center.y = player.y
	bullet[index].angle = player.angle
	bullet[index].speed = player.bulletSpeed
	bullet[index].colorIndex = player.bulletColorIndex
	bullet[index].sprite = CreateSprite(ballImage[player.bulletColorIndex])
	SetSpriteSize(bullet[index].sprite, 112.0, 112.0)
	SetSpriteOffset(bullet[index].sprite, 56.0, 56.0)
EndFunction index

// Удалить выстреленный шар
//
// bulletIndex - идентификатор выстреленного шара

Function DeleteBullet(bulletIndex As Integer)
	DeleteSprite(bullet[bulletIndex].sprite)
	bullet.Remove(bulletIndex)
EndFunction

// Переместить выстреленный шар
//
// bulletIndex - идентификатор выстреленного шара

Function MoveBullet(bulletIndex As Integer)
	ballIndex As Integer
	distance As Float
	stepDistance As Float
	displace As Float
	distance2 As Float
	forcedSign As Float
	distanceToTarget As Float
	iteration As Integer
	distance = frameTime * bullet[bulletIndex].speed
	Repeat
		If distance => bulletStep
			stepDistance = bulletStep
			distance = distance - bulletStep
		Else
			stepDistance = distance
			distance = 0.0
		EndIf
		Select bullet[bulletIndex].bulletToBallFlag
			Case 0
				bullet[bulletIndex].center.x = bullet[bulletIndex].center.x + Cos(bullet[bulletIndex].angle) * stepDistance
				bullet[bulletIndex].center.y = bullet[bulletIndex].center.y + Sin(bullet[bulletIndex].angle) * stepDistance
				SetSpritePositionByOffset(bullet[bulletIndex].sprite, bullet[bulletIndex].center.x, bullet[bulletIndex].center.y)
				For ballIndex = 0 To ball.length
					forcedSign = 0.0
					For iteration = 1 To NumOfIterations
						distance2 = DistTwoPoints(ball[ballIndex].center, bullet[bulletIndex].center)
						If distance2 => (ballDiameter - 1.0) Then Exit
						displace = DisplaceBall(bullet[bulletIndex], ball[ballIndex], forcedSign)
						If forcedSign = 0.0 Then forcedSign = Sign(displace)
						MoveBall(ballIndex, displace)
						If Not bullet[bulletIndex].bulletToBallFlag
							bullet[bulletIndex].bulletToBallFlag = True
							bullet[bulletIndex].targetDistance = ball[ballIndex].distance - ballDiameter * forcedSign
							DistanceToPathPoint(bullet[bulletIndex].targetDistance, bullet[bulletIndex].targetPoint)
							bullet[bulletIndex].angle = ATan2(bullet[bulletIndex].targetPoint.y - bullet[bulletIndex].center.y, bullet[bulletIndex].targetPoint.x - bullet[bulletIndex].center.x)
						EndIf
					Next iteration
				Next ballIndex
			EndCase
			Case 1
				distanceToTarget = DistTwoPoints(bullet[bulletIndex].center, bullet[bulletIndex].targetPoint)
				If distanceToTarget <= (stepDistance + 1.0)
					AddBall(bullet[bulletIndex].targetDistance, bullet[bulletIndex].colorIndex)
					DeleteBullet(bulletIndex)
					ExitFunction True
				Else
					bullet[bulletIndex].center.x = bullet[bulletIndex].center.x + Cos(bullet[bulletIndex].angle) * stepDistance
					bullet[bulletIndex].center.y = bullet[bulletIndex].center.y + Sin(bullet[bulletIndex].angle) * stepDistance
					SetSpritePositionByOffset(bullet[bulletIndex].sprite, bullet[bulletIndex].center.x, bullet[bulletIndex].center.y)
					For ballIndex = 0 To ball.length
						forcedSign = 0.0
						For iteration = 1 To NumOfIterations
							distance2 = DistTwoPoints(ball[ballIndex].center, bullet[bulletIndex].center)
							If distance2 => (ballDiameter - 1.0) Then Exit
							displace = DisplaceBall(bullet[bulletIndex], ball[ballIndex], forcedSign)
							If forcedSign = 0.0 Then forcedSign = Sign(displace)
							MoveBall(ballIndex, displace)
						Next iteration
					Next ballIndex
				EndIf
			EndCase
		EndSelect
	Until distance = 0.0
	If bullet[bulletIndex].center.x < bulletMinX Or bullet[bulletIndex].center.x > bulletMaxX Or bullet[bulletIndex].center.y < bulletMinY Or bullet[bulletIndex].center.y > bulletMaxY
		DeleteBullet(bulletIndex)
		ExitFunction True
	EndIf
EndFunction False

// Обновить (переместить) все выстреленные шары

Function UpdateBullets()
	index As Integer
	For index = 0 To bullet.length
		If MoveBullet(index)
			Dec index
		EndIf
	Next index
EndFunction
