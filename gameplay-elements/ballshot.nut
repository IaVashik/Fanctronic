function setBallshoot(mode) {
    caller = entLib.FromEntity(caller)
    local vecball = projectileModes[mode - 1]

    local name = caller.GetNamePrefix() + "-*"
    animate.ColorTransition(name, caller.GetColor(), vecball.GetColor(), 1)
    caller.SetUserData("vecball", vacball)
}

function BallShoot() {
    caller = entLib.FromEntity(caller)
    local vecball = caller.GetUserData("vecball")
    local vecballIdx = projectileModes.search(vecball)

    local start = caller.GetOrigin()
    local trace = bboxcast(start, start + caller.GetForwardVector() * maxDistance, caller, vecballIdx, traceSettings)
    local hit = trace.GetHitpos()

    vecball.Shoot(start, hit, caller)

    // Sprite animate
    local sprite = caller.GetNamePrefix() + "-sprite"
    animate.AlphaTransition(sprite, 30, 255, 0.2)
    animate.AlphaTransition(sprite, 255, 30, 1, null, 0.2)
}