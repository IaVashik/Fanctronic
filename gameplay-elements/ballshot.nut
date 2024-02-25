local ballshotsModes = {}

function setBallshoot(mode) : (ballshotsModes) {
    caller = entLib.FromEntity(caller)
    local vecball = projectileModes[mode - 1]

    local name = caller.GetNamePrefix() + "*"
    animate.ColorTransition(name, caller.GetColor(), vecball.GetColor(), 0.5)
    ballshotsModes[caller] <- vecball

    if(caller.GetUserData("particle"))
        caller.GetUserData("particle").Destroy()
    
    local colorPrefix = "@" + vecball.GetType() + "-"
    entLib.FindByName(colorPrefix + "ballshot-spawn").SpawnEntity()
    local baseFX = entLib.FindByName(colorPrefix + "ballshot-base")
    baseFX.SetUniqueName()
    baseFX.SetOrigin(caller.GetOrigin() + caller.GetForwardVector() * 30)
    caller.SetUserData("particle", baseFX)
}


function BallShoot() : (ballshotsModes) {
    caller = entLib.FromEntity(caller)
    local vecball = ballshotsModes[caller]

    local start = caller.GetOrigin() + caller.GetForwardVector() * 30
    local end = start + caller.GetForwardVector() * maxDistance

    vecball.Shoot(start, end, caller)

    // Sprite animate
    local sprite = caller.GetNamePrefix() + "sprite"
    animate.AlphaTransition(sprite, 50, 255, 0.1)
    animate.AlphaTransition(sprite, 255, 50, 0.7, {globalDelay = 0.15})


    local shotter = caller.GetNamePrefix() + "*"
    local color = StrToVec(caller.GetColor())
    local newColor = math.clampVector(color * 0.5)
    animate.ColorTransition(shotter, color, newColor, 0.1)
    animate.ColorTransition(shotter, newColor, color, 0.7, {globalDelay = 0.35})
}