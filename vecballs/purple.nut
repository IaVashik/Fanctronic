local purple = vecProjectile("purple", "154 141 233")
purple.addHandleFunc(function(cargo) {
    // For toggle-mode:
    if(cargo.GetModeType() == "purple") {
        return cargo.DeactivateMode(false)
    }

    cargo.SetUserData("previousMode", cargo.GetMode())

    local thisColor = this.GetColor()
    local activateColor = cargo.GetColor()
    local eventName = cargo.CBaseEntity

    local action = function(cargo, thisColor, activateColor, eventName) {
        animate.ColorTransition(cargo, thisColor, activateColor, 1, {eventName = eventName})
        animate.ColorTransition(cargo, activateColor, thisColor, 1, {eventName = eventName, globalDelay = 1})
    }
    ScheduleEvent.AddInterval(eventName, action, 2, 1, [cargo, thisColor, activateColor, eventName])
    
    cargo.ActivateMode(this)
    cargo.EnableIgnoreVecBalls()
})

purple.addRemoverFunc(function(cargo) {
    local eventName = cargo.CBaseEntity
    if(eventIsValid(eventName)) ScheduleEvent.Cancel(eventName)
    
    local previousMode = cargo.GetUserData("previousMode")
    if(previousMode)
        cargo.SetMode(previousMode)
})

projectileModes.append(purple)