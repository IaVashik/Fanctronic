function initDispancer(mode) {
    local ballMode = projectileModes[(mode - 1) % projectileModes.len()]
    local dispancer = entLib.FromEntity(caller)
    local prefix = dispancer.GetNamePrefix()

    dispancer.SetColor(ballMode.GetColor())

    // Set particles
    local basePoint = entLib.FindByName(prefix + "dispenser_particle")
    local vecballPoint = entLib.FindByName(prefix + "dispenser_vecball")

    local colorPrefix = "@" + ballMode.GetType() + "-"

    entLib.FindByName(colorPrefix + "dispancer-spawn").SpawnEntity()
    local baseFX = entLib.FindByName(colorPrefix + "dispancer-base")
    local coreFX = entLib.FindByName(colorPrefix + "dispancer-core")
    local vecballFX = entLib.FindByName(colorPrefix + "dispancer-vecball")

        // Particle initialization
        baseFX.SetOrigin(basePoint.GetOrigin())
        coreFX.SetOrigin(basePoint.GetOrigin())
        vecballFX.SetOrigin(vecballPoint.GetOrigin())

        // baseFX.SetParent(basePoint)
        // coreFX.SetParent(basePoint)
        // vecballFX.SetParent(vecballPoint)

        baseFX.SetName(basePoint.GetName())
        coreFX.SetName(basePoint.GetName())
        vecballFX.SetName(vecballPoint.GetName())

        EntFireByHandle(baseFX, "Start")
        EntFireByHandle(coreFX, "Start")
        EntFireByHandle(vecballFX, "Start")
    
    // ballMode.appendDispancer(dispancer)
}

function touchDispancer(mode) {
    local vecgun = vecgunOwners[activator]
    vecgun.activateMode(mode, caller)
}