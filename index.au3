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
Global $StartBeToJe = GUICtrlCreateButton("Start conversion", 457, 162, 145, 25)
GUICtrlSetTip(-1, "Start conversion")
Global $JEPackDescInput = GUICtrlCreateInput("", 112, 80, 489, 21)
GUICtrlSetTip(-1, "Pack description")
Global $JEPackDescTitle = GUICtrlCreateLabel("Pack Description:", 15, 80, 88, 17)
Global $JEPackNameTitle = GUICtrlCreateLabel("Pack Name:", 16, 48, 63, 17)
Global $JEPackNameInput = GUICtrlCreateInput("", 88, 48, 513, 21)
GUICtrlSetTip(-1, "Pack name")
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
Global $VersionNumber = GUICtrlCreateLabel("Version: 1.0.0", 537, 200, 69, 17)
Global $GitHubNotice = GUICtrlCreateLabel("View source code,  report bugs and contribute on GitHub", 219, 200, 273, 17)
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

Func startUp() ;Function to be ran on startup (excluding create logs function)
	If FileExists(@ScriptDir & "\LICENSE.txt") = 0 Then
		InetGet("https://thealiendoctor.com/software-license/pack-converter-2022.txt", @ScriptDir & "\LICENSE.txt")
		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", "Re-downloaded license" & @CRLF)
		FileClose($logDir & "\log.latest")
	EndIf
EndFunc   ;==>startUp

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

Func convert($mode, $conversionArray, $arrayDataCount)

	$arrayDataCount -= 1 ;For loops start at 0, so you need to minus 1 from the total

	If $mode = 0 Then ;BedrockToJava
		For $index = 0 To $arrayDataCount
			Local $current = $conversionArray[$index]

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

	ElseIf $mode = 1 Then ;JavaToBedrock
		For $index = 0 To $arrayDataCount
			Local $current = $conversionArray[$index]

			If FileExists($inputDir & "\" & $current[1]) Then
				FileMove($inputDir & "\" & $current[1], $bedrockDir & "\pack\" & $current[0], 8)
				$conversionCount += 1
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[1] & " found, moved it to " & $current[0] & @CRLF)
				FileClose($logDir & "\log.latest")
			Else
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", $current[1] & " not found, ignoring it! " & @CRLF)
				FileClose($logDir & "\log.latest")
			EndIf
		Next
	EndIf
EndFunc   ;==>convert

;###########################################################################################################################################################################################
;Main conversion functions

Func bedrockToJava()
	Local $confirmBox = MsgBox(1, "Alien's pack converter", "Are you sure you want to start conversion? This will delete everything inside the " & $javaDir & " folder, so make sure you have removed any previous packs from it.")
	If $confirmBox = 1 Then

		Local $javaPackName = GUICtrlRead($JEPackNameInput)
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

		convert(0, $blockTextures1, 49)
		convert(0, $blockTextures2, 48)
		convert(0, $blockTextures3, 48)
		convert(0, $blockTextures4, 48)
		convert(0, $blockTextures5, 48)
		convert(0, $blockTextures6, 48)
		convert(0, $blockTextures7, 48)
		convert(0, $blockTextures8, 48)
		convert(0, $blockTextures9, 48)
		convert(0, $blockTextures10, 48)
		convert(0, $blockTextures11, 48)
		convert(0, $blockTextures12, 48)
		convert(0, $blockTextures13, 48)
		convert(0, $blockTextures14, 48)
		convert(0, $blockTextures15, 48)
		convert(0, $blockTextures16, 48)
		convert(0, $blockTextures17, 4)
		convert(0, $blockTextures18, 45)

		convert(0, $colorMapTextures, 2)

		convert(0, $itemTextures1, 86)
		convert(0, $itemTextures2, 85)
		convert(0, $itemTextures3, 85)
		convert(0, $itemTextures4, 85)

		convert(0, $entityTextures1, 94)
		convert(0, $entityTextures2, 92)
		convert(0, $entityTextures3, 27)

		convert(0, $environmentTextures, 3)

		convert(0, $armorTextures, 11)

		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", "Converted armor textures!" & @CRLF)
		FileWrite($logDir & "\log.latest", @CRLF)
		FileClose($logDir & "\log.latest")


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
		FileClose($logDir & "\log.latest")

		FileMove($javaDir & "\pack.zip", $javaDir & "\" & $javaPackName)

		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", ".zip folder renamed!" & @CRLF)
		FileWrite($logDir & "\log.latest", "Bedrock to Java pack conversion complete!" & @CRLF)
		FileClose($logDir & "\log.latest")

		MsgBox(0, "Alien's pack converter", "Conversion complete! Converted " & $conversionCount & " files to Java edition!")
	Else
		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", "Conversion aborted" & @CRLF)
		FileClose($logDir & "\log.latest")
	EndIf
EndFunc   ;==>bedrockToJava

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

		convert(1, $blockTextures1, 49)
		convert(1, $blockTextures2, 48)
		convert(1, $blockTextures3, 48)
		convert(1, $blockTextures4, 48)
		convert(1, $blockTextures5, 48)
		convert(1, $blockTextures6, 48)
		convert(1, $blockTextures7, 48)
		convert(1, $blockTextures8, 48)
		convert(1, $blockTextures9, 48)
		convert(1, $blockTextures10, 48)
		convert(1, $blockTextures11, 48)
		convert(1, $blockTextures12, 48)
		convert(1, $blockTextures13, 48)
		convert(1, $blockTextures14, 48)
		convert(1, $blockTextures15, 48)
		convert(1, $blockTextures16, 48)
		convert(1, $blockTextures17, 4)
		convert(1, $blockTextures18, 45)

		convert(1, $colorMapTextures, 2)

		convert(1, $itemTextures1, 86)
		convert(1, $itemTextures2, 85)
		convert(1, $itemTextures3, 85)
		convert(1, $itemTextures4, 85)

		convert(1, $entityTextures1, 94)
		convert(1, $entityTextures2, 92)
		convert(1, $entityTextures3, 27)

		convert(1, $environmentTextures, 3)

		convert(1, $armorTextures, 11)

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
	FileWrite($logDir & "\log.latest", @CRLF)
	FileClose($logDir & "\log.latest")

	MsgBox(0, "Alien's pack converter", "Conversion complete! Converted " & $conversionCount & " files to Bedrock edition!")
EndFunc   ;==>javaToBedrock


;###########################################################################################################################################################################################
;GUI Control

createLog()
startUp()
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

		Case $CopyrightNotice
			If FileExists(@ScriptDir & "\LICENSE.txt") = 0 Then
				InetGet("https://thealiendoctor.com/software-license/pack-converter-2022.txt", @ScriptDir & "\LICENSE.txt")
				FileOpen($logDir & "\log.latest", 1)
				FileWrite($logDir & "\log.latest", "Re-downloaded license" & @CRLF)
				FileClose($logDir & "\log.latest")
				ShellExecute(@ScriptDir & "\LICENSE.txt")
			ElseIf FileExists(@ScriptDir & "\LICENSE.txt") Then
				ShellExecute(@ScriptDir & "\LICENSE.txt")
			EndIf

		Case $GitHubNotice
			ShellExecute("https://github.com/TheAlienDoctor/minecraft-resource-pack-converter")

	EndSwitch
WEnd
