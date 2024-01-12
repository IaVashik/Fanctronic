local green = vecProjectile("green", "200 100 200")
green.addHandleFunc(function(cargo) {
    if(cargo.GetUserData("CurrentMode") == "green") {
        cargo.GetUserData("Clone").Destroy()
    }

    
})

projectileModes.append(green)