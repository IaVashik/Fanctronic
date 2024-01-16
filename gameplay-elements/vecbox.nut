::vecBox <- class extends pcapEntity {
    function SetMode(type) null
    function DeactivateMode() null
    function ResetModes() null
    function GetMode() vecProjectile
    function GetModeType() string

    function DisableGravity() null
    function EnableGravity() null

    function CreateGhost() null
    function GetGhost() pcapEntity
}



function vecBox::SetMode(type) {
    this.SetUserData("ActivatedMode", type)

    type.playParticle("vecbox", this.GetOrigin())
    this.SetColor(type.color)
    this.EmitSound("VecBox.Activate")
}

function vecBox::DeactivateMode() {
    if(this.GetMode() == null)
        return
    
    this.ResetModes()
    this.EmitSound("VecBox.Deactivate")
    defaultVecball.playParticle("vecbox", this.GetOrigin())
}

function vecBox::ResetModes() {
    local currentMode = this.GetMode()

    foreach(mode in projectileModes) {
        if(mode == currentMode)
            mode.cargoRemoveEffects(this)
    }

    this.SetUserData("ActivatedMode", null)
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
    EntFire("@gravity_zero", "Enable", "", 0.03)
    EntFireByHandle(this, "wake")

    this.SetContext("ingravity", 1)
}

function vecBox::EnableGravity() {
    EntFire("@gravity_zero", "Disable", "")
    EntFire("@gravity_zero", "Enable", "", 0.06)
    EntFireByHandle(this, "wake")

    this.SetContext("ingravity", 0, 0.03)
}


function vecBox::CreateGhost() {
    entLib.FindByName("@green_spawn").SpawnEntity()
    local ghost = entLib.FindByName("@ghost-cube")

    ghost.SetName(UniqueString())

    ghost.SetOrigin(this.GetOrigin())
    ghost.SetAbsAngles(this.GetAngles())
    ghost.SetColor(this.GetMode().GetColor())
    ghost.SetCollisionGroup(12)

    local workaround = entLib.FindByClassnameWithin("trigger_multiple", this.GetOrigin(), 1)
    workaround.addOutput("OnEndTouchAll", ghost, "AddOutput", "CollisionGroup 24")

    this.SetUserData("ghostCargo", ghost)
}

function vecBox::GetGhost() {
    return this.GetUserData("ghostCargo")
}