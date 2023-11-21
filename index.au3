#pragma compile(Compatibility, XP, vista, win7, win8, win81, win10, win11)
#pragma compile(FileDescription, Alien's Minecraft resource pack converter)
#pragma compile(ProductName, Alien's Minecraft resource pack converter)
#pragma compile(ProductVersion, 1.4.0)
#pragma compile(FileVersion, 1.4.0)
#pragma compile(LegalCopyright, ©TheAlienDoctor)
#pragma compile(CompanyName, TheAlienDoctor)
#pragma compile(OriginalFilename, AliensPackConverter-V1.4.0)

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>

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

#Region ### START Koda GUI section ### Form=d:\code\minecraft-resource-pack-converter\gui.kxf
Global $gui_mainWindow = GUICreate("" & $guiTitle & "", 618, 340, -1, -1)
Global $gui_tabs = GUICtrlCreateTab(8, 0, 601, 289)
Global $gui_convertTab = GUICtrlCreateTabItem("Convert")
GUICtrlSetTip(-1, "")
Global $gui_packInfoGroup = GUICtrlCreateGroup("Pack Info", 24, 32, 569, 89)
Global $gui_packNameTitle = GUICtrlCreateLabel("Pack Name:", 32, 56, 63, 17)
Global $gui_packNameInput = GUICtrlCreateInput("Pack Name", 104, 56, 481, 21)
Global $gui_packDescriptionTitle = GUICtrlCreateLabel("Pack Description:", 32, 88, 88, 17)
Global $gui_packDescriptionInput = GUICtrlCreateInput("Pack Description", 128, 88, 457, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_packTypeGroup = GUICtrlCreateGroup("Pack Type", 24, 128, 569, 81)
Global $gui_beToJeBox = GUICtrlCreateCheckbox("Bedrock to Java", 32, 152, 97, 17)
Global $gui_jeToBeBox = GUICtrlCreateCheckbox("Java to Bedrock", 32, 176, 97, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_startBtn = GUICtrlCreateButton("Start Conversion", 160, 248, 139, 33)
Global $gui_loadInfoBtn = GUICtrlCreateButton("Load Original Pack Info", 16, 248, 139, 33)
Global $gui_checkForUpdatesBtn = GUICtrlCreateButton("Check For Updates", 464, 248, 139, 33)
Global $gui_settingsTab = GUICtrlCreateTabItem("Settings")
Global $gui_customLogDirInput = GUICtrlCreateInput("", 152, 32, 441, 21)
Global $gui_saveSettingsBtn = GUICtrlCreateButton("Save Settings", 496, 248, 105, 33)
Global $gui_customLogDirBox = GUICtrlCreateCheckbox("Custom Log Directory:", 16, 32, 129, 17)
Global $gui_customOutputDirBox = GUICtrlCreateCheckbox("Custom Output Directory:", 16, 64, 137, 17)
Global $gui_customOutputDirInput = GUICtrlCreateInput("", 160, 64, 433, 21)
Global $gui_bedrockSettingsGroup = GUICtrlCreateGroup("Bedrock Output Settings", 16, 160, 290, 121)
Global $gui_packMinVerTitle = GUICtrlCreateLabel("Minimuim Minecraft Version:", 24, 184, 135, 17)
Global $gui_packMinVerInput = GUICtrlCreateInput("", 168, 184, 129, 21)
Global $gui_OutputAsMcpackBox = GUICtrlCreateCheckbox("Output as .mcpack", 24, 248, 177, 17)
Global $gui_packVerTitle = GUICtrlCreateLabel("Pack Version:", 24, 216, 70, 17)
Global $gui_packVerInput = GUICtrlCreateInput("", 104, 216, 193, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_javaSettingsGroup = GUICtrlCreateGroup("Java Output Settings", 312, 160, 290, 81)
Global $gui_packFormatTitle = GUICtrlCreateLabel("Pack Format version:", 320, 184, 104, 17)
Global $gui_outputAsZipBox = GUICtrlCreateCheckbox("Output as .zip", 320, 208, 121, 17)
Global $gui_packFormatInput = GUICtrlCreateInput("", 432, 184, 161, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_outputWithFolderBox = GUICtrlCreateCheckbox("Output with Folder", 16, 128, 113, 17)
Global $gui_repeatsTitle = GUICtrlCreateLabel("Repeat Conversions:", 408, 128, 103, 17)
Global $gui_checkUpdatesBox = GUICtrlCreateCheckbox("Check for updates on startup", 200, 128, 161, 17)
Global $gui_customInputDirBox = GUICtrlCreateCheckbox("Custom Input Directory:", 16, 96, 137, 17)
Global $gui_customInputDirInput = GUICtrlCreateInput("", 152, 96, 441, 21)
Global $gui_repeatsInput = GUICtrlCreateInput("", 520, 128, 73, 21)
GUICtrlSetTip(-1, "Settings")
GUICtrlCreateTabItem("")
Global $gui_copyright = GUICtrlCreateLabel("Copyright © 2022 - 2023, TheAlienDoctor", 8, 320, 200, 17)
GUICtrlSetTip(-1, "Copyright notice")
GUICtrlSetCursor(-1, 0)
Global $gui_verNum = GUICtrlCreateLabel("Version: V1.4.0", 537, 320, 76, 17)
GUICtrlSetTip(-1, "Check for updates")
GUICtrlSetCursor(-1, 0)
Global $gui_github = GUICtrlCreateLabel("View source code, report bugs and contribute on GitHub", 235, 320, 270, 17)
GUICtrlSetTip(-1, "Open GitHub repo")
GUICtrlSetCursor(-1, 0)
Global $gui_progressBar = GUICtrlCreateProgress(8, 296, 601, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;###########################################################################################################################################################################################
;Declare variables

Global $dateTime = @MDAY & '.' & @MON & '.' & @YEAR & '-' & @HOUR & '.' & @MIN & '.' & @SEC
Global $settingsFile = @ScriptDir & "\settings.ini"
Global $conversionCount = 0
Global $cancel = False

Global Const $currentVersionNumber = 140
Global Const $je_unsupportedVersions[3] = [1, 2, 3]

;###########################################################################################################################################################################################
;Functions

Func loadSettings()
	Global $cfg_useCustomLogDir = IniRead($settingsFile, "general", "useCustomLogDir", "empty")
	If $cfg_useCustomLogDir = "True" Then
		GUICtrlSetState($gui_customLogDirBox, $GUI_CHECKED)
	ElseIf $cfg_useCustomLogDir = "False" Then
		GUICtrlSetState($gui_customLogDirBox, $GUI_UNCHECKED)
	EndIf

	Global $cfg_customLogDir = IniRead($settingsFile, "general", "customLogDir", "empty")
	GUICtrlSetData($gui_customLogDirInput, $cfg_customLogDir)

	Global $cfg_useCustomOutputDir = IniRead($settingsFile, "general", "useCustomOutputDir", "empty")
	If $cfg_useCustomOutputDir = "True" Then
		GUICtrlSetState($gui_customOutputDirBox, $GUI_CHECKED)
	ElseIf $cfg_useCustomOutputDir = "False" Then
		GUICtrlSetState($gui_customOutputDirBox, $GUI_UNCHECKED)
	EndIf

	Global $cfg_customOutputDir = IniRead($settingsFile, "general", "customOutputDir", "empty")
	GUICtrlSetData($gui_customOutputDirInput, $cfg_customOutputDir)

	Global $cfg_useCustomInputDir = IniRead($settingsFile, "general", "useCustomInputDir", "empty")
	If $cfg_useCustomInputDir = "True" Then
		GUICtrlSetState($gui_customInputDirBox, $GUI_CHECKED)
	ElseIf $cfg_useCustomInputDir = "False" Then
		GUICtrlSetState($gui_customInputDirBox, $GUI_UNCHECKED)
	EndIf

	Global $cfg_customInputDir = IniRead($settingsFile, "general", "customInputDir", "empty")
	GUICtrlSetData($gui_customInputDirInput, $cfg_customInputDir)

	Global $cfg_repeats = IniRead($settingsFile, "general", "repeats", "empty")
	GUICtrlSetData($gui_repeatsInput, $cfg_repeats)

	Global $cfg_outputWithFolder = IniRead($settingsFile, "general", "outputWithFolder", "empty")
	If $cfg_outputWithFolder = "True" Then
		GUICtrlSetState($gui_outputWithFolderBox, $GUI_CHECKED)
	ElseIf $cfg_outputWithFolder = "False" Then
		GUICtrlSetState($gui_outputWithFolderBox, $GUI_UNCHECKED)
	EndIf

	Global $cfg_checkForUpdates = IniRead($settingsFile, "general", "checkForUpdates", "empty")
	If $cfg_checkForUpdates = "True" Then
		GUICtrlSetState($gui_checkUpdatesBox, $GUI_CHECKED)
	ElseIf $cfg_checkForUpdates = "False" Then
		GUICtrlSetState($gui_checkUpdatesBox, $GUI_UNCHECKED)
	EndIf

	Global $cfg_packFormatVer = IniRead($settingsFile, "java", "packFormatVer", "empty")
	GUICtrlSetData($gui_packFormatInput, $cfg_packFormatVer)

	Global $cfg_outputAsZip = IniRead($settingsFile, "java", "outputAsZip", "empty")
	If $cfg_outputAsZip = "True" Then
		GUICtrlSetState($gui_outputAsZipBox, $GUI_CHECKED)
	ElseIf $cfg_outputAsZip = "False" Then
		GUICtrlSetState($gui_outputAsZipBox, $GUI_UNCHECKED)
	EndIf

	Global $cfg_packMinVer = IniRead($settingsFile, "bedrock", "packMinVer", "empty")
	GUICtrlSetData($gui_packMinVerInput, $cfg_packMinVer)

	Global $cfg_outputAsMcpack = IniRead($settingsFile, "bedrock", "outputAsMcpack", "empty")
	If $cfg_outputAsMcpack = "True" Then
		GUICtrlSetState($gui_OutputAsMcpackBox, $GUI_CHECKED)
	ElseIf $cfg_outputAsMcpack = "False" Then
		GUICtrlSetState($gui_OutputAsMcpackBox, $GUI_UNCHECKED)
	EndIf

	reloadSettings()
EndFunc   ;==>loadSettings

Func saveSettings()

	GUICtrlSetData($gui_progressBar, 0)

	If GUICtrlRead($gui_customLogDirBox) = 1 Then
		$cfg_useCustomLogDir = "True"
	ElseIf GUICtrlRead($gui_customLogDirBox) = 4 Then
		$cfg_useCustomLogDir = "False"
	EndIf
	IniWrite($settingsFile, "general", "useCustomLogDir", $cfg_useCustomLogDir)
	GUICtrlSetData($gui_progressBar, 7)

	$cfg_customLogDir = GUICtrlRead($gui_customLogDirInput)
	IniWrite($settingsFile, "general", "customLogDir", $cfg_customLogDir)
	GUICtrlSetData($gui_progressBar, 14)

	If GUICtrlRead($gui_customOutputDirBox) = 1 Then
		$cfg_useCustomOutputDir = "True"
	ElseIf GUICtrlRead($gui_customOutputDirBox) = 4 Then
		$cfg_useCustomOutputDir = "False"
	EndIf
	IniWrite($settingsFile, "general", "useCustomOutputDir", $cfg_useCustomOutputDir)
	GUICtrlSetData($gui_progressBar, 21)

	$cfg_customOutputDir = GUICtrlRead($gui_customOutputDirInput)
	IniWrite($settingsFile, "general", "customOutputDir", $cfg_customOutputDir)
	GUICtrlSetData($gui_progressBar, 28)

	If GUICtrlRead($gui_customInputDirBox) = 1 Then
		$cfg_useCustomInputDir = "True"
	ElseIf GUICtrlRead($gui_customInputDirBox) = 4 Then
		$cfg_useCustomInputDir = "False"
	EndIf
	IniWrite($settingsFile, "general", "useCustomInputDir", $cfg_useCustomInputDir)
	GUICtrlSetData($gui_progressBar, 35)

	$cfg_customInputDir = GUICtrlRead($gui_customInputDirInput)
	IniWrite($settingsFile, "general", "customInputDir", $cfg_customInputDir)
	GUICtrlSetData($gui_progressBar, 42)

	$cfg_repeats = GUICtrlRead($gui_repeatsInput)
	IniWrite($settingsFile, "general", "repeats", $cfg_repeats)
	GUICtrlSetData($gui_progressBar, 49)

	If GUICtrlRead($gui_outputWithFolderBox) = 1 Then
		$cfg_outputWithFolder = "True"
	ElseIf GUICtrlRead($gui_outputWithFolderBox) = 4 Then
		$cfg_outputWithFolder = "False"
	EndIf
	IniWrite($settingsFile, "general", "outputWithFolder", $cfg_outputWithFolder)
	GUICtrlSetData($gui_progressBar, 56)

	If GUICtrlRead($gui_checkUpdatesBox) = 1 Then
		$cfg_checkForUpdates = "True"
	ElseIf GUICtrlRead($gui_checkUpdatesBox) = 4 Then
		$cfg_checkForUpdates = "False"
	EndIf
	IniWrite($settingsFile, "general", "checkForUpdates", $cfg_checkForUpdates)
	GUICtrlSetData($gui_progressBar, 63)

	$cfg_packFormatVer = GUICtrlRead($gui_packFormatInput)
	IniWrite($settingsFile, "java", "packFormatVer", $cfg_packFormatVer)
	GUICtrlSetData($gui_progressBar, 70)

	If GUICtrlRead($gui_outputAsZipBox) = 1 Then
		$cfg_outputAsZip = "True"
	ElseIf GUICtrlRead($gui_outputAsZipBox) = 4 Then
		$cfg_outputAsZip = "False"
	EndIf
	IniWrite($settingsFile, "java", "outputAsZip", $cfg_outputAsZip)
	GUICtrlSetData($gui_progressBar, 77)

	$cfg_packMinVer = GUICtrlRead($gui_packMinVerInput)
	IniWrite($settingsFile, "bedrock", "packMinVer", $cfg_packMinVer)
	GUICtrlSetData($gui_progressBar, 84)

	If GUICtrlRead($gui_OutputAsMcpackBox) = 1 Then
		$cfg_outputAsMcpack = "True"
	ElseIf GUICtrlRead($gui_OutputAsMcpackBox) = 4 Then
		$cfg_outputAsMcpack = "False"
	EndIf
	IniWrite($settingsFile, "bedrock", "outputAsMcpack", $cfg_outputAsMcpack)
	GUICtrlSetData($gui_progressBar, 100)

	MsgBox(0, $guiTitle, "Your settings have been saved!")
	GUICtrlSetData($gui_progressBar, 0)
	reloadSettings()
EndFunc   ;==>saveSettings

Func reloadSettings()
	If $cfg_useCustomOutputDir = "True" Then
		Global $outputDir = $cfg_customOutputDir
	ElseIf $cfg_useCustomOutputDir = "False" Then
		Global $outputDir = @ScriptDir & "\output"
	EndIf

	If $cfg_useCustomInputDir = "True" Then
		Global $inputDir = $cfg_customInputDir
	ElseIf $cfg_useCustomInputDir = "False" Then
		Global $inputDir = @ScriptDir & "\input"
	EndIf

	If $cfg_useCustomLogDir = "True" Then
		Global $logDir = $cfg_customLogDir
	ElseIf $cfg_useCustomLogDir = "False" Then
		Global $logDir = @ScriptDir & "\logs"
	EndIf
EndFunc   ;==>reloadSettings

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

Func startUp() ;Function to be ran on startup (excluding create logs and load settings functions)

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

	If $cfg_checkForUpdates = "True" Then
		checkForUpdates(0)
	ElseIf $cfg_checkForUpdates = "False" Then
		logWrite(0, "Auto update check is disabled")
		MsgBox(0, $guiTitle, "Auto update check is disabled - this is not recommended!")
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
	GuiCtrlSetState($gui_packNameInput, $GUI_DISABLE)
	GuiCtrlSetState($gui_packDescriptionInput, $GUI_DISABLE)
	GuiCtrlSetState($gui_beToJeBox, $GUI_DISABLE)
	GuiCtrlSetState($gui_jeToBeBox, $GUI_DISABLE)
	GuiCtrlSetState($gui_loadInfoBtn, $GUI_DISABLE)
	GuiCtrlSetState($gui_startBtn, $GUI_DISABLE)
	GuiCtrlSetState($gui_checkForUpdatesBtn, $GUI_DISABLE)

	GUICtrlSetState($gui_customLogDirBox, $GUI_DISABLE)
	GUICtrlSetState($gui_customLogDirInput, $GUI_DISABLE)
	GUICtrlSetState($gui_customOutputDirBox, $GUI_DISABLE)
	GUICtrlSetState($gui_customOutputDirInput, $GUI_DISABLE)
	GUICtrlSetState($gui_customInputDirBox, $GUI_DISABLE)
	GUICtrlSetState($gui_customInputDirInput, $GUI_DISABLE)
	GUICtrlSetState($gui_outputWithFolderBox, $GUI_DISABLE)
	GUICtrlSetState($gui_checkUpdatesBox, $GUI_DISABLE)
	GUICtrlSetState($gui_repeatsInput, $GUI_DISABLE)
	GUICtrlSetState($gui_packMinVerInput, $GUI_DISABLE)
	GUICtrlSetState($gui_packVerInput, $GUI_DISABLE)
	GUICtrlSetState($gui_OutputAsMcpackBox, $GUI_DISABLE)
	GUICtrlSetState($gui_packFormatInput, $GUI_DISABLE)
	GUICtrlSetState($gui_outputAsZipBox, $GUI_DISABLE)
	GUICtrlSetState($gui_saveSettingsBtn, $GUI_DISABLE)
EndFunc   ;==>GuiDisable

Func GuiEnable()
	;Convert tab
	GuiCtrlSetState($gui_packNameInput, $GUI_ENABLE)
	GuiCtrlSetState($gui_packDescriptionInput, $GUI_ENABLE)
	GuiCtrlSetState($gui_beToJeBox, $GUI_ENABLE)
	GuiCtrlSetState($gui_jeToBeBox, $GUI_ENABLE)
	GuiCtrlSetState($gui_loadInfoBtn, $GUI_ENABLE)
	GuiCtrlSetState($gui_startBtn, $GUI_ENABLE)
	GuiCtrlSetState($gui_checkForUpdatesBtn, $GUI_ENABLE)

	GUICtrlSetState($gui_customLogDirBox, $GUI_ENABLE)
	GUICtrlSetState($gui_customLogDirInput, $GUI_ENABLE)
	GUICtrlSetState($gui_customOutputDirBox, $GUI_ENABLE)
	GUICtrlSetState($gui_customOutputDirInput, $GUI_ENABLE)
	GUICtrlSetState($gui_customInputDirBox, $GUI_ENABLE)
	GUICtrlSetState($gui_customInputDirInput, $GUI_ENABLE)
	GUICtrlSetState($gui_outputWithFolderBox, $GUI_ENABLE)
	GUICtrlSetState($gui_checkUpdatesBox, $GUI_ENABLE)
	GUICtrlSetState($gui_repeatsInput, $GUI_ENABLE)
	GUICtrlSetState($gui_packMinVerInput, $GUI_ENABLE)
	GUICtrlSetState($gui_packVerInput, $GUI_ENABLE)
	GUICtrlSetState($gui_OutputAsMcpackBox, $GUI_ENABLE)
	GUICtrlSetState($gui_packFormatInput, $GUI_ENABLE)
	GUICtrlSetState($gui_outputAsZipBox, $GUI_ENABLE)
	GUICtrlSetState($gui_saveSettingsBtn, $GUI_ENABLE)
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
		GUICtrlSetData($gui_packNameInput, $name)
		GUICtrlSetData($gui_packDescriptionInput, $description)
		logWrite(0, "Loaded original pack info")
	ElseIf FileExists($inputDir & "\pack.mcmeta") Then ;Java Pack
		logWrite(0, "Detected pack.mcmeta")
		Local $file = FileRead($inputDir & "\pack.mcmeta")
		Local $decoded_json = Json_Decode($file)
		Local $description = Json_Get($decoded_json, '["pack"]["description"]')
		logWrite(0, "Decoded json")
		GUICtrlSetData($gui_packDescriptionInput, $description)
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

Func startConversion()
	logWrite(0, "Start button pressed")
	If GUICtrlRead($gui_beToJeBox) == GUICtrlRead($gui_jeToBeBox) Then
		logWrite(0, "Either both modes are selected or only one")
		MsgBox(0, $guiTitle, "Please select one conversion mode")
	ElseIf GUICtrlRead($gui_beToJeBox) <> GUICtrlRead($gui_jeToBeBox) Then
		selectConversionMode()
	EndIf
EndFunc   ;==>startConversion

Func selectConversionMode()
	If GUICtrlRead($gui_beToJeBox) = 1 Then
		logWrite(0, "Bedrock to Java mode selected")
		bedrockToJava()
	ElseIf $gui_jeToBeBox = 1 Then
		logWrite(0, "Java to Bedrock mode selected")
		javaToBedrock()
	EndIf
EndFunc   ;==>selectConversionMode

Func convert($mode, $conversionArray, $arrayDataCount, $gui_progressBarPercent)
	$arrayDataCount -= 1 ;ForLoops start at 0, so you need to minus 1 from the total
	If $mode = 0 Then ;BedrockToJava
		For $index = 0 To $arrayDataCount
			Local $current = $conversionArray[$index]

			If FileExists($inputDir & "\" & $current[0]) Then
				FileMove($inputDir & "\" & $current[0], $outputDir & "\pack\" & $current[1], 8)
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
				FileMove($inputDir & "\" & $current[1], $outputDir & "\pack\" & $current[0], 8)
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

		If FileExists($outputDir & "\pack\assets\minecraft\textures\block\" & $current[0]) Then
			FileOpen($outputDir & "\pack\assets\minecraft\textures\block\" & $current[0] & ".mcmeta")
			FileWrite($outputDir & "\pack\assets\minecraft\textures\block\" & $current[0] & ".mcmeta", $current[1])
			FileClose($outputDir & "\pack\assets\minecraft\textures\block\" & $current[0] & ".mcmeta")
			logWrite(0, "Found file " & $outputDir & "\pack\assets\minecraft\textures\block\" & $current[0] & " and generated a .mcmeta file for it")
			$animeCount += 1
		Else
			logWrite(0, "Could not find animated file " & $outputDir & "\pack\assets\minecraft\textures\block\" & $current[0] & " so did not generate an .mcmeta file.")
		EndIf
	Next

	For $index = 0 To 19
		Local $current = $animeTextures2[$index]

		If FileExists($outputDir & "\pack\assets\minecraft\textures\block\" & $current[0]) Then
			FileOpen($outputDir & "\pack\assets\minecraft\textures\block\" & $current[0] & ".mcmeta")
			FileWrite($outputDir & "\pack\assets\minecraft\textures\block\" & $current[0] & ".mcmeta", $current[1])
			FileClose($outputDir & "\pack\assets\minecraft\textures\block\" & $current[0] & ".mcmeta")
			logWrite(0, "Found file " & $outputDir & "\pack\assets\minecraft\textures\block\" & $current[0] & " and generated a .mcmeta file for it")
			$animeCount += 1
		Else
			logWrite(0, "Could not find animated file " & $outputDir & "\pack\assets\minecraft\textures\block\" & $current[0] & " so did not generate an .mcmeta file.")
		EndIf
	Next
EndFunc   ;==>convertAnime

Func convertPackIcon()
	If FileExists($inputDir & "\pack_icon.png") Then ;Bedrock Pack
		FileMove($inputDir & "\pack_icon.png", $outputDir & "\pack\pack.png", 8)
		logWrite(0, "Converted pack icon")
		$conversionCount += 1
	ElseIf FileExists($inputDir & "\pack.png") Then ;Java Pack
		FileMove($inputDir & "\pack.png", $outputDir & "\pack\pack_icon.png", 8)
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
	Local $confirmBox = MsgBox(1, $guiTitle, "Are you sure you want to start conversion? This will delete everything inside the " & $outputDir & " folder, so make sure you have removed any previous packs from it.")
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

		Local $javaPackName = GUICtrlRead($gui_packNameInput)
		Local $javaPackDesc = GUICtrlRead($gui_packDescriptionInput)
		Global $conversionCount = 0
		Local $timesRan = 0

		DirRemove($outputDir, 1)
		DirCreate($outputDir & "\pack")

		logWrite(0, "Generating pack.mcmeta file")
		GUICtrlSetData($gui_progressBar, 5)

		FileOpen($outputDir & "\pack\pack.txt", 8)
		FileWrite($outputDir & '\pack\pack.txt', '{"pack":{"pack_format":' & $cfg_packFormatVer & ',"description":"' & $javaPackDesc & '"}}')
		FileClose($outputDir & "\pack\pack.txt")
		FileMove($outputDir & "\pack\pack.txt", $outputDir & "\pack\pack.mcmeta")

		GUICtrlSetData($gui_progressBar, 10)

		logWrite(0, "Generated pack.mcmeta file")
		logWrite(0, "Beginning texture file conversion")

		While $timesRan < $cfg_repeats
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
			logWrite(1, "Texture conversion function ran " & $timesRan & "/" & $cfg_repeats)
		WEnd

		convertAnime()

		GUICtrlSetData($gui_progressBar, 47)

		convertPackIcon()

		GUICtrlSetData($gui_progressBar, 48)

		logWrite(0, "Generated " & $animeCount & " .mcmeta files for animated textures.")
		logWrite(0, "Finished converting files! Converted " & $conversionCount & " files!")
		logWrite(0, "Creating pack.zip file")

		GUICtrlSetData($gui_progressBar, 50)

		If $cfg_outputAsZip Then
			_Zip_Create($outputDir & "\pack.zip")

			logWrite(0, "Created pack.zip file")
			logWrite(0, "Adding files to pack.zip file")

			_Zip_AddFolderContents($outputDir & "\pack.zip", $outputDir & "\pack", 0)

			logWrite(0, "Finished adding files to pack.zip!")
			GUICtrlSetData($gui_progressBar, 60)

			FileMove($outputDir & "\pack.zip", $outputDir & "\" & $javaPackName & ".zip")
		EndIf

		If $cfg_outputWithFolder = "False" Then
			FileDelete($inputDir & "\pack")
		EndIf

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
	Local $confirmBox = MsgBox(1, $guiTitle, "Are you sure you want to start conversion? This will delete everything inside the " & $outputDir & " folder, so make sure you have removed any previous packs from it.")

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

		Local $bedrockPackName = GUICtrlRead($gui_packNameInput)
		Local $bedrockPackDesc = GUICtrlRead($gui_packDescriptionInput)
		Global $conversionCount = 0
		Local $timesRan = 0

		DirRemove($outputDir, 1)
		DirCreate($outputDir & "\pack")

		logWrite(0, "Generating manifest.json file")
		GUICtrlSetData($gui_progressBar, 5)

		Local $conf_bedrockPackVersion = IniRead("options.ini", "Java to Bedrock", "pack_version", "1,0,0")

		FileOpen($outputDir & "\pack\manifest.txt", 8)
		FileWrite($outputDir & '\pack\manifest.txt', '{"format_version":2,"header":{"description":"' & $bedrockPackDesc & ' | §9Converted to from Java to Bedrock using Aliens pack converter §r | §eDownload pack converter from TheAlienDoctor.com §r","name":"' & $bedrockPackName & '","uuid":"' & uuidGenerator() & '","version":[' & $conf_bedrockPackVersion & '],"min_engine_version":[' & $cfg_packMinVer & ']},"modules":[{"description":"' & $bedrockPackDesc & ' | §9Converted to from Java to Bedrock using Aliens pack converter §r | §eDownload pack converter from TheAlienDoctor.com §r","type":"resources","uuid":"' & uuidGenerator() & '","version":[' & $conf_bedrockPackVersion & ']}]}')
		FileClose($outputDir & "\pack\manifest.txt")
		FileMove($outputDir & "\pack\manifest.txt", $outputDir & "\pack\manifest.json")

		GUICtrlSetData($gui_progressBar, 10)

		logWrite(0, "Generated manifest.json file")
		logWrite(0, "Beginning texture file conversion")

		While $timesRan < $cfg_repeats
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
			logWrite(1, "Texture conversion function ran " & $timesRan & "/" & $cfg_repeats)
		WEnd

		convertPackIcon()

		GUICtrlSetData($gui_progressBar, 47)

		logWrite(0, "Finished converting files! Converted " & $conversionCount & " files!")
		logWrite(0, "Creating .mcpack file")

		GUICtrlSetData($gui_progressBar, 50)

		If $cfg_outputAsMcpack = True Then
			_Zip_Create($outputDir & "\" & $bedrockPackName & ".zip")

			logWrite(0, "Created pack.zip file")
			logWrite(0, "Adding files to pack.zip file")

			_Zip_AddFolderContents($outputDir & "\" & $bedrockPackName & ".zip", $outputDir & "\pack\", 1)

			logWrite(0, "Finished adding files to pack.zip!")
			GUICtrlSetData($gui_progressBar, 60)

			FileMove($outputDir & "\" & $bedrockPackName & ".zip", $outputDir & "\" & $bedrockPackName & ".mcpack")
		EndIf

		If $cfg_outputWithFolder = "False" Then
			FileDelete($inputDir & "\pack")
		EndIf

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

loadSettings()
createLog()
startUp()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			exitProgram()
			Exit

		Case $gui_loadInfoBtn
			loadInfo()

		Case $gui_startBtn
			startConversion()

		Case $gui_saveSettingsBtn
			saveSettings()

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

		Case $gui_checkForUpdatesBtn
			checkForUpdates(1)

	EndSwitch
WEnd
