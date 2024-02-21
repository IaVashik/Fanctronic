::vecBox <- class extends pcapEntity {
    function SetMode(type) null
    function DeactivateMode() null
    function ResetModes() null
    function GetMode() vecProjectile
    function GetModeType() string

    function ShouldHardReset() bool
    function ShouldIgnoreVecBalls() bool
    function EnableHardReset() null
    function EnableIgnoreVecBalls() null
    
    function DisableGravity() null
    function EnableGravity() null

    function CreateGhost() null
    function GetGhost() pcapEntity
}



function vecBox::SetMode(type) {
    this.SetUserData("ActivatedMode", type)
    // For filters
    this.SetContext(type.GetType(), 1)

    type.playParticle("vecbox", this.GetOrigin())

    animate.ColorTransition(this, this.GetColor(), type.color, 0.3, {eventName = this.CBaseEntity})
    this.EmitSound("VecBox.Activate")
}

function vecBox::DeactivateMode(hardReset = false) {
    if(this.GetMode() == null)
        return
    
    this.ResetModes(hardReset)
    animate.ColorTransition(this, this.GetColor(), "255 255 255", 0.5, {eventName = this.CBaseEntity}) // TODO hard code?
    this.EmitSound("VecBox.Deactivate")
    defaultVecball.playParticle("vecbox", this.GetOrigin())
}

function vecBox::ResetModes(hardReset = false) {
    local currentMode = this.GetMode()

    foreach(mode in projectileModes) {
        if(mode == currentMode || hardReset) {
            mode.cargoRemoveEffects(this)
            this.SetContext(mode.GetType(), 0)
        }
    }

    // TODO hard code?
    this.SetUserData("ActivatedMode", null)
    this.SetUserData("ShouldHardReset", false)
    this.SetUserData("ShouldIgnoreVecBalls", false)
}


// todo
function vecBox::ShouldHardReset() {
    return this.GetUserData("ShouldHardReset")
}

function vecBox::ShouldIgnoreVecBalls() {
    return this.GetUserData("ShouldIgnoreVecBalls")
}

function vecBox::EnableHardReset() {
    this.SetUserData("ShouldHardReset", true)
}

function vecBox::EnableIgnoreVecBalls() {
    this.SetUserData("ShouldIgnoreVecBalls", true)
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

    ghost.SetUniqueName()

    ghost.SetOrigin(this.GetOrigin())
    ghost.SetAbsAngles(this.GetAngles())
    ghost.SetColor(this.GetMode().GetColor())
    ghost.SetCollisionGroup(12)
    animate.AlphaTransition(ghost, 0, 255, 0.15)

    local workaround = entLib.FindByClassnameWithin("trigger_multiple", this.GetOrigin(), 1)
    workaround.addOutput("OnEndTouchAll", ghost, "AddOutput", "CollisionGroup 24")

    this.SetUserData("ghostCargo", ghost)
}

function vecBox::GetGhost() {
    return this.GetUserData("ghostCargo")
}