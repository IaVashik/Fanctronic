local orange = vecProjectile("orange", "193 183 123")
orange.addHandleFunc(function(cargo) {
    if(cargo.ShouldIgnoreVecBalls()) {
        return cargo.EmitSound("ParticleBall.Explosion")
    }
    
    if(cargo.GetModeType() != null) {
        cargo.ResetModes(cargo.ShouldHardReset())
    }

    cargo.SetMode(this)
    cargo.Dissolve()
})

orange.addRemoverFunc(function(_) {})

projectileModes.append(orange)