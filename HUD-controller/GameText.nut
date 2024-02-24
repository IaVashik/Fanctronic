class ScreenText extends HudInterface {
    constructor(position, message, holdtime = 10, targetname = "") {
        this.CBaseEntity = entLib.CreateByClassname("game_text", {
            // Set initial properties for the text display entity
            channel = 2,
            color = "170 170 170",
            color2 = "0 0 0",
            effect = 0,
            fadein = 0,
            fadeout = 0,
            fxtime = 0,
            holdtime = holdtime,
            x = position.x,
            y = position.y,
            spawnflags = 0,
            message = message,
            targetname = targetname
        }).CBaseEntity
    }

    function SetText(message) null // Changes the message of the text display
    function SetChannel(value) null
    function SetColor(string_color) null
    function SetColor2(string_color) null
    function SetEffect(value) null
    function SetFadeIn(value) null
    function SetFadeOut(value) null
    function SetHoldTime(time) null
    function SetPos(Vector) null
}


// Implementation of 'enable' to display the on-screen text
function ScreenText::Enable() {
    EntFireByHandle(this, "Display")
}

// Implementation of 'disable' to hide the on-screen text
function ScreenText::Disable() {
    EntFireByHandle(this, "Disable")
}

function ScreenText::Update() {
    this.Enable()
}

function ScreenText::Change(message) {
    this.SetText(message)
}


// TODO comments

// Implementation of 'SetText' to change the message and re-enable the text display
function ScreenText::SetText(message) {
    this.SetKeyValue("message", message)
}

function ScreenText::SetChannel(channel) {
    this.SetKeyValue("channel", channel)
}

function ScreenText::SetColor(color) {
    this.SetKeyValue("color", color)
}

function ScreenText::SetColor2(color) {
    this.SetKeyValue("color2", color)
}

function ScreenText::SetEffect(idx) {
    this.SetKeyValue("effect", idx)
}

function ScreenText::SetFadeIn(value) {
    this.SetKeyValue("fadein", value)
}

function ScreenText::SetFadeOut(value) {
    this.SetKeyValue("fadeout", value)
}

function ScreenText::SetHoldTime(time) {
    this.SetKeyValue("holdtime", time)
}

function ScreenText::SetPos(position) {
    this.SetKeyValue("x", position.x)
    this.SetKeyValue("y", position.y)
}