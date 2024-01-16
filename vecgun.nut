class VectronicGun {
    owner = null;

    currentMode = null;
    availablesModes = null;
    activeProjectiles = null;
    usedDispancer = null;

    constructor(player) {
        local vecballCount = projectileModes.len()

        this.availablesModes = array(vecballCount, false)
        this.owner = player;
        this.activeProjectiles = arrayLib.new()

        this.usedDispancer = arrayLib.new()
        for(local i = 0; i < vecballCount; i++) {
            this.usedDispancer.append(arrayLib.new())
        }
    }

    function Shoot() null
    function activateMode(idx) null
    function deactivateMode(idx) null
    function SetMode(idx) null
    function resetModes() null
    function switchMode() null
    function GetBall() null
}


function VectronicGun::Shoot() {
    if(this.currentMode == null) 
        return printl("Fanctronic: No projectile")  // todo change to viewmodel

    local start = GetPlayerEx().EyePosition() 
    local end = start + GetPlayerEx().EyeForwardVector() * maxDistance
    local projectile = this.GetBall().Shoot(start, end, this.owner)

    // local idx = activeProjectiles.len() // TODO
    // activeProjectiles.append(projectile)
    // CreateScheduleEvent(projectile.eventName, function() : (activeProjectiles, idx) {
    //     activeProjectiles.remove(idx)
    // }, projectile.timeLife)
}

function VectronicGun::activateMode(idx, dispancer = null) {
    idx = (idx - 1) % this.availablesModes.len() 
    this.availablesModes[idx] = true
    this.SetMode(idx)
    this.owner.EmitSound("Weapon_VecGun.Upgrade")

    if(dispancer) {
        this.usedDispancer[idx].append(dispancer)
    }
}

function VectronicGun::deactivateMode(idx) {
    idx -= 1

    if(availablesModes[idx] == false)
        return dev.log("This mode has already been deactivated: " + idx)

    this.availablesModes[idx] = false
    if(currentMode == idx) 
        this.switchMode()
    
    local type = projectileModes[idx].GetType()
    foreach(idx, ball in this.activeProjectiles){
        if(ball.GetType() == type) {
            ball.Destroy()
            this.activeProjectiles.remove(idx)
        }
    }

    local dispancers = this.usedDispancer[idx]
    foreach(dispancer in dispancers){
        EntFireByHandle(dispancer, "FireUser1")
    }
    dispancers.clear()
}

function VectronicGun::SetMode(idx) {
    this.currentMode = idx
    // TODO viewmodel logic
}

function VectronicGun::resetModes() {
    if(this.currentMode == null)
        return

    this.currentMode = null

    foreach(idx, key in this.availablesModes){
        key = false
    }

    foreach(projectile in this.activeProjectiles){
        projectile.Destroy()
    }
    this.activeProjectiles.clear()

    foreach(dispancers in this.usedDispancer){
        foreach(dispancer in dispancers){
            EntFireByHandle(dispancer, "FireUser1")
        }
        dispancers.clear()
    }
    
    this.owner.EmitSound("Weapon_VecGun.Fizzle")
}

function VectronicGun::switchMode() {
    if(this.currentMode == null)
        return printl("Fanctronic: No projectile")  // todo change to viewmodel

    local startIndex = this.currentMode
    local nextMode = null
    local len = this.availablesModes.len()

    for (local i = 1; i < len; i++) {
        local index = (startIndex + i) % len
        if (this.availablesModes[index]) {
            nextMode = index
            break
        }
    }
    if(nextMode == null) {
        if(this.availablesModes[startIndex] == false) {
            return this.currentMode = null
        }
        else return printl("Fanctronic: No other projectile")  // todo change to viewmodel
    }
        
    

    this.currentMode = nextMode
    this.owner.EmitSound("Weapon_Vecgun.Change")
    printl("Fanctronic: Set " + (nextMode + 1) + " mode :>") // todo change to viewmodel
}

function VectronicGun::GetBall() {
    return projectileModes[this.currentMode]
}