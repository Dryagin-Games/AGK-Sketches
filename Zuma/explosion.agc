
// Эффект взрыва

Global Dim explosion [] As Integer

// Добавить эффект взрыва
//
// x, y - координаты центра взрыва на экране

Function AddExplosion(x As Float, y As Float)
	If explosion.length = -1
		explosion.Insert(CreateSprite(explosionImage))
	Else
		explosion.Insert(CreateSprite(explosionImage), 0)
	EndIf
	SetSpriteAnimation(explosion[0], 256, 256, 5)
	SetSpriteOffset(explosion[0], 128.0, 128.0)
	PlaySprite(explosion[0], 12.0, False, 1, 5)
	SetSpritePositionByOffset(explosion[0], x, y)
EndFunction

// Проверить состояния взрывов, и удаление, при необходимости

Function UpdateExplosions()
	index As Integer
	index = explosion.length
	While index => 0
		If Not GetSpritePlaying(explosion[index])
			DeleteSprite(explosion[index])
			explosion.Remove(index)
		Else
			Exit
		EndIf
		Dec index
	EndWhile
EndFunction
