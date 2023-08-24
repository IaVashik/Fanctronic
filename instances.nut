function initBallshoot(mode) {
    EntFireByHandle(caller, "Color", projectileInfo[mode-1].color, 0, null, null)
}


function initDispanser(mode) {
    EntFireByHandle(caller, "Color", projectileInfo[mode-1].color, 0, null, null)
    local prefix = caller.split("-")[0]
    local color_point = projectileInfo[mode-1].projectileEnt.GetName() + "-color"
    EntFire(prefix + "-particle", "addoutput", "point1 " + color_point, 0) // TOOD
    EntFire(prefix + "-particle2", "addoutput", "point1 " + color_point, 0) // TOOD
}


function enableCollision() {
    local ent = Entities.FindByClassnameWithin(null, "prop_dynamic", caller.GetOrigin(), 3)
    EntFireByHandle(ent, "EnableCollision", "", 0, null, null)
}


function BallShoot(mode) {
    local start = caller.GetOrigin()
    local trace = bboxcast(start, start + caller.GetForwardVector() * maxDistance, caller)
    local hit = trace.GetHitpos()
    fireProjectile(mode, start, hit)

    local prefix = caller.split("-")[0]
    local sprite = Entities.FindByName(null, prefix + "-sprite")
    SmoothAlphaTransition(sprite, 0, 255, 0.2)
    SmoothAlphaTransition(sprite, 255, 0, 1, 0.2)
}