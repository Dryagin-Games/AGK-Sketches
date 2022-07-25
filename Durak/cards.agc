
// Коды мастей
#Constant CARD_SUIT_HEART     0
#Constant CARD_SUIT_DIAMOND   1
#Constant CARD_SUIT_CLUB      2
#Constant CARD_SUIT_SPADE     3

// Коды карт
#Constant CARD_BACK           0
#Constant CARD_HEART_2        1
#Constant CARD_HEART_3        2
#Constant CARD_HEART_4        3
#Constant CARD_HEART_5        4
#Constant CARD_HEART_6        5
#Constant CARD_HEART_7        6
#Constant CARD_HEART_8        7
#Constant CARD_HEART_9        8
#Constant CARD_HEART_10       9
#Constant CARD_HEART_JACK    10
#Constant CARD_HEART_QUEEN   11
#Constant CARD_HEART_KING    12
#Constant CARD_HEART_ACE     13
#Constant CARD_DIAMOND_2     14
#Constant CARD_DIAMOND_3     15
#Constant CARD_DIAMOND_4     16
#Constant CARD_DIAMOND_5     17
#Constant CARD_DIAMOND_6     18
#Constant CARD_DIAMOND_7     19
#Constant CARD_DIAMOND_8     20
#Constant CARD_DIAMOND_9     21
#Constant CARD_DIAMOND_10    22
#Constant CARD_DIAMOND_JACK  23
#Constant CARD_DIAMOND_QUEEN 24
#Constant CARD_DIAMOND_KING  25
#Constant CARD_DIAMOND_ACE   26
#Constant CARD_CLUB_2        27
#Constant CARD_CLUB_3        28
#Constant CARD_CLUB_4        29
#Constant CARD_CLUB_5        30
#Constant CARD_CLUB_6        31
#Constant CARD_CLUB_7        32
#Constant CARD_CLUB_8        33
#Constant CARD_CLUB_9        34
#Constant CARD_CLUB_10       35
#Constant CARD_CLUB_JACK     36
#Constant CARD_CLUB_QUEEN    37
#Constant CARD_CLUB_KING     38
#Constant CARD_CLUB_ACE      39
#Constant CARD_SPADE_2       40
#Constant CARD_SPADE_3       41
#Constant CARD_SPADE_4       42
#Constant CARD_SPADE_5       43
#Constant CARD_SPADE_6       44
#Constant CARD_SPADE_7       45
#Constant CARD_SPADE_8       46
#Constant CARD_SPADE_9       47
#Constant CARD_SPADE_10      48
#Constant CARD_SPADE_JACK    49
#Constant CARD_SPADE_QUEEN   50
#Constant CARD_SPADE_KING    51
#Constant CARD_SPADE_ACE     52
#Constant CARD_JOKER_RED     53
#Constant CARD_JOKER_BLACK   54

#Constant CARD_LAST          54

// Диапазоны карт определенных мастей
#Constant CARD_HEART_FIRST    1
#Constant CARD_HEART_LAST    13
#Constant CARD_DIAMOND_FIRST 14
#Constant CARD_DIAMOND_LAST  26
#Constant CARD_CLUB_FIRST    27
#Constant CARD_CLUB_LAST     39
#Constant CARD_SPADE_FIRST   40
#Constant CARD_SPADE_LAST    52

// Размеры карт
#Constant CARD_WIDTH   = 225.0
#Constant CARD_HEIGHT  = 350.0
#Constant CARD_CENTERX = 112.5
#Constant CARD_CENTERY = 175.0

// Расположение и поворот колоды
#Constant TALONPILEX = 220.0
#Constant TALONPILEY = 860.0
#Constant TALONPILEANGLE = -30.0

// Расположение и поворот отбоя
#Constant DISCARDPILEX = 1700.0
#Constant DISCARDPILEY = 860.0
#Constant DISCARDPILEANGLE = 30.0

// Расположение карт на столе
Global Dim cardTableX [] As Float = [842.5,1077.5,607.5,1312.5,372.5,1547.5]
Global Dim cardTableY [] As Float = [450.0,450.0,450.0,450.0,450.0,450.0]

// Изображения карт
Global cardsImage As Integer
Global Dim cardImage [CARD_LAST] As Integer
cardsImage = LoadImage("cards.png")
For index = 0 To CARD_LAST
	cardImage[index] = LoadSubImage(cardsImage, Str(index))
Next index

// Названия карт
Global Dim cardFullName [] As String = ["Рубашка","Червонная двойка","Червонная тройка","Червонная четвёрка","Червонная пятёрка","Червонная шестёрка","Червонная семёрка","Червонная восьмёрка","Червонная девятка","Червонная десятка","Червонный валет","Червонная дама","Червонный король","Червонный туз","Бубновая двойка","Бубновая тройка","Бубновая четвёрка","Бубновая пятёрка","Бубновая шестёрка","Бубновая семёрка","Бубновая восьмёрка","Бубновая девятка","Бубновая десятка","Бубновый валет","Бубновая дама","Бубновый король","Бубновый туз","Трефовая двойка","Трефовая тройка","Трефовая четвёрка","Трефовая пятёрка","Трефовая шестёрка","Трефовая семёрка","Трефовая восьмёрка","Трефовая девятка","Трефовая десятка","Трефовый валет","Трефовая дама","Трефовый король","Трефовый туз","Пиковая двойка","Пиковая тройка","Пиковая четвёрка","Пиковая пятёрка","Пиковая шестёрка","Пиковая семёрка","Пиковая восьмёрка","Пиковая девятка","Пиковая десятка","Пиковый валет","Пиковая дама","Пиковый король","Пиковый туз","Красный джокер","Чёрный джокер"]
Global Dim cardShortName [] As String = ["?","2♥","3♥","4♥","5♥","6♥","7♥","8♥","9♥","10♥","В♥","Д♥","К♥","Т♥","2♦","3♦","4♦","5♦","6♦","7♦","8♦","9♦","10♦","В♦","Д♦","К♦","Т♦","2♣","3♣","4♣","5♣","6♣","7♣","8♣","9♣","10♣","В♣","Д♣","К♣","Т♣","2♠","3♠","4♠","5♠","6♠","7♠","8♠","9♠","10♠","В♠","Д♠","К♠","Т♠","R★","B★"]
Global Dim cardSuitName [] As String = ["Червы", "Бубны", "Трефы", "Пики"]

// Значения достоинства карт
Global Dim cardRank [] As Integer = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,1,2,3,4,5,6,7,8,9,10,11,12,13,1,2,3,4,5,6,7,8,9,10,11,12,13,1,2,3,4,5,6,7,8,9,10,11,12,13,0,0]

// Определить масть карты по её коду

Function GetCardSuit(var As Integer)
	If var => CARD_HEART_FIRST And var <= CARD_HEART_LAST
		ExitFunction CARD_SUIT_HEART
	ElseIf var => CARD_DIAMOND_FIRST And var <= CARD_DIAMOND_LAST
		ExitFunction CARD_SUIT_DIAMOND
	ElseIf var => CARD_CLUB_FIRST And var <= CARD_CLUB_LAST
		ExitFunction CARD_SUIT_CLUB
	ElseIf var => CARD_SPADE_FIRST And var <= CARD_SPADE_LAST
		ExitFunction CARD_SUIT_SPADE
	EndIf
EndFunction -1

// Коды принадлежности карт
#Constant CARD_OWNER_TALON   = -1 // Прикуп
#Constant CARD_OWNER_TABLE   = -2 // Стол
#Constant CARD_OWNER_DISCARD = -3 // Отбой
#Constant CARD_OWNER_PLAYER_0 = 0 // Игроки
#Constant CARD_OWNER_PLAYER_1 = 1
#Constant CARD_OWNER_PLAYER_2 = 2
#Constant CARD_OWNER_PLAYER_3 = 3
#Constant CARD_OWNER_PLAYER_4 = 4

Type CardType
	var As Integer
	rank As Integer
	sprite As Integer
	owner As Integer
EndType

Global Dim card [] As CardType
Global trumpSuit As Integer         // Код козырной масти
Global topTalonCardIndex As Integer // Порядковый номер верхней карты в колоде

// Установить расположение карты

Function SetCardPosition(cardIndex As Integer, x As Float, y As Float)
	SetSpritePositionByOffset(card[cardIndex].sprite, x, y)
EndFunction

// Повернуть карту на угол

Function SetCardAngle(cardIndex As Integer, angle As Float)
	SetSpriteAngle(card[cardIndex].sprite, angle)
EndFunction

// Установить глубину карты

Function SetCardDepth(cardIndex As Integer, depth As Integer)
	SetSpriteDepth(card[cardIndex].sprite, depth)
EndFunction

// Перевернуть карту
//
// state - состояние карты: -1 - рубашкой вверх, 1 - лицевой сторонй вверх, 0 - если надо поменять текущее состояние на противоположное

Function FlipCard(cardIndex As Integer, state As Integer)
	If state = -1
		SetSpriteImage(card[cardIndex].sprite, cardImage[CARD_BACK])
	ElseIf state = 1
		SetSpriteImage(card[cardIndex].sprite, cardImage[ card[cardIndex].var ])
	Else
		If GetSpriteImageID(card[cardIndex].sprite) = cardImage[CARD_BACK]
			SetSpriteImage(card[cardIndex].sprite, cardImage[ card[cardIndex].var ])
		Else
			SetSpriteImage(card[cardIndex].sprite, cardImage[CARD_BACK])
		EndIf
	EndIf
EndFunction

// Подготовить колоду к игре
//
// numOfCards - количество карт в колоде, может быть только 36 или 52

Function InitDeck(numOfCards As Integer)
	playableCardIndex As Integer
	Dim playableCard [] As Integer
	Select numOfCards
		Case 36
			playableCard = [5,6,7,8,9,10,11,12,13,18,19,20,21,22,23,24,25,26,31,32,33,34,35,36,37,38,39,44,45,46,47,48,49,50,51,52]
		EndCase
		Case 52
			playableCard = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,39,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52]
		EndCase
	EndSelect
	card.length = numOfCards - 1
	topTalonCardIndex = -1
	// Последняя карта в колоде, определяющая козырную масть, не должна быть тузом
	Repeat
		playableCardIndex = Random(0, playableCard.length)
	Until playableCard[playableCardIndex] <> CARD_HEART_ACE And playableCard[playableCardIndex] <> CARD_DIAMOND_ACE And playableCard[playableCardIndex] <> CARD_CLUB_ACE And playableCard[playableCardIndex] <> CARD_SPADE_ACE
	trumpSuit = GetCardSuit(playableCard[playableCardIndex])
	// Даём значения карт в массиве card [] случайным образом, удаляя значения из массива playableCard []
	Repeat
		Inc topTalonCardIndex
		card[topTalonCardIndex].var = playableCard[playableCardIndex]
		card[topTalonCardIndex].rank = cardRank[ card[topTalonCardIndex].var ]
		If GetCardSuit(card[topTalonCardIndex].var) = trumpSuit Then card[topTalonCardIndex].rank = card[topTalonCardIndex].rank + 100
		card[topTalonCardIndex].sprite = CreateSprite(cardImage[CARD_BACK])
		SetSpriteOffset(card[topTalonCardIndex].sprite, GetImageWidth(cardImage[CARD_BACK]) / 2, GetImageHeight(cardImage[CARD_BACK]) / 2)
		SetCardPosition(topTalonCardIndex, TALONPILEX - topTalonCardIndex * 2.0, TALONPILEY)
		SetCardAngle(topTalonCardIndex, TALONPILEANGLE)
		SetCardDepth(topTalonCardIndex, DECKDEPTH - topTalonCardIndex)
		card[topTalonCardIndex].owner = CARD_OWNER_TALON
		playableCard.Remove(playableCardIndex)
		playableCardIndex = Random(0, playableCard.length)
	Until topTalonCardIndex = numOfCards - 1 Or playableCard.length = -1
	// Переворачиваем козырь и кладём его под углом
	FlipCard(0, 1)
	SetCardAngle(0, TALONPILEANGLE + 90.0)
	SetCardPosition(0, TALONPILEX + Cos(TALONPILEANGLE) * (CARD_CENTERY - CARD_CENTERX), TALONPILEY + Sin(TALONPILEANGLE) * (CARD_CENTERY - CARD_CENTERX))
EndFunction
