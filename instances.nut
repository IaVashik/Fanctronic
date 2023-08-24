function initBallshoot(mode) {
    EntFireByHandle(caller, "Color", projectileInfo[mode-1].color, 0, null, null)
}


function enableCollision() {
    local ent = Entities.FindByClassnameWithin(null, "prop_dynamic", caller.GetOrigin(), 3)
    EntFireByHandle(ent, "EnableCollision", "", 0, null, null)
}


function BallShoot(mode) {
    local start = caller.GetOrigin()
    local trace = bboxcast(start, start + caller.GetForwardVector() * maxDistance, caller)
    local hit = trace.GetHitpos()
    fireProjectile(mode, start, hit, caller)

    local prefix = split(caller.GetName(), "-")[0]
    local sprite = prefix + "-sprite"
    SmoothAlphaTransition(sprite, 30, 255, 0.2)
    SmoothAlphaTransition(sprite, 255, 30, 1, 0.2)
}