local _playerFizzle = function(modeIdx) {
    local vecgun = vecgunOwners[activator]
    
    if(modeIdx == null)
        modeIdx = caller.GetHealth() % projectileModes.len()

    vecgun.deactivateMode(modeIdx)
}

local _cubeFizzle = function(modeIdx) {
    local cargo = vecBox(activator)
    if(cargo.GetMode() == projectileModes[modeIdx - 1]) {
        cargo.ResetModes()
        cargo.EmitSound("VecBox.ClearShield")
        defaultVecball.playParticle("vecbox", cargo.GetOrigin())
    }
}

function vecFizzle(modeIdx = null) : (_playerFizzle, _cubeFizzle) {
    if(activator.GetClassname() == "player") 
        return _playerFizzle(modeIdx)
    _cubeFizzle(modeIdx)
}


function vecFizzleAll() {
    if(activator.GetClassname() == "player") 
        return vecgunOwners[activator].resetModes()
    
    local cargo = vecBox(activator)
    if(cargo.GetMode() == null)
        return

    cargo.ResetModes()
    cargo.EmitSound("VecBox.ClearShield")
    defaultVecball.playParticle("vecbox", cargo.GetOrigin())
}