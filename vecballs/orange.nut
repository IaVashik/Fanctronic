local orange = vecProjectile("orange", "193 183 123")
orange.addHandleFunc(function(cargo) : (orange) {
    if(cargo.ShouldIgnoreVecBalls()) {
        return cargo.EmitSound("ParticleBall.Explosion")
    }
    
    if(cargo.GetModeType() != null) {
        cargo.ResetModes(cargo.ShouldHardReset())
    }

    cargo.SetMode(orange)
    cargo.Dissolve()
})

orange.addRemoverFunc(function(_) {})

projectileModes.append(orange)