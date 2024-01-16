local blue = vecProjectile("blue", "138 206 247")
blue.addHandleFunc(function(cargo) : (blue) {
    if(cargo.GetModeType() == "blue") {
        cargo.EnableGravity()
        cargo.ResetMode()
        return
    }
    if(cargo.GetModeType() == "green") {
        cargo.GetGhost().Destroy()
    }

    cargo.DisableGravity()
    cargo.SetMode(blue)
})

projectileModes.append(blue)