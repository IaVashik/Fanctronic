function initDispancer(mode) {
    local ballMode = projectileModes[mode - 1]
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

        baseFX.SetParent(basePoint)
        coreFX.SetParent(basePoint)
        vecballFX.SetParent(vecballPoint)

        baseFX.SetName(basePoint.GetName())
        coreFX.SetName(basePoint.GetName())
        vecballFX.SetName(vecballFX.GetName())

    
    ballMode.appendDispancer(dispancer)
}