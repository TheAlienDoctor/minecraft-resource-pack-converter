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
;GUI (from Koda)

#Region ### START Koda GUI section ### Form=d:\06 code\minecraft-resource-pack-converter\gui.kxf
Global $PackConverter = GUICreate("Alien's Pack Converter", 619, 203, -1, -1)
Global $PackConverter = GUICtrlCreateTab(8, 8, 601, 185)
Global $BedrockToJava = GUICtrlCreateTabItem("Bedrock to Java")
Global $PackNameTitle = GUICtrlCreateLabel("Pack Name:", 16, 48, 63, 17)
Global $PackDescTitle = GUICtrlCreateLabel("Pack Description:", 15, 80, 88, 17)
Global $StartBeToJe = GUICtrlCreateButton("Start conversion", 457, 162, 145, 25)
GUICtrlSetTip(-1, "Start conversion")
Global $InputPackName = GUICtrlCreateInput("Pack name", 88, 48, 513, 21)
GUICtrlSetTip(-1, "Pack name")
Global $PackDescInput = GUICtrlCreateInput("Pack description", 112, 80, 489, 21)
GUICtrlSetTip(-1, "Pack description")
Global $JavaToBedrock = GUICtrlCreateTabItem("Java to Bedrock")
Global $BEPackDescInput = GUICtrlCreateInput("Pack description", 112, 80, 489, 21)
GUICtrlSetTip(-1, "Pack description")
Global $BEPackNameInput = GUICtrlCreateInput("Pack name", 88, 48, 513, 21)
GUICtrlSetTip(-1, "Pack name")
Global $StartJeToBe = GUICtrlCreateButton("Start conversion", 457, 162, 145, 25)
GUICtrlSetTip(-1, "Start conversion")
Global $BEPackDescTitle = GUICtrlCreateLabel("Pack Description:", 15, 80, 88, 17)
Global $BEPackNameTitle = GUICtrlCreateLabel("Pack Name:", 16, 48, 63, 17)
GUICtrlCreateTabItem("")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;###########################################################################################################################################################################################
;Declare variables

Global $dateTime = @MDAY & '.' & @MON & '.' & @YEAR & '-' & @HOUR & '.' & @MIN & '.' & @SEC
Global $bedrockDir = @ScriptDir & "\" & IniRead("options.ini", "config", "BedrockDir", "Bedrock-pack")
Global $javaDir = @ScriptDir & "\" & IniRead("options.ini", "config", "JavaDir", "Java-pack")

If IniRead("options.ini", "logConfig", "CustomLogDir", "false") = "false" Then
	Global $logDir = @ScriptDir & "\" & "logs"
ElseIf IniRead("options.ini", "logConfig", "CustomLogDir", "false") = "true" Then
	Global $logDir = IniRead("options.ini", "logConfig", "LogDir", @ScriptDir & "\logs")
EndIf

;###########################################################################################################################################################################################
;Conversion variables

;Declare the Bedrock texture and Java texture
;NOTE: The name of the variable is (unless specified) the Bedrock texture name.
Global $acacia_trapdoor[2] = ["textures\blocks\acacia_trapdoor.png", "assets\minecraft\textures\block\acacia_trapdoor.png"]
Global $amethyst_block[2] = ["textures\blocks\amethyst_block.png", "assets\minecraft\block\amethyst_block.png"]
Global $amethyst_cluster[2] = ["textures\blocks\amethyst_cluster.png", "assets\minecraft\block\amethyst_cluster.png"]
Global $ancient_debris_side[2] = ["textures\blocks\ancient_debris_side.png", "assets\minecraft\block\ancient_debris_side.png"]
Global $ancient_debris_top[2] = ["textures\blocks\ancient_debris_top.png", "assets\minecraft\block\ancient_debris_top.png"]
Global $anvil_base[2] = ["textures\blocks\anvil_base.png", "assets\minecraft\block\anvil.png"]
Global $anvil_top_damaged_0[2] = ["textures\blocks\anvil_top_damaged_0.png", "assets\minecraft\block\anvil_top.png"]
Global $anvil_top_damaged_1[2] = ["textures\blocks\anvil_top_damaged_1.png", "assets\minecraft\block\chipped_anvil_top.png"]
Global $anvil_top_damaged_2[2] = ["textures\blocks\anvil_top_damaged_2.png", "assets\minecraft\block\damaged_anvil_top.png"]


Global $textures[7] = [$acacia_trapdoor, $amethyst_block, $amethyst_cluster, $ancient_debris_side, $ancient_debris_top, $anvil_base, $anvil_top_damaged_1]

;###########################################################################################################################################################################################
;Functions

Func bedrockToJava()
	FileOpen($logDir & "\" & "log.latest", 1)
	FileWrite($logDir & "\" & "log.latest", "Begin converting Bedrock to Java" & @CRLF)
	FileClose($logDir & "\" & "log.latest")

	For $index = 0 To 1
		FileOpen("")
		Local $current = $textures[$index]

		If FileExists($bedrockDir & "\" & $current[0]) Then
			FileMove($bedrockDir & "\" & $current[0], $javaDir & "\" & $current[1], 8)
			FileOpen($logDir & "\" & "log.latest", 1)
			FileWrite($logDir & "\" & "log.latest", $current[0] & " found, moved it to " & $current[1] & @CRLF)
			FileClose($logDir & "\" & "log.latest")
		Else
			FileOpen($logDir & "\" & "log.latest", 1)
			FileWrite($logDir & "\" & "log.latest", $current[0] & " not found, ignoring it! " & @CRLF)
			FileClose($logDir & "\" & "log.latest")
		EndIf
	Next
	FileOpen($logDir & "\" & "log.latest", 1)
	FileWrite($logDir & "\" & "log.latest", "Bedrock to Java conversion complete!" & @CRLF)
	FileClose($logDir & "\" & "log.latest")
	MsgBox(0, "Alien's pack converter", "Conversion complete!")
EndFunc   ;==>bedrockToJava

Func createLog()
	If FileExists($logDir) Then ;If directory exists then begin writing logs
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)" & @CRLF)
		FileWrite($logDir & "\" & "log.latest", "###################################################################" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	ElseIf FileExists($logDir) = "0" Then ;If directory doesn't exist create it then begin writing logs
		DirCreate($logDir)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)" & @CRLF)
		FileWrite($logDir & "\" & "log.latest", "###################################################################" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
EndFunc   ;==>createLog

Func finishLog()
	FileOpen($logDir & "\" & "log.latest", 1)
	FileWrite($logDir & "\" & "log.latest", "###################################################################" & @CRLF)
	FileWrite($logDir & "\" & "log.latest", "Log file closed at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)" & @CRLF)
	FileClose($logDir & "\" & "log.latest")
	FileMove($logDir & "\log.latest", $logDir & "\log[" & $dateTime & "].txt")
EndFunc   ;==>finishLog

Func bedrockToJavaOLD()
	FileOpen($logDir & "\" & "log.latest", 1)
	FileWrite($logDir & "\" & "log.latest", "Begin converting Bedrock to Java" & @CRLF)
	FileClose($logDir & "\" & "log.latest")

	If FileExists($bedrockDir & "\textures\blocks\acacia_trapdoor.png") Then
		FileMove($bedrockDir & "\textures\blocks\acacia_trapdoor.png", $javaDir & "\assets\minecraft\textures\block\acacia_trapdoor.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "acacia_trapdoor.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "acacia_trapdoor.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf

	FileOpen($logDir & "\" & "log.latest", 1)
	FileWrite($logDir & "\" & "log.latest", "Bedrock to Java conversion complete!" & @CRLF)
	FileClose($logDir & "\" & "log.latest")
	MsgBox(0, "Alien's pack converter", "Conversion complete!")

Endfunc   ;==>bedrockToJavaOLD

;###########################################################################################################################################################################################
;GUI Control

createLog()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			finishLog()
			Exit

		Case $StartBeToJe
			bedrockToJava()

	EndSwitch
WEnd
