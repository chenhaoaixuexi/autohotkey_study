#Persistent
#InstallKeybdHook	
#SingleInstance	force
#WinActivateForce
SetCapsLockState, AlwaysOff
SendMode Input
SetTitleMatchMode, 2
FileEncoding utf-8
;==================================================================================
;==================================================================================
;
;		initial variable from file
;
;==================================================================================
;==================================================================================
;=======|	UWP config 	|============================================
UWPedgeSignal := False
;=======|	winA mode	|============================================
noteSignal := False
codeSignal := False
IniRead, rootFile,./config.ini,filePath,ROOTFILE
noteFile := rootFile . "note\"
IniRead, lastDate, ./config.ini, DATE, Today, "20190502"
IniRead, lastDateName, ./config.ini, DATE, TodayString, "2019_05_02"
IniRead,notePath,./config.ini,filePath,todayNotePath
;=======|	debug	|============================================
allStringWithNum := "1,2,3,4,5,6,7,8,9,0,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
allString := "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
;=======|	search string	|============================================
searchSignal := False
searchEnginName := Object()
searchEnginString := Object()
searchPrompt :="please input SearchString`n"
IniRead ,searchEnginDefauleName,config.ini,SearchEnginName,default
IniRead ,searchEnginDefaultString,config.ini,SearchEngin,default
Loop 10{
	iniKey := "alt" . A_Index
	IniRead ,temp1,config.ini,SearchEnginName,%iniKey%,%searchEnginDefauleName%
	IniRead ,temp2,config.ini,SearchEngin,%iniKey%,%searchEnginDefaultString%
	searchEnginName[A_Index] := temp1
	searchEnginString[A_Index] := temp2
}
; prompt
Loop 5{
	temp1 := searchEnginName[A_Index*2-1]
	temp2 := searchEnginName[A_Index*2]
	searchPrompt := searchPrompt . "`nAlt+" . A_Index*2-1 . ": " . temp1 . "	Alt+" . A_Index*2 . ": " . temp2
}
;=======|	oneNote	|============================================
signStateOneNote := 0

;=======|	winBind	|============================================
keyWinBind := Object()
loop 20{
	winID := "win" . A_Index
	IniRead  temp, config.ini,winBind_id, %winID%
	keyWinBind[A_Index] := temp
}

; ;=======|	winRmode	|============================================
winRsignal := 0
; winRsignal2 := 0
; winRArray := Object()
; loop 676{
; 	IniRead  temp, config.ini,winR, %A_Index%
; 	winRArray[A_Index] := temp
; }
;=======|	winEmode	|============================================
winEsignal := False
; winEsignal2 := 0
; winEArray := Object()
; loop 676{
; 	IniRead  temp, config.ini,winE, %A_Index%
; 	winEArray[A_Index] := temp
; }

;=======|	daily record	|============================================
IniRead  dailyRecordPath, config.ini,filePath, dailyRecordPathKey
;=======|	temp	|============================================
IniRead  tempFile, config.ini,filePath, tempKey
;=======|	yinxiang	|============================================
IniRead yinxiang ,config.ini.filePath,yinxiang
;=======|	Transparent	|============================================
global TransparentFlag := 0 
;=======|	groupadd string	|============================================
GroupAdd ,notePad ,ahk_class SciTEWindow
GroupAdd ,notePad ,ahk_class Notepad++
GroupAdd ,notePad ,ahk_class PX_WINDOW_CLASS
GroupAdd, notePad,ahk_exe Code.exe
;=======|	group IDE	|============================================
GroupAdd , IDE,ahk_exe Code.exe
GroupAdd ,IDE ,ahk_class PX_WINDOW_CLASS
GroupAdd ,IDE ,ahk_exe ConEmu64.exe
;=======|	shift==>ctrl	|============================================
GroupAdd , altNum,ahk_exe Code.exe
GroupAdd ,altNum, ahk_exe ConEmu64.exe
groupadd ,altNum, ahk_class PX_WINDOW_CLASS
;=======|	ahk file	|============================================
IniRead  exePath, config.ini,AHKPATH, exe
IniRead  exeFilePath, config.ini,AHKPATH, exeFile
IniRead  exeConfigPath, config.ini,AHKPATH, exeConfig
IniRead  ahkPath, config.ini,AHKPATH, ahk
IniRead  ahkFilePath, config.ini,AHKPATH, ahkFile
IniRead  ahkRunPath, config.ini,AHKPATH, ahkRun
; ListVars

;==================================================================================
;==================================================================================
;
;		include file
;
;==================================================================================
;==================================================================================
#Include, ./capslock.ahk
#Include, ./winActive.ahk
#Include, ./space.ahk
#Include, ./typing.ahk	
#Include, ./roller.ahk
#Include, ./search.ahk
#Include, ./string.ahk
#Include, ./transparent.ahk
#Include, ./winActive.ahk
#Include, ./debug.ahk
#Include, ./winR.ahk
#Include,  ./winE.ahk
#Include, ./shift.ahk
#Include, ./winA.ahk
;=======|	function	|============================================ 
longPress(key,time:=200)
{
	KeyWait %key%
	if (A_TimeSinceThisHotkey > time)
	{
		return True
	}else{
		return False
	}
}

normal_key(key)
{
	sendInput,{blind}{%key%}
	return
}
_IniRead(sectionName,key,path := "./config.ini"){
    IniRead temp,%path%,%sectionName%,%key%
    Return temp
}

_IniWrite(sectionName,key,value,path := "./config.ini"){
    IniWrite, %Value%, %path%, %sectionName%, %Key%
    Return
}

;return 0 : no data clip
;return 1 : has data clip
func_getClipboard()
{
Clipboard = 
Send,^{c}
ClipWait 0.1
if ErrorLevel
	return 0
return 1
}
;=======|	tooltip	|============================================
func_tooltip(string:="",time := 1000)
{
ToolTip %string%
SetTimer ,toollable ,%time%
}
toollable:
	ToolTip
	return



;==================================================================================
;==================================================================================
;
;		other runSet
;
;==================================================================================
;==================================================================================
;=======|	mindmaster	|============================================
#IfWinActive ahk_exe C:\Program Files\mindmaster\MindMaster.exe
tab::Send, ^{enter}
#if
#IfWinActive ahk_class  SWT_Window0
$F2::Send , {F2}{Right}
#If
;=======|	vnote	|============================================
#IfWinActive ahk_exe D:\Program Portable\VNote\VNote.exe
\::send ^{e}
!i::
send !{i}
send {i}
return
#if
;=======|	dito	|============================================
Space & v::send !^+#{v}
`; & 7::Send #!^+{1}
`; & 8::Send #!^+{2}
`; & 9::Send #!^+{3}
`; & 0::Send #!^+{4}
;=======|	qq tim	|============================================
CapsLock & Tab::
Send !^+{z}
Sleep 100
IfWinActive, ahk_exe tim.exe
{
	convertTypeWriter("C")
}
return
#IfWinActive ahk_exe TIM.exe
; alt
!F::Click 205,52
!s::click 500,742
!v::
Click 1002,113 
Sleep 1000
Click 1060,308
return

!-::MouseMove 139,397
!=::MouseMove 698,418

!p::
Click 205,52
send 手机
Sleep 100
send {enter}
return

!b::
Click 205,52
send 宝宝
Sleep 100
send {enter}
return

!m::click 717,200

; shift
+`:: click 151,122
+1:: click 226,198
+2:: click 187,296
+3:: click 199,398
+4:: click 148,480
+5:: click 133,593
+6:: click 151,665
+7:: click 117,753
+8:: click 110,855


;string
`::
send ``
convertTypeWriter("E")
Sleep 2000
convertTypeWriter("C")
return
#if
;=======|	wechat	|============================================
Enter & \:: 
Send !^{w} 
IfWinActive, ahk_exe wechat.exe
	convertTypeWriter("C")
return
#IfWinActive ahk_exe WeChat.exe
!F::Click 313,54
!-::MouseMove 308,326
!=::MouseMove 666,319

+1::click 366,145
+2::click 333,255
+3::click 273,313
+4::click 263,456
+5::click 237,544
+6::click 236,636
+7::click 222,730
#if
;=======|	Scite notePad++ subLine++	|============================================
#IfWinActive ahk_class SciTEWindow
F5::click 506,83
#If
;=======|	chm exe	|============================================
#IfWinActive ahk_exe C:\Windows\hh.exe
!p::
click 280,100
Sleep 500
Send {enter}
Sleep 500
Send {enter}
return
#If
;=======|	explore.exe	|============================================
#IfWinActive, ahk_class #32770
!a::
click 181,110
return
!f::
click 540,214
return
#If
#IfWinActive ahk_class CabinetWClass
!=::
click 738,638
Sleep 300
send {esc}
return
!-::MouseMove 328,597

!a::
Sleep 500
Send ,{RButton}
Send {p 2}
Send {enter}
return
#if
!`::Send,^!{tab}
;=======|	dida	|============================================
Enter & d::Send, !+^{o}
space & a::send, !+^{a}
Space & f::send, !+^{f}
;=======|	QTranslate |============================================
CapsLock & T::
Send !{0}
Sleep 500
send {CtrlUp}}
return
;=======|	eveerything		|============================================
CapsLock & n::Run C:\Program Files\Everything\Everything.exe

;=======|	xortime	|============================================
#IfWinActive,  ahk_exe XorTime.exe
F5::
send {f6}{up}
Sleep 300
send {down}
Sleep 300
send {F5}
return
#If

;=======|	oneNote	|============================================
#If WinActive("ahk_exe" "ONENOTE.EXE") and (signStateOneNote == 0 or signStateOneNote == "")
	!1::func_oneNote(678,177)
	!2::func_oneNote(758,173)
	!3::func_oneNote(764,139)
	!4::func_oneNote(521,140)
	!z::func_oneNote(297,140)
	func_oneNote(x,y){
		Send {esc}
		MouseGetPos, xpos, ypos 
		Click %x%,%y%
		MouseMove xpos, ypos
	}
	
	!CapsLock::
	MouseGetPos, xpos, ypos
	signStateOneNote := 1
	func_tooltip("in write mode")
	Click 126,90
	MouseMove xpos, ypos
	return 
#If WinActive("ahk_exe" "ONENOTE.EXE") and (signStateOneNote == 1)
		!1::func_oneNote2(23,196)
		!2::func_oneNote2(159,156)
		!3::func_oneNote2(31,30)
		func_oneNote2(x,y){	
			MouseGetPos, xpos, ypos 
			Click 447,196
			Click %x%,%y%
			MouseMove xpos, ypos
		}
		
		!CapsLock::
		MouseGetPos, xpos, ypos
		signStateOneNote := 0
		func_tooltip("in draw mode")
		Click 288,87
		MouseMove xpos, ypos
		return
#if

$~*F5::normal_key("F5")
F5 & t::
Run D:\Program Portable\TinyCountdown\TinyCountdown.exe
Sleep 900
convertTypeWriter("E")
Sleep 100
Send M
Send {enter}
return


;=======|      mailbox |============================================
enter & BS::Send !^+{p}

;=======|	chrome	|============================================
#IfWinActive, ahk_exe chrome.exe
!capslock::
click 1492,94
MouseMove 1396,156
return

!w::
send !{w}
Sleep 500
click 1696,315
MouseMove 300,513
return
#if

;=======|	FOXITREADER 	|============================================
#IfWinActive, ahk_class classFoxitReader
!1::FOXITREADER(366,119)
!2::FOXITREADER(301,119)
!3::FOXITREADER(51,125)

!CapsLock::
click 198,56
click 155,116
click 768,62
return
#if
FOXITREADER(x,y){
		MouseGetPos, xpos, ypos 
		Click %x%,%y%
		MouseMove xpos, ypos
}


;=======|	uwp	|============================================
#IfWinActive, ahk_class ApplicationFrameWindow
!capslock::
if UWPedgeSignal == true
	UWPedgeSignal := False
else
{
	MsgBox, 4,, is edge?
	IfMsgBox Yes
	{
		UWPedgeSignal := True
		MouseGetPos x1,y1
		click 1305,94
		MouseMove %x1% , %y1%
	}
	else
	UWPoneNoteSignal := True
}
#if


#if (UWPedgeSignal == true) and WinActive("ahk_class ApplicationFrameWindow")
!1::edgeDraw(1513,225)
!2::edgeDraw(1427,240)
!3::edgeDraw(1184,225)
edgeDraw(x,y){
	MouseGetPos x1,y1
	click 1527,87
	click 1391,95
	click 1391,95
	Sleep 100
	Click %x%,%y%	
	MouseMove %x1% , %y1%
	return
}
!4::
MouseGetPos x1,y1
click 1527,87
click 1329,77
MouseMove %x1% , %y1%
return

; erazer
!z::
MouseGetPos x1,y1
click 1527,87
click 1451,77
MouseMove %x1% , %y1%
return

!a::
MouseGetPos x,y
click 1532,95
MouseMove %x%, %y%
return
#if