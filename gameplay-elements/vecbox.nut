::vecBox <- class { // extends pcapEntity //* I have ur Valve
    CPcapEntity = null;
    CBaseEntity = null;

    constructor(entity) {
        this.CPcapEntity = entLib.FromEntity(entity)
        this.CBaseEntity = CPcapEntity.CBaseEntity
    }

    function SetMode(type) null
    function ActivateMode(type) null
    function DeactivateMode(hardReset) null
    function ResetModes(hardReset) null
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

    function _tostring() {
        return "pcapEntity: " + this.CBaseEntity + ""
    }

    function _typeof() {
        return "pcapEntity"
    }
}



function vecBox::SetMode(type) {
    this.SetUserData("ActivatedMode", type)
    this.SetContext(type.GetType(), 1) // For filters
}

function vecBox::ActivateMode(type) {
    this.SetMode(type)
    type.playParticle("vecbox", this.GetOrigin())

    animate.ColorTransition(this, this.GetColor(), type.color, 0.3, {eventName = this.CPcapEntity.CBaseEntity})
    this.EmitSound("VecBox.Activate")
}

function vecBox::DeactivateMode(hardReset = false) {
    if(this.GetMode() == null)
        return
    
    this.ResetModes(hardReset)
    animate.ColorTransition(this, this.GetColor(), "255 255 255", 0.5, {eventName = this.CPcapEntity.CBaseEntity}) // TODO hard code?
    this.EmitSound("VecBox.Deactivate")
    defaultVecball.playParticle("vecbox", this.GetOrigin())
}

function vecBox::ResetModes(hardReset = false) {
    local currentMode = this.GetMode()

    //? hard code?
    this.SetUserData("ActivatedMode", null)
    this.SetUserData("ShouldHardReset", false)
    this.SetUserData("ShouldIgnoreVecBalls", false)

    foreach(mode in projectileModes) {
        if(mode == currentMode || hardReset) {
            mode.cargoRemoveEffects(this)
            this.SetContext(mode.GetType(), 0)
        }
    }
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



// DID YOU KNOW THAT CLASS EXTENSION BREAKS THE GAME ON SAVE/LOAD? AND I DIDN'T KNOW! THAT'S WHY I HAD TO USE THIS FUCKING WORKAROUND!!!!
// More info: https://discord.com/channels/262311619428614144/263051788767199232/1211025106076307569
function vecBox::EmitSound(sound_name) this.CBaseEntity.EmitSound(sound_name)

function vecBox::GetAngles() return this.CBaseEntity.GetAngles()
function vecBox::GetAngularVelocity() return this.CBaseEntity.GetAngularVelocity()
function vecBox::GetBoundingMaxs() return this.CBaseEntity.GetBoundingMaxs()
function vecBox::GetBoundingMins() return this.CBaseEntity.GetBoundingMins()
function vecBox::GetCenter() return this.CBaseEntity.GetCenter()
function vecBox::GetClassname() return this.CBaseEntity.GetClassname()
function vecBox::GetForwardVector() return this.CBaseEntity.GetForwardVector()
function vecBox::GetHealth() return this.CBaseEntity.GetHealth()
function vecBox::GetLeftVector() return this.CBaseEntity.GetLeftVector()
function vecBox::GetMaxHealth() return this.CBaseEntity.GetMaxHealth()
function vecBox::GetModelKeyValues() return this.CBaseEntity.GetModelKeyValues()
function vecBox::GetModelName() return this.CBaseEntity.GetModelName()
function vecBox::GetName() return this.CBaseEntity.GetName()
function vecBox::GetOrigin() return this.CBaseEntity.GetOrigin()
function vecBox::GetScriptId() return this.CBaseEntity.GetScriptId()
function vecBox::GetUpVector() return this.CBaseEntity.GetUpVector()
function vecBox::ValidateScriptScope() return this.CBaseEntity.ValidateScriptScope()

function vecBox::SetAbsOrigin(vector) this.CBaseEntity.SetAbsOrigin(vector)
function vecBox::SetForwardVector(vector) this.CBaseEntity.SetForwardVector(vector)
function vecBox::SetHealth(health) this.CBaseEntity.SetHealth(health)
function vecBox::SetMaxHealth(health) this.CBaseEntity.SetMaxHealth(health)
function vecBox::SetModel(model_name) this.CBaseEntity.SetModel(model_name)
function vecBox::SetOrigin(vector) this.CBaseEntity.SetOrigin(vector)

// pcapEnt func
function vecBox::Destroy() this.CPcapEntity.Destroy()
function vecBox::Kill(fireDelay = 0) this.CPcapEntity.Kill(fireDelay)
function vecBox::Dissolve() this.CPcapEntity.Dissolve()
function vecBox::addOutput(outputName, target, input, param = "", delay = 0, fires = -1) this.CPcapEntity.addOutput(outputName, target, input, param, delay, fires)
function vecBox::ConnectOutputEx(outputName, script, delay = 0, fires = -1) this.CPcapEntity.ConnectOutputEx(outputName, script, delay, fires)
function vecBox::EmitSoundEx(sound_name, timeDelay = 0, eventName = this) this.CPcapEntity.EmitSoundEx(sound_name, timeDelay, eventName)

function vecBox::SetKeyValue(key, value) this.CPcapEntity.SetKeyValue(key, value)
function vecBox::SetAngles(x, y, z) this.CPcapEntity.SetAngles(x, y, z)
function vecBox::SetAbsAngles(vector) this.CPcapEntity.SetAbsAngles(vector)
function vecBox::SetName(name) this.CPcapEntity.SetName(name)
function vecBox::SetUniqueName(prefix = "a") this.CPcapEntity.SetUniqueName(prefix)
function vecBox::SetParent(parentEnt, fireDelay = 0) this.CPcapEntity.SetParent(parentEnt, fireDelay)
function vecBox::SetCollision(solid, fireDelay = 0) this.CPcapEntity.SetCollision(solid, fireDelay)
function vecBox::SetCollisionGroup(collisionGroup) this.CPcapEntity.SetCollisionGroup(collisionGroup)
function vecBox::SetAnimation(animationName, fireDelay) this.CPcapEntity.SetAnimation(animationName, fireDelay)
function vecBox::SetAlpha(opacity, fireDelay = 0) this.CPcapEntity.SetAlpha(opacity, fireDelay)
function vecBox::SetColor(colorValue, fireDelay = 0) this.CPcapEntity.SetColor(colorValue, fireDelay)
function vecBox::SetSkin(skin, fireDelay = 0) this.CPcapEntity.SetSkin(skin, fireDelay)
function vecBox::SetDrawEnabled(isEnabled, fireDelay = 0) this.CPcapEntity.SetDrawEnabled(isEnabled, fireDelay)
function vecBox::SetSpawnflags(flag) this.CPcapEntity.SetSpawnflags(flag)
function vecBox::SetModelScale(scaleValue, fireDelay = 0) this.CPcapEntity.SetModelScale(scaleValue, fireDelay)
function vecBox::SetCenter(vector) this.CPcapEntity.SetCenter(vector)
function vecBox::SetBBox(minBounds, maxBounds) this.CPcapEntity.SetBBox(minBounds, maxBounds)
function vecBox::SetContext(name, value, fireDelay = 0) this.CPcapEntity.SetContext(name, value, fireDelay)
function vecBox::SetUserData(name, value) this.CPcapEntity.SetUserData(name, value)

function vecBox::IsValid() return this.CPcapEntity.IsValid()
function vecBox::IsPlayer() return this.CPcapEntity.IsPlayer()
function vecBox::GetUserData(name) return this.CPcapEntity.GetUserData(name)
function vecBox::GetBBox() return this.CPcapEntity.GetBBox()
function vecBox::GetAABB() return this.CPcapEntity.GetAABB()
function vecBox::GetIndex() return this.CPcapEntity.GetIndex()
function vecBox::GetKeyValue(key) return this.CPcapEntity.GetKeyValue(key)
function vecBox::GetSpawnflags() return this.CPcapEntity.GetSpawnflags()
function vecBox::GetAlpha() return this.CPcapEntity.GetAlpha()
function vecBox::GetColor() return this.CPcapEntity.GetColor()
function vecBox::GetSkin() return this.CPcapEntity.GetSkin()
function vecBox::GetNamePrefix() return this.CPcapEntity.GetNamePrefix()
function vecBox::GetNamePostfix() return this.CPcapEntity.GetNamePostfix()