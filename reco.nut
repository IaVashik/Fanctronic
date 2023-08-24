IncludeScript("vectronic/bboxcast")
IncludeScript("vectronic/EventHandler_mini")

projectileInfo <- [
    null,
    {projectileEnt = EntityGroup[0], color = "50 50 255"},
    {projectileEnt = EntityGroup[1], color = "255 50 255"},
    {projectileEnt = EntityGroup[2], color = "255 200 0"},
]

CurrentMode <- 1
currentProjectile <- null
isCannonActive <- false

const maxDistance = 3000
const projectileSpeed = 8 // units per frame
const recursionDepth = 5


function fireProjectile(type, start = null, end = null) {
    if(isCannonActive) 
        return prinlt("Fanctronic: Projectile is already running :O")
    if(!start || !end) {
        start = caller.GetOrigin()
        end = start + caller.GetForwardVector() * maxDistance
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

    currentProjectile = projectileInfo[type]["projectileEnt"]
    local animationDuration = 0

    animationDuration += animateProjectile(start, end)

    for(local recursion = 0; recursion < recursionDepth; recursion++) {
        local bounceSurface = Entities.FindByClassnameWithin(null, "trigger_push", end, 1)

        if(!bounceSurface)
            break 

        local trace = bboxcast(start, end, GetPlayer())
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
    
    local cargo = Entities.FindByClassnameWithin(null, "prop_dynamic", currentProjectile.GetOrigin(), 1) 
    if(!cargo)
        return prinlt("Fanctronic: No cargo :<")
    projectileInfo[type]["handle"](cargo)
}


projectileInfo[1]["handle"] <- handleBlueProjectileImpact function(cargo) {
    
}


function handleGreenProjectileImpactClone() {
    
}


function handleYellowProjectileImpact() {
    
}


function fireProjectileByPlayer() {
    if(!CurrentMode) return printl("No bull")

    local trace = bboxcast.TracePlayerEyes(maxDistance)
    local start = trace.GetStartPos() 
    local hit = trace.GetHitpos()
    fireProjectile(CurrentMode, start, hit)
}


function Reflect(dir, normal) 
    return dir - normal * (dir.Dot(normal) * 2)


EntFireByHandle(self, "runscriptcode", "SendToConsole(\"sv_alternateticks 0\")", 1, null, null)
