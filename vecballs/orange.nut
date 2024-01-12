local orange = vecProjectile(EntityGroup[2], "255 200 0", "orange")
orange.addHandleFunc(function(cargo) {
    if(cargo.GetUserData("CurrentMode") == "green") {
        cargo.GetUserData("Clone").Destroy()
    }

    cargo.SetColor(this.color)
    cargo.Dissolve()
    this.playParticle("vecbox", cargo.GetOrigin())
})

projectileModes.append(orange)