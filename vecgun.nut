class VectronicGun {
    owner = null;

    currentMode = null;
    availablesModes = null;
    activeProjectiles = null;

    constructor(player) {
        this.availablesModes = array(projectileModes.len(), false)
        this.owner = player;
        this.activeProjectiles = arrayLib.new()
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

    local trace = bboxcast.TracePlayerEyes(maxDistance, null, defaultSettings, this.owner)
    local start = trace.GetStartPos() 
    local hit = trace.GetHitpos()

    local projectile = this.GetBall().Shoot(start, hit, this.owner)

    // local idx = activeProjectiles.len()
    // activeProjectiles.append(projectile)
    // CreateScheduleEvent(projectile.eventName, function() : (activeProjectiles, idx) {
    //     activeProjectiles.remove(idx)
    // }, projectile.timeLife)
}

function VectronicGun::activateMode(idx) {
    idx--
    this.availablesModes[idx] = true
    this.SetMode(idx)
}

function VectronicGun::deactivateMode(idx) {
    idx--
    if(currentMode == idx) 
        this.switchMode

    this.availablesModes[idx] = false
    
    local type = projectileModes[idx].GetType()
    foreach(idx, ball in this.activeProjectiles){
        if(ball.GetType() == type) {
            ball.Destroy()
            this.activeProjectiles.remove(idx)
        }
    }
}

function VectronicGun::SetMode(idx) {
    this.currentMode = idx
    // TODO viewmodel logic
}

function VectronicGun::resetModes() {
    this.availablesModes.apply(function(idx) : (activeProjectiles) {
        activeProjectiles[value].Destroy()
        return false
    });
    this.currentMode = null
    this.activeProjectile.clear()
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
    if(nextMode == null) 
        return printl("Fanctronic: No other projectile")  // todo change to viewmodel

    this.currentMode = nextMode
    printl("Fanctronic: Set " + (nextMode + 1) + " mode :>") // todo change to viewmodel
}

function VectronicGun::GetBall() {
    return projectileModes[this.currentMode]
}