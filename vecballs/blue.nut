local blue = vecProjectile("blue", "138 206 247")
blue.addHandleFunc(function(cargo) : (blue) {
    // EntFire("@gravity_zero", "Disable", "")
    // EntFire("@gravity_zero", "Enable", "", 0.1)

    if(cargo.GetModeType() == "blue") {
        cargo.SetContext("ingravity", 0)
        cargo.ResetMode()
        return cargo.Deactivate()
    }

    cargo.SetMode(blue)
    cargo.SetContext("ingravity", 1)

    return cargo.Activate() // TODO
})

projectileModes.append(blue)