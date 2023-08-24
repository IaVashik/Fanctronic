projectileInfo <- [
    {projectileEnt = EntityGroup[0], color = "138 206 247", available = false},
    {projectileEnt = EntityGroup[1], color = "200 100 200", available = false},
    {projectileEnt = EntityGroup[2], color = "255 200 0", available = false},
]

projectileInfo[0]["handle"] <- function(cargo, deactivateCargo) {
    if(cargo.GetHealth() == 1) {
        Entities.FindByName(null, "@gray-vecbox").SetOrigin(cargo.GetOrigin())
        EntFire("@gray-vecbox", "Stop")
        EntFire("@gray-vecbox", "Start", "", FrameTime())
        return deactivateCargo(cargo)
    }

    if(cargo.GetHealth() == 2) {
        local cloned_cargo_name = "cloned_cube_" + cargo.entindex()
        Entities.FindByName(null, cloned_cargo_name).Destroy()
    }

    local ingravity_cargo = Entities.FindByName(null, "@ingravity-cube")

    ingravity_cargo.SetOrigin(cargo.GetOrigin())
    local angle = cargo.GetAngles()
    ingravity_cargo.SetAngles(angle.x, angle.y, angle.z)
    ingravity_cargo.__KeyValueFromString("targetname", cargo.GetName())
    
    cargo.Destroy()

    EntFire("@spawn-ingravity-cube", "forcespawn")
    ingravity_cargo.SetHealth(1)

    Entities.FindByName(null, "@blue-vecbox").SetOrigin(ingravity_cargo.GetOrigin())
    EntFire("@blue-vecbox", "Stop")
    EntFire("@blue-vecbox", "Start", "", FrameTime())
}


projectileInfo[1]["handle"] <- function(cargo, deactivateCargo) {
    local cloned_cargo_name = "cloned_cube_" + cargo.entindex()

    if(cargo.GetHealth() == 2) {
        Entities.FindByName(null, cloned_cargo_name).Destroy()
    }
    else if(cargo.GetHealth() != 0) {
        cargo = deactivateCargo(cargo)
        cloned_cargo_name = "cloned_cube_" + cargo.entindex()
    }

    local clone_cargo = Entities.FindByName(null, "@clone-cube")
    

    clone_cargo.SetOrigin(cargo.GetOrigin())
    local angle = cargo.GetAngles()
    clone_cargo.SetAngles(angle.x, angle.y, angle.z)
    clone_cargo.__KeyValueFromString("targetname", cloned_cargo_name)
    EntFireByHandle(clone_cargo, "DisableCollision", "", 0, null, null)

    EntFire("@spawn-clone-cube", "forcespawn")
    cargo.SetHealth(2)

    Entities.FindByName(null, "@purple-vecbox").SetOrigin(cargo.GetOrigin())
    EntFire("@purple-vecbox", "Stop")
    EntFire("@purple-vecbox", "Start", "", FrameTime())
}  

projectileInfo[2]["handle"] <- function(cargo, deactivateCargo) {
    if(cargo.GetHealth() == 2) {
        local cloned_cargo_name = "cloned_cube_" + cargo.entindex()
        Entities.FindByName(null, cloned_cargo_name).Destroy()
    }

    EntFireByHandle(cargo, "Color", "255 200 0", 0, null, null)
    local dissolver = Entities.FindByName(null, "@dissolver")
    if(cargo.GetName() == "")
        cargo.__KeyValueFromString("targetname", "dissolved-"+rand())
    dissolver.__KeyValueFromString("target", cargo.GetName())
    cargo.SetHealth(1000)
    EntFire("@dissolver", "dissolve")

    Entities.FindByName(null, "@yellow-vecbox").SetOrigin(cargo.GetOrigin())
    EntFire("@yellow-vecbox", "Stop")
    EntFire("@yellow-vecbox", "Start", "", FrameTime())
}  


function deactivateCargo(cargo) {
    local default_cargo = Entities.FindByName(null, "@default-cube")

    default_cargo.SetOrigin(cargo.GetOrigin())
    local angle = cargo.GetAngles()
    default_cargo.SetAngles(angle.x, angle.y, angle.z)
    default_cargo.__KeyValueFromString("targetname", cargo.GetName())

    if(cargo.GetHealth() == 2) {
        local cloned_cargo_name = "cloned_cube_" + cargo.entindex()
        Entities.FindByName(null, cloned_cargo_name).Destroy()
    }
    cargo.Destroy()
    EntFire("@spawn-default-cube", "forcespawn")
    EntFireByHandle(default_cargo, "wake", "", 0, null, null)

    return default_cargo
}


function fireProjectile(type, start, end, activator_ent) {
    if(isCannonActive)
        return printl("Fanctronic: Projectile is already running :O")

    activator_ent.EmitSound("VecLauncher.Fire")
    local animateProjectile = function(start, end, delay = 0) {
        local distance = end - start
        local dir = end - start
        dir.Norm()
        
        local steps = abs(distance.Length() / projectileSpeed)
        for (local tick = 0; tick < steps; tick++) {
            local newPosition = start + (dir * projectileSpeed * tick)
            local elapsed = (FrameTime() * tick) + delay
            local act = "currentProjectile.SetAbsOrigin( Vector(" + newPosition.x + ", " + newPosition.y + ", " + newPosition.z + ") )"
            EntFireByHandle(self, "runscriptcode", act, elapsed, null, null)
        }

        return FrameTime() * steps
    }

    currentProjectile = projectileInfo[type - 1]["projectileEnt"]
    local animationDuration = 0

    animationDuration += animateProjectile(start, end)

    for(local recursion = 0; recursion < recursionDepth; recursion++) {
        local bounceSurface = Entities.FindByClassnameWithin(null, "trigger_push", end, 2)
        // DebugDrawBox(end, Vector(2,2,2)*-1,Vector(2,2,2),255,255,255,100,2)

        if(!bounceSurface || RandomInt(1,4) == 4)
            break 

        local trace = bboxcast(start, end, [GetPlayer(), caller])
        local dirReflection = Reflect(trace.GetDir(), trace.GetImpactNormal())

        local new_end = end + dirReflection * maxDistance
        start = trace.GetHitpos() + dirReflection * 0.1
        end = bboxcast(start, new_end).GetHitpos()

        EntFireByHandle(self, "runscriptcode", "currentProjectile.EmitSound(\"ParticleBall.Impact\")", animationDuration, null, null)
        animationDuration += animateProjectile(start, end, animationDuration)
    }

    EntFireByHandle(currentProjectile, "Start", "", 0, null, null)
    isCannonActive = true
    EntFireByHandle(currentProjectile, "Stop", "", animationDuration, null, null)
    EntFireByHandle(self, "runscriptcode", "handleProjectileImpact("+type+")", animationDuration, null, null)
}


function handleProjectileImpact(type) {
    isCannonActive = false
    
    local cargo = Entities.FindByClassnameWithin(null, "prop_physics", currentProjectile.GetOrigin(), 35)
    if(!cargo || cargo.GetModelName() != "models/props/puzzlebox.mdl" || cargo.GetHealth() == 1000)
        return printl("Fanctronic: No cargo :<")

    cargo.EmitSound("VecBox.Activate")
    projectileInfo[type - 1]["handle"](cargo, deactivateCargo)
}


foreach(info in projectileInfo){
    local targetname = info.projectileEnt.GetName() + "-color"
    Entities.FindByName(null, targetname).SetOrigin(StrToVec(info.color))
}


function Precache() {
    self.PrecacheSoundScript("VecLauncher.Fire")
    self.PrecacheSoundScript("VecBox.Activate")
    self.PrecacheSoundScript("ParticleBall.Impact")
    // self.PrecacheSoundScript("ParticleBall.AmbientLoop")
}
Precache()