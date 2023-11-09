#pragma compile(Compatibility, XP, vista, win7, win8, win81, win10, win11)
#pragma compile(FileDescription, Alien's Minecraft resource pack converter)
#pragma compile(ProductName, Alien's Minecraft resource pack converter)
#pragma compile(ProductVersion, 1.4.0-Beta1)
#pragma compile(FileVersion, 1.4.0.1)
#pragma compile(LegalCopyright, ©TheAlienDoctor)
#pragma compile(CompanyName, TheAlienDoctor)
#pragma compile(OriginalFilename, AliensPackConverter-V1.4.0-Beta1)

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <InetConstants.au3>

#include "conversions.au3"
#include "animeTextures.au3"
#include "UDF\Zip.au3"
#include "UDF\JSON.au3"
#include "UDF\BinaryCall.au3"

Global Const $guiTitle = "Alien's Pack Converter V1.4.0"

;###########################################################################################################################################################################################
;Code for single instance

Global Const $SingeInstance = "c87e8274-07e6-40ab-b3d5-b605dc9f85b2"
;UUID will change to match version ID in the update file on my website. This means you can have multiple instances of different versions open. Not sure who wants this, but you're welcome :D

If WinExists($SingeInstance) Then
	MsgBox(0, $guiTitle, "Pack converter already running!" & @CRLF & "You can only have one instance open at a time.")
	Exit ; It's already running
EndIf

AutoItWinSetTitle($SingeInstance)

;###########################################################################################################################################################################################
;GUI

#Region ### START Koda GUI section ###
Global $gui_mainWindow = GUICreate("" & $guiTitle & "", 619, 221, -1, -1)
Global $gui_tabs = GUICtrlCreateTab(8, 8, 601, 145)
Global $gui_bedrockToJavaTab = GUICtrlCreateTabItem("Bedrock to Java")
Global $gui_jeDescTitle = GUICtrlCreateLabel("Pack Description:", 15, 80, 88, 17)
Global $gui_jeNameInput = GUICtrlCreateInput("Pack name here", 88, 48, 513, 21)
GUICtrlSetTip(-1, "Pack name")
Global $gui_jeDescInput = GUICtrlCreateInput("Pack description here", 112, 80, 489, 21)
GUICtrlSetTip(-1, "Pack description")
Global $gui_beLoadInfo = GUICtrlCreateButton("Load original pack info", 13, 122, 145, 25)
GUICtrlSetTip(-1, "Load original pack name and description")
Global $gui_startBeToJeBtn = GUICtrlCreateButton("Start conversion", 457, 122, 145, 25)
GUICtrlSetTip(-1, "Start conversion")
Global $gui_jeNameTitle = GUICtrlCreateLabel("Pack Name:", 16, 48, 63, 17)
Global $gui_javaToBedrockTab = GUICtrlCreateTabItem("Java to Bedrock")
Global $gui_bePackNameInput = GUICtrlCreateInput("Pack name here", 88, 48, 513, 21)
GUICtrlSetTip(-1, "Pack name")
Global $gui_bePackDescInput = GUICtrlCreateInput("Pack description here", 112, 80, 489, 21)
GUICtrlSetTip(-1, "Pack description")
Global $gui_jeLoadInfo = GUICtrlCreateButton("Load original pack info", 13, 122, 145, 25)
GUICtrlSetTip(-1, "Load original pack name and description")
Global $gui_beDescTitle = GUICtrlCreateLabel("Pack Description:", 15, 80, 88, 17)
Global $gui_startJeToBeBtn = GUICtrlCreateButton("Start conversion", 457, 122, 145, 25)
GUICtrlSetTip(-1, "Start conversion")
Global $gui_beNameTitle = GUICtrlCreateLabel("Pack Name:", 16, 48, 63, 17)
GUICtrlCreateTabItem("")
Global $gui_copyright = GUICtrlCreateLabel("Copyright © 2022 - 2023, TheAlienDoctor", 8, 200, 200, 17)
GUICtrlSetTip(-1, "Copyright notice")
GUICtrlSetCursor (-1, 0)
Global $gui_verNum = GUICtrlCreateLabel("Version: V1.4.0", 537, 200, 76, 17)
GUICtrlSetTip(-1, "Check for updates")
GUICtrlSetCursor (-1, 0)
Global $gui_github = GUICtrlCreateLabel("View source code,  report bugs and contribute on GitHub", 235, 200, 273, 17)
GUICtrlSetTip(-1, "Open GitHub repo")
GUICtrlSetCursor (-1, 0)
Global $gui_progressBar = GUICtrlCreateProgress(8, 168, 601, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;###########################################################################################################################################################################################
;Declare variables

Global $dateTime = @MDAY & '.' & @MON & '.' & @YEAR & '-' & @HOUR & '.' & @MIN & '.' & @SEC
Global $inputDir = @ScriptDir & "\" & IniRead("options.ini", "config", "InputDir", "input")
Global $repeats = IniRead("options.ini", "config", "repeats", 2)
Global $conversionCount = 0
Global $cancel = False

Global Const $currentVersionNumber = 140
Global Const $je_unsupportedVersions[3] = [1, 2, 3]

;Config file error checking
If IniRead("options.ini", "Bedrock to Java", "useCustomDir", "error") = "false" Then
	Global $javaDir = @ScriptDir & "\Java Pack"

ElseIf IniRead("options.ini", "Bedrock to Java", "useCustomDir", "error") = "true" Then
	Global $javaDir = IniRead("options.ini", "Bedrock to Java", "JavaDir", @ScriptDir & "Java-pack")

Else
	MsgBox(0, $guiTitle, "Error in config file: useCustomDir can only be set to true or false!")
	exitProgram()
	Exit
EndIf


If IniRead("options.ini", "Java to Bedrock", "useCustomDir", "false") = "false" Then
	Global $bedrockDir = @ScriptDir & "\Bedrock pack"

ElseIf IniRead("options.ini", "Java to Bedrock", "useCustomDir", "false") = "true" Then
	Global $bedrockDir = IniRead("options.ini", "Java to Bedrock", "BedrockDir", @ScriptDir & "\Bedrock Pack")

Else
	MsgBox(0, $guiTitle, "Error in config file: useCustomDir can only be set to true or false!")
	exitProgram()
	Exit
EndIf

If IniRead("options.ini", "logConfig", "CustomLogDir", "error") = "false" Then
	Global $logDir = @ScriptDir & "\logs"

ElseIf IniRead("options.ini", "logConfig", "CustomLogDir", "error") = "true" Then
	Global $logDir = IniRead("options.ini", "logConfig", "LogDir", @ScriptDir & "\logs")

Else
	MsgBox(0, $guiTitle, "Error in config file: CustomLogDir can only be set to true or false!")
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
			Global $updateMsgBox = MsgBox(4, $guiTitle, "There is a new update out now!" & @CRLF & $updateMsg & @CRLF & @CRLF & "Would you like to download it?")
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
				MsgBox(0, $guiTitle, "No new updates found")
			EndIf

		EndIf

	Else ;If ping is below 0 then update server is down, or user is not connected to the internet
		$NoInternetMsgBox = "clear variable"
		$NoInternetMsgBox = MsgBox(6, $guiTitle, "Warning: You are not connected to the internet or TheAlienDoctor.com is down. This means the update checker could not run. Continue?")
		logWrite(0, "Failed to connect to update server, unable to check for updates")
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
		MsgBox(0, $guiTitle, "Error in config file: autoCheckUpdates can only be set to true or false!")
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
	FileWrite($logDir & "\log.latest", @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & $content & @CRLF)
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

Func GuiDisable()
	GuiCtrlSetState($gui_jeDescInput, $GUI_DISABLE)
	GuiCtrlSetState($gui_bePackDescInput, $GUI_DISABLE)
	GuiCtrlSetState($gui_jeNameInput, $GUI_DISABLE)
	GuiCtrlSetState($gui_bePackNameInput, $GUI_DISABLE)
	GuiCtrlSetState($gui_startBeToJeBtn, $GUI_DISABLE)
	GuiCtrlSetState($gui_startJeToBeBtn, $GUI_DISABLE)
	GuiCtrlSetState($gui_jeLoadInfo, $GUI_DISABLE)
	GuiCtrlSetState($gui_beLoadInfo, $GUI_DISABLE)
EndFunc   ;==>GuiDisable

Func GuiEnable()
	GuiCtrlSetState($gui_jeDescInput, $GUI_ENABLE)
	GuiCtrlSetState($gui_bePackDescInput, $GUI_ENABLE)
	GuiCtrlSetState($gui_jeNameInput, $GUI_ENABLE)
	GuiCtrlSetState($gui_bePackNameInput, $GUI_ENABLE)
	GuiCtrlSetState($gui_startBeToJeBtn, $GUI_ENABLE)
	GuiCtrlSetState($gui_startJeToBeBtn, $GUI_ENABLE)
	GuiCtrlSetState($gui_jeLoadInfo, $GUI_ENABLE)
	GuiCtrlSetState($gui_beLoadInfo, $GUI_ENABLE)
EndFunc   ;==>GuiEnable

Func loadInfo()
	logWrite(0, "Began loading original pack information")
	If FileExists($inputDir & "\manifest.json") Then ;Bedrock Pack
		logWrite(0, "Detected manifest.json")
		Local $file = FileRead($inputDir & "\manifest.json")
		Local $decoded_json = Json_Decode($file)
		Local $name = Json_Get($decoded_json, '["header"]["name"]')
		Local $description = Json_Get($decoded_json, '["header"]["description"]')
		logWrite(0, "Decoded json")
		GUICtrlSetData($gui_jeNameInput, $name)
		GUICtrlSetData($gui_jeDescInput, $description)
		logWrite(0, "Loaded original pack info")
	ElseIf FileExists($inputDir & "\pack.mcmeta") Then ;Java Pack
		logWrite(0, "Detected pack.mcmeta")
		Local $file = FileRead($inputDir & "\pack.mcmeta")
		Local $decoded_json = Json_Decode($file)
		Local $description = Json_Get($decoded_json, '["pack"]["description"]')
		logWrite(0, "Decoded json")
		GUICtrlSetData($gui_bePackDescInput, $description)
		logWrite(0, "Loaded original pack info")
	Else
		logWrite(0, "Error: Unable to find manifest.json or pack.mcmeta")
		MsgBox(0, $guiTitle, "Error: Unable to find manifest.json or pack.mcmeta")
	EndIf
EndFunc   ;==>loadInfo

Func compatCheck() ;Check compatibility
	logWrite(0, "Began checking input pack compatibility")
	Global $compatible_result = True

	If FileExists($inputDir & "\pack_manifest.json") Then ;Outdated Bedrock pack manifest
		logWrite(0, "Detected pack_manifest.json, which is an outdated version of the up to date manifest.json") ;
		Global $compatible_result = False
		logWrite(0, "Pack compatible result: " & $compatible_result)
	ElseIf FileExists($inputDir & "\manifest.json") Then ;Everything should be fine, Bedrock resource packs haven't undergone major updates like Java, except when they were first released.
		Global $compatible_result = True ;...and back then the manifest.json was called pack_manifest.json, which makes it very easy to check.
		Return
	ElseIf FileExists($inputDir & "\pack.mcmeta") Then ;Java pack
		logWrite(0, "Detected pack.mcmeta")
		logWrite(0, "Detected pack.mcmeta")
		Local $file = FileRead($inputDir & "\pack.mcmeta")
		Local $decoded_json = Json_Decode($file)
		Local $pack_version = Json_Get($decoded_json, '["pack"]["pack_format"]')
		logWrite(0, "Decoded json")
		For $index = 0 to 2
			If $pack_version = $je_unsupportedVersions[$index] Then
				Global $compatible_result = False
			Else
				Global $compatible_result = True
			EndIf
		Next
		logWrite(0, "Pack compatible result: " & $compatible_result)
	Else
		logWrite(0, "Error: Unable to find manifest.json or pack.mcmeta")
		MsgBox(0, $guiTitle, "Error: Unable to find manifest.json or pack.mcmeta")
	EndIf

EndFunc   ;==>compatCheck

;###########################################################################################################################################################################################
;Other conversion functions

Func convert($mode, $conversionArray, $arrayDataCount, $gui_progressBarPercent)
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

	GUICtrlSetData($gui_progressBar, $gui_progressBarPercent)

EndFunc   ;==>convert

Func convertAnime() ;Converts animated block textures
	Global $animeCount = 0
	For $index = 0 To 25
		Local $current = $animeTextures1[$index]

		If FileExists($javaDir & "\pack\assets\minecraft\textures\block\" & $current[0]) Then
			FileOpen($javaDir & "\pack\assets\minecraft\textures\block\" & $current[0] & ".mcmeta")
			FileWrite($javaDir & "\pack\assets\minecraft\textures\block\" & $current[0] & ".mcmeta", $current[1])
			FileClose($javaDir & "\pack\assets\minecraft\textures\block\" & $current[0] & ".mcmeta")
			logWrite(0, "Found file " & $javaDir & "\pack\assets\minecraft\textures\block\" & $current[0] & " and generated a .mcmeta file for it")
			$animeCount += 1
		Else
			logWrite(0, "Could not find animated file " & $javaDir & "\pack\assets\minecraft\textures\block\" & $current[0] & " so did not generate an .mcmeta file.")
		EndIf
	Next

	For $index = 0 To 19
		Local $current = $animeTextures2[$index]

		If FileExists($javaDir & "\pack\assets\minecraft\textures\block\" & $current[0]) Then
			FileOpen($javaDir & "\pack\assets\minecraft\textures\block\" & $current[0] & ".mcmeta")
			FileWrite($javaDir & "\pack\assets\minecraft\textures\block\" & $current[0] & ".mcmeta", $current[1])
			FileClose($javaDir & "\pack\assets\minecraft\textures\block\" & $current[0] & ".mcmeta")
			logWrite(0, "Found file " & $javaDir & "\pack\assets\minecraft\textures\block\" & $current[0] & " and generated a .mcmeta file for it")
			$animeCount += 1
		Else
			logWrite(0, "Could not find animated file " & $javaDir & "\pack\assets\minecraft\textures\block\" & $current[0] & " so did not generate an .mcmeta file.")
		EndIf
	Next
EndFunc   ;==>convertAnime

Func convertPackIcon()
	If FileExists($inputDir & "\pack_icon.png") Then ;Bedrock Pack
		FileMove($inputDir & "\pack_icon.png", $javaDir & "\pack\pack.png", 8)
		logWrite(0, "Converted pack icon")
		$conversionCount += 1
	ElseIf FileExists($inputDir & "\pack.png") Then ;Java Pack
		FileMove($inputDir & "\pack.png", $bedrockDir & "\pack\pack_icon.png", 8)
		logWrite(0, "Converted pack icon")
		$conversionCount += 1
	Else
		logWrite(0, "Pack Icon not found!")
	EndIf
EndFunc   ;==>convertPackIcon

;###########################################################################################################################################################################################
;Main conversion functions

Func bedrockToJava()
	GUICtrlSetData($gui_progressBar, 0)
	Local $confirmBox = MsgBox(1, $guiTitle, "Are you sure you want to start conversion? This will delete everything inside the " & $javaDir & " folder, so make sure you have removed any previous packs from it.")
	If $confirmBox = 1 Then

		logWrite(1, "Began converting Bedrock to Java")
		GuiDisable()

		compatCheck()
		If $compatible_result = False Then
			logWrite(0, "Outdated pack version detected")
			$incompatible_msg = MsgBox(4, $guiTitle, "Error: Outdated pack version detected!" & @CRLF & "The input pack may not convert properly due to being made for an older version of Minecraft" & @CRLF & "Continue?")
			If $incompatible_msg = 6 Then
				;Do nothing, continue with pack conversion
				logWrite(0, "Continued pack conversion")
			ElseIf $incompatible_msg = 7 Then
				logWrite(3, "Pack conversion aborted due to outdated version")
				GuiEnable()
				Return ;Stop function
			EndIf
		EndIf

		Local $javaPackName = GUICtrlRead($gui_jeNameInput)
		Local $javaPackDesc = GUICtrlRead($gui_jeDescInput)
		Global $conversionCount = 0
		Local $timesRan = 0

		DirRemove($javaDir, 1)
		DirCreate($javaDir & "\pack")

		logWrite(0, "Generating pack.mcmeta file")
		GUICtrlSetData($gui_progressBar, 5)

		Local $conf_javaPackFormat = IniRead("options.ini", "Bedrock to Java", "pack_format", "15")

		FileOpen($javaDir & "\pack\pack.txt", 8)
		FileWrite($javaDir & '\pack\pack.txt', '{"pack":{"pack_format":' & $conf_javaPackFormat & ',"description":"' & $javaPackDesc & '"}}')
		FileClose($javaDir & "\pack\pack.txt")
		FileMove($javaDir & "\pack\pack.txt", $javaDir & "\pack\pack.mcmeta")

		GUICtrlSetData($gui_progressBar, 10)

		logWrite(0, "Generated pack.mcmeta file")
		logWrite(0, "Beginning texture file conversion")

		While $timesRan < $repeats
			If $cancel = True Then
				GuiEnable()
			EndIf

			convert(0, $blockTextures1, 49, 11)
			convert(0, $blockTextures2, 48, 12)
			convert(0, $blockTextures3, 46, 13)
			convert(0, $blockTextures4, 48, 14)
			convert(0, $blockTextures5, 48, 15)
			convert(0, $blockTextures6, 48, 16)
			convert(0, $blockTextures7, 48, 17)
			convert(0, $blockTextures8, 48, 18)
			convert(0, $blockTextures9, 48, 19)
			convert(0, $blockTextures10, 47, 20)
			convert(0, $blockTextures11, 48, 21)
			convert(0, $blockTextures12, 48, 22)
			convert(0, $blockTextures13, 48, 23)
			convert(0, $blockTextures14, 48, 24)
			convert(0, $blockTextures15, 48, 25)
			convert(0, $blockTextures16, 48, 26)
			convert(0, $blockTextures17, 4, 27)
			convert(0, $blockTextures18, 43, 28)
			convert(0, $blockTextures19, 44, 29)
			convert(0, $blockTextures20, 44, 30)

			convert(0, $colorMapTextures, 2, 31)

			convert(0, $itemTextures1, 86, 32)
			convert(0, $itemTextures2, 85, 33)
			convert(0, $itemTextures3, 85, 34)
			convert(0, $itemTextures4, 85, 35)
			convert(0, $itemTextures5, 21, 36)
			convert(0, $itemTextures6, 30, 37)
			convert(0, $itemTextures7, 31, 38)

			convert(0, $entityTextures1, 94, 39)
			convert(0, $entityTextures2, 92, 40)
			convert(0, $entityTextures3, 57, 41)
			convert(0, $entityTextures4, 43, 42)
			convert(0, $entityTextures5, 19, 43)

			convert(0, $environmentTextures, 12, 43)

			convert(0, $armorTextures, 11, 44)

			convert(0, $guiTextures, 8, 45)

			convert(0, $trimTextures, 48, 46)
			$timesRan += 1
			logWrite(1, "Texture conversion function ran " & $timesRan & "/" & $repeats)
		WEnd

		convertAnime()

		GUICtrlSetData($gui_progressBar, 47)

		convertPackIcon()

		GUICtrlSetData($gui_progressBar, 48)

		logWrite(0, "Generated " & $animeCount & " .mcmeta files for animated textures.")
		logWrite(0, "Finished converting files! Converted " & $conversionCount & " files!")
		logWrite(0, "Creating pack.zip file")

		GUICtrlSetData($gui_progressBar, 50)

		_Zip_Create($javaDir & "\pack.zip")

		logWrite(0, "Created pack.zip file")
		logWrite(0, "Adding files to pack.zip file")

		_Zip_AddFolderContents($javaDir & "\pack.zip", $javaDir & "\pack", 0)

		logWrite(0, "Finished adding files to pack.zip!")
		GUICtrlSetData($gui_progressBar, 60)

		FileMove($javaDir & "\pack.zip", $javaDir & "\" & $javaPackName & ".zip")

		logWrite(0, ".zip folder renamed!")
		logWrite(0, "Bedrock to Java pack conversion complete!")
		GUICtrlSetData($gui_progressBar, 70)
		MsgBox(0, $guiTitle, "Conversion complete! Converted " & $conversionCount & " files to Java edition!")
		GUICtrlSetData($gui_progressBar, 80)
	Else
		logWrite(0, "Conversion aborted")
	EndIf

	GUICtrlSetData($gui_progressBar, 100)
	GuiEnable()
EndFunc   ;==>bedrockToJava

Func javaToBedrock()
	GUICtrlSetData($gui_progressBar, 0)
	Local $confirmBox = MsgBox(1, $guiTitle, "Are you sure you want to start conversion? This will delete everything inside the " & $bedrockDir & " folder, so make sure you have removed any previous packs from it.")

	If $confirmBox = 1 Then
		logWrite(1, "Began converting Java to Bedrock")
		GuiDisable()

		compatCheck()
		If $compatible_result = False Then
			logWrite(0, "Outdated pack version detected")
			$incompatible_msg = MsgBox(4, $guiTitle, "Error: Outdated pack version detected!" & @CRLF & "The input pack may not convert properly due to being made for an older version of Minecraft" & @CRLF & "Continue?")
			If $incompatible_msg = 6 Then
				;Do nothing, continue with pack conversion
				logWrite(0, "Continued pack conversion")
			ElseIf $incompatible_msg = 7 Then
				logWrite(3, "Pack conversion aborted due to outdated version")
				GuiEnable()
				Return ;Stop function
			EndIf
		EndIf

		Local $bedrockPackName = GUICtrlRead($gui_bePackNameInput)
		Local $bedrockPackDesc = GUICtrlRead($gui_bePackDescInput)
		Global $conversionCount = 0
		Local $timesRan = 0

		DirRemove($bedrockDir, 1)
		DirCreate($bedrockDir & "\pack")

		logWrite(0, "Generating manifest.json file")
		GUICtrlSetData($gui_progressBar, 5)

		Local $conf_bedrockMinEngineVersion = IniRead("options.ini", "Java to Bedrock", "min_engine_version", "1,20,0")
		Local $conf_bedrockPackVersion = IniRead("options.ini", "Java to Bedrock", "pack_version", "1,0,0")

		FileOpen($bedrockDir & "\pack\manifest.txt", 8)
		FileWrite($bedrockDir & '\pack\manifest.txt', '{"format_version":2,"header":{"description":"' & $bedrockPackDesc & ' | §9Converted to from Java to Bedrock using Aliens pack converter §r | §eDownload pack converter from TheAlienDoctor.com §r","name":"' & $bedrockPackName & '","uuid":"' & uuidGenerator() & '","version":[' & $conf_bedrockPackVersion & '],"min_engine_version":[' & $conf_bedrockMinEngineVersion & ']},"modules":[{"description":"' & $bedrockPackDesc & ' | §9Converted to from Java to Bedrock using Aliens pack converter §r | §eDownload pack converter from TheAlienDoctor.com §r","type":"resources","uuid":"' & uuidGenerator() & '","version":[' & $conf_bedrockPackVersion & ']}]}')
		FileClose($bedrockDir & "\pack\manifest.txt")
		FileMove($bedrockDir & "\pack\manifest.txt", $bedrockDir & "\pack\manifest.json")

		GUICtrlSetData($gui_progressBar, 10)

		logWrite(0, "Generated manifest.json file")
		logWrite(0, "Beginning texture file conversion")

		While $timesRan < $repeats
			convert(1, $blockTextures1, 49, 11)
			convert(1, $blockTextures2, 48, 12)
			convert(1, $blockTextures3, 46, 13)
			convert(1, $blockTextures4, 48, 14)
			convert(1, $blockTextures5, 48, 15)
			convert(1, $blockTextures6, 48, 16)
			convert(1, $blockTextures7, 48, 17)
			convert(1, $blockTextures8, 48, 18)
			convert(1, $blockTextures9, 48, 19)
			convert(1, $blockTextures10, 47, 20)
			convert(1, $blockTextures11, 48, 21)
			convert(1, $blockTextures12, 48, 22)
			convert(1, $blockTextures13, 48, 23)
			convert(1, $blockTextures14, 48, 24)
			convert(1, $blockTextures15, 48, 25)
			convert(1, $blockTextures16, 48, 26)
			convert(1, $blockTextures17, 4, 27)
			convert(1, $blockTextures18, 43, 28)
			convert(1, $blockTextures19, 44, 29)
			convert(1, $blockTextures20, 44, 30)

			convert(1, $colorMapTextures, 2, 31)

			convert(1, $itemTextures1, 86, 32)
			convert(1, $itemTextures2, 85, 33)
			convert(1, $itemTextures3, 85, 34)
			convert(1, $itemTextures4, 85, 35)
			convert(1, $itemTextures5, 21, 36)
			convert(1, $itemTextures6, 30, 37)
			convert(1, $itemTextures7, 31, 38)

			convert(1, $entityTextures1, 94, 39)
			convert(1, $entityTextures2, 92, 40)
			convert(1, $entityTextures3, 57, 41)
			convert(1, $entityTextures4, 43, 42)
			convert(1, $entityTextures5, 19, 43)

			convert(1, $environmentTextures, 12, 43)

			convert(1, $armorTextures, 11, 44)

			convert(1, $guiTextures, 8, 45)

			convert(1, $trimTextures, 48, 46)
			$timesRan += 1
			logWrite(1, "Texture conversion function ran " & $timesRan & "/" & $repeats)
		WEnd

		convertPackIcon()

		GUICtrlSetData($gui_progressBar, 47)

		logWrite(0, "Finished converting files! Converted " & $conversionCount & " files!")
		logWrite(0, "Creating .mcpack file")

		GUICtrlSetData($gui_progressBar, 50)

		_Zip_Create($bedrockDir & "\" & $bedrockPackName & ".zip")

		logWrite(0, "Created pack.zip file")
		logWrite(0, "Adding files to pack.zip file")

		_Zip_AddFolderContents($bedrockDir & "\" & $bedrockPackName & ".zip", $bedrockDir & "\pack\", 1)

		logWrite(0, "Finished adding files to pack.zip!")
		GUICtrlSetData($gui_progressBar, 60)

		FileMove($bedrockDir & "\" & $bedrockPackName & ".zip", $bedrockDir & "\" & $bedrockPackName & ".mcpack")

		logWrite(0, ".zip folder renamed!")
		logWrite(3, "Java to Bedrock pack conversion complete!")
		GUICtrlSetData($gui_progressBar, 70)

		MsgBox(0, $guiTitle, "Conversion complete! Converted " & $conversionCount & " files to Bedrock edition!")
		GUICtrlSetData($gui_progressBar, 80)
	Else
		logWrite(0, "Conversion aborted")
	EndIf
	GuiEnable()
	GUICtrlSetData($gui_progressBar, 100)
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

		Case $gui_beLoadInfo
			loadInfo()

		Case $gui_jeLoadInfo
			loadInfo()

		Case $gui_startBeToJeBtn
			bedrockToJava()

		Case $gui_startJeToBeBtn
			javaToBedrock()

		Case $gui_copyright
			If FileExists(@ScriptDir & "\LICENSE.txt") = 0 Then
				InetGet("https://thealiendoctor.com/software-license/pack-converter-2022.txt", @ScriptDir & "\LICENSE.txt")
				logWrite(0, "Re-downloaded license")
				ShellExecute(@ScriptDir & "\LICENSE.txt")
			ElseIf FileExists(@ScriptDir & "\LICENSE.txt") Then
				ShellExecute(@ScriptDir & "\LICENSE.txt")
			EndIf

		Case $gui_github
			ShellExecute("https://github.com/TheAlienDoctor/minecraft-resource-pack-converter")

		Case $gui_verNum
			checkForUpdates(1)

	EndSwitch
WEnd
