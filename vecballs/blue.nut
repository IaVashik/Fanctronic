local blue = vecProjectile("blue", "138 206 247")
blue.addHandleFunc(function(cargo) {
    printl(cargo)
})

projectileModes.append(blue)