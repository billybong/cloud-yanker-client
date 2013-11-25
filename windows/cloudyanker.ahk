IniRead, LOCATION, config.ini, SETTINGS, LOCATION, ""
IniRead, USER, config.ini, SETTINGS, USER, ""
URL = %LOCATION%%USER%

MsgBox, Welcome %USER%. CTRL+ALT+Y to copy, CTRL+ALT+P to paste. Will use %URL% as backend.

/*
###############################################################################################################
###                                       CloudYanker. Version 1.0                                       ###
###############################################################################################################

Uses the HTTPRequest script to call the CloudYanker service when hotkeys are pressed.
Hotkeys can be switched, see AutoHotkey for instructions. Default is CTRL+ALT+Y for copying, and CTRL+ALT+P for pasting
*/

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include httprequest.ahk

^!p:: ;Performs a GET
data := getSnippet(URL)
clipboard = %data%
send, ^v
return

^!y:: ;Performs a POST
postSnippet(URL)
return


getSnippet(url){
    HTTPRequest(url, data, "", "")
    return data
}

postSnippet(url){
	data := getFromClipboard()

	Headers=
	(
	 Content-Type: text/plain; charset=utf-8
	)

    HTTPRequest(url, data, Headers, "`nCODEPAGE")
	return
}

getFromClipboard(){
	clipboard = ; Empty the clipboard
	Send, ^c
	ClipWait, 2
	if ErrorLevel
	{
	    MsgBox, The attempt to copy text onto the clipboard failed.
	    return
	}
	return clipboard
}

#Include httprequest.ahk