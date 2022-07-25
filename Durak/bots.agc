
// Сделать попытку подкинуть карту
//
// playerIndex - идентификатор игрока-бота
// Возврашает: TRUE - если была подкинута карта, FALSE - если подкидывать нечего

Function BotTryAttack(playerIndex As Integer)
	playerCardIndexIndex As Integer
	For playerCardIndexIndex = 0 To player[playerIndex].cardIndex.length
		If cardPair.length => 0 And GetCardSuit(card[player[playerIndex].cardIndex[playerCardIndexIndex]].var) = trumpSuit Then Continue
		If Attack(playerIndex, playerCardIndexIndex) Then ExitFunction TRUE
	Next playerCardIndexIndex
EndFunction FALSE

// Сделать попытку отбиться
//
// playerIndex - идентификатор игрока-бота
// Возвращает: TRUE - если удалось отбиться, FALSE - если нечем отбиваться

Function BotTryDefence(playerIndex As Integer)
	playerCardIndexIndex As Integer
	cardPairIndex As Integer
	For playerCardIndexIndex = 0 To player[playerIndex].cardIndex.length
		cardPairIndex = GetCardPairCanBeBeaten(player[playerIndex].cardIndex[playerCardIndexIndex], -1)
		If cardPairIndex <> -1
			Defence(playerIndex, playerCardIndexIndex, cardPairIndex)
			ExitFunction TRUE
		EndIf
	Next playerCardIndexIndex
EndFunction FALSE
