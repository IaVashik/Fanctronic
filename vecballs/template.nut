local ball = vecProjectile("ballName", "255 125 125")
ball.addHandleFunc(function(cargo) : (ball) {
    if(cargo.GetModeType() != null) {
        cargo.ResetModes()
    }

    // your logic

    cargo.SetMode(ball)
})

ball.addRemoverFunc(function(cargo) {
})

projectileModes.append(ball)