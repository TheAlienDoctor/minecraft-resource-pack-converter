#pragma compile(Compatibility, vista, win7, win8, win81, win10, win11)
#pragma compile(FileDescription, Converts Minecraft resource packs between Minecraft Bedrock and Java)
#pragma compile(ProductName, Alien's Minecraft resource pack converter)
#pragma compile(ProductVersion, 1.0.1)
#pragma compile(FileVersion, 1.0.1.0)
#pragma compile(LegalCopyright, ©TheAlienDoctor)
#pragma compile(CompanyName, TheAlienDoctor)
#pragma compile(OriginalFilename, AliensPackConverter-V1.0.1)

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>

#include "conversions.au3"
#include "UDF\Zip.au3"
#include <InetConstants.au3>

;###########################################################################################################################################################################################
;GUI (from Koda)

#Region ### START Koda GUI section ###
Global $PackConverter = GUICreate("Alien's Pack Converter", 615, 221, -1, -1)
Global $PackConverter = GUICtrlCreateTab(8, 8, 601, 185)
Global $BedrockToJava = GUICtrlCreateTabItem("Bedrock to Java")
Global $StartBeToJe = GUICtrlCreateButton("Start conversion", 457, 162, 145, 25)
GUICtrlSetTip(-1, "Start conversion")
Global $JEPackDescInput = GUICtrlCreateInput("Pack description here", 112, 80, 489, 21)
GUICtrlSetTip(-1, "Pack description")
Global $JEPackDescTitle = GUICtrlCreateLabel("Pack Description:", 15, 80, 88, 17)
Global $JEPackNameTitle = GUICtrlCreateLabel("Pack Name:", 16, 48, 63, 17)
Global $JEPackNameInput = GUICtrlCreateInput("Pack name here", 88, 48, 513, 21)
GUICtrlSetTip(-1, "Pack name")
Global $JavaToBedrock = GUICtrlCreateTabItem("Java to Bedrock")
Global $BEPackDescInput = GUICtrlCreateInput("Pack description here", 112, 80, 489, 21)
GUICtrlSetTip(-1, "Pack description")
Global $BEPackNameInput = GUICtrlCreateInput("Pack name here", 88, 48, 513, 21)
GUICtrlSetTip(-1, "Pack name")
Global $StartJeToBe = GUICtrlCreateButton("Start conversion", 457, 162, 145, 25)
GUICtrlSetTip(-1, "Start conversion")
Global $BEPackDescTitle = GUICtrlCreateLabel("Pack Description:", 15, 80, 88, 17)
Global $BEPackNameTitle = GUICtrlCreateLabel("Pack Name:", 16, 48, 63, 17)
GUICtrlCreateTabItem("")
Global $CopyrightNotice = GUICtrlCreateLabel("Copyright © 2022, TheAlienDoctor", 8, 200, 167, 17)
GUICtrlSetTip(-1, "Copyright notice")
GUICtrlSetCursor(-1, 0)
Global $VersionNumber = GUICtrlCreateLabel("Version: 1.0.1", 537, 200, 69, 17)
GUICtrlSetTip(-1, "Check for updates")
GUICtrlSetCursor(-1, 0)
Global $GitHubNotice = GUICtrlCreateLabel("View source code,  report bugs and contribute on GitHub", 219, 200, 273, 17)
GUICtrlSetTip(-1, "Open GitHub repo")
GUICtrlSetCursor(-1, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;###########################################################################################################################################################################################
;Declare variables

Global $dateTime = @MDAY & '.' & @MON & '.' & @YEAR & '-' & @HOUR & '.' & @MIN & '.' & @SEC
Global $inputDir = @ScriptDir & "\" & IniRead("options.ini", "config", "InputDir", "input")
Global $repeats = IniRead("options.txt", "config", "repeats", 2)
Global $currentVersionNumber = 100

If IniRead("options.ini", "Bedrock to Java", "useCustomDir", "error") = "false" Then
	Global $javaDir = @ScriptDir & "\Java Pack"

ElseIf IniRead("options.ini", "Bedrock to Java", "useCustomDir", "error") = "true" Then
	Global $javaDir = IniRead("options.ini", "Bedrock to Java", "JavaDir", @ScriptDir & "Java-pack")

Else
	MsgBox(0, "Alien's pack converter", "Error in config file: useCustomDir can only be set to true or false!")
	exitProgram()
	Exit
EndIf


If IniRead("options.ini", "Java to Bedrock", "useCustomDir", "false") = "false" Then
	Global $bedrockDir = @ScriptDir & "\Bedrock pack"

ElseIf IniRead("options.ini", "Java to Bedrock", "useCustomDir", "false") = "true" Then
	Global $bedrockDir = IniRead("options.ini", "Java to Bedrock", "BedrockDir", @ScriptDir & "\Bedrock Pack")

Else
	MsgBox(0, "Alien's pack converter", "Error in config file: useCustomDir can only be set to true or false!")
	exitProgram()
	Exit
EndIf

If IniRead("options.ini", "logConfig", "CustomLogDir", "error") = "false" Then
	Global $logDir = @ScriptDir & "\logs"

ElseIf IniRead("options.ini", "logConfig", "CustomLogDir", "error") = "true" Then
	Global $logDir = IniRead("options.ini", "logConfig", "LogDir", @ScriptDir & "\logs")

Else
	MsgBox(0, "Alien's pack converter", "Error in config file: CustomLogDir can only be set to true or false!")
	Exit
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

Func checkForUpdates($updateCheckOutputMsg)
	logWrite(0, "Running update check")
	Local $ping = Ping("TheAlienDoctor.com")
	Local $NoInternetMsgBox = 0


	If $ping > 0 Then
		DirCreate(@ScriptDir & "\temp\")
		InetGet("https://thealiendoctor.com/software-versions/pack-converter-versions.ini", @ScriptDir & "\temp\versions.ini", 1)
		Global $latestVersionNum = IniRead(@ScriptDir & "\temp\versions.ini", "latest", "latest-version-num", "100")

		If $latestVersionNum > $currentVersionNumber Then
			Global $updateMsg = IniRead(@ScriptDir & "\temp\versions.ini", $latestVersionNum, "update-message", "(updated message undefined)")
			Global $updateMsgBox = MsgBox(4, "Alien's pack converter", "There is a new update out now!" & @CRLF & $updateMsg & @CRLF & @CRLF & "Would you like to download it?")
			logWrite(0, "New version found")

			If $updateMsgBox = 6 Then
				Global $versionPage = IniRead(@ScriptDir & "\temp\versions.ini", $latestVersionNum, "version-page", "https://www.thealiendoctor.com/downloads/pack-converter")
				ShellExecute($versionPage)
				logWrite(0, "Opened newest version page")
				exitProgram()
				Exit
			EndIf
		Else
			logWrite(0, "No new updates found")
			If $updateCheckOutputMsg = 1 Then
				;Do some stuff
			EndIf
		EndIf

	Else ;If ping is below 0 then update server is down, or user is not connected to the internet
		$NoInternetMsgBox = "clear variable"
		$NoInternetMsgBox = MsgBox(6, "Alien's pack converter", "Warning: You are not connected to the internet or TheAlienDoctor.com is down. This means the update checker could not run. Continue?")
		logWrite(0, "No Internet, unable to check for updates")
	EndIf

	If $NoInternetMsgBox = 2 Then ;Cancel
		exitProgram()
		Exit

	ElseIf $NoInternetMsgBox = 10 Then ;Try again
		logWrite(0, "Trying to check for updates again")
		checkForUpdates(1)

	ElseIf $NoInternetMsgBox = 11 Then ;Continue
		logWrite(0, "Continued without checking for updates (no internet)")
	EndIf

	DirRemove(@ScriptDir & "\temp\", 1)
EndFunc   ;==>checkForUpdates

Func createLog()
	If FileExists($logDir & "\latest.log") Then
		FileMove($logDir & "\log.latest", $logDir & "\log.old")
	EndIf

	If FileExists($logDir) Then ;If directory exists then begin writing logs
		logWrite(0, "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
		logWrite(0, "###################################################################")
	ElseIf FileExists($logDir) = 0 Then ;If directory doesn't exist create it then begin writing logs
		DirCreate($logDir)
		logWrite(0, "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
		logWrite(0, "###################################################################")
		logWrite(0, "Created logging directory!")
	EndIf
EndFunc   ;==>createLog

Func startUp() ;Function to be ran on startup (excluding create logs function)

	If FileExists(@ScriptDir & "\LICENSE.txt") = 0 Then ;License redownload
		InetGet("https://thealiendoctor.com/software-license/pack-converter-2022.txt", @ScriptDir & "\LICENSE.txt")
		logWrite(0, "Re-downloaded license")
	EndIf

	If FileExists($inputDir) Then ;Create input directory if it doesn't already exist
		logWrite(0, "Input directory exists")
	Else
		DirCreate($inputDir)
		logWrite(0, "Created input directory")
	EndIf

	If IniRead("options.ini", "config", "autoCheckUpdates", "Error") = true Then ;Check for updates on startup
		checkForUpdates(0)

	ElseIf IniRead("options.ini", "config", "autoCheckUpdates", "Error") = false Then
		logWrite(0, "Auto update check is disabled - this is not recommended!")
	Else
		MsgBox(0, "Alien's pack converter", "Error in config file: autoCheckUpdates can only be set to true or false!")
		exitProgram()
		Exit
	EndIf
EndFunc   ;==>startUp

Func logWrite($spaces, $content)
	If $spaces = 1 Then ;For adding spaces around the content written to the log
		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", @CRLF)
		FileClose($logDir & "\log.latest")
	ElseIf $spaces = 2 Then
		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", @CRLF)
		FileClose($logDir & "\log.latest")
	EndIf

	FileOpen($logDir & "\log.latest", 1)
	FileWrite($logDir & "\log.latest", $content & @CRLF)
	FileClose($logDir & "\log.latest")

	If $spaces = 1 Then
		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", @CRLF)
		FileClose($logDir & "\log.latest")
	ElseIf $spaces = 3 Then
		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", @CRLF)
		FileClose($logDir & "\log.latest")
	EndIf
EndFunc   ;==>logWrite

Func exitProgram()
	FileOpen($logDir & "\log.latest", 1)
	logWrite(0, "###################################################################")
	logWrite(0, "Log file closed at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
	FileMove($logDir & "\log.latest", $logDir & "\log[" & $dateTime & "].txt")

	DirRemove(@ScriptDir & "\temp\", 1)
EndFunc   ;==>exitProgram

Func convert($mode, $conversionArray, $arrayDataCount)

	$arrayDataCount -= 1 ;ForLoops start at 0, so you need to minus 1 from the total

	If $mode = 0 Then ;BedrockToJava
		For $index = 0 To $arrayDataCount
			Local $current = $conversionArray[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $javaDir & "\pack\" & $current[1], 8)
				Sleep(10)
				$conversionCount += 1
				logWrite(0, $current[0] & " found, moved it to " & $current[1])
			Else
				logWrite(0, $current[0] & " not found, ignoring it!")
			EndIf
		Next

	ElseIf $mode = 1 Then ;JavaToBedrock
		For $index = 0 To $arrayDataCount
			Local $current = $conversionArray[$index]

			If FileExists($inputDir & "\" & $current[1]) Then
				FileMove($inputDir & "\" & $current[1], $bedrockDir & "\pack\" & $current[0], 8)
				Sleep(10)
				$conversionCount += 1
				logWrite(0, $current[1] & " found, moved it to " & $current[0])
			Else
				logWrite(0, $current[1] & " not found, ignoring it!")
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
		Global $conversionCount = 0
		Local $timesRan = 0

		logWrite(0, "Began converting Bedrock to Java")

		DirRemove($javaDir, 1)
		DirCreate($javaDir & "\pack")

		logWrite(0, "Generating pack.mcmeta file")

		FileOpen($javaDir & "\pack\pack.txt", 8)
		FileWrite($javaDir & '\pack\pack.txt', '{"pack":{"pack_format":9,"description":"' & $javaPackDesc & '"}}')
		FileClose($javaDir & "\pack\pack.txt")
		FileMove($javaDir & "\pack\pack.txt", $javaDir & "\pack\pack.mcmeta")

		FileOpen($logDir & "\log.latest", 1)
		logWrite(0, "Generated pack.mcmeta file")
		logWrite(0, "Beginning texture file conversion")

		While $timesRan < $repeats
			convert(0, $blockTextures1, 49)
			convert(0, $blockTextures2, 48)
			convert(0, $blockTextures3, 46)
			convert(0, $blockTextures4, 48)
			convert(0, $blockTextures5, 48)
			convert(0, $blockTextures6, 48)
			convert(0, $blockTextures7, 48)
			convert(0, $blockTextures8, 48)
			convert(0, $blockTextures9, 48)
			convert(0, $blockTextures10, 47)
			convert(0, $blockTextures11, 48)
			convert(0, $blockTextures12, 48)
			convert(0, $blockTextures13, 48)
			convert(0, $blockTextures14, 48)
			convert(0, $blockTextures15, 48)
			convert(0, $blockTextures16, 48)
			convert(0, $blockTextures17, 4)
			convert(0, $blockTextures18, 43)

			convert(0, $colorMapTextures, 2)

			convert(0, $itemTextures1, 86)
			convert(0, $itemTextures2, 85)
			convert(0, $itemTextures3, 85)
			convert(0, $itemTextures4, 85)
			convert(0, $itemTextures5, 21)

			convert(0, $entityTextures1, 94)
			convert(0, $entityTextures2, 92)
			convert(0, $entityTextures3, 57)
			convert(0, $entityTextures4, 43)

			convert(0, $environmentTextures, 12)

			convert(0, $armorTextures, 11)

			convert(0, $guiTextures, 1)
			$timesRan += 1
			logWrite(1, "Texture conversion function ran " & $timesRan & "/" & $repeats)
		WEnd

		logWrite(0, "Texture file conversion complete! Converted " & $conversionCount & " files!")
		logWrite(0, "Creating pack.zip file")

		_Zip_Create($javaDir & "\pack.zip")

		logWrite(0, "Created pack.zip file")
		logWrite(0, "Adding files to pack.zip file")

		_Zip_AddFolderContents($javaDir & "\pack.zip", $javaDir & "\pack", 1)

		logWrite(0, "Finished adding files to pack.zip!")

		FileMove($javaDir & "\pack.zip", $javaDir & "\" & $javaPackName & ".zip")

		logWrite(0, ".zip folder renamed!")
		logWrite(0, "Bedrock to Java pack conversion complete!")

		MsgBox(0, "Alien's pack converter", "Conversion complete! Converted " & $conversionCount & " files to Java edition!")
	Else
		logWrite(0, "Conversion aborted")
	EndIf
EndFunc   ;==>bedrockToJava

Func javaToBedrock()
	Local $confirmBox = MsgBox(1, "Alien's pack converter", "Are you sure you want to start conversion? This will delete everything inside the " & $bedrockDir & " folder, so make sure you have removed any previous packs from it.")
	If $confirmBox = 1 Then
		Local $bedrockPackName = GUICtrlRead($BEPackNameInput)
		Local $bedrockPackDesc = GUICtrlRead($BEPackDescInput)
		Global $conversionCount = 0
		Local $timesRan = 0

		logWrite(0, "Began converting Java to Bedrock")

		DirRemove($bedrockDir, 1)
		DirCreate($bedrockDir & "\pack")

		logWrite(0, "Generating manifest.json file")

		FileOpen($bedrockDir & "\pack\manifest.txt", 8)
		FileWrite($bedrockDir & '\pack\manifest.txt', '{"format_version":2,"header":{"description":"' & $bedrockPackDesc & ' | §9Converted to from Java to Bedrock using Aliens pack converter §r | §eDownload pack converter from TheAlienDoctor.com §r","name":"' & $bedrockPackName & '","uuid":"' & uuidGenerator() & '","version":[1,0,0],"min_engine_version":[1,19,0]},"modules":[{"description":"' & $bedrockPackDesc & ' | §9Converted to from Java to Bedrock using Aliens pack converter §r | §eDownload pack converter from TheAlienDoctor.com §r","type":"resources","uuid":"' & uuidGenerator() & '","version":[1,0,0]}]}')
		FileClose($bedrockDir & "\pack\manifest.txt")
		FileMove($bedrockDir & "\pack\manifest.txt", $bedrockDir & "\pack\manifest.json")

		logWrite(0, "Generated manifest.json file")
		logWrite(0, "Beginning texture file conversion")

		While $timesRan < $repeats
			convert(1, $blockTextures1, 49)
			convert(1, $blockTextures2, 48)
			convert(1, $blockTextures3, 46)
			convert(1, $blockTextures4, 48)
			convert(1, $blockTextures5, 48)
			convert(1, $blockTextures6, 48)
			convert(1, $blockTextures7, 48)
			convert(1, $blockTextures8, 48)
			convert(1, $blockTextures9, 48)
			convert(1, $blockTextures10, 47)
			convert(1, $blockTextures11, 48)
			convert(1, $blockTextures12, 48)
			convert(1, $blockTextures13, 48)
			convert(1, $blockTextures14, 48)
			convert(1, $blockTextures15, 48)
			convert(1, $blockTextures16, 48)
			convert(1, $blockTextures17, 4)
			convert(1, $blockTextures18, 43)

			convert(1, $colorMapTextures, 2)

			convert(1, $itemTextures1, 86)
			convert(1, $itemTextures2, 85)
			convert(1, $itemTextures3, 85)
			convert(1, $itemTextures4, 85)
			convert(1, $itemTextures5, 21)

			convert(1, $entityTextures1, 94)
			convert(1, $entityTextures2, 92)
			convert(1, $entityTextures3, 57)
			convert(1, $entityTextures4, 43)

			convert(1, $environmentTextures, 12)

			convert(1, $armorTextures, 11)

			convert(1, $guiTextures, 1)

			$timesRan += 1
			Sleep(10)
		WEnd

		logWrite(0, "Texture file conversion complete! Converted " & $conversionCount & "files!")
		logWrite(0, "Creating .mcpack file")

		_Zip_Create($bedrockDir & "\" & $bedrockPackName & ".zip")

		logWrite(0, "Created pack.zip file")
		logWrite(0, "Adding files to pack.zip file")

		_Zip_AddFolderContents($bedrockDir & "\" & $bedrockPackName & ".zip", $bedrockDir & "\pack\", 1)

		logWrite(0, "Finished adding files to pack.zip!")

		FileMove($bedrockDir & "\" & $bedrockPackName & ".zip", $bedrockDir & "\" & $bedrockPackName & ".mcpack")

		logWrite(3, "Java to Bedrock pack conversion complete!")

		MsgBox(0, "Alien's pack converter", "Conversion complete! Converted " & $conversionCount & " files to Bedrock edition!")
	Else
		logWrite(0, "Conversion aborted")
	EndIf
EndFunc   ;==>javaToBedrock


;###########################################################################################################################################################################################
;GUI Control

createLog()
startUp()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			exitProgram()
			Exit

		Case $StartBeToJe
			bedrockToJava()

		Case $StartJeToBe
			javaToBedrock()

		Case $CopyrightNotice
			If FileExists(@ScriptDir & "\LICENSE.txt") = 0 Then
				InetGet("https://thealiendoctor.com/software-license/pack-converter-2022.txt", @ScriptDir & "\LICENSE.txt")
				logWrite(0, "Re-downloaded license")
				ShellExecute(@ScriptDir & "\LICENSE.txt")
			ElseIf FileExists(@ScriptDir & "\LICENSE.txt") Then
				ShellExecute(@ScriptDir & "\LICENSE.txt")
			EndIf

		Case $GitHubNotice
			ShellExecute("https://github.com/TheAlienDoctor/minecraft-resource-pack-converter")

		Case $VersionNumber
			checkForUpdates(1)

	EndSwitch
WEnd
