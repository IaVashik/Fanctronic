::HintInstructor <- class extends HudInterface {
    constructor(message, holdtime = 5, icon = "icon_tip", showOnHud = 1, targetname = "hint") {
        this.CBaseEntity = entLib.CreateByClassname("env_instructor_hint", {
            // The text of your hint. 100 character limit.
            hint_caption = message,
            // Either show at the position of the Target Entity, or show the hint directly on the HUD at a fixed position.
            hint_static = showOnHud,
            hint_allow_nodraw_target = showOnHud,
            // The color of the caption text.
            hint_color = "255, 255, 255",
            // The icon to use when the hint is within the player's view.
            hint_icon_onscreen = icon,
            hint_icon_offscreen = icon,
            // The automatic timeout for the hint. 0 will persist until stopped with EndHint.
            hint_timeout = holdtime,
            hint_forcecaption = 1
            hint_nooffscreen = 0,
            hint_range = 0,
            targetname = targetname
        }).CBaseEntity
    }

    function SetText(message) null // Changes the message of the text display
    function SetBind(bind) null
    function SetPositioning(value) null
    function SetColor(string_color) null
    function SetIconOnScreen(icon) null
    function SetIconOffScreen(bind) null
    function SetHoldTime(time) null
    function SetDistance(value) null
    function SetEffects(sizePulsing, alphaPulsing, shaking) null
}

// Implementation of 'enable' to display the on-screen text
function HintInstructor::Enable() {
    EntFireByHandle(this, "ShowHint")
}

// Implementation of 'disable' to hide the on-screen text
function HintInstructor::Disable() {
    EntFireByHandle(this, "EndHint")
}

function HintInstructor::Update() {
    this.Enable()
}

function HintInstructor::Change(message) {
    this.SetText(message)
}


// TODO comments
function HintInstructor::SetText(message) {
    this.SetKeyValue("hint_caption", message)
}
 
function HintInstructor::SetBind(bind) {
    this.SetKeyValue("hint_binding", bind)
    this.SetKeyValue("hint_icon_onscreen", "use_binding")
}

function HintInstructor::SetPositioning(value) { // showOnHud
    this.SetKeyValue("hint_static", value)
}

function HintInstructor::SetColor(color) {
    this.SetKeyValue("hint_color", color)
}

function HintInstructor::SetIconOnScreen(icon) {
    this.SetKeyValue("hint_icon_onscreen", icon)
}

function HintInstructor::SetIconOffScreen(bind) {
    this.SetKeyValue("hint_icon_offscreen", icon)
}   

function HintInstructor::SetHoldTime(time) {
    this.SetKeyValue("hint_timeout", time)
}

function HintInstructor::SetDistance(value) {
    this.SetKeyValue("hint_range", value)
}

function HintInstructor::SetEffects(sizePulsing, alphaPulsing, shaking) {
    this.SetKeyValue("hint_pulseoption", sizePulsing)
    this.SetKeyValue("hint_alphaoption", alphaPulsing)
    this.SetKeyValue("hint_shakeoption", shaking)
}