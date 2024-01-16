::vecBox <- class extends pcapEntity {
    CurrentMode = null;

    function SetMode(type) null
    function ResetMode() null
    function GetMode() vecProjectile
    function GetModeType() string

    function DisableGravity()
    function EnableGravity()

    function CreateGhost()
    function GetGhost()
}



function vecBox::SetMode(type) {
    this.SetUserData("ActivatedMode", type)
    this.CurrentMode = type;

    type.playParticle("vecbox", this.GetOrigin())
    this.SetColor(type.color)
}

function vecBox::ResetMode() {
    this.SetUserData("ActivatedMode", null)
    this.CurrentMode = null;

    this.SetColor("255 255 255")
}

function vecBox::GetMode() {
    return this.GetUserData("ActivatedMode")
}

function vecBox::GetModeType() {
    local mode = this.GetMode()
    return mode ? mode.GetType() : null
}



// todo
function vecBox::DisableGravity() {
    EntFire("@gravity_zero", "Disable", "")
    EntFire("@gravity_zero", "Enable", "", 0.06)
    cargo.SetContext("ingravity", 0, 0.03)
}

function vecBox::EnableGravity() {
    EntFire("@gravity_zero", "Disable", "")
    EntFire("@gravity_zero", "Enable", "", 0.03)
    cargo.SetContext("ingravity", 1)
}


function vecBox::CreateGhost() {
    local ghost = entLib.CreateProp("prop_physics", cargo.GetOrigin(), cargo.GetModelName())
    ghost.SetAbsAngles(cargo.GetAngles())
    this.SetUserData("ghostCargo", ghost)
}

function vecBox::GetGhost() {
    return this.GetUserData("ghostCargo")
}