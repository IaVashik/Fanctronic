local ball = vecProjectile("ballName", "255 125 125")

// This function will be called when Vecball hits the cargo
ball.addHandleFunc(function(cargo) : (ball) {
    // Should we ignore the vecballs (optional, for example: used in purple mode)
    if(cargo.ShouldIgnoreVecBalls()) {
        return cargo.EmitSound("ParticleBall.Explosion")
    }
    // To turn ignore on - just type: `cargo.EnableIgnoreVecBalls()`, to disable: cargo.ResetModes/DeactivateMode

    // For toggle-mode:
    // if(cargo.GetModeType() == "ballName") {
    //     return cargo.DeactivateMode()
    // }

    if(cargo.GetModeType() != null) {
        cargo.ResetModes(cargo.ShouldHardReset())
    }

    // your logic
    // example: cargo.SetAlpha(100)

    cargo.SetMode(ball)
    // Set the need to conduct a HardReset (Clearing effects from all modes)
    // cargo.EnableHardReset()
})

// This function will be called to undo effects
ball.addRemoverFunc(function(cargo) {
    // example: cargo.SetAlpha(255)
})

projectileModes.append(ball)