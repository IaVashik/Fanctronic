local orange = vecProjectile("orange", "255 200 0")
orange.addHandleFunc(function(cargo) : (orange) {
    // if(cargo.GetUserData("CurrentMode") == "green") {
    //     cargo.GetUserData("Clone").Destroy()
    // }
    if(cargo.GetModeType() == "blue") {
        cargo.EnableGravity()
    }

    cargo.SetMode(orange)
    cargo.Dissolve()
})

projectileModes.append(orange)