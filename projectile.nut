class vecProjectile {
    projectileEnt = null;   // черт, а их ведь теперь надо динамически создавать, нужен спавнер!
    type = null;
    color = null;
    handleHitFunc = null;

    constructor(projectileEnt, color, type = "unknown", handleFunc = null) {
        this.projectileEnt = projectileEnt
        this.color = color
        this.type = type
        this.handleHitFunc = handleFunc

        // add change color point
    }

    function addHandleFunc(func) null
    function SetStatus(bool) null

    function GetStatus() bool

    function GetType() string
    function GetColor() string
    
    function Shoot(startPos, endPos, caller = GetPlayer()) null

    function __createProjectile() null
}


function vecProjectile::addHandleFunc(func) {
    this.handleHitFunc = func
}

function vecProjectile::GetType() {
    return this.type
}

function vecProjectile::GetColor() {
    return this.color
}

function vecProjectile::Shoot(startPos, endPos, caller = GetPlayer()) {
    local eventName = UniqueString("activeProjectile")
    local particleEnt = this.__createProjectile()

    local projectile = launchedProjectile(particleEnt, eventName, name)
    local animationDuration = 0 

    // todo comment -----
    for(local recursion = 0; recursion < recursionDepth; recursion++) {
        animationDuration += projectile.moveBetween(startPos, endPos, animationDuration)

        local bounceSurface = entLib.FindByClassnameWithin("trigger_push", endPos, 2)
        local physObject = entLib.FindByClassnameWithin("prop_physics", endPos, 25) //* как варик юзать и для hitFunc

        if(bounceSurface || physObject)
            break 

        local trace = bboxcast(startPos, endPos, caller)
        local dirReflection = math.reflectVector(trace.GetDir(), trace.GetImpactNormal())

        local newEnd = end + dirReflection * maxDistance

        startPos = trace.GetHitpos() + dirReflection * 0.1
        endPos = bboxcast(startPos, newEnd).GetHitpos()

        CreateScheduleEvent(eventName, function():(projectileEnt) {
            projectileEnt.EmitSound("ParticleBall.Impact")
        }, animationDuration)
    }

    caller.EmitSound("VecLauncher.Fire")
    projectile.timeLife = animationDuration

    EntFireByHandle(this.projectileEnt, "Start")
    EntFireByHandle(this.projectileEnt, "Stop", "", animationDuration)
    EntFireByHandle(this.projectileEnt, "kill", "", animationDuration + 1)

    local hitFunc = function() : (endPos, handleHitFunc) {        
        local cargo = entLib.FindByModelWithin("models/props/puzzlebox.mdl", endPos, 25)
        if(!cargo) return

        handleHitFunc(cargo)
        cargo.EmitSound("VecBox.Activate")
    }
    CreateScheduleEvent(eventName, hitFunc, animationDuration)

    return projectile
}



class launchedProjectile {
    particleEnt = null;
    eventName = null;
    timeLife = 0;
    type = null;

    constructor(particleEnt, eventName, type) {
        this.particleEnt = particleEnt
        this.eventName = eventName
        this.type = type
    }

    function Destroy() {
        cancelScheduledEvent(eventName)
        particleEnt.Destroy()
    }

    function isValid() {
        return eventIsValid(eventName)
    }

    function moveBetween(startPos, endPos, delay = 0) {
        return animate.PositionTransitionBySpeed(this.particleEnt, startPos, endPos, 
            projectileSpeed, eventName, delay = 0)
    }

    function GetType() {
        return this.type
    }
}