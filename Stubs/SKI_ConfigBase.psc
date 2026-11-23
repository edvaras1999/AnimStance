Scriptname SKI_ConfigBase extends SKI_QuestBase
; Stub do SkyUI (so para compilar). O jogo usa o script verdadeiro do SkyUI.
string[] Property Pages Auto
int Function GetVersion()
	return 1
EndFunction
Function ForcePageReset() native
Function SetInfoText(string a_text) native
bool Function ShowMessage(string a_message, bool a_withCancel = true, string a_acceptLabel = "$Accept", string a_cancelLabel = "$Cancel") native
int Function AddHeaderOption(string a_text, int a_flags = 0) native
int Function AddEmptyOption() native
int Function AddMenuOption(string a_text, string a_value, int a_flags = 0) native
int Function AddToggleOption(string a_text, bool a_checked, int a_flags = 0) native
int Function AddKeyMapOption(string a_text, int a_keyCode, int a_flags = 0) native
Function SetMenuOptionValue(int a_option, string a_value, bool a_noUpdate = false) native
Function SetToggleOptionValue(int a_option, bool a_checked, bool a_noUpdate = false) native
Function SetKeyMapOptionValue(int a_option, int a_keyCode, bool a_noUpdate = false) native
Function SetMenuDialogOptions(string[] a_options) native
Function SetMenuDialogStartIndex(int a_value) native
Function SetMenuDialogDefaultIndex(int a_value) native
