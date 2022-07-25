
// Игрок

Type PlayerType
	name As String
	cardIndex As Integer []
	x As Float
	y As Float
	flag As Integer
	text As Integer
EndType

Global Dim player [] As PlayerType

// Пары карт на столе

Type CardPairType
	attackCardIndex As Integer
	defenceCardIndex As Integer
EndType

Global Dim cardPair [] As CardPairType

// Количество карт в отбое
Global numOfDiscard As Integer

// Взять карту игроку
//
// playerIndex - идентификатор игрока
// Возвращает количество карт у игрока

Function DrawCard(playerIndex As Integer)
	playerCardIndexIndex As Integer
	If topTalonCardIndex => 0
		playerCardIndexIndex = player[playerIndex].cardIndex.length + 1
		player[playerIndex].cardIndex.length = playerCardIndexIndex
		player[playerIndex].cardIndex[playerCardIndexIndex] = topTalonCardIndex 
		card[topTalonCardIndex].owner = playerIndex
		If playerIndex = 0
			FlipCard(topTalonCardIndex, 1)
		Else
			FlipCard(topTalonCardIndex, -1)
		EndIf
		Dec topTalonCardIndex
		ExitFunction playerCardIndexIndex
	EndIf
EndFunction -1

// Упорядочить расположение спрайтов карт игрока
//
// playerIndex - идентификатор игрока
// playerCardIndexIndex - идентификатор карты игрока, -1 - если надо упорядочить все карты

Function ArrangePlayerCard(playerIndex As Integer, playerCardIndexIndex As Integer)
	cardIndex As Integer
	k As Float
	angle0 As Float
	angle1 As Float
	If playerCardIndexIndex = -1
		For playerCardIndexIndex = 0 To player[playerIndex].cardIndex.length
			ArrangePlayerCard(playerIndex, playerCardIndexIndex)
		Next playerCardIndexIndex
	Else
		cardIndex = player[playerIndex].cardIndex[playerCardIndexIndex]
		k = playerCardIndexIndex - player[playerIndex].cardIndex.length * 0.5
		If playerIndex = 0
			angle0 = k * 5.0
			angle1 = angle0 - 90.0
		Else
			angle0 = k * 2.5
			angle1 = angle0 + 90.0
		EndIf
		SetCardPosition(cardIndex, player[playerIndex].x + Cos(angle1) * 350.0, player[playerIndex].y + Sin(angle1) * 225.0)
		SetCardAngle(cardIndex, angle0)
		SetCardDepth(cardIndex, PLAYERDEPTH - playerCardIndexIndex)
	EndIf
EndFunction

// Выдать игроку указанное количество карт
//
// playerIndex - идентификатор игрока
// numOfCards - количество карт

Function DealCardsToPlayer(playerIndex As Integer, numOfCards As Integer)
	playerCardIndexIndex As Integer
	cardIndex As Integer
	k As Float
	playerCardIndexIndex = player[playerIndex].cardIndex.length
	While playerCardIndexIndex < numOfCards - 1
		playerCardIndexIndex = DrawCard(playerIndex)
		If playerCardIndexIndex = -1 Then Exit
	EndWhile 
	SortPlayerCards(playerIndex)
	ArrangePlayerCard(playerIndex, -1)
EndFunction

// Упорядочить массив идентификаторов карт игрока
//
// playerIndex - идентификатор игрока

Function SortPlayerCards(playerIndex As Integer)
	flag As Integer
	playerCardIndexIndex As Integer
	cardIndex0 As Integer
	cardIndex1 As Integer
	cardVar As Integer
	Dim buffer [] As Integer
	bufferIndex As Integer
	If playerIndex = 0
		buffer = player[0].cardIndex
		playerCardIndexIndex = 0
		For cardVar = 1 To CARD_LAST
			If GetCardSuit(cardVar) <> trumpSuit
				For bufferIndex = 0 To buffer.length
					If card[ buffer[bufferIndex] ].var = cardVar
						player[0].cardIndex[playerCardIndexIndex] = buffer[bufferIndex]
						Inc playerCardIndexIndex
						Exit
					EndIf
				Next bufferIndex
			EndIf
		Next cardVar
		For cardVar = 1 To CARD_LAST
			If GetCardSuit(cardVar) = trumpSuit
				For bufferIndex = 0 To buffer.length
					If card[ buffer[bufferIndex] ].var = cardVar
						player[0].cardIndex[playerCardIndexIndex] = buffer[bufferIndex]
						Inc playerCardIndexIndex
						Exit
					EndIf
				Next bufferIndex
			EndIf
		Next cardVar
	Else
		Repeat
			flag = FALSE
			For playerCardIndexIndex = 1 To player[playerIndex].cardIndex.length
				cardIndex0 = player[playerIndex].cardIndex[playerCardIndexIndex - 1]
				cardIndex1 = player[playerIndex].cardIndex[playerCardIndexIndex]
				If card[cardIndex0].rank > card[cardIndex1].rank
					player[playerIndex].cardIndex.Remove(playerCardIndexIndex)
					player[playerIndex].cardIndex.Insert(cardIndex1, playerCardIndexIndex - 1)
					flag = TRUE
					Exit
				EndIf
			Next playerCardIndexIndex
		Until Not flag
	EndIf
EndFunction

// Подготовить значения в массиве игроков
//
// numOfPlayers - количество игроков
// numOfCards - количество карт, которые будут розданы игрокам

Function InitPlayers(numOfPlayers As Integer, numOfCards As Integer)
	playerIndex As Integer
	playerCardIndexIndex As Integer
	player.length = numOfPlayers - 1
	player[0].x = 960.0
	player[0].y = 1200.0
	DealCardsToPlayer(0, numOfCards)
	For playerCardIndexIndex = 0 To player[0].cardIndex.length
		FlipCard(player[0].cardIndex[playerCardIndexIndex], 1)
	Next playerCardIndexIndex
	For playerIndex = 1 To player.length
		player[playerIndex].x = (1920.0 * playerIndex - 960.0) / player.length
		player[playerIndex].y = -150.0
		DealCardsToPlayer(playerIndex, numOfCards)
	Next playerIndex
	For playerIndex = 0 To player.length
		player[playerIndex].text = CreateText(Str(playerIndex))
		SetTextSize(player[playerIndex].text, 128.0)
		SetTextAlignment(player[playerIndex].text, 1)
		If playerIndex = 0
			SetTextPosition(player[playerIndex].text, 960.0, 900.0)
		Else
			SetTextPosition(player[playerIndex].text, player[playerIndex].x, 50.0)
		EndIf
		SetTextDepth(player[playerIndex].text, 5)
	Next playerIndex
EndFunction

// Определить идентификатор карты в массиве карт игрока по идентификатору карты
//
// cardIndex - идентификатор карты
// Возвращает идентификатор карты в массиве карт игрока

Function GetPlayerCardIndexIndex(cardIndex As Integer)
	playerIndex As Integer
	playerCardIndexIndex As Integer
	For playerIndex = 0 To player.length
		For playerCardIndexIndex = 0 To player[playerIndex].cardIndex.length
			If player[playerIndex].cardIndex[playerCardIndexIndex] = cardIndex
				ExitFunction playerCardIndexIndex
			EndIf
		Next playerCardIndexIndex
	Next playerIndex
EndFunction -1

// Определение заходящего игрока, имеющего на руках козырную карту наименьшего достоинства

Function GetFirstAttackerIndex()
	playerIndex As Integer
	playerCardIndexIndex As Integer
	cardIndex As integer
	rank As Integer
	attackerIndex As Integer
	rank = 1000
	For playerIndex = 0 To player.length
		For playerCardIndexIndex = 0 To player[playerIndex].cardIndex.length
			cardIndex = player[playerIndex].cardIndex[playerCardIndexIndex]
			If GetCardSuit(card[cardIndex].var) = trumpSuit
				If cardRank[ card[cardIndex].var ] < rank
					rank = cardRank[card[cardIndex].var]
					attackerIndex = playerIndex
				EndIf
			EndIf
		Next playerCardIndexIndex
	Next playerIndex
	// Если у игроков нет козырей, то заходящий выбирается случайно
	If rank = 1000 Then attackerIndex = Random(0, player.length)
EndFunction attackerIndex

// Определение отбивающегося игрока
//
// attackerIndex - идентификатор заходящего игрока
// Возвращает идентификатор отбивающегося игрока

Function GetDefenderIndex(attackerIndex As Integer)
	defenderIndex As Integer
	defenderIndex = attackerIndex
	Repeat
		Inc defenderIndex
		If defenderIndex > player.length Then defenderIndex = 0
		If player[defenderIndex].cardIndex.length => 0 Then ExitFunction defenderIndex
	Until defenderIndex = attackerIndex
EndFunction -1

// Определить следующего ходящего игрока
//
// mainAttackerIndex - идентификатор игрока, который заходил первым
// currentAttackerIndex - идентификатор игрока, после которого надо определить следующего атакующего
// defenderIndex - идентификатор отбивающегося игрока
// Возвращает идентификатор следуюшего игрока, либо -1, если прошёл круг

Function GetNextAttackerIndex(mainAttackerIndex As Integer, currentAttackerIndex As Integer, defenderIndex As Integer)
	nextAttackerIndex As Integer
	nextAttackerIndex = currentAttackerIndex
	Repeat
		Inc nextAttackerIndex
		If nextAttackerIndex > player.length  Then nextAttackerIndex = 0
		If nextAttackerIndex = mainAttackerIndex
			ExitFunction -1
		ElseIf player[nextAttackerIndex].cardIndex.length => 0
			If nextAttackerIndex <> defenderIndex
				ExitFunction nextAttackerIndex
			EndIf
		EndIf
	Until nextAttackerIndex = mainAttackerIndex
EndFunction -1

// Сделать ход
//
// platerIndex - идентификатор игрока
// playerCardIndexIndex - идентификатор карты в массиве карт игрока
// Возврашает TRUE, если удалось сделать ход, FALSE - если нет

Function Attack(playerIndex As Integer, playerCardIndexIndex As Integer)
	cardPairIndex As Integer
	cardIndex As Integer
	flag As Integer
	flag = FALSE
	cardIndex = player[playerIndex].cardIndex[playerCardIndexIndex]
	If cardPair.length = -1
		flag = TRUE
	Else
		For cardPairIndex = 0 To cardPair.length
			If cardRank[ card[ cardPair[cardPairIndex].attackCardIndex ].var ] = cardRank[ card[cardIndex].var ]
				flag = TRUE
				Exit
			EndIf
			If cardPair[cardPairIndex].defenceCardIndex <> -1
				If cardRank[ card[ cardPair[cardPairIndex].defenceCardIndex ].var ] = cardRank[ card[cardIndex].var ]
					flag = TRUE
					Exit
				EndIf
			EndIf
		Next cardPairIndex
	EndIf
	If flag
		player[playerIndex].cardIndex.Remove(playerCardIndexIndex)
		cardPairIndex = cardPair.length + 1
		cardPair.length = cardPairIndex
		cardPair[cardPairIndex].attackCardIndex = cardIndex
		cardPair[cardPairIndex].defenceCardIndex = -1
		FlipCard(cardIndex, 1)
		card[cardIndex].owner = CARD_OWNER_TABLE
		SetCardPosition(cardIndex, cardTableX[cardPairIndex], cardTableY[cardPairIndex])
		SetCardAngle(cardIndex, 0.0)
		SetCardDepth(cardIndex, ATTACKDEPTH)
	EndIf
EndFunction flag

// Отбиться
//
// playerIndex - идентификатор игрока
// playerCardIndexIndex - идентификатор карты в массиве карт игрока
// cardPairIndex - идентификатор пары карт, в которой находится отбиваемая карта
// Возвращает TRUE в случае успеха, и FALSE - если не удалось

Function Defence(playerIndex As Integer, playerCardIndexIndex As Integer, cardPairIndex As Integer)
	attackCardIndex As Integer
	defenceCardIndex As Integer
	defenceCardIndex = player[playerIndex].cardIndex[playerCardIndexIndex]
	If cardPairIndex > -1 And cardPairIndex <= cardPair.length
		If cardPair[cardPairIndex].defenceCardIndex = -1
			attackCardIndex = cardPair[cardPairIndex].attackCardIndex
			If IsCanBeat(attackCardIndex, defenceCardIndex)
				player[playerIndex].cardIndex.Remove(playerCardIndexIndex)
				cardPair[cardPairIndex].defenceCardIndex = defenceCardIndex
				FlipCard(defenceCardIndex, 1)
				card[defenceCardIndex].owner = CARD_OWNER_TABLE
				SetCardPosition(defenceCardIndex, cardTableX[cardPairIndex] + 10.0, cardTableY[cardPairIndex] + 30.0)
				SetCardAngle(defenceCardIndex, 15.0)
				SetCardDepth(defenceCardIndex, DEFENCEDEPTH)
				ExitFunction TRUE
			EndIf
		EndIf
	EndIf
EndFunction FALSE

// Забрать карты со стола
//
// playerIndex - идентификатор игрока

Function PickUp(playerIndex As Integer)
	While cardPair.length > -1
		If cardPair[0].defenceCardIndex <> -1
			card[cardPair[0].defenceCardIndex].owner = playerIndex
			If playerIndex = 0
				FlipCard(cardPair[0].defenceCardIndex, 1)
			Else
				FlipCard(cardPair[0].defenceCardIndex, -1)
			EndIf
			player[playerIndex].cardIndex.Insert(cardPair[0].defenceCardIndex)
		EndIf
		card[cardPair[0].attackCardIndex].owner = playerIndex
		If playerIndex = 0
			FlipCard(cardPair[0].attackCardIndex, 1)
		Else
			FlipCard(cardPair[0].attackCardIndex, -1)
		EndIf
		player[playerIndex].cardIndex.Insert(cardPair[0].attackCardIndex)
		cardPair.Remove(0)
	EndWhile
	ArrangePlayerCard(playerIndex, -1)
EndFunction

// Скинуть карты в отбой

Function Discard()
	While cardPair.length > -1
		If cardPair[0].defenceCardIndex <> -1
			card[cardPair[0].defenceCardIndex].owner = CARD_OWNER_DISCARD
			FlipCard(cardPair[0].defenceCardIndex, -1)
			SetCardPosition(cardPair[0].defenceCardIndex, DISCARDPILEX - numOfDiscard * 2.0, DISCARDPILEY)
			SetCardAngle(cardPair[0].defenceCardIndex, DISCARDPILEANGLE)
			SetCardDepth(cardPair[0].defenceCardIndex, DISCARDDEPTH - numOfDiscard)
			Inc numOfDiscard
		EndIf
		card[cardPair[0].attackCardIndex].owner = CARD_OWNER_DISCARD
		FlipCard(cardPair[0].attackCardIndex, -1)
		SetCardPosition(cardPair[0].attackCardIndex, DISCARDPILEX - numOfDiscard * 2.0, DISCARDPILEY)
		SetCardAngle(cardPair[0].attackCardIndex, DISCARDPILEANGLE)
		SetCardDepth(cardPair[0].attackCardIndex, DISCARDDEPTH - numOfDiscard)
		Inc numOfDiscard
		cardPair.Remove(0)
	EndWhile
EndFunction

// Определить, не остался ли кто-то из игроков в дураках

Function IsFool()
	playerIndex As Integer
	numOfPlayersWithCards As Integer
	For playerIndex = 0 To player.length
		If player[playerIndex].cardIndex.length > -1 Then Inc numOfPlayersWithCards
	Next playerIndex
	If numOfPlayersWithCards > 1 Then ExitFunction FALSE
EndFunction TRUE

// Определить, в какой паре находится карта
//
// cardIndex - идентификатор карты
// Возвращает идентификатор пары, либо -1

Function GetCardPair(cardIndex As Integer)
	cardPairIndex As Integer
	For cardPairIndex = 0 To cardPair.length
		If cardPair[cardPairIndex].attackCardIndex = cardIndex Or cardPair[cardPairIndex].defenceCardIndex = cardIndex
			ExitFunction cardPairIndex
		EndIf
	Next cardPairIndex
EndFunction -1

// Можно ли побить карту attackCardIndex картой defenceCardIndex
//
// attackCardIndex - идентификатор отбиваемой карты
// defenceCardIndex - идентикиатор отбивающей карты
// Возвращает TRUE - если можно, либо FALSE - если нельзя

Function IsCanBeat(attackCardIndex As Integer, defenceCardIndex As Integer)
	attackCardSuit As Integer
	defenceCardSuit As Integer
	attackCardSuit = GetCardSuit(card[attackCardIndex].var)
	defenceCardSuit = GetCardSuit(card[defenceCardIndex].var)
	If attackCardSuit = defenceCardSuit
		If cardRank[card[attackCardIndex].var] < cardRank[card[defenceCardIndex].var]
			ExitFunction TRUE
		EndIf
	Else
		If defenceCardSuit = trumpSuit
			ExitFunction TRUE
		EndIf
	EndIf
EndFunction FALSE

// Сколько карт на столе может быть побито картой defenceCardIndex
//
// defenceCardIndex - идентификатор отбивающей карты
// Возвращает количество

Function GetNumOfVariantsOfDefence(defenceCardIndex As Integer)
	count As Integer
	cardPairIndex As Integer
	For cardPairIndex = 0 To cardPair.length
		If cardPair[cardPairIndex].defenceCardIndex = -1
			If IsCanBeat(cardPair[cardPairIndex].attackCardIndex, defenceCardIndex) Then Inc count
		EndIf
	Next cardPairIndex
EndFunction count

// Количество непобитых карт на столе

Function GetNumOfUnbeaten()
	cardPairIndex As Integer
	result As Integer
	For cardPairIndex = 0 To cardPair.length
		If cardPair[cardPairIndex].defenceCardIndex = -1 Then Inc result
	Next cardPairIndex
EndFunction result

// Какую атакующую карту может побить выбранная карта
//
// defenceCardIndex - идентификатор отбивающей карты
// previousCardPairIndex - идентификатор пары, с которой нужно начать перебор
// Возвращает порядковый номер пары на столе, либо -1

Function GetCardPairCanBeBeaten(defenceCardIndex As Integer, previousCardPairIndex As Integer)
	cardPairIndex As Integer
	For cardPairIndex = previousCardPairIndex + 1 To cardPair.length
		If cardPair[cardPairIndex].defenceCardIndex = -1
			If IsCanBeat(cardPair[cardPairIndex].attackCardIndex, defenceCardIndex) Then ExitFunction cardPairIndex
		EndIf
	Next cardPairIndex
EndFunction -1

// Может ли игрок подкинуть какую-либо карту
//
// playerIndex - идентификатор игрока
// attackLimit - ограничение по количеству подкидываемых карт

Function IsPlayerCanAttack(playerIndex As Integer, attackLimit As Integer)
	playerCardIndexIndex As Integer
	cardPairIndex As Integer
	playerCardIndex As Integer
	If player[playerIndex].cardIndex.length > -1
		If cardPair.length = -1
			ExitFunction TRUE
		ElseIf cardPair.length < attackLimit - 1
			For playerCardIndexIndex = 0 To player[playerIndex].cardIndex.length
				For cardPairIndex = 0 To cardPair.length
					playerCardIndex = player[playerIndex].cardIndex[playerCardIndexIndex]
					If cardRank[ card[ playerCardIndex ].var ] = cardRank[ card[ cardPair[cardPairIndex].attackCardIndex ].var ]
						ExitFunction TRUE
					EndIf
					If cardPair[cardPairIndex].defenceCardIndex <> -1
						If cardRank[ card[ playerCardIndex ].var ] = cardRank[ card[ cardPair[cardPairIndex].defenceCardIndex ].var ]
							ExitFunction TRUE
						EndIf
					EndIf
				Next cardPairIndex
			Next
		EndIf
	EndIf
EndFunction FALSE

// Может ли игрок отбиться
//
// playerIndex - идентификатор игрока

Function IsPlayerCanDefence(playerIndex As Integer)
	Dim notBeatCardIndex [] As Integer
	Dim onHandCardIndex [] As Integer
	cardPairIndex As Integer
	cardIndex As Integer
	notBeatCardIndexIndex As Integer
	onHandCardIndexIndex As Integer
	playerCardIndexIndex As Integer
	flag As Integer
	// Создаём список неотбитых карт в порядке возрастания достоинства
	For cardPairIndex = 0 To cardPair.length
		If cardPair[cardPairIndex].defenceCardIndex = -1
			cardIndex = cardPair[cardPairIndex].attackCardIndex
			If notBeatCardIndex.length = -1
				notBeatCardIndex.Insert(cardIndex)
			Else
				flag = FALSE
				For notBeatCardIndexIndex = 0 To notBeatCardIndex.length
					If card[ notBeatCardIndex[notBeatCardIndexIndex] ].rank > card[ cardIndex ].rank
						notBeatCardIndex.Insert(cardIndex, notBeatCardIndexIndex)
						flag = TRUE
						Exit
					EndIf
				Next notBeatCardIndexIndex
				If Not flag
					notBeatCardIndex.Insert(cardIndex)
				EndIf
			EndIf
		EndIf
	Next cardPairIndex
	// Создаём копию карт отбивающегося
	For playerCardIndexIndex = 0 To player[playerIndex].cardIndex.length
		cardIndex = player[playerIndex].cardIndex[playerCardIndexIndex]
		If onHandCardIndex.length = -1
			onHandCardIndex.Insert(cardIndex)
		Else
			flag = FALSE
			For onHandCardIndexIndex = 0 To onHandCardIndex.length
				If card[ onHandCardIndex[onHandCardIndexIndex] ].rank > card[ cardIndex ].rank
					onHandCardIndex.Insert(cardIndex, onHandCardIndexIndex)
					flag = TRUE
					Exit
				EndIf
			Next onHandCardIndexIndex
			If Not flag
				onHandCardIndex.Insert(cardIndex)
			EndIf
		EndIf
	Next playerCardIndexIndex
	// Пробуем побить все карты по порядку, от самой мелкой до самой крупной
	For notBeatCardIndexIndex = 0 To notBeatCardIndex.length
		flag = FALSE
		For onHandCardIndexIndex = 0 To onHandCardIndex.length
			If IsCanBeat(notBeatCardIndex[notBeatCardIndexIndex], onHandCardIndex[onHandCardIndexIndex])
				onHandCardIndex.Remove(onHandCardIndexIndex)
				flag = TRUE
				Exit
			EndIf
		Next onHandCardIndexIndex
		If Not flag
			ExitFunction FALSE
		EndIf
	Next notBeatCardIndexIndex
EndFunction TRUE

// Выдать карты игрокам
//
// mainAttackerIndex - идентификатор заходящего игрока (берёт первым)
// defenderIndex - идентификатор отбивающегося игрока (берёт последним)

Function DealCards(mainAttackerIndex As Integer, defenderIndex As Integer)
	playerIndex As Integer
	playerIndex = mainAttackerIndex
	Repeat
		If playerIndex <> defenderIndex Then DealCardsToPlayer(playerIndex, 6)
		Inc playerIndex
		If playerIndex > player.length Then playerIndex = 0
	Until playerIndex = mainAttackerIndex
	DealCardsToPlayer(defenderIndex, 6)
EndFunction

// Обновить метки игроков
//
// attackerIndex - идентификатор подкидываюшего игрока
// defenderIndex - идентификатор отбиваюшегося игрока

Function UpdatePlayerLabels(attackerIndex As Integer, defenderIndex As Integer)
	playerIndex As Integer
	For playerIndex = 0 To player.length
		If playerIndex = attackerIndex
			SetTextFont(player[playerIndex].text, emojiFont)
			SetTextString(player[playerIndex].text, Chr(0x2694))
			SetTextColor(player[playerIndex].text, 255, 0, 0, 255)
		ElseIf playerIndex = defenderIndex
			SetTextFont(player[playerIndex].text, emojiFont)
			SetTextString(player[playerIndex].text, Chr(0x1F6E1))
			SetTextColor(player[playerIndex].text, 0, 0, 255, 255)
		Else
			SetTextString(player[playerIndex].text, "")
		EndIf
	Next playerIndex
EndFunction
