
// Project: Durak 
// Created: 2022-06-21

#Option_Explicit

#Constant FALSE 0
#Constant TRUE  1

SetErrorMode(2)
SetWindowTitle("Durak")
SetWindowSize(1280, 720, FALSE)
SetWindowAllowResize(TRUE)
SetVirtualResolution(1920, 1080)
SetOrientationAllowed(FALSE, FALSE, TRUE, TRUE)
SetSyncRate(30, 0)
SetScissor(0, 0, 0, 0)
UseNewDefaultFonts(TRUE)
SetPrintSize(48.0)
SetClearColor(64, 128, 192)

Function Wait(time As Float)
	time = Timer() + time
	While Timer() <= time
		Sync()
	EndWhile
EndFunction

#Insert "cards.agc"
#Insert "players.agc"
#Insert "bots.agc"
#Insert "ui.agc"

#Constant FIRSTDISCARDATTACKLIMIT = 5
#Constant REGULARATTACKLIMIT = 6

#Constant GAMEFLAG_ATTACK   = 0
#Constant GAMEFLAG_DEFENCE  = 1
#Constant GAMEFLAG_SELECT   = 2
#Constant GAMEFLAG_PICKUP   = 3
#Constant GAMEFLAG_DISCARD  = 4
#Constant GAMEFLAG_OVER     = 255

index As Integer
gameFlag As Integer
mainAttackerIndex As Integer
attackerIndex As Integer
defenderIndex As Integer
attackLimit As Integer
sprite As Integer
cardIndex As Integer
canDefenceFlag As Integer
cardPairIndex As Integer

InitDeck(36)

InitPlayers(NumOfPlayersRequester(), 6)
attackLimit = FIRSTDISCARDATTACKLIMIT
mainAttackerIndex = GetFirstAttackerIndex()
attackerIndex = mainAttackerIndex
defenderIndex = GetDefenderIndex(attackerIndex)
gameFlag = GAMEFLAG_ATTACK

Do
	
	UpdatePlayerLabels(attackerIndex, defenderIndex)
	
	Select gameFlag
		
		Case GAMEFLAG_ATTACK
			
			If cardPair.length < attackLimit - 1 And GetNumOfUnbeaten() <= player[defenderIndex].cardIndex.length And attackerIndex <> -1
				If attackerIndex = 0
					If IsPlayerCanAttack(attackerIndex, attackLimit)
						If cardPair.length > -1 Then ShowPassButton()
						sprite = GetSpriteHit(GetPointerX(), GetPointerY())
						If GetPointerPressed()
							If sprite = buttonSprite
								HideButton()
								attackerIndex = GetNextAttackerIndex(mainAttackerIndex, attackerIndex, defenderIndex)
							Else
								cardIndex = GetCardIndexBySprite(sprite)
								If cardIndex > -1
									If card[cardIndex].owner = CARD_OWNER_PLAYER_0
										If Attack(attackerIndex, GetPlayerCardIndexIndex(cardIndex))
											HideButton()
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					Else
						attackerIndex = GetNextAttackerIndex(mainAttackerIndex, attackerIndex, defenderIndex)
					EndIf
				Else
					If BotTryAttack(attackerIndex)
						Wait(1.0)
					Else
						Wait(1.0)
						attackerIndex = GetNextAttackerIndex(mainAttackerIndex, attackerIndex, defenderIndex)
					EndIf
				EndIf
			Else
				gameFlag = GAMEFLAG_DEFENCE
				canDefenceFlag = IsPlayerCanDefence(defenderIndex)
			EndIf
			
		EndCase
		
		Case GAMEFLAG_DEFENCE
			
			If IsFool()
				GameOver()
				gameFlag = GAMEFLAG_OVER
			Else
				If GetNumOfUnbeaten() = 0
					Wait(2.0)
					gameFlag = GAMEFLAG_DISCARD
				Else
					If defenderIndex = 0
						ShowPickButton()
						sprite = GetSpriteHit(GetPointerX(), GetPointerY())
						If GetPointerPressed()
							If sprite = buttonSprite
								HideButton()
								gameFlag = GAMEFLAG_PICKUP
							Else
								If canDefenceFlag
									cardIndex = GetCardIndexBySprite(sprite)
									If cardIndex > -1
										If card[cardIndex].owner = CARD_OWNER_PLAYER_0
											Select GetNumOfVariantsOfDefence(cardIndex)
												Case 0
												EndCase
												Case 1
													If Defence(0, GetPlayerCardIndexIndex(cardIndex), GetCardPairCanBeBeaten(cardIndex, -1))
														HideButton()
														attackerIndex = mainAttackerIndex
														gameFlag = GAMEFLAG_ATTACK
													EndIf
												EndCase
												Case Default
													cardPairIndex = GetCardPairCanBeBeaten(cardIndex, -1)
													While cardPairIndex <> -1
														SetSpriteColor(card[cardPair[cardPairIndex].attackCardIndex].sprite, 133, 218, 248, 255)
														cardPairIndex = GetCardPairCanBeBeaten(cardIndex, cardPairIndex)
													EndWhile
													gameFlag = GAMEFLAG_SELECT
												EndCase
											EndSelect
											
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					Else
						If canDefenceFlag
							If BotTryDefence(defenderIndex)
								Wait(1.0)
								gameFlag = GAMEFLAG_ATTACK
								attackerIndex = mainAttackerIndex
							EndIf
						Else
							Wait(2.0)
							gameFlag = GAMEFLAG_PICKUP
						EndIf
						
					EndIf
				EndIf
			EndIf
			
		EndCase
		
		Case GAMEFLAG_SELECT
			
			sprite = GetSpriteHit(GetPointerX(), GetPointerY())
			If GetPointerPressed()
				If sprite = buttonSprite
					For cardPairIndex = 0 To cardPair.length
						SetSpriteColor(card[cardPair[cardPairIndex].attackCardIndex].sprite, 255, 255, 255, 255)
					Next cardPairIndex
					gameFlag = GAMEFLAG_PICKUP
				Else
					cardPairIndex = GetCardPair(GetCardIndexBySprite(sprite))
					If cardPairIndex > -1
						For index = 0 To cardPair.length
							SetSpriteColor(card[cardPair[index].attackCardIndex].sprite, 255, 255, 255, 255)
						Next index
						If Defence(0, GetPlayerCardIndexIndex(cardIndex), cardPairIndex)
							HideButton()
							attackerIndex = mainAttackerIndex
							gameFlag = GAMEFLAG_ATTACK
						Else
							gameFlag = GAMEFLAG_DEFENCE
						EndIf
					EndIf
				EndIf
			EndIf
			
		EndCase
		
		Case GAMEFLAG_PICKUP
			
			PickUp(defenderIndex)
			DealCards(mainAttackerIndex, defenderIndex)
			mainAttackerIndex = GetNextAttackerIndex(defenderIndex, defenderIndex, defenderIndex)
			attackerIndex = mainAttackerIndex
			defenderIndex = GetDefenderIndex(attackerIndex)
			gameFlag = GAMEFLAG_ATTACK
			
		EndCase
		
		Case GAMEFLAG_DISCARD
			
			attackLimit = REGULARATTACKLIMIT
			Discard()
			DealCards(mainAttackerIndex, defenderIndex)
			mainAttackerIndex = defenderIndex
			While player[mainAttackerIndex].cardIndex.length = -1
				Inc mainAttackerIndex
				If mainAttackerIndex > player.length Then mainAttackerIndex = 0
			EndWhile
			attackerIndex = mainAttackerIndex
			defenderIndex = GetDefenderIndex(attackerIndex)
			gameFlag = GAMEFLAG_ATTACK
			
		EndCase
		
		Case GAMEFLAG_OVER
			
		EndCase
		
	EndSelect
	
	Sync()
	
Loop
