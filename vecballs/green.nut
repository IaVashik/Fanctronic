local green = vecProjectile("green", "172 235 174")
green.addHandleFunc(function(cargo) : (green) {
    if(cargo.ShouldIgnoreVecBalls()) {
        return cargo.EmitSound("ParticleBall.Explosion")
    }
    
    if(cargo.GetModeType() == "green") {
        return cargo.DeactivateMode()
    }

    if(cargo.GetModeType() != null) {
        cargo.ResetModes(cargo.ShouldHardReset())
    }

    cargo.SetMode(green)
    cargo.CreateGhost()
})

green.addRemoverFunc(function(cargo) {
    local ghost = cargo.GetGhost()
    if(ghost && ghost.IsValid()) 
        ghost.Destroy()
})

projectileModes.append(green)