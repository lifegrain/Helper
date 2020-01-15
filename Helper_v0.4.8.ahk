/*
 * * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\Helper_v0.4.8.exe
[VERSION]
Set_Version_Info=1
File_Description=Helps your Minecraft Afk needs
File_Version=0.4.8.0
Inc_File_Version=0
Product_Name=Minecraft Helper
Product_Version=1.1.30.3
Set_AHK_Version=1
[ICONS]
Icon_1=D:\-\Picture\Icon\App Icon\Helper_ico.ico
Icon_2=0
Icon_3=0
Icon_4=0
Icon_5=0

* * * Compile_AHK SETTINGS END * * *
*/

;==================================================================================================

#NoEnv

SetBatchLines -1
SetTitleMatchMode 3
#SingleInstance Off
#MaxThreads 3
#NoTrayIcon

version = 0.4.8

;===================================================================================================
;PreLoad, stuff you want to have prepared before everything else
;===================================================================================================
wintit = Please Press Alt + W while Minecraft is active
winid = No ID
def_itv = 165
Swordspeed = 600
Axespeed = 1200
Fish = 165
Sprint = 0

FormatTime, Date, , dM ;Checks Local Date and Month (returns dateMonth i.e 25 december = 2512)

;===================================================================================================
;Shortcuts
;===================================================================================================
Hotkey  !f,   	Click		;	Pressing alt + f will start fishing
Hotkey  !s,   	Stop		;	Pressing alt + s will stop it
Hotkey	!x,		tog_cli		;	Pressing alt + x will toggle between right click and left click mode
Hotkey	!LCtrl,	sprintstat	;	Pressing alt + ctrl will toggle Hold Sprint mode
Hotkey	!p,		focuspause	;	Pressing alt + p will toggle Pause on lost focus
Hotkey	!F5,	Reload		;	Alt + F5 to reload the whole script
Hotkey	!1,		Fish		;	Pressing Alt + 1 will change interval to 165, Default Click speed
Hotkey	!2,		Sword		;	Pressing Alt + 2 will change interval to 600, sword Click speed
Hotkey	!3,		Axe			;	Pressing Alt + 3 will change interval to 600, Axe Click speed
Hotkey	!w,		Getwin		;	Pressing Alt + W will obtain ID of current active window

;===================================================================================================
;GUI
;===================================================================================================
;Window size and name
Gui, Show, w650 h330 , Helper v%version%

;Main Button
Gui, Add, Button, x30 y75 w100 h75 gClick vnamebut Default, Right-Click ;Default in the Parameter 4 means pressing enter while the window is focused will press this button
Gui, Add, Button, y+20 w100 h75 gStop, Stop All

;Hotkey List
Gui, Add, Text, y20 x310 cBlue, Hotkey List
Gui, Add, Text, vname y+13 w300, Alt+F		Right-Click
Gui, Add, Text, y+10, Alt+S		Stop All
Gui, Add, Text, y+10, Alt+X		Toggle Click Mode
Gui, Add, Text, Y+10, Alt+Ctrl		Toggle Sprint Hold
Gui, Add, Text, y+10, Alt+P		Toggle Pause on Lost Focus
Gui, Add, Text, y+10, Alt+F5		Reload
Gui, Add, Text, y+10, Alt+1		Default Interval
Gui, Add, Text, y+10, Alt+2		Sword Interval
Gui, Add, Text, y+10, Alt+3		Axe Interval
Gui, Add, Text, y+10 CPurple vgetkey, Alt+W		Get Windows ID and Title from active Window

;Reset Getwin Button and hides it initially
Gui, Add, Button, y280 x495 w150 vReset gReset, Reselect Windows ID && Title target
GuiControl, Hide, Reset

;Warning/Reminder
Gui, Add, Text, y255 x30 CRed w100 vWarning, All Modifiers (interval,etc) is updated live without the need to stop the script!

;Left-Click/Right-Click Radio Button
Gui, Add, Radio, y75 x165 gClickMode vRight_mode Checked, Right-Click
Gui, Add, Radio, y+10 x165 gClickMode vLeft_mode, Left Click

;Interval Settings
Gui, Add, Text, y185 x165, Interval
Gui, Add, Edit, y+2 w50 h20 -multi number center vinterval, %def_itv%
Gui, Add, Text, y+-15 x+3, millisecond(s)

;Set Sprint Key
;Gui, Add, Radio, y185 x210 Checked vCtrl, Sprint : Ctrl
;Gui, Add, Radio, y+10 vShift, Sprint : Shift
Gui, Add, Button, y265 x215 w60 vSprintBut gsprintstat, Hold Sprint Off

;Sword/Axe/Fish Button
Gui, Add, Button, y125 x190 w45 h20 gFish, Default
Gui, Add, Button, y+10 x165 w45 h20 gSword, Sword
Gui, Add, Button, x+5 w45 h20 gAxe, Axe

;Checks/Reload
Gui, Add, Button, y265 x165 w45 h20 gReload, Reload

;Window Title Check
Gui, Add, Text, CGreen y20 x70 vstatus center, Minecraft Window Name - ID
Gui, Add, Text, CPurple y+5 x30 vwintit center w210, %wintit% - %winid%

;Scroll all the way down to know what this does basically, since this is a function
Holidays(Date)

;===================================================================================================
;Tray Menu
;===================================================================================================
Menu, Tray, NoStandard ;Standard Tray Menu disable (no Current use)

;===================================================================================================
;Check for Minecraft if they are on
;===================================================================================================
Loop
	{
		ifWinExist ,ahk_id %winid%
		{
			GuiControl, Show, status
			GuiControl, Text, status, Minecraft Window Name - ID
			GuiControl, Text, wintit, %wintit% - %winid%
		}
		ifWinNotExist ,ahk_id %winid%
		{
			GuiControl, Show, status
			Sleep 500
			GuiControl, Hide, status 
			GuiControl, Text, wintit, %wintit% - %winid%
		}
		Sleep 500
	}
return

;===================================================================================================
;Get Minecraft Windows title and ID and disables the hotkey
;===================================================================================================
Getwin:
	WinGet, winid, ID, A
	WinGettitle, wintit, A
	Hotkey, !w, Getwin, Off
	GuiControl, Hide, getkey
	GuiControl, Show, Reset
	SoundBeep, 500, 100
return

;===================================================================================================
;Get Minecraft Windows title and ID and disables the hotkey
;===================================================================================================
Reset:
	Hotkey, !w, Getwin, On
	wintit = Please Press Alt + W while Minecraft is active
	winid = No ID
	GuiControl, Show, getkey
	GuiControl, Hide, Reset
	GuiControl, Text, wintit, %wintit% - %winid%
return

;===================================================================================================
;===================================================================================================
Click:
	GuiControlGet, Right_mode
	GuiControlGet, Left_mode
	ifWinExist , ahk_id %winid%
	{
		BreakLoop = 0
			Loop
			{
            if (BreakLoop = 1)
				{
					BreakLoop = 0
					break
				}
				if(Right_mode = 1) ;Right-Click mode
				{
					GuiControlGet, interval
					ControlClick, , ahk_id %winid%, ,R, , NA
					Sleep %interval%
				} else if (Left_mode = 1) ;Left-Click mode
				{
					GuiControlGet, interval
					ControlClick, , ahk_id %winid%, ,L, , NA
					Sleep %interval%
				}
			}
	}
Return

;===================================================================================================
;Stop the Loop/ Stop all Action
Stop:
BreakLoop = 1
return

;===================================================================================================
;Toggle Minecraft Pause on Loss focus
focuspause:
	ControlSend, , {F3 Down}p{F3 Up}, ahk_id %winid%
return

;===================================================================================================
;Toggle click mode
ClickMode:
GuiControlGet, Right_mode
GuiControlGet, Left_mode
if (Right_mode = 1)
{
	RightClickRename()
} else if (Left_mode = 1)
{
	LeftClickRename()
}
return

;===================================================================================================
;Hotkey click mode
tog_cli:
GuiControlGet, Right_mode
GuiControlGet, Left_mode
if (Right_mode = 1)
{
	LeftClickRename()
	GuiControl, , Left_mode, 1 ;Select Left-Click Radio Button and unselects Right-Click Radio Button
} else if (Left_mode = 1)
{
	RightClickRename()
	GuiControl, , Right_mode, 1 ;Select Right-Click Radio Button and unselects Left-Click Radio Button
}
return

;===================================================================================================
;Choose Sword/Axe/fish default Interval
Sword:
GuiControl, Text, interval, %Swordspeed%
return

Axe:
GuiControl, Text, interval, %Axespeed%
return

Fish:
GuiControl, Text, interval, %Fish%
return

;===================================================================================================
;Toggle Hold Sprint Key
sprintstat:
if (Sprint = 0)
{
	Sprint = 1
	GuiControl, Text, SprintBut, Hold Sprint On
} else if (Sprint = 1)
{
	Sprint = 0
	GuiControl, Text, SprintBut, Hold Sprint Off
}
return

;===================================================================================================
;Walk/Sprint ###LShift not Working?
~$W::
	;GuiControlGet, Ctrl
	;GuiControlGet, Shift
	Ctrl = 1
	if (Sprint = 1 && Ctrl = 1)
	{
		ControlSend, , {LCtrl Down}, ahk_id %winid%
		if (GetKeyState ("W", "P") = 0)
		{
			ControlSend, ,{LCtrl Up}, ahk_id %winid%
		}
	}
return

;===================================================================================================
;Reloads Script
Reload:
reload
return

;===================================================================================================
ESC:
GuiClose:
GuiEscape:
ExitApp
return


;===================================================================================================
;miscellaneous, AKA User-Function area
;===================================================================================================
;Happy Holidays Greeting
Holidays(x) ;This is what you call a user-defined function
{
	if (x = 14)
	{
		GuiControl, Text, Warning, Installing Yiff Mod, April Fools! if you don't know what Yiff is don't ask or google!
	} else if (x = 3110)
	{
		GuiControl, Text, Warning, BOO! Happy Halloween!
	} else if (x = 2512)
	{
		GuiControl, Text, Warning, Merry Christmas, My present for you is the program is free forever!
	} else if (x = 11 || x = 3112)
	{
		GuiControl, Text, Warning, Happy New Year! also Happy Chinese New Year! for whatever date it is
	} else if (x = 142)
	{
		GuiControl, Text, Warning, Happy Valentines Day! Will you be my Valentine?
	}
	
	
	 ; remove the semi-colon (;) below to use the code below, for debugging purposes only
	 ;else GuiControl, Text, Warning, %x%
}

LeftClickRename()
{
	GuiControl, Text, Name, Alt+F		Left-Click
	GuiControl, Text, namebut, Left-Click
}

RightClickRename()
{
	GuiControl, Text, Name, Alt+F		Right-Click
	GuiControl, Text, namebut, Right-Click
}