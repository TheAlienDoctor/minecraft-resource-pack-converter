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

;###########################################################################################################################################################################################
;Functions

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

Func bedrockToJava()
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
	If FileExists($bedrockDir & "\textures\blocks\amethyst_block.png") Then
		FileMove($bedrockDir & "\textures\blocks\amethyst_block.png", $javaDir & "\assets\minecraft\textures\block\amethyst_block.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "amethyst_block.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "acacia_trapdoor.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\amethyst_cluster.png") Then
		FileMove($bedrockDir & "\textures\blocks\amethyst_cluster.png", $javaDir & "\assets\minecraft\textures\block\amethyst_cluster.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "amethyst_cluster.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "amethyst_cluster.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\ancient_debris_side.png") Then
		FileMove($bedrockDir & "\textures\blocks\ancient_debris_side.png", $javaDir & "\assets\minecraft\textures\block\ancient_debris_side.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "ancient_debris_side.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "ancient_debris_side.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\ancient_debris_top.png") Then
		FileMove($bedrockDir & "\textures\blocks\ancient_debris_top.png", $javaDir & "\assets\minecraft\textures\block\ancient_debris_top.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "ancient_debris_top.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "ancient_debris_top.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\anvil_base.png") Then
		FileMove($bedrockDir & "\textures\blocks\anvil_base.png", $javaDir & "\assets\minecraft\textures\block\anvil.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "anvil_base.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "anvil_base.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\anvil_top_damaged_0.png") Then
		FileMove($bedrockDir & "\textures\blocks\anvil_top_damaged_0.png", $javaDir & "\assets\minecraft\textures\block\anvil_top.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "anvil_top_damaged_0.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "anvil_top_damaged_0.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\anvil_top_damaged_1.png") Then
		FileMove($bedrockDir & "\textures\blocks\anvil_top_damaged_1.png", $javaDir & "\assets\minecraft\textures\block\chipped_anvil_top.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "anvil_top_damaged_1.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "anvil_top_damaged_1.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\anvil_top_damaged_2.png") Then
		FileMove($bedrockDir & "\textures\blocks\anvil_top_damaged_2.png", $javaDir & "\assets\minecraft\textures\block\damaged_anvil_top.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "anvil_top_damaged_2.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "anvil_top_damaged_2.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\azalea_leaves.png") Then
		FileMove($bedrockDir & "\textures\blocks\azalea_leaves.png", $javaDir & "\assets\minecraft\textures\block\azalea_leaves.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "azalea_leaves.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "azalea_leaves.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\azalea_leaves_flowers.png") Then
		FileMove($bedrockDir & "\textures\blocks\azalea_leaves_flowers.png", $javaDir & "\assets\minecraft\textures\block\flowering_azalea_leaves.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "azalea_leaves_flowers.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "azalea_leaves_flowers.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\azalea_plant.png") Then
		FileMove($bedrockDir & "\textures\blocks\azalea_plant.png", $javaDir & "\assets\minecraft\textures\block\azalea_plant.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "azalea_plant.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "azalea_plant.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\azalea_side.png") Then
		FileMove($bedrockDir & "\textures\blocks\azalea_side.png", $javaDir & "\assets\minecraft\textures\block\azalea_side.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "azalea_side.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "azalea_side.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\azalea_top.png") Then
		FileMove($bedrockDir & "\textures\blocks\azalea_top.png", $javaDir & "\assets\minecraft\textures\block\azalea_top.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "azalea_top.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "azalea_top.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bamboo_leaf.png") Then
		FileMove($bedrockDir & "\textures\blocks\bamboo_leaf.png", $javaDir & "\assets\minecraft\textures\block\bamboo_large_leaves.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bamboo_leaf.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bamboo_leaf.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bamboo_sapling.png") Then
		FileMove($bedrockDir & "\textures\blocks\bamboo_sapling.png", $javaDir & "\assets\minecraft\textures\block\bamboo_stage0.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bamboo_sapling.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bamboo_sapling.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bamboo_singleleaf.png") Then
		FileMove($bedrockDir & "\textures\blocks\bamboo_singleleaf.png", $javaDir & "\assets\minecraft\textures\block\bamboo_singleleaf.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bamboo_singleleaf.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bamboo_singleleaf.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bamboo_small_leaf.png") Then
		FileMove($bedrockDir & "\textures\blocks\bamboo_small_leaf.png", $javaDir & "\assets\minecraft\textures\block\bamboo_small_leaves.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bamboo_small_leaf.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bamboo_small_leaf.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bamboo_stem.png") Then
		FileMove($bedrockDir & "\textures\blocks\bamboo_stem.png", $javaDir & "\assets\minecraft\textures\block\bamboo_stalk.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bamboo_stem.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bamboo_stem.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\barrel_bottom.png") Then
		FileMove($bedrockDir & "\textures\blocks\barrel_bottom.png", $javaDir & "\assets\minecraft\textures\block\barrel_bottom.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "barrel_bottom.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "barrel_bottom.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\barrel_side.png") Then
		FileMove($bedrockDir & "\textures\blocks\barrel_side.png", $javaDir & "\assets\minecraft\textures\block\barrel_side.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "barrel_side.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "barrel_side.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\barrel_top.png") Then
		FileMove($bedrockDir & "\textures\blocks\barrel_top.png", $javaDir & "\assets\minecraft\textures\block\barrel_top.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "barrel_top.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "barrel_top.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\barrel_top_open.png") Then
		FileMove($bedrockDir & "\textures\blocks\barrel_top_open.png", $javaDir & "\assets\minecraft\textures\block\barrel_top_open.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "barrel_top_open.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "barrel_top_open.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\barrier.png") Then
		FileMove($bedrockDir & "\textures\blocks\barrier.png", $javaDir & "\assets\minecraft\textures\item\barrier.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "barrier.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "barrier.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\basalt_side.png") Then
		FileMove($bedrockDir & "\textures\blocks\basalt_side.png", $javaDir & "\assets\minecraft\textures\block\basalt_side.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "basalt_side.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "basalt_side.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\basalt_top.png") Then
		FileMove($bedrockDir & "\textures\blocks\basalt_top.png", $javaDir & "\assets\minecraft\textures\block\basalt_top.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "basalt_top.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "basalt_top.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\beacon.png") Then
		FileMove($bedrockDir & "\textures\blocks\beacon.png", $javaDir & "\assets\minecraft\textures\block\beacon.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beacon.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beacon.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\beacon.png") Then
		FileMove($bedrockDir & "\textures\blocks\beacon.png", $javaDir & "\assets\minecraft\textures\block\beacon.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beacon.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beacon.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bedrock.png") Then
		FileMove($bedrockDir & "\textures\blocks\bedrock.png", $javaDir & "\assets\minecraft\textures\block\bedrock.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bedrock.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bedrock.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bee_nest_bottom.png") Then
		FileMove($bedrockDir & "\textures\blocks\bee_nest_bottom.png", $javaDir & "\assets\minecraft\textures\block\bee_nest_bottom.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bee_nest_bottom.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bee_nest_bottom.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bee_nest_front.png") Then
		FileMove($bedrockDir & "\textures\blocks\bee_nest_front.png", $javaDir & "\assets\minecraft\textures\block\bee_nest_front.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bee_nest_front.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bee_nest_front.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bee_nest_front_honey.png") Then
		FileMove($bedrockDir & "\textures\blocks\bee_nest_front_honey.png", $javaDir & "\assets\minecraft\textures\block\bee_nest_front_honey.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bee_nest_front_honey.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bee_nest_front_honey.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bee_nest_side.png") Then
		FileMove($bedrockDir & "\textures\blocks\bee_nest_side.png", $javaDir & "\assets\minecraft\textures\block\bee_nest_side.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bee_nest_side.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bee_nest_side.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bee_nest_top.png") Then
		FileMove($bedrockDir & "\textures\blocks\bee_nest_top.png", $javaDir & "\assets\minecraft\textures\block\bee_nest_top.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bee_nest_top.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bee_nest_top.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\beehive_front.png") Then
		FileMove($bedrockDir & "\textures\blocks\beehive_front.png", $javaDir & "\assets\minecraft\textures\block\beehive_front.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beehive_front.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beehive_front.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\beehive_front_honey.png") Then
		FileMove($bedrockDir & "\textures\blocks\beehive_front_honey.png", $javaDir & "\assets\minecraft\textures\block\beehive_front_honey.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beehive_front_honey.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beehive_front_honey.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\beehive_side.png") Then
		FileMove($bedrockDir & "\textures\blocks\beehive_side.png", $javaDir & "\assets\minecraft\textures\block\beehive_side.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beehive_side.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beehive_side.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\beehive_top.png") Then
		FileMove($bedrockDir & "\textures\blocks\beehive_top.png", $javaDir & "\assets\minecraft\textures\block\beehive_end.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beehive_top.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beehive_top.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\beetroots_stage_0.png") Then
		FileMove($bedrockDir & "\textures\blocks\beetroots_stage_0.png", $javaDir & "\assets\minecraft\textures\block\beetroots_stage0.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beetroots_stage_0.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beetroots_stage_0.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\beetroots_stage_1.png") Then
		FileMove($bedrockDir & "\textures\blocks\beetroots_stage_1.png", $javaDir & "\assets\minecraft\textures\block\beetroots_stage1.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beetroots_stage_1.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beetroots_stage_1.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\beetroots_stage_2.png") Then
		FileMove($bedrockDir & "\textures\blocks\beetroots_stage_2.png", $javaDir & "\assets\minecraft\textures\block\beetroots_stage2.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beetroots_stage_2.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beetroots_stage_2.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\beetroots_stage_3.png") Then
		FileMove($bedrockDir & "\textures\blocks\beetroots_stage_3.png", $javaDir & "\assets\minecraft\textures\block\beetroots_stage3.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beetroots_stage_3.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "beetroots_stage_3.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bell_bottom.png") Then
		FileMove($bedrockDir & "\textures\blocks\bell_bottom.png", $javaDir & "\assets\minecraft\textures\block\bell_bottom.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bell_bottom.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bell_bottom.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bell_side.png") Then
		FileMove($bedrockDir & "\textures\blocks\bell_side.png", $javaDir & "\assets\minecraft\textures\block\bell_side.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bell_side.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bell_side.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\big_dripleaf_side1.png") Then
		FileMove($bedrockDir & "\textures\blocks\big_dripleaf_side1.png", $javaDir & "\assets\minecraft\textures\block\big_dripleaf_side.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "big_dripleaf_side1.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "big_dripleaf_side1.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\big_dripleaf_side2.png") Then
		FileMove($bedrockDir & "\textures\blocks\big_dripleaf_side2.png", $javaDir & "\assets\minecraft\textures\block\big_dripleaf_tip.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "big_dripleaf_side2.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "big_dripleaf_side2.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\big_dripleaf_stem.png") Then
		FileMove($bedrockDir & "\textures\blocks\big_dripleaf_stem.png", $javaDir & "\assets\minecraft\textures\block\big_dripleaf_stem.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "big_dripleaf_stem.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "big_dripleaf_stem.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\big_dripleaf_top.png") Then
		FileMove($bedrockDir & "\textures\blocks\big_dripleaf_top.png", $javaDir & "\assets\minecraft\textures\block\big_dripleaf_top.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "big_dripleaf_top.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "big_dripleaf_top.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\birch_trapdoor.png") Then
		FileMove($bedrockDir & "\textures\blocks\birch_trapdoor.png", $javaDir & "\assets\minecraft\textures\block\birch_trapdoor.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "birch_trapdoor.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "birch_trapdoor.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\blackstone.png") Then
		FileMove($bedrockDir & "\textures\blocks\blackstone.png", $javaDir & "\assets\minecraft\textures\block\blackstone.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "blackstone.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "blackstone.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\blackstone_top.png") Then
		FileMove($bedrockDir & "\textures\blocks\blackstone_top.png", $javaDir & "\assets\minecraft\textures\block\blackstone_top.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "blackstone_top.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "blackstone_top.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\blast_furnace_front_off.png") Then
		FileMove($bedrockDir & "\textures\blocks\blast_furnace_front_off.png", $javaDir & "\assets\minecraft\textures\block\blast_furnace_front.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "blast_furnace_front_off.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "blast_furnace_front_off.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\blast_furnace_front_on.png") Then
		FileMove($bedrockDir & "\textures\blocks\blast_furnace_front_on.png", $javaDir & "\assets\minecraft\textures\block\blast_furnace_front_on.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "blast_furnace_front_on.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "blast_furnace_front_on.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\blast_furnace_side.png") Then
		FileMove($bedrockDir & "\textures\blocks\blast_furnace_side.png", $javaDir & "\assets\minecraft\textures\block\blast_furnace_side.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "blast_furnace_side.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "blast_furnace_side.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\blast_furnace_top.png") Then
		FileMove($bedrockDir & "\textures\blocks\blast_furnace_top.png", $javaDir & "\assets\minecraft\textures\block\blast_furnace_top.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "blast_furnace_top.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "blast_furnace_top.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\blue_ice.png") Then
		FileMove($bedrockDir & "\textures\blocks\blue_ice.png", $javaDir & "\assets\minecraft\textures\block\blue_ice.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "blue_ice.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "blue_ice.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bone_block_side.png") Then
		FileMove($bedrockDir & "\textures\blocks\bone_block_side.png", $javaDir & "\assets\minecraft\textures\block\bone_block_side.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bone_block_side.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bone_block_side.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bone_block_top.png") Then
		FileMove($bedrockDir & "\textures\blocks\bone_block_top.png", $javaDir & "\assets\minecraft\textures\block\bone_block_top.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bone_block_top.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bone_block_top.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bookshelf.png") Then
		FileMove($bedrockDir & "\textures\blocks\bookshelf.png", $javaDir & "\assets\minecraft\textures\block\bookshelf.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bookshelf.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bookshelf.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\bookshelf.png") Then
		FileMove($bedrockDir & "\textures\blocks\bookshelf.png", $javaDir & "\assets\minecraft\textures\block\bookshelf.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bookshelf.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "bookshelf.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf
	If FileExists($bedrockDir & "\textures\blocks\brewing_stand.png") Then
		FileMove($bedrockDir & "\textures\blocks\brewing_stand.png", $javaDir & "\assets\minecraft\textures\block\brewing_stand.png", 8)
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "brewing_stand.png texture found, converting it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	Else
		FileOpen($logDir & "\" & "log.latest", 1)
		FileWrite($logDir & "\" & "log.latest", "brewing_stand.png texture not found, ignoring it!" & @CRLF)
		FileClose($logDir & "\" & "log.latest")
	EndIf

	FileOpen($logDir & "\" & "log.latest", 1)
	FileWrite($logDir & "\" & "log.latest", "Bedrock to Java conversion complete!" & @CRLF)
	FileClose($logDir & "\" & "log.latest")
	MsgBox(0, "Alien's pack converter", "Conversion complete!")

Endfunc   ;==>bedrockToJava
