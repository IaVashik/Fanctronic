class vecProjectile {
    particleMaker = null;
    type = null;
    color = null;

    handleHitFunc = null;
    removeEffectsFunc = null;

    constructor(type, color, handleFunc = null) {
        this.color = color
        this.type = type
        this.handleHitFunc = handleFunc

        this.particleMaker = entLib.FindByName("@" + type + "-projectile-spawn")

        entLib.FindByName("@" + type + "-colorPoint").SetOrigin(StrToVec(color))
    }

    function addHandleFunc(func) null
    function addRemoverFunc(func) null
    function cargoRemoveEffects(cargo) null

    function GetStatus() bool
    function GetType() string
    function GetColor() string
    
    function Shoot(startPos, endPos, caller = GetPlayer()) null
    function playParticle(particleName, originPos) pcapEnt

    function __createProjectile() null
}


function vecProjectile::addHandleFunc(func) {
    this.handleHitFunc = func
}

function vecProjectile::addRemoverFunc(func) {
    this.removeEffectsFunc = func
}

function vecProjectile::cargoRemoveEffects(cargo) {
    this.removeEffectsFunc(cargo)
}

function vecProjectile::GetType() {
    return this.type
}

function vecProjectile::GetColor() {
    return this.color
}

function vecProjectile::Shoot(startPos, endPos, caller) {
    local eventName = UniqueString("activeProjectile")
    local particleEnt = this.__createProjectile()

    local projectile = launchedProjectile(particleEnt, eventName, this.type)
    local animationDuration = 0 
    local vecballIdx = projectileModes.search(this)

    for(local recursion = 0; recursion < recursionDepth; recursion++) {
        animationDuration += projectile.moveBetween(startPos, endPos, animationDuration)

        local bounceSurface = entLib.FindByClassnameWithin("trigger_push", endPos, 2)
        local physObject = entLib.FindByClassnameWithin("prop_physics", endPos, 25) //* как варик юзать и для hitFunc

        if(bounceSurface || physObject)
            break 

        local trace = bboxcast(startPos, endPos, caller, traceSettings, vecballIdx)
        local dirReflection = math.reflectVector(trace.GetDir(), trace.GetImpactNormal())

        local newEnd = endPos + dirReflection * maxDistance

        startPos = trace.GetHitpos() + dirReflection * 0.1
        endPos = bboxcast(startPos, newEnd).GetHitpos()

        CreateScheduleEvent(eventName, function():(particleEnt) {
            particleEnt.EmitSound("ParticleBall.Impact")
        }, animationDuration)
    }

    caller.EmitSound("VecLauncher.Fire")
    projectile.timeLife = animationDuration

    EntFireByHandle(particleEnt, "Start")
    EntFireByHandle(particleEnt, "Stop", "", animationDuration)
    EntFireByHandle(particleEnt, "kill", "", animationDuration + 1) // TODO надо наверное destroy вызывать

    local hitFunc = function() : (endPos, handleHitFunc, particleEnt) {
        local cargo = entLib.FindByModelWithin("models/props/puzzlebox.mdl", endPos, 25)
        if(!cargo || cargo.IsValid() == false) 
            return particleEnt.EmitSound("ParticleBall.Explosion")

        handleHitFunc(vecBox(cargo))
    }
    CreateScheduleEvent(eventName, hitFunc, animationDuration)

    return projectile
}

function vecProjectile::playParticle(particleName, originPos) {
    local particle = entLib.FindByName("@" + this.type + "-" + particleName)

    particle.SetOrigin(originPos)
    EntFireByHandle(particle, "Stop")
    EntFireByHandle(particle, "Start", "", 0.01)

    return particle
}

function vecProjectile::__createProjectile() {
    local prefix = "@" + this.type + "-"

    entLib.FindByName(prefix + "projectile-spawn").SpawnEntity()
    local particle = entLib.FindByName(prefix + "projectile")

    particle.SetName(this.type)
    return particle
}


::projectileCount <- []

::launchedProjectile <- class {
    particleEnt = null;
    eventName = null;
    type = null;
    timeLife = 0;

    __countIndex = 0;

    constructor(particleEnt, eventName, type) {
        this.particleEnt = particleEnt
        this.eventName = eventName
        this.type = type

        // An optional functionality, created purely for the sake of optimization       
        if(::projectileCount.len() > maxProjectilesOnMap) {
            if(::projectileCount[0].IsValid()) 
                ::projectileCount[0].Destroy()
            ::projectileCount.remove(0)
        }
        this.__countIndex = ::projectileCount.len()
        ::projectileCount.append(this)
    }

    function Destroy() {
        cancelScheduledEvent(eventName)
        particleEnt.Destroy()
        ::projectileCount.remove(this.__countIndex)
    }

    function IsValid() {
        return eventIsValid(eventName) && particleEnt.IsValid()
    }

    function moveBetween(startPos, endPos, delay = 0) {
        return animate.PositionTransitionBySpeed(this.particleEnt, startPos, endPos, 
            projectileSpeed, {eventName = this.eventName, globalDelay =  delay})
    }

    function GetType() {
        return this.type
    }
}