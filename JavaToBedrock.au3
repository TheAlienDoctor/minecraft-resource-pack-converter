Func javaToBedrock()
	Local $bedrockPackName = GUICtrlRead($BEPackNameInput)
	Local $bedrockPackDesc = GUICtrlRead($BEPackDescInput)
	Local $conversionCount = 0

	FileOpen($logDir & "\log.latest", 1)
	FileWrite($logDir & "\log.latest", "Began converting Java to Bedrock" & @CRLF)
	FileClose($logDir & "\log.latest")

	DirCreate($bedrockDir & "\pack")

	FileOpen($logDir & "\log.latest", 1)
	FileWrite($logDir & "\log.latest", "Generating manifest.json file" & @CRLF)
	FileClose($logDir & "\log.latest")

	FileOpen($bedrockDir & "\pack\manifest.txt", 8)
	FileWrite($bedrockDir & '\pack\manifest.txt', '{"format_version":2,"header":{"description":"' & $bedrockPackDesc & ' | §9Converted to from Java to Bedrock using Aliens pack converter §r | §eDownload pack converter from TheAlienDoctor.com §r","name":"' & $bedrockPackName & '","uuid":"' & uuidGenerator() & '","version":[1,0,0],"min_engine_version":[1,19,0]},"modules":[{"description":"' & $bedrockPackDesc & ' | §9Converted to from Java to Bedrock using Aliens pack converter §r | §eDownload pack converter from TheAlienDoctor.com §r","type":"resources","uuid":"' & uuidGenerator() & '","version":[1,0,0]}]}')
	FileClose($bedrockDir & "\pack\manifest.txt")
	FileMove($bedrockDir & "\pack\manifest.txt", $bedrockDir & "\pack\manifest.json")

	FileOpen($logDir & "\log.latest", 1)
	FileWrite($logDir & "\log.latest", "Generated manifest.json file" & @CRLF)
	FileWrite($logDir & "\log.latest", "Beginning texture file conversion" & @CRLF)
	FileClose($logDir & "\log.latest")

	;For $index = 0 To 8
	;	Local $current = $textures[$index]
	;
	;	If FileExists($inputDir & "\" & $current[1]) Then
	;		FileMove($inputDir & "\" & $current[1], $bedrockDir & "\pack\" & $current[0], 8)
	;		Local $conversionCount = +1
	;		FileOpen($logDir & "\log.latest", 1)
	;		FileWrite($logDir & "\log.latest", $current[1] & " found, moved it to " & $current[0] & @CRLF)
	;		FileClose($logDir & "\log.latest")
	;	Else
	;		FileOpen($logDir & "\log.latest", 1)
	;		FileWrite($logDir & "\log.latest", $current[1] & " not found, ignoring it! " & @CRLF)
	;		FileClose($logDir & "\log.latest")
	;	EndIf
	;Next

	FileOpen($logDir & "\log.latest", 1)
	FileWrite($logDir & "\log.latest", "Texture file conversion complete!" & @CRLF)
	FileWrite($logDir & "\log.latest", "Creating .zip file" & @CRLF)
	FileClose($logDir & "\log.latest")

	_Zip_Create($bedrockDir & "\pack.zip")

	FileOpen($logDir & "\log.latest", 1)
	FileWrite($logDir & "\log.latest", "Created pack.zip file" & @CRLF)
	FileWrite($logDir & "\log.latest", "Adding files to pack.zip file" & @CRLF)
	FileClose($logDir & "\log.latest")

	_Zip_AddFolderContents($bedrockDir & "\pack.zip", $bedrockDir & "\pack\", 1)

	FileOpen($logDir & "\log.latest", 1)
	FileWrite($logDir & "\log.latest", "Finished adding files to pack.zip!" & @CRLF)
	FileWrite($logDir & "\log.latest", "Java to Bedrock pack conversion complete!" & @CRLF)
	FileClose($logDir & "\log.latest")

	MsgBox(0, "Alien's pack converter", "Conversion complete! Converted " & $conversionCount & " files to Bedrock edition!")
EndFunc   ;==>javaToBedrock