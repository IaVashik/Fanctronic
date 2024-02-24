local _playerFizzle = function(modeIdx) {
    if((activator in vecgunOwners) == false) 
        return
    local vecgun = vecgunOwners[activator]        
    vecgun.deactivateMode(modeIdx)
}

local _cubeFizzle = function(cargo, hardReset = false) {
    if(cargo.GetMode() == null)
        return

    cargo.DeactivateMode(hardReset)
    cargo.EmitSound("VecBox.ClearShield")
}


function vecFizzle(modeIdx = null) : (_playerFizzle, _cubeFizzle) {
    if(modeIdx == null)
        modeIdx = caller.GetHealth()
    if(modeIdx == 999)
        return vecFizzleAll()
        
    if(activator.GetClassname() == "player") 
        return _playerFizzle(modeIdx)

    local cargo = vecBox(activator)

    if(cargo.GetMode() == projectileModes[modeIdx-1]) {
        if(cargo.GetModeType() == "purple") // hard code
            return _cubeFizzle(cargo, true)
        _cubeFizzle(cargo)
    }
}


function vecFizzleAll() : (_cubeFizzle) {
    if(activator.GetClassname() == "player") 
        return vecgunOwners[activator].resetModes()

    local cargo = vecBox(activator)
    if(cargo.GetModeType() == "purple") // hardcode
        return

    _cubeFizzle(cargo)
}