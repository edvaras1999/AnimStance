Scriptname ASL_MCM extends SKI_ConfigBase
{AnimStanceLE - seletor de estilos de animacao (punhos) / animation style selector (fists)}

; ---------------------------------------------------------------
; Propriedades preenchidas no plugin (AnimStanceLE.esp)
; ---------------------------------------------------------------
Spell Property ASL_Unarmed_Sel1_Ability Auto
Spell Property ASL_Unarmed_Sel2_Ability Auto
Spell Property ASL_Unarmed_Sel3_Ability Auto

; ---------------------------------------------------------------
; Estado (guardado no save)
; ---------------------------------------------------------------
int _style = 0          ; 0 = padrao (MCO base), 1..3 = seletor ativo
int _key = -1           ; tecla para alternar (-1 = nenhuma)
int _lang = 0           ; 0 = Portugues, 1 = English
bool _notify = true     ; aviso no ecra
int _maxStyle = 2       ; estilos instalados (1..3). O 3 esta reservado

int _oStyle
int _oKey
int _oNotify
int _oLang

; ---------------------------------------------------------------
; Inicio / carregar jogo
; ---------------------------------------------------------------
int Function GetVersion()
	return 1
EndFunction

Event OnConfigInit()
	ModName = "AnimStance"
	Pages = new string[1]
	Pages[0] = "AnimStance"
	RegisterKey()
	SyncStyle()
EndEvent

Event OnGameReload()
	parent.OnGameReload()
	RegisterKey()
	SyncStyle()
EndEvent

Function RegisterKey()
	UnregisterForAllKeys()
	if _key > 0
		RegisterForKey(_key)
	endIf
EndFunction

; ---------------------------------------------------------------
; Tecla: alterna 0 -> 1 -> 2 -> 0 (so com os punhos)
; ---------------------------------------------------------------
Event OnKeyDown(int a_keyCode)
	if a_keyCode != _key
		return
	endIf
	if Utility.IsInMenuMode()
		return
	endIf
	Actor p = Game.GetPlayer()
	if p.GetEquippedItemType(1) != 0
		if _notify
			Debug.Notification(T("AnimStance: sem estilos para esta arma", "AnimStance: no styles for this weapon"))
		endIf
		return
	endIf
	int next = _style + 1
	if next > _maxStyle
		next = 0
	endIf
	ApplyStyle(next, true)
EndEvent

; ---------------------------------------------------------------
; Logica dos estilos
; ---------------------------------------------------------------
Spell Function SelSpell(int a_style)
	if a_style == 1
		return ASL_Unarmed_Sel1_Ability
	elseIf a_style == 2
		return ASL_Unarmed_Sel2_Ability
	elseIf a_style == 3
		return ASL_Unarmed_Sel3_Ability
	endIf
	return None
EndFunction

Function ApplyStyle(int a_style, bool a_notice)
	Actor p = Game.GetPlayer()
	Spell chosen = SelSpell(a_style)
	int i = 1
	while i <= 3
		Spell s = SelSpell(i)
		if s != None && s != chosen && p.HasSpell(s)
			p.RemoveSpell(s)
		endIf
		i += 1
	endWhile
	if chosen != None && !p.HasSpell(chosen)
		p.AddSpell(chosen, false)
	endIf
	_style = a_style
	if a_notice && _notify
		Debug.Notification("AnimStance: " + StyleName(a_style))
	endIf
EndFunction

Function SyncStyle()
	Actor p = Game.GetPlayer()
	if p == None
		return
	endIf
	int found = 0
	if p.HasSpell(ASL_Unarmed_Sel3_Ability)
		found = 3
	endIf
	if p.HasSpell(ASL_Unarmed_Sel2_Ability)
		found = 2
	endIf
	if p.HasSpell(ASL_Unarmed_Sel1_Ability)
		found = 1
	endIf
	ApplyStyle(found, false)
EndFunction

; ---------------------------------------------------------------
; Textos (PT / EN)
; ---------------------------------------------------------------
string Function T(string a_pt, string a_en)
	if _lang == 1
		return a_en
	endIf
	return a_pt
EndFunction

string Function StyleName(int a_style)
	if a_style == 1
		return "Unarmed Moveset"
	elseIf a_style == 2
		return "Brawler (For Honor)"
	elseIf a_style == 3
		return T("Estilo 3", "Style 3")
	endIf
	return T("Padrao (MCO)", "Default (MCO)")
EndFunction

string[] Function StyleList()
	string[] l = new string[3]
	l[0] = StyleName(0)
	l[1] = StyleName(1)
	l[2] = StyleName(2)
	return l
EndFunction

string Function LangName(int a_lang)
	if a_lang == 1
		return "English"
	endIf
	return "Portugues"
EndFunction

; ---------------------------------------------------------------
; Menu MCM
; ---------------------------------------------------------------
Event OnPageReset(string a_page)
	; duas colunas (esquerda / direita), da esquerda para a direita
	AddHeaderOption(T("Punhos (unarmed)", "Fists (unarmed)"))
	AddHeaderOption(T("Controlos", "Controls"))
	_oStyle = AddMenuOption(T("Estilo de animacao", "Animation style"), StyleName(_style))
	_oKey = AddKeyMapOption(T("Tecla para alternar o estilo", "Key to cycle the style"), _key)
	AddEmptyOption()
	_oNotify = AddToggleOption(T("Aviso no ecra", "On-screen notice"), _notify)
	AddHeaderOption("Idioma / Language")
	AddEmptyOption()
	_oLang = AddMenuOption("Idioma / Language", LangName(_lang))
EndEvent

Event OnOptionMenuOpen(int a_option)
	if a_option == _oStyle
		SetMenuDialogOptions(StyleList())
		SetMenuDialogStartIndex(_style)
		SetMenuDialogDefaultIndex(0)
	elseIf a_option == _oLang
		string[] l = new string[2]
		l[0] = "Portugues"
		l[1] = "English"
		SetMenuDialogOptions(l)
		SetMenuDialogStartIndex(_lang)
		SetMenuDialogDefaultIndex(0)
	endIf
EndEvent

Event OnOptionMenuAccept(int a_option, int a_index)
	if a_option == _oStyle
		ApplyStyle(a_index, false)
		SetMenuOptionValue(a_option, StyleName(_style))
	elseIf a_option == _oLang
		_lang = a_index
		SetMenuOptionValue(a_option, LangName(_lang))
		ForcePageReset()
	endIf
EndEvent

Event OnOptionSelect(int a_option)
	if a_option == _oNotify
		_notify = !_notify
		SetToggleOptionValue(a_option, _notify)
	endIf
EndEvent

Event OnOptionKeyMapChange(int a_option, int a_keyCode, string a_conflictControl, string a_conflictName)
	if a_option == _oKey
		bool proceed = true
		if a_conflictControl != ""
			string msg
			if a_conflictName != ""
				msg = T("Esta tecla ja esta atribuida a:\n", "This key is already mapped to:\n") + a_conflictControl + " (" + a_conflictName + ")\n\n" + T("Continuar?", "Continue?")
			else
				msg = T("Esta tecla ja esta atribuida a:\n", "This key is already mapped to:\n") + a_conflictControl + "\n\n" + T("Continuar?", "Continue?")
			endIf
			proceed = ShowMessage(msg, true, "$Yes", "$No")
		endIf
		if proceed
			_key = a_keyCode
			SetKeyMapOptionValue(a_option, _key)
			RegisterKey()
		endIf
	endIf
EndEvent

Event OnOptionDefault(int a_option)
	if a_option == _oStyle
		ApplyStyle(0, false)
		SetMenuOptionValue(a_option, StyleName(0))
	elseIf a_option == _oKey
		_key = -1
		SetKeyMapOptionValue(a_option, _key)
		RegisterKey()
	elseIf a_option == _oNotify
		_notify = true
		SetToggleOptionValue(a_option, _notify)
	elseIf a_option == _oLang
		_lang = 0
		SetMenuOptionValue(a_option, LangName(0))
		ForcePageReset()
	endIf
EndEvent

Event OnOptionHighlight(int a_option)
	if a_option == _oStyle
		SetInfoText(T("Escolhe qual conjunto de animacoes de punhos toca. O padrao usa o MCO base.", "Chooses which fist animation set plays. Default uses the base MCO."))
	elseIf a_option == _oKey
		SetInfoText(T("Alterna entre os estilos quando estas sem arma na mao direita.", "Cycles the styles while your right hand is empty."))
	elseIf a_option == _oNotify
		SetInfoText(T("Mostra o nome do estilo no ecra ao alternar.", "Shows the style name on screen when cycling."))
	elseIf a_option == _oLang
		SetInfoText("Portugues / English")
	endIf
EndEvent
