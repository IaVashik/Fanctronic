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

        this.particleMaker = entLib.FindByName(dev.format("@{}-projectile-spawn", type)) 

        entLib.FindByName(dev.format("@{}-colorPoint", type)).SetOrigin(StrToVec(color))
    }

    function addHandleFunc(func) null
    function addRemoverFunc(func) null
    function cargoRemoveEffects(cargo) null

    function GetStatus() bool
    function GetType() string
    function GetColor() string
    
    function Shoot(startPos, endPos, caller) null
    function playParticle(particleName, originPos) pcapEnt

    function _createProjectileParticle() null
    function _tostring() return "vecProjectile: " + type
}


// Setters & Getters
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


// Something more interesting
function vecProjectile::Shoot(startPos, endPos, caller) {
    local eventName = UniqueString("activeProjectile")
    local particleEnt = this._createProjectileParticle()

    caller.EmitSound("VecLauncher.Fire")

    local projectile = launchedProjectile(particleEnt, eventName, this)
    local animationDuration = 0  

    //? вынести?
    for(local recursion = 0; recursion < recursionDepth; recursion++) {
        local trace = TracePlus.PortalBbox(startPos, endPos, caller, TraceConfig , this)

        local breakIt = false
        local portalTraces = trace.GetAggregatedPortalEntryInfo()
        foreach(iter, portalTrace in portalTraces) {
            animationDuration += projectile.moveBetween(portalTrace.GetStartPos(), portalTrace.GetHitpos(), animationDuration)

            local hitEnt = portalTrace.GetEntityClassname()
            if(hitEnt == "trigger_gravity" || hitEnt == "prop_physics" || hitEnt == "trigger_multiple") {
                endPos = portalTrace.GetHitpos()
                breakIt = true
                break 
            }
        }
        if(breakIt || recursion == recursionDepth - 1) break

        local surfaceNormal = trace.GetImpactNormal()
        local dirReflection = math.vector.reflect(trace.GetDir(), surfaceNormal)

        local newEnd = endPos + dirReflection * maxDistance
        endPos = TracePlus.Cheap(trace.GetHitpos(), newEnd).GetHitpos()
        startPos = trace.GetHitpos() + surfaceNormal
        
        particleEnt.EmitSoundEx("ParticleBall.Impact", animationDuration, eventName)
    }

    projectile.SoftKill(animationDuration)

    //* Основная обработка попадания vecball в куб
    local hitFunc = function() : (endPos, handleHitFunc, particleEnt) {
        local cargo = entLib.FindByModelWithin("models/props/puzzlebox.mdl", endPos, 25)
        if(!cargo || !cargo.IsValid()) 
            return particleEnt.EmitSound("ParticleBall.Explosion")

        handleHitFunc(vecBox(cargo))
    }
    ScheduleEvent.Add(eventName, hitFunc, animationDuration)

    return projectile
}

function vecProjectile::playParticle(particleName, originPos) {
    local particle = entLib.FindByName(dev.format("@{}-{}", this.type, particleName)) 

    particle.SetOrigin(originPos)
    EntFireByHandle(particle, "Stop")
    EntFireByHandle(particle, "Start", "", 0.01)

    return particle
}

function vecProjectile::_createProjectileParticle() {
    local prefix = dev.format("@{}-", this.type)

    entLib.FindByName(prefix + "projectile-spawn").SpawnEntity()
    local particle = entLib.FindByName(prefix + "projectile")

    particle.SetName(this.type)
    EntFireByHandle(particle, "Start")
    return particle
}



// Storage of all launched projectile
::projectileCount <- List()

// The object of the Projectile itself :>
::launchedProjectile <- class {
    particleEnt = null;
    eventName = null;
    vecType = null;
    timeLife = 0;

    constructor(particleEnt, eventName, vecProjectile) {
        this.particleEnt = particleEnt
        this.eventName = eventName
        this.vecType = vecProjectile

        // An optional functionality, created purely for the sake of optimization
        if(::projectileCount.len() > maxProjectilesOnMap) {
            local oldestProjectile = ::projectileCount.first()
            if(oldestProjectile.IsValid()) 
                oldestProjectile.Destroy()
            ::projectileCount.remove(0)
        }
        ::projectileCount.append(this)
    }

    function Destroy() {
        if(this.IsValid() == false) return
        ScheduleEvent.Cancel(this.eventName)
        this.particleEnt.Destroy()
    }

    function SoftKill(delay) {
        EntFireByHandle(particleEnt, "Stop", "", delay)
        EntFireByHandle(particleEnt, "kill", "", delay + 1)
    }

    function IsValid() {
        return ScheduleEvent.IsValid(this.eventName) && this.particleEnt.IsValid()
    }

    function moveBetween(startPos, endPos, delay = 0) {
        return animate.PositionTransitionBySpeed(this.particleEnt, startPos, endPos, 
            projectileSpeed, {eventName = this.eventName, globalDelay = delay})
    }

    function GetType() {
        return this.vecType.type
    }

    function GetOrigin() {
        return this.particleEnt.GetOrigin()
    }
}