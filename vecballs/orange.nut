local orange = vecProjectile("orange", "255 200 0")
orange.addHandleFunc(function(cargo) : (orange) {
    if(cargo.GetUserData("CurrentMode") == "green") {
        cargo.GetUserData("Clone").Destroy()
    }

    
    cargo.Dissolve()
    orange.playParticle("vecbox", cargo.GetOrigin())
})

projectileModes.append(orange)