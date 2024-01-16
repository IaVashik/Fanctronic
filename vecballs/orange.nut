local orange = vecProjectile("orange", "193 183 123")
orange.addHandleFunc(function(cargo) : (orange) {
    if(cargo.GetModeType() != null) {
        cargo.ResetModes()
    }

    cargo.SetMode(orange)
    cargo.Dissolve()
})

orange.addRemoverFunc(function(_) {})

projectileModes.append(orange)