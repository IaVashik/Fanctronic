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
    
    function Shoot(startPos, endPos, caller) null
    function playParticle(particleName, originPos) pcapEnt

    function __createProjectile() null
    function _tostring() return "vecProjectile: " + type
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
    local vecballIdx = projectileModes.search(this) + 1

    for(local recursion = 0; recursion < recursionDepth; recursion++) {
        local trace = bboxcast(startPos, endPos, caller, traceSettings, vecballIdx) //? vecballIdx 

        animationDuration += projectile.moveBetween(startPos, trace.GetHitpos(), animationDuration)

        local hitEnt = trace.GetEntityClassname()
        if(hitEnt == "trigger_push" || hitEnt == "prop_physics" || hitEnt == "trigger_multiple") {
            endPos = trace.GetHitpos()
            break 
        }

        local dirReflection = math.reflectVector(trace.GetDir(), trace.GetImpactNormal())

        local newEnd = endPos + dirReflection * maxDistance
        endPos = bboxcast._TraceEnd(trace.GetHitpos(), newEnd) //
        startPos = trace.GetHitpos() + trace.GetImpactNormal()
        
        if(recursion != recursionDepth - 1) {
            CreateScheduleEvent(eventName, function():(particleEnt, recursion) {
                particleEnt.EmitSound("ParticleBall.Impact")
            }, animationDuration)
        }
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

    constructor(particleEnt, eventName, type) {
        this.particleEnt = particleEnt
        this.eventName = eventName
        this.type = type

        // An optional functionality, created purely for the sake of optimization // TODO add delay and delete
        if(::projectileCount.len() > maxProjectilesOnMap) {
            if(::projectileCount[0].IsValid()) 
                ::projectileCount[0].Destroy()
            ::projectileCount.remove(0)
        }
        ::projectileCount.append(this)
    }

    function Destroy() {
        if(this.IsValid() == false) return
        cancelScheduledEvent(eventName)
        particleEnt.Destroy()
    }

    function IsValid() {
        return eventIsValid(this.eventName) && particleEnt.IsValid()
    }

    function moveBetween(startPos, endPos, delay = 0) {
        return animate.PositionTransitionBySpeed(this.particleEnt, startPos, endPos, 
            projectileSpeed, {eventName = this.eventName, globalDelay =  delay})
    }

    function GetType() {
        return this.type
    }
}