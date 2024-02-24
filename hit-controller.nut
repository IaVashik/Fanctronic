::allCargos <- {}

// The vecballHitController function is a **workaround** that allows the vecball to trigger interactions with the vecbox if a player brings the box within proximity during the vecball's flight. 
// This is necessary because the entire flight trajectory of the vecball is calculated at the moment of launch to conserve resources.
// This function does not use `entLib.FindByModelWithin()` simply because it is too expensive to check every entity every 8 frames, so all existing vecboxes are "cached" in allCargoes for the sake of optimization.
// Could this function have been avoided? Yes, it would have been possible to make vecball's flight dynamic, but that would have been expensive as it would have required checking every entity every frame again.
function vecballHitController() {
    EntFireByHandle(self, "RunScriptCode", "vecballHitController()", FrameTime() * 8)
    if(projectileCount.len() == 0) return 

    foreach(cargo, _ in allCargos) {
        if(!cargo.IsValid()) 
            continue

        vecCheck(cargo)
    }
}

::vecCheck <- function(cargo) {
    local cargoOrigin = cargo.GetOrigin()
    local runAgain = false

    for(local idx = 0; idx < projectileCount.len(); idx++) {
        local projectile = projectileCount[idx]
        if(projectile.IsValid() == false) {
            projectileCount.remove(idx)
            continue
        } 

        local distance = (projectile.GetOrigin() - cargoOrigin).Length()
        if(distance <= 50) {
            projectile.vecType.handleHitFunc(vecBox(cargo))
            projectile.Destroy()
            break
        }

        if(distance <= 120) {
            runAgain = true
        }
    }

    // If vecball is near the cargo, check the distance every frame. This is necessary to improve accuracy
    if(runAgain) {
        RunScriptCode.delay(function():(cargo) {vecCheck(cargo)}, FrameTime())
    }
}

// This function is used to update the cache of existing cargo (vecbox) entities.
::updateCargosList <- function() {
    for(local ent; ent = Entities.FindByModel(ent, "models/props/puzzlebox.mdl");) {
        if(ent in allCargos) continue
        allCargos[ent] <- null
    }

    foreach(ent, _ in allCargos) {
        if(ent.IsValid() == false) 
            allCargos.rawdelete(ent)
    }
}

updateCargosList()
vecballHitController()
