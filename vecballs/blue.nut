local blue = vecProjectile("blue", "135 213 212") // 143 229 226
blue.addHandleFunc(function(cargo) : (blue) {
    if(cargo.GetModeType() == "blue") {
        return cargo.DeactivateMode()
    }
    
    if(cargo.GetModeType() != null) {
        cargo.ResetModes()
    }

    cargo.DisableGravity()
    cargo.SetMode(blue)
})

blue.addRemoverFunc(function(cargo) {
    cargo.EnableGravity()
})

projectileModes.append(blue)