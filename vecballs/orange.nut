local orange = vecProjectile("orange", "193 183 123")
orange.addHandleFunc(function(cargo) : (orange) {
    if(cargo.IsValid() == false) 
        return
    
    if(cargo.GetModeType() == "blue") {
        cargo.EnableGravity()
    }
    if(cargo.GetModeType() == "green") {
        cargo.GetGhost().Destroy()
    }

    cargo.SetMode(orange)
    cargo.Dissolve()
})

projectileModes.append(orange)