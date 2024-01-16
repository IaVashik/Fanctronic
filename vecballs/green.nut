local green = vecProjectile("green", "172 235 174")
green.addHandleFunc(function(cargo) : (green) {
    if(cargo.IsValid() == false) 
        return
    
    if(cargo.GetModeType() == "blue") {
        cargo.EnableGravity()
    }
    if(cargo.GetModeType() == "green") {
        cargo.GetGhost().Destroy()
    }

    cargo.SetMode(green)
    cargo.CreateGhost()
})

projectileModes.append(green)