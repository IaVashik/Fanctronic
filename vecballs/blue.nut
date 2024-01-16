local blue = vecProjectile("blue", "123 124 193") // 183 237 242
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