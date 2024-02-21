::allCargos <- {}

function vecballHitController() {
    // foreach(projectile in projectileCount){
    //     if(projectile.IsValid() == false) continue
        
    //     local cargo = entLib.FindByModelWithin("models/props/puzzlebox.mdl", projectile.GetOrigin(), 25)
    //     if(!cargo || !cargo.IsValid()) continue
    //     projectile.vecType.handleHitFunc(vecBox(cargo)) // bruh
    //     projectile.Destroy()
    // }

    EntFireByHandle(self, "RunScriptCode", "vecballHitController()", FrameTime() * 7)
    if(projectileCount.len() == 0) return 

    foreach(cargo, _ in allCargos) {
        if(!cargo.IsValid()) 
            continue

        local cargoOrigin = cargo.GetOrigin()
        
        foreach(projectile in projectileCount) {
            if(projectile.IsValid() == false) 
                continue
            if((projectile.GetOrigin() - cargoOrigin).Length() <= 50) {
                projectile.vecType.handleHitFunc(vecBox(cargo))
                projectile.Destroy()
                break
            }

        }
    }
}

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
