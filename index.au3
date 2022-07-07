#pragma compile(Compatibility, Windows)
#pragma compile(FileDescription, Converts Minecraft resource packs between Minecraft Bedrock and Java)
#pragma compile(ProductName, Alien's Minecraft resource pack converter)
#pragma compile(ProductVersion, 1.0.0)
#pragma compile(FileVersion, 1.0.0.0)
#pragma compile(LegalCopyright, ©TheAlienDoctor)
#pragma compile(CompanyName, TheAlienDoctor)

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>

#include "conversions.au3"
#include "UDF\Zip.au3"

;###########################################################################################################################################################################################
;GUI (from Koda)

#Region ### START Koda GUI section ### Form=d:\06 code\minecraft-resource-pack-converter\gui.kxf
Global $PackConverter = GUICreate("Alien's Pack Converter", 615, 221, -1, -1)
Global $PackConverter = GUICtrlCreateTab(8, 8, 601, 185)
Global $BedrockToJava = GUICtrlCreateTabItem("Bedrock to Java")
Global $JEPackDescTitle = GUICtrlCreateLabel("Pack Description:", 15, 48, 88, 17)
Global $StartBeToJe = GUICtrlCreateButton("Start conversion", 457, 162, 145, 25)
GUICtrlSetTip(-1, "Start conversion")
Global $JEPackDescInput = GUICtrlCreateInput("", 112, 48, 489, 21)
GUICtrlSetTip(-1, "Pack description")
Global $JavaToBedrock = GUICtrlCreateTabItem("Java to Bedrock")
Global $BEPackDescInput = GUICtrlCreateInput("", 112, 80, 489, 21)
GUICtrlSetTip(-1, "Pack description")
Global $BEPackNameInput = GUICtrlCreateInput("", 88, 48, 513, 21)
GUICtrlSetTip(-1, "Pack name")
Global $StartJeToBe = GUICtrlCreateButton("Start conversion", 457, 162, 145, 25)
GUICtrlSetTip(-1, "Start conversion")
Global $BEPackDescTitle = GUICtrlCreateLabel("Pack Description:", 15, 80, 88, 17)
Global $BEPackNameTitle = GUICtrlCreateLabel("Pack Name:", 16, 48, 63, 17)
GUICtrlCreateTabItem("")
Global $CopyrightNotice = GUICtrlCreateLabel("Copyright © 2022, TheAlienDoctor", 8, 200, 167, 17)
GUICtrlSetTip(-1, "Copyright notice")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;###########################################################################################################################################################################################
;Declare variables

Global $dateTime = @MDAY & '.' & @MON & '.' & @YEAR & '-' & @HOUR & '.' & @MIN & '.' & @SEC

Global $inputDir = @ScriptDir & "\" & IniRead("options.ini", "config", "InputDir", "input")
Global $bedrockDir = @ScriptDir & "\" & IniRead("options.ini", "config", "BedrockDir", "Bedrock-pack" & "pack")
Global $javaDir = @ScriptDir & "\" & IniRead("options.ini", "config", "JavaDir", "Java-pack" & "pack")

If IniRead("options.ini", "logConfig", "CustomLogDir", "false") = "false" Then
	Global $logDir = @ScriptDir & "\logs"
ElseIf IniRead("options.ini", "logConfig", "CustomLogDir", "false") = "true" Then
	Global $logDir = IniRead("options.ini", "logConfig", "LogDir", @ScriptDir & "\logs")
EndIf

;The conversion variables can be found in conversions.au3, this is to help with not cluttering this script
Global $textures[9] = [$acacia_trapdoor, $amethyst_block, $amethyst_cluster, $ancient_debris_side, $ancient_debris_top, $anvil_base, $anvil_top_damaged_0, $anvil_top_damaged_1, $anvil_top_damaged_2]

;###########################################################################################################################################################################################
;Functions

;Version 4 UUID generator
;credits goes to mimec (http://php.net/uniqid#69164)
Func uuidGenerator()
	Return StringFormat('%04x%04x-%04x-%04x-%04x-%04x%04x%04x', _
			Random(0, 0xffff), Random(0, 0xffff), _
			Random(0, 0xffff), _
			BitOR(Random(0, 0x0fff), 0x4000), _
			BitOR(Random(0, 0x3fff), 0x8000), _
			Random(0, 0xffff), Random(0, 0xffff), Random(0, 0xffff) _
			)
EndFunc   ;==>uuidGenerator


Func bedrockToJava()
	Local $javaPackDesc = GUICtrlRead($JEPackDescInput)

	FileOpen($logDir & "\log.latest", 1)
	FileWrite($logDir & "\log.latest", "Began converting Bedrock to Java" & @CRLF)
	FileClose($logDir & "\log.latest")

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

	For $index = 0 To 8
		Local $current = $textures[$index]

		If FileExists($inputDir & "\" & $current[0]) Then
			FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
			FileOpen($logDir & "\log.latest", 1)
			FileWrite($logDir & "\log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
			FileClose($logDir & "\log.latest")
		Else
			FileOpen($logDir & "\log.latest", 1)
			FileWrite($logDir & "\log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
			FileClose($logDir & "\log.latest")
		EndIf
	Next
	FileOpen($logDir & "\log.latest", 1)
	FileWrite($logDir & "\log.latest", "Texture file conversion complete!" & @CRLF)
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
	MsgBox(0, "Alien's pack converter", "Conversion complete!")
EndFunc   ;==>bedrockToJava

; Page break to help my eyes xD ########################################################################################

Func javaToBedrock()
	Local $bedrockPackName = GUICtrlRead($BEPackNameInput)
	Local $bedrockPackDesc = GUICtrlRead($BEPackDescInput)

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

	For $index = 0 To 8
		Local $current = $textures[$index]

		If FileExists($inputDir & "\" & $current[1]) Then
			FileMove($inputDir & "\" & $current[1], $bedrockDir & "\pack\" & $current[0], 8)
			FileOpen($logDir & "\log.latest", 1)
			FileWrite($logDir & "\log.latest", $current[1] & " found, moved it to " & $current[0] & @CRLF)
			FileClose($logDir & "\log.latest")
		Else
			FileOpen($logDir & "\log.latest", 1)
			FileWrite($logDir & "\log.latest", $current[1] & " not found, ignoring it! " & @CRLF)
			FileClose($logDir & "\log.latest")
		EndIf
	Next

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
	MsgBox(0, "Alien's pack converter", "Conversion complete!")
EndFunc   ;==>javaToBedrock

Func createLog()
	If FileExists($logDir) Then ;If directory exists then begin writing logs
		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)" & @CRLF)
		FileWrite($logDir & "\log.latest", "###################################################################" & @CRLF)
		FileClose($logDir & "\log.latest")
	ElseIf FileExists($logDir) = "0" Then ;If directory doesn't exist create it then begin writing logs
		DirCreate($logDir)
		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", "Created log file directory" & @CRLF)
		FileWrite($logDir & "\log.latest", @CRLF)
		FileWrite($logDir & "\log.latest", "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)" & @CRLF)
		FileWrite($logDir & "\log.latest", "###################################################################" & @CRLF)
		FileClose($logDir & "\log.latest")
	EndIf
EndFunc   ;==>createLog

Func finishLog()
	FileOpen($logDir & "\log.latest", 1)
	FileWrite($logDir & "\log.latest", "###################################################################" & @CRLF)
	FileWrite($logDir & "\log.latest", "Log file closed at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)" & @CRLF)
	FileClose($logDir & "\log.latest")
	FileMove($logDir & "\log.latest", $logDir & "\log[" & $dateTime & "].txt")
EndFunc   ;==>finishLog

Func createInputDir()
	If FileExists($inputDir) Then
		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", "Input directory exists" & @CRLF)
		FileClose($logDir & "\log.latest")
	Else
		DirCreate($inputDir)
		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", "Created input directory" & @CRLF)
		FileClose($logDir & "\log.latest")
	EndIf
EndFunc   ;==>createInputDir

;###########################################################################################################################################################################################
;GUI Control

createLog()
createInputDir()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			finishLog()
			Exit

		Case $StartBeToJe
			bedrockToJava()

		Case $StartJeToBe
			javaToBedrock()

	EndSwitch
WEnd
