local blue = vecProjectile("blue", "135 213 212") // 143 229 226
blue.addHandleFunc(function(cargo) {
    if(cargo.ShouldIgnoreVecBalls()) {
        return cargo.EmitSound("ParticleBall.Explosion")
    }

    if(cargo.GetModeType() == "blue") {
        return cargo.DeactivateMode()
    }
    
    if(cargo.GetModeType() != null) {
        cargo.ResetModes(cargo.ShouldHardReset())
    }

    cargo.DisableGravity()
    cargo.ActivateMode(this)
})

blue.addRemoverFunc(function(cargo) {
    cargo.EnableGravity()
})

projectileModes.append(blue)