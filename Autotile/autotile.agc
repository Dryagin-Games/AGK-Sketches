// Функция автоматического подбора плитки в зависимости от соседних
//
// tileset - код набора плиток (см. в папке media tileset[код].png)
// mask - маска соседних плиток
// sub - использование альтернативной плитки для 2 набора
// 
// Возвращаем порядковый номер подходящего спрайта в наборе плиток
//
//   Маска - это двоичное кодирование 8 соседних плиток, которые    -----------
// на ходятся вокруг подбираемой плитки.                           | 1 | 2 | 4 |
//   Удобнее всего представлять её как сумма произведений          |---+---+---|
// отсутствия (0) или наличия (1) на коэффициенты, закреплённые    | 8 |   | 16|
// за соседними плитками.                                          |---+---+---|
//   Для наглядности коэффициенты представлены на схеме справа.    | 32| 64|128|
//                                                                  -----------

Function Autotile(tileset As Integer, mask As Integer, sub As Integer)
	Select tileset
		Case 0
			If mask = -1
				ExitFunction 0
			Else
				ExitFunction 1
			EndIf
		EndCase
		Case 1
			Select mask
				Case 0, 1, 4, 5, 32, 33, 36, 37, 128, 129, 132, 133, 160, 161, 164, 165
					ExitFunction 1
				EndCase
				Case 2, 3, 6, 7, 34, 35, 38, 39, 130, 131, 134, 135, 162, 163, 166, 167
					ExitFunction 2
				EndCase
				Case 8, 9, 12, 13, 40, 41, 44, 45, 136, 137, 140, 141, 168, 169, 172, 173
					ExitFunction 3
				EndCase
				Case 10, 11, 14, 15, 42, 43, 46, 47, 138, 139, 142, 143, 170, 171, 174, 175
					ExitFunction 4
				EndCase
				Case 16, 17, 20, 21, 48, 49, 52, 53, 144, 145, 148, 149, 176, 177, 180, 181
					ExitFunction 5
				EndCase
				Case 18, 19, 22, 23, 50, 51, 54, 55, 146, 147, 150, 151, 178, 179, 182, 183
					ExitFunction 6
				EndCase
				Case 24, 25, 28, 29, 56, 57, 60, 61, 152, 153, 156, 157, 184, 185, 188, 189
					ExitFunction 7
				EndCase
				Case 26, 27, 30, 31, 58, 59, 62, 63, 154, 155, 158, 159, 186, 187, 190, 191
					ExitFunction 8
				EndCase
				Case 64, 65, 68, 69, 96, 97, 100, 101, 192, 193, 196, 197, 224, 225, 228, 229
					ExitFunction 9
				EndCase
				Case 66, 67, 70, 71, 98, 99, 102, 103, 194, 195, 198, 199, 226, 227, 230, 231
					ExitFunction 10
				EndCase
				Case 72, 73, 76, 77, 104, 105, 108, 109, 200, 201, 204, 205, 232, 233, 236, 237
					ExitFunction 11
				EndCase
				Case 74, 75, 78, 79, 106, 107, 110, 111, 202, 203, 206, 207, 234, 235, 238, 239
					ExitFunction 12
				EndCase
				Case 80, 81, 84, 85, 112, 113, 116, 117, 208, 209, 212, 213, 240, 241, 244, 245
					ExitFunction 13
				EndCase
				Case 82, 83, 86, 87, 114, 115, 118, 119, 210, 211, 214, 215, 242, 243, 246, 247
					ExitFunction 14
				EndCase
				Case 88, 89, 92, 93, 120, 121, 124, 125, 216, 217, 220, 221, 248, 249, 252, 253
					ExitFunction 15
				EndCase
				Case 90, 91, 94, 95, 122, 123, 126, 127, 218, 219, 222, 223, 250, 251, 254, 255
					ExitFunction 16
				EndCase
				Case Default
					ExitFunction 0
				EndCase
			EndSelect
		EndCase
		Case 2
			Select mask
				Case 0
					ExitFunction 0
				EndCase
				Case 1
					ExitFunction 1
				EndCase
				Case 2, 3, 5, 6, 7
					ExitFunction 2
				EndCase
				Case 4
					ExitFunction 3
				EndCase
				Case 8, 9, 33, 40, 41
					ExitFunction 4
				EndCase
				Case 10, 11, 12, 13, 14, 15, 34, 35, 37, 38, 39, 42, 43, 44, 45, 46, 47
					ExitFunction 5
				EndCase
				Case 16, 20, 132, 144, 148
					ExitFunction 6
				EndCase
				Case 17, 18, 19, 21, 22, 23, 130, 131, 133, 134, 135, 145, 146, 147, 149, 150, 151
					ExitFunction 7
				EndCase
				Case 24, 25, 26, 27, 28, 29, 30, 31, 49, 50, 51, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 66, 67, 69, 70, 71, 74, 75, 76, 77, 78, 79, 81, 82, 83, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 98, 99, 101, 102, 103, 106, 107, 108, 109, 110, 111, 113, 114, 115, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 138, 139, 140, 141, 142, 143, 152, 153, 154, 155, 156, 157, 158, 159, 162, 163, 165, 166, 167, 170, 171, 172, 173, 174, 175, 177, 178, 179, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 194, 195, 197, 198, 199, 202, 203, 204, 205, 206, 207, 209, 210, 211, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 226, 227, 229, 230, 231, 234, 235, 236, 237, 238, 239, 241, 242, 243, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255
					ExitFunction 8
				EndCase
				Case 32
					ExitFunction 9
				EndCase
				Case 36
					If Not sub
						ExitFunction 10
					Else
						ExitFunction 16
					EndIf
				EndCase
				Case 48, 52, 68, 80, 84, 100, 112, 116, 164, 176, 180, 196, 208, 212, 228, 240, 244
					ExitFunction 11
				EndCase
				Case 64, 96, 160, 192, 224
					ExitFunction 12
				EndCase
				Case 65, 72, 73, 97, 104, 105, 136, 137, 161, 168, 169, 193, 200, 201, 225, 232, 233
					ExitFunction 13
				EndCase
				Case 128
					ExitFunction 14
				EndCase
				Case 129
					If Not sub
						ExitFunction 15
					Else
						ExitFunction 17
					EndIf
				EndCase
				Case Default
					ExitFunction 8
				EndCase
			EndSelect
		EndCase
		Case 3
			Select mask
				Case 0
					ExitFunction 0
				EndCase
				Case 1
					ExitFunction 1
				EndCase
				Case 2, 3, 6, 7
					ExitFunction 2
				EndCase
				Case 4
					ExitFunction 3
				EndCase
				Case 5
					ExitFunction 4
				EndCase
				Case 8, 9, 40, 41
					ExitFunction 5
				EndCase
				Case 10, 11, 14, 15, 42, 43, 46, 47
					ExitFunction 6
				EndCase
				Case 12, 13, 44, 45
					ExitFunction 7
				EndCase
				Case 16, 20, 144, 148
					ExitFunction 8
				EndCase
				Case 17, 21, 145, 149
					ExitFunction 9
				EndCase
				Case 18, 19, 22, 23, 146, 147, 150, 151
					ExitFunction 10
				EndCase
				Case 24, 25, 28, 29, 56, 57, 60, 61, 152, 153, 156, 157, 184, 185, 188, 189
					ExitFunction 11
				EndCase
				Case 26, 27, 30, 31, 58, 59, 62, 63, 154, 155, 158, 159, 186, 187, 190, 191
					ExitFunction 12
				EndCase
				Case 32
					ExitFunction 13
				EndCase
				Case 33
					ExitFunction 14
				EndCase
				Case 34, 35, 38, 39
					ExitFunction 15
				EndCase
				Case 36
					ExitFunction 16
				EndCase
				Case 37
					ExitFunction 17
				EndCase
				Case 48, 52, 176, 180
					ExitFunction 18
				EndCase
				Case 49, 53, 177, 181
					ExitFunction 19
				EndCase
				Case 50, 51, 54, 55, 178, 179, 182, 183
					ExitFunction 20
				EndCase
				Case 64, 96, 192, 224
					ExitFunction 21
				EndCase
				Case 65, 97, 193, 225
					ExitFunction 22
				EndCase
				Case 66, 67, 70, 71, 98, 99, 102, 103, 194, 195, 198, 199, 226, 227, 230, 231
					ExitFunction 23
				EndCase
				Case 68, 100, 196, 228
					ExitFunction 24
				EndCase
				Case 69, 101, 197, 229
					ExitFunction 25
				EndCase
				Case 72, 73, 104, 105, 200, 201, 232, 233
					ExitFunction 26
				EndCase
				Case 74, 75, 78, 79, 106, 107, 110, 111, 202, 203, 206, 207, 234, 235, 238, 239
					ExitFunction 27
				EndCase
				Case 76, 77, 108, 109, 204, 205, 236, 237
					ExitFunction 28
				EndCase
				Case 80, 84, 112, 116, 208, 212, 240, 244
					ExitFunction 29
				EndCase
				Case 81, 85, 113, 117, 209, 213, 241, 245
					ExitFunction 30
				EndCase
				Case 82, 83, 86, 87, 114, 115, 118, 119, 210, 211, 214, 215, 242, 243, 246, 247
					ExitFunction 31
				EndCase
				Case 88, 89, 92, 93, 120, 121, 124, 125, 216, 217, 220, 221, 248, 249, 252, 253
					ExitFunction 32
				EndCase
				Case 90, 91, 94, 95, 122, 123, 126, 127, 218, 219, 222, 223, 250, 251, 254, 255
					ExitFunction 33
				EndCase
				Case 128
					ExitFunction 34
				EndCase
				Case 129
					ExitFunction 35
				EndCase
				Case 130, 131, 134, 135
					ExitFunction 36
				EndCase
				Case 132
					ExitFunction 37
				EndCase
				Case 133
					ExitFunction 38
				EndCase
				Case 136, 137, 168, 169
					ExitFunction 39
				EndCase
				Case 138, 139, 142, 143, 170, 171, 174, 175
					ExitFunction 40
				EndCase
				Case 140, 141, 172, 173
					ExitFunction 41
				EndCase
				Case 160
					ExitFunction 42
				EndCase
				Case 161
					ExitFunction 43
				EndCase
				Case 162, 163, 166, 167
					ExitFunction 44
				EndCase
				Case 164
					ExitFunction 45
				EndCase
				Case 165
					ExitFunction 46
				EndCase
				Case Default
					ExitFunction 47
				EndCase
			EndSelect
		EndCase
		Case 4
			Select mask
				Case 0, 1, 4, 5, 32, 33, 36, 37, 128, 129, 132, 133, 160, 161, 164, 165
					ExitFunction 1
				EndCase
				Case 2, 3, 6, 7, 34, 35, 38, 39, 130, 131, 134, 135, 162, 163, 166, 167
					ExitFunction 2
				EndCase
				Case 8, 9, 12, 13, 40, 41, 44, 45, 136, 137, 140, 141, 168, 169, 172, 173
					ExitFunction 3
				EndCase
				Case 10, 14, 42, 46, 138, 142, 170, 174
					ExitFunction 4
				EndCase
				Case 11, 15, 43, 47, 139, 143, 171, 175
					ExitFunction 5
				EndCase
				Case 16, 17, 20, 21, 48, 49, 52,53, 144, 145, 148, 149, 176, 177, 180, 181
					ExitFunction 6
				EndCase
				Case 18, 19, 50, 51, 146, 147, 178, 179
					ExitFunction 7
				EndCase
				Case 22, 23, 54, 55, 150, 151, 182, 183
					ExitFunction 8
				EndCase
				Case 24, 25, 28, 29, 56, 57, 60, 61, 152, 153, 156, 157, 184, 185, 188, 189
					ExitFunction 9
				EndCase
				Case 26, 58, 154, 186
					ExitFunction 10
				EndCase
				Case 27, 59, 155, 187
					ExitFunction 11
				EndCase
				Case 30, 62, 158, 190
					ExitFunction 12
				EndCase
				Case 31, 63, 159, 191
					ExitFunction 13
				EndCase
				Case 64, 65, 68, 69, 96, 97, 100, 101, 192, 193, 196, 197, 224, 225, 228, 229
					ExitFunction 14
				EndCase
				Case 66, 67, 70, 71, 98, 99, 102, 103, 194, 195, 198, 199, 226, 227, 230, 231
					ExitFunction 15
				EndCase
				Case 72, 73, 76, 77, 200, 201, 204, 205
					ExitFunction 16
				EndCase
				Case 74, 78, 202, 206
					ExitFunction 17
				EndCase
				Case 75, 79, 203, 207
					ExitFunction 18
				EndCase
				Case 80, 81, 84, 85, 112, 113, 116, 117
					ExitFunction 19
				EndCase
				Case 82, 83, 114, 115
					ExitFunction 20
				EndCase
				Case 86, 87, 118, 119
					ExitFunction 21
				EndCase
				Case 88, 89, 92, 93
					ExitFunction 22
				EndCase
				Case 90
					ExitFunction 23
				EndCase
				Case 91
					ExitFunction 24
				EndCase
				Case 94
					ExitFunction 25
				EndCase
				Case 95
					ExitFunction 26
				EndCase
				Case 104, 105, 108, 109, 232, 233, 236, 237
					ExitFunction 27
				EndCase
				Case 106, 110, 234, 238
					ExitFunction 28
				EndCase
				Case 107, 111, 235, 239
					ExitFunction 29
				EndCase
				Case 120, 121, 124, 125
					ExitFunction 30
				EndCase
				Case 122
					ExitFunction 31
				EndCase
				Case 123
					ExitFunction 32
				EndCase
				Case 126
					ExitFunction 33
				EndCase
				Case 127
					ExitFunction 34
				EndCase
				Case 208, 209, 212, 213, 240, 241, 244, 245
					ExitFunction 35
				EndCase
				Case 210, 211, 242, 243
					ExitFunction 36
				EndCase
				Case 214, 215, 246, 247
					ExitFunction 37
				EndCase
				Case 216, 217, 220, 221
					ExitFunction 38
				EndCase
				Case 218
					ExitFunction 39
				EndCase
				Case 219
					ExitFunction 40
				EndCase
				Case 222
					ExitFunction 41
				EndCase
				Case 223
					ExitFunction 42
				EndCase
				Case 248, 249, 252, 253
					ExitFunction 43
				EndCase
				Case 250
					ExitFunction 44
				EndCase
				Case 251
					ExitFunction 45
				EndCase
				Case 254
					ExitFunction 46
				EndCase
				Case 255
					ExitFunction 47
				EndCase
				Case Default
					ExitFunction 0
				EndCase
			EndSelect
		EndCase
	EndSelect
EndFunction 0
