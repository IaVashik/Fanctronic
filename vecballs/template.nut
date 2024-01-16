local ball = vecProjectile("ballName", "255 125 125")
ball.addHandleFunc(function(cargo) : (ball) {
    // For toggle-mode:
    // if(cargo.GetModeType() == "ballName") {
    //     return cargo.DeactivateMode()
    // }

    if(cargo.GetModeType() != null) {
        cargo.ResetModes()
    }

    // your logic

    cargo.SetMode(ball)
})

ball.addRemoverFunc(function(cargo) {
})

projectileModes.append(ball)