#pragma compile(Compatibility, win10 & win11)
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

;###########################################################################################################################################################################################
;GUI section (from Koda)

#Region ### START Koda GUI section ### Form=d:\06 code\minecraft-resource-pack-converter\gui.kxf
Global $Form1_1 = GUICreate("Alien's Pack Converter", 615, 205, -1, -1)
Global $Tab1 = GUICtrlCreateTab(8, 8, 601, 185)
Global $BedrockToJava = GUICtrlCreateTabItem("Bedrock to Java")
Global $PackNameTitle = GUICtrlCreateLabel("Pack Name:", 16, 48, 63, 17)
Global $PackDescTitle = GUICtrlCreateLabel("Pack Description:", 15, 80, 88, 17)
Global $StartBeToJe = GUICtrlCreateButton("Start conversion", 48, 120, 497, 57)
GUICtrlSetTip(-1, "Start conversion")
Global $InputPackName = GUICtrlCreateInput("Pack name", 88, 48, 513, 21)
GUICtrlSetTip(-1, "Pack name")
Global $PackDescInput = GUICtrlCreateInput("Pack description", 112, 80, 489, 21)
GUICtrlSetTip(-1, "Pack description")
Global $JavaToBedrock = GUICtrlCreateTabItem("Java to Bedrock")
GUICtrlCreateTabItem("")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;###########################################################################################################################################################################################
;Things that need to be ran before everything else

If IniRead("options.ini", "logConfig", "CustomLogDir", "false") = "false" Then
	Global $logDir = @ScriptDir & "\" & "logs"
ElseIf IniRead("options.ini", "logConfig", "CustomLogDir", "false") = "true" Then
	Global $logDir = IniRead("options.ini", "logConfig", "LogDir", @ScriptDir & "\logs")
EndIf

;###########################################################################################################################################################################################
;GUI Control

Global $dateTime = @MDAY & '.' & @MON & '.' & @YEAR & '-' & @HOUR & '.' & @MIN & '.' & @SEC
Global $bedrockDir = @ScriptDir & "\" & IniRead("options.ini", "config", "BedrockDir", "BedrockPack")

While 1
	createLog()
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			finishLog()
			Exit
		Case $StartBeToJe
			bedrockToJava()

	EndSwitch
WEnd

;###########################################################################################################################################################################################
;Functions

Func createLog()
	If FileExists($logDir) Then ;If directory exists then begin writing logs
		FileOpen($logDir & "\" & "log.latest", 2)
		FileWrite($logDir & "\" & "log.latest", "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)" & @CRLF)
		FileWrite($logDir & "\" & "log.latest", "###################################################################" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	ElseIf FileExists($logDir) = "0" Then ;If directory doesn't exist create it then begin writing logs
		DirCreate($logDir)
		FileOpen($logDir & "\" & "log.latest", 2)
		FileWrite($logDir & "\" & "log.latest", "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)" & @CRLF)
		FileWrite($logDir & "\" & "log.latest", "###################################################################" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
EndFunc   ;==>createLog

Func finishLog()
	FileOpen($logDir & "\" & "log.latest", 1)
	FileWrite($logDir & "\" & "log.latest", "Log file closed at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)" & @CRLF)
	FileWrite($logDir & "\" & "log.latest", "###################################################################" & @CRLF)
	FileClose($logDir & "\" & "log.latest")
	FileMove($logDir & "\log.latest", $logDir & "\log[" & $dateTime & "].txt") ;Once the script has finished running, it will rename the log.latest to have the date and time
EndFunc   ;==>finishLog

Func bedrockToJava()
	FileOpen($logDir & "\" & "log.latest", 1)
	FileWrite($logDir & "\" & "log.latest", "Bedrock mode selected" & @CRLF)
	MsgBox(0, "Alien's pack converter", "Conversion complete!")
Endfunc   ;==>bedrockToJava
