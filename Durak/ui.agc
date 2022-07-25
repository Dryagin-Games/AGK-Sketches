
#Constant BACKGROUNDDEPTH = 1000
#Constant DECKDEPTH       =  500
#Constant DISCARDDEPTH    =  500
#Constant PLAYERDEPTH     =  400
#Constant ATTACKDEPTH     =  300
#Constant DEFENCEDEPTH    =  200
#Constant TOPDEPTH        =  100

backgroundSprite As Integer
backgroundSprite = LoadSprite("background.jpg")
FixSpriteToScreen(backgroundSprite, TRUE)
SetSpriteDepth(backgroundSprite, BACKGROUNDDEPTH)

pointerCardIndex As Integer
hoverCardIndex As Integer

pointerCardIndex = -1
hoverCardIndex = -1

Function GetPointerCardIndex()
	sprite As Integer
	cardIndex As Integer
	sprite = GetSpriteHit(GetPointerX(), GetPointerY())
	For cardIndex = 0 To card.length
		If card[cardIndex].sprite = sprite Then ExitFunction cardIndex
	Next cardIndex
EndFunction -1

Function GetCardIndexBySprite(sprite As Integer)
	cardIndex As Integer
	For cardIndex = 0 To card.length
		If card[cardIndex].sprite = sprite Then ExitFunction cardIndex
	Next cardIndex
EndFunction -1

Function NumOfPlayersRequester()
	Dim text [4] As Integer
	index As Integer
	numOfPlayers As Integer
	For index = 0 To 4
		text[index] = CreateText("Выберите количество игроков," + Chr(10) + "нажав на клавиатуре от 2 до 5")
		SetTextAlignment(text[index], 1)
		SetTextSize(text[index], 128.0)
		SetTextPosition(text[index], 960.0, 300.0)
		SetTextColor(text[index], 0, 0, 0, 255)
	Next index
	SetTextColor(text[0], 255, 255, 255, 255)
	SetTextDepth(text[0], 1)
	SetTextPosition(text[1], 960.0, 300.0 - 2.0)
	SetTextPosition(text[2], 960.0, 300.0 + 2.0)
	SetTextPosition(text[3], 960.0 - 2.0, 300.0)
	SetTextPosition(text[4], 960.0 + 2.0, 300.0)
	Repeat
		If GetRawKeyPressed(50)
			numOfPlayers = 2
		ElseIf GetRawKeyPressed(51)
			numOfPlayers = 3
		ElseIf GetRawKeyPressed(52)
			numOfPlayers = 4
		ElseIf GetRawKeyPressed(53)
			numOfPlayers = 5
		EndIf
		Sync()
	Until numOfPlayers > 0
	For index = 0 To 4
		DeleteText(text[index])
	Next index
EndFunction numOfPlayers

Global buttonsImage As Integer
Global passButtonImage As Integer
Global pickButtonImage As Integer
Global buttonSprite As Integer

buttonsImage = LoadImage("buttons.png")
passButtonImage = LoadSubImage(buttonsImage, "pass")
pickButtonImage = LoadSubImage(buttonsImage, "pick")

Function ShowPassButton()
	If buttonSprite = 0
		buttonSprite = CreateSprite(passButtonImage)
		SetSpriteOffset(buttonSprite, 112.5, 45.0)
		SetSpriteDepth(buttonSprite, 10)
	Else
		SetSpriteImage(buttonSprite, passButtonImage)
	EndIf
	SetSpritePositionByOffset(buttonSprite, 960.0, 730.0)
EndFunction

Function ShowPickButton()
	If buttonSprite = 0
		buttonSprite = CreateSprite(pickButtonImage)
		SetSpriteOffset(buttonSprite, 112.5, 45.0)
		SetSpriteDepth(buttonSprite, 10)
	Else
		SetSpriteImage(buttonSprite, pickButtonImage)
	EndIf
	SetSpritePositionByOffset(buttonSprite, 960.0, 730.0)
EndFunction

Function HideButton()
	If buttonSprite
		SetSpritePositionByOffset(buttonSprite, -65535.0, -65535.0)
	EndIf
EndFunction

Function GameOver()
	Dim text [4] As Integer
	index As Integer
	For index = 0 To 4
		text[index] = CreateText("ИГРА ОКОНЧЕНА")
		SetTextSize(text[index], 128.0)
		SetTextAlignment(text[index], 1)
		SetTextColor(text[index], 0, 0, 0, 255)
		SetTextBold(text[index], TRUE)
		SetTextSpacing(text[index], 10.0)
	Next index
	SetTextPosition(text[0], 960.0, 476.0)
	SetTextPosition(text[1], 960.0, 476.0 - 2.0)
	SetTextPosition(text[2], 960.0, 476.0 + 2.0)
	SetTextPosition(text[3], 960.0 - 2.0, 476.0)
	SetTextPosition(text[4], 960.0 + 2.0, 476.0)
	SetTextColor(text[0], 255, 255, 255, 255)
	SetTextDepth(text[0], 1)
EndFunction

Global emojiFont As Integer
emojiFont = LoadFont("Segoe UI Emoji")
trumText As Integer
Select trumpSuit
	Case CARD_SUIT_HEART
		trumText = CreateText(Chr(0x2665))
		SetTextColor(trumText, 255, 0, 0, 255)
	EndCase
	Case CARD_SUIT_DIAMOND
		trumText = CreateText(Chr(0x2666))
		SetTextColor(trumText, 255, 0, 0, 255)
	EndCase
	Case CARD_SUIT_CLUB
		trumText = CreateText(Chr(0x2663))
		SetTextColor(trumText, 0, 0, 0, 255)
	EndCase
	Case CARD_SUIT_SPADE
		trumText = CreateText(Chr(0x2660))
		SetTextColor(trumText, 0, 0, 0, 255)
	EndCase
EndSelect
SetTextFont(trumText, emojiFont)
SetTextSize(trumText, 128.0)
SetTextAlignment(trumText, 0)
SetTextPosition(trumText, 10.0, 1080.0 - 128.0 - 10.0)
SetTextDepth(trumText, 10)
