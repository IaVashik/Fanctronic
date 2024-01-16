local blue = vecProjectile("blue", "123 124 193") // 183 237 242
blue.addHandleFunc(function(cargo) : (blue) {
    if(cargo.IsValid() == false) 
        return
        
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