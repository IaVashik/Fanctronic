IncludeScript("Fanctronic/bboxcast")

projectileInfo <- [
    {projectileEnt = EntityGroup[0], color = "138 206 247", available = false},
    {projectileEnt = EntityGroup[1], color = "200 100 200", available = false},
    {projectileEnt = EntityGroup[2], color = "255 200 0", available = false},
]

CurrentMode <- null
currentProjectile <- null
isCannonActive <- false

const maxDistance = 3000
const projectileSpeed = 8 // units per frame
const recursionDepth = 5


function fireProjectile(type, start = null, end = null) {
    if(isCannonActive) 
        return printl("Fanctronic: Projectile is already running :O")
    if(!start || !end) {
        start = caller.GetOrigin()
        local trace = bboxcast(start, start + caller.GetForwardVector() * maxDistance, caller)
        end = trace.GetHitpos()
    }

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
        local bounceSurface = Entities.FindByClassnameWithin(null, "trigger_push", end, 1)
        // DebugDrawBox(end, Vector(2,2,2)*-1,Vector(2,2,2),255,255,255,100,2)

        if(!bounceSurface || RandomInt(1,4) == 4)
            break 

        local trace = bboxcast(start, end, [GetPlayer(), caller])
        local dirReflection = Reflect(trace.GetDir(), trace.GetImpactNormal())

        local new_end = end + dirReflection * maxDistance
        start = trace.GetHitpos() + dirReflection * 0.1
        end = bboxcast(start, new_end).GetHitpos()

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
    if(!cargo || cargo.GetModelName() != "models/props/puzzlebox.mdl")
        return printl("Fanctronic: No cargo :<")

    return projectileInfo[type - 1]["handle"](cargo, deactivateCargo)

}


projectileInfo[0]["handle"] <- function(cargo, deactivateCargo) {
    if(cargo.GetHealth() == 1) return deactivateCargo(cargo)
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


function fireProjectileByPlayer() {
    if(CurrentMode == null) return printl("Fanctronic: No projectile")

    local trace = bboxcast.TracePlayerEyes(maxDistance)
    local start = trace.GetStartPos() 
    local hit = trace.GetHitpos()
    fireProjectile(CurrentMode, start, hit)
}


function Reflect(dir, normal) 
    return dir - normal * (dir.Dot(normal) * 2)

function StrToVec(str) {
    local str_arr = split(str, " ")
    local vec = Vector(str_arr[0].tointeger(), str_arr[1].tointeger(), str_arr[2].tointeger())
    return vec
}

EntFireByHandle(self, "runscriptcode", "SendToConsole(\"sv_alternateticks 0\")", 1, null, null)

foreach(info in projectileInfo){
    local targetname = info.projectileEnt.GetName() + "-color"
    Entities.FindByName(null, targetname).SetOrigin(StrToVec(info.color))
}



function activateMode(mode) {
    projectileInfo[mode-1].available <- true
    if(CurrentMode == null)
        CurrentMode = mode
}

function deactivateAllMode() {
    foreach(info in projectileInfo){
        info.available <- false
    }
    CurrentMode = null
}

function switchMode() {
    if(CurrentMode == null)
        return printl("Fanctronic: No projectile")

    local Currentindex = CurrentMode

    foreach(index, info in projectileInfo){
        if (info.available && index > Currentindex - 1) {
            CurrentMode = index + 1
            break
        }
    }

    if(CurrentMode > projectileInfo.len() || (projectileInfo[0].available && CurrentMode == Currentindex)) {
        CurrentMode = 1
    }

    printl("Fanctronic: Set " + CurrentMode + " mode :>")
}


function initBallshoot(mode) {
    EntFireByHandle(caller, "Color", projectileInfo[mode-1].color, 0, null, null)
}

function enableCollision() {
    local ent = Entities.FindByClassnameWithin(null, "prop_dynamic", caller.GetOrigin(), 3)
    printl(ent)
    EntFireByHandle(ent, "EnableCollision", "", 0, null, null)
}

function Dissolve(ent)
{
    local dissolver = Entities.FindByName(null, "@dissolver")
    KString(,"target",ent.GetName());
    Collision(ent,5)
    EntFire("@dissolver","dissolve")
    dev.log("entity "+ent+" dissolve")
}