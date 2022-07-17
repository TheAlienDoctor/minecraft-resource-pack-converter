Func bedrockToJava()
	Local $confirmBox = MsgBox(1, "Alien's pack converter", "Are you sure you want to start conversion? This will delete everything inside the " & $javaDir & " folder, so make sure you have removed any previous packs from it.")
	If $confirmBox = 1 Then

		Local $javaPackDesc = GUICtrlRead($JEPackDescInput)
		$conversionCount = 0

		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", "Began converting Bedrock to Java" & @CRLF)
		FileClose($logDir & "\log.latest")

		DirRemove($javaDir, 1)
		DirCreate($javaDir & "\pack")

		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", "Generating pack.mcmeta file" & @CRLF)
		FileClose($logDir & "\log.latest")

		FileOpen($javaDir & "\pack\pack.txt", 8)
		FileWrite($javaDir & '\pack\pack.txt', '{"pack":{"pack_format":9,"description":"' & $javaPackDesc & '"}}')
		FileClose($javaDir & "\pack\pack.txt")
		FileMove($javaDir & "\pack\pack.txt", $javaDir & "\pack\pack.mcmeta")

		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", "Generated pack.mcmeta file" & @CRLF)
		FileWrite($logDir & "\log.latest", "Beginning texture file conversion" & @CRLF)
		FileClose($logDir & "\log.latest")

		For $index = 0 To 48
			Local $current = $blockTextures1[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 47
			Local $current = $blockTextures2[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 47
			Local $current = $blockTextures3[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 47
			Local $current = $blockTextures4[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 47
			Local $current = $blockTextures5[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 47
			Local $current = $blockTextures6[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 47
			Local $current = $blockTextures7[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 47
			Local $current = $blockTextures8[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 47
			Local $current = $blockTextures9[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 47
			Local $current = $blockTextures10[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 47
			Local $current = $blockTextures11[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 47
			Local $current = $blockTextures12[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 47
			Local $current = $blockTextures13[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 47
			Local $current = $blockTextures14[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 47
			Local $current = $blockTextures15[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 47
			Local $current = $blockTextures16[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 3
			Local $current = $blockTextures17[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next

		For $index = 0 To 85
			Local $current = $itemTextures1[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 84
			Local $current = $itemTextures2[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 84
			Local $current = $itemTextures3[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 84
			Local $current = $itemTextures4[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next

		For $index = 0 To 93
			Local $current = $entityTextures1[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
		For $index = 0 To 91
			Local $current = $entityTextures2[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next

		For $index = 0 To 2
			Local $current = $environmentTextures[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next

		For $index = 0 To 10
			Local $current = $armorTextures[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next

		

		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", "Texture file conversion complete! Converted " & $conversionCount & " files!" & @CRLF)
		FileWrite($logDir & "\log.latest", "Creating pack.zip file" & @CRLF)
		FileClose($logDir & "\log.latest")

		_Zip_Create($javaDir & "\pack.zip")

		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", "Created pack.zip file" & @CRLF)
		FileWrite($logDir & "\log.latest", "Adding files to pack.zip file" & @CRLF)
		FileClose($logDir & "\log.latest")

		_Zip_AddFolderContents($javaDir & "\pack.zip", $javaDir & "\pack", 1)

		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", "Finished adding files to pack.zip!" & @CRLF)
		FileWrite($logDir & "\log.latest", ".zip folder created and renamed!" & @CRLF)
		FileWrite($logDir & "\log.latest", "Bedrock to Java pack conversion complete!" & @CRLF)
		FileClose($logDir & "\log.latest")

		MsgBox(0, "Alien's pack converter", "Conversion complete! Converted " & $conversionCount & " files to Java edition!")
	Else
		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", "Conversion aborted" & @CRLF)
		FileClose($logDir & "\log.latest")
	EndIf
EndFunc   ;==>bedrockToJava