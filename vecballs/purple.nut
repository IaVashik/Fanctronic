local purple = vecProjectile("purple", "154 141 233")
purple.addHandleFunc(function(cargo) : (purple) {
    // For toggle-mode:
    if(cargo.GetModeType() == "purple") {
        return cargo.DeactivateMode(true)
    }

    local thisColor = purple.GetColor()
    local activateColor = cargo.GetColor()
    local eventName = cargo.CBaseEntity

    RunScriptCode.setInterval(function():(cargo, thisColor, activateColor, eventName) {
        animate.ColorTransition(cargo, thisColor, activateColor, 1, {eventName = eventName})
        animate.ColorTransition(cargo, activateColor, thisColor, 1, {eventName = eventName, globalDelay = 1})
    }, 2, 1, eventName)
    
    
    cargo.SetMode(purple)
})

purple.addRemoverFunc(function(cargo) {
    local eventName = cargo.CBaseEntity
    if(eventIsValid(eventName)) cancelScheduledEvent(eventName)
})

projectileModes.append(purple)