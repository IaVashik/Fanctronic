local green = vecProjectile(EntityGroup[1], "200 100 200", "green")
green.addHandleFunc(function(cargo) {
    if(cargo.GetUserData("CurrentMode") == "green") {
        cargo.GetUserData("Clone").Destroy()
    }

    
})

projectileModes.append(green)