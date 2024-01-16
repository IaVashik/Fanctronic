local green = vecProjectile("green", "200 100 200")
green.addHandleFunc(function(cargo) : (green) {
    if(cargo.GetModeType() == "blue") {
        cargo.EnableGravity()
    }
    if(cargo.GetModeType() == "green") {
        cargo.GetGhost().Destroy()
    }

    cargo.CreateGhost()
    cargo.SetMode(green)
})

projectileModes.append(green)


// projectileModes[1]["handle"] <- function(cargo, deactivateCargo) {
//     local cloned_cargo_name = "cloned_cube_" + cargo.entindex()

//     if(cargo.GetHealth() == 2) {
//         Entities.FindByName(null, cloned_cargo_name).Destroy()
//     }
//     else if(cargo.GetHealth() != 0) {
//         cargo = deactivateCargo(cargo)
//         cloned_cargo_name = "cloned_cube_" + cargo.entindex()
//     }

//     local clone_cargo = Entities.FindByName(null, "@clone-cube")
    

//     clone_cargo.SetOrigin(cargo.GetOrigin())
//     local angle = cargo.GetAngles()
//     clone_cargo.SetAngles(angle.x, angle.y, angle.z)
//     clone_cargo.__KeyValueFromString("targetname", cloned_cargo_name)
//     EntFireByHandle(clone_cargo, "DisableCollision", "", 0, null, null)

//     EntFire("@spawn-clone-cube", "forcespawn")
//     cargo.SetHealth(2)

//     Entities.FindByName(null, "@purple-vecbox").SetOrigin(cargo.GetOrigin())
//     EntFire("@purple-vecbox", "Stop")
//     EntFire("@purple-vecbox", "Start", "", FrameTime())
// }  