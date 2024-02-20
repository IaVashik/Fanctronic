function vecballHitController() {
    foreach(projectile in projectileCount){
        if(projectile.IsValid() == false) continue
        
        local cargo = entLib.FindByModelWithin("models/props/puzzlebox.mdl", projectile.GetOrigin(), 25)
        if(!cargo || !cargo.IsValid()) continue
        projectile.vecType.handleHitFunc(vecBox(cargo)) // bruh
        projectile.Destroy()
    }
}

RunScriptCode.setInterval(vecballHitController, FrameTime() *  5)
