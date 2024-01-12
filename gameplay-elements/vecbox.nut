::vecBox <- class extends pcapEntity {
    CurrentMode = null;

    function SetMode(type) null
    function ResetMode() null
    function GetMode() vecProjectile
    function GetModeType() string

    // function GetGhost()

    function Activate() null
    function Deactivate() null
    function GetStatus() bool
}



function vecBox::SetMode(type) {
    this.SetUserData("ActivatedMode", type)
    this.CurrentMode = type;
}

function vecBox::ResetMode() {
    this.SetUserData("ActivatedMode", null)
    this.CurrentMode = null;
}

function vecBox::GetMode() {
    return this.GetUserData("ActivatedMode")
}

function vecBox::GetModeType() {
    local mode = this.GetMode()
    return mode ? mode.GetType() : null
}

function vecBox::Activate() {
    this.SetUserData("active", true)
    this.SetColor(this.CurrentMode.color)
}

function vecBox::Deactivate() {
    this.SetUserData("active", false)
    this.SetColor("255 255 255")
}

function vecBox::GetStatus() {
    return this.GetUserData("active")
}