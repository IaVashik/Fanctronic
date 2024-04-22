// IncludeScript("Fanctronic/pcapture-lib")
IncludeScript("pcapture-lib/PCapture-Lib.nut") // TODO

IncludeScript("Fanctronic/projectile")
IncludeScript("Fanctronic/hit-controller")
IncludeScript("Fanctronic/vecballs/main")
IncludeScript("Fanctronic/vecgun")

IncludeScript("Fanctronic/event-controller/GameEvent")
IncludeScript("Fanctronic/event-controller/EventListener")
IncludeScript("Fanctronic/event-controller/gameevents")
IncludeScript("Fanctronic/event-controller/hintevents")

IncludeScript("Fanctronic/HUD-controller/controller")

IncludeScript("Fanctronic/gameplay-elements/vecbox")
IncludeScript("Fanctronic/gameplay-elements/dispenser")
IncludeScript("Fanctronic/gameplay-elements/ballshot")
IncludeScript("Fanctronic/gameplay-elements/fizzler")


// Const
const maxDistance = 3000
const projectileSpeed = 16.6 // units per frame
const recursionDepth = 8
const maxProjectilesOnMap = 10
const vecgunShootDelay = 0

::TraceConfig <- TracePlus.Settings.new()
TraceConfig.SetPriorityClasses(arrayLib(["trigger_gravity"]))
TraceConfig.SetIgnoredModels(arrayLib(["portal_emitter"]))
TraceConfig.SetErrorTolerance(1000)
TraceConfig.SetCollisionFilter(function(ent, ballType) {
    if(ent.GetClassname() != "trigger_multiple") 
        return false
    local vecballIdx = projectileModes.search(ballType) + 1
    return ent.GetHealth() == vecballIdx || ent.GetHealth() == 999
})


// TODO COMMENT
::vecgunOwners <- {}

function giveVecGun(player) { // todo
    if(player in vecgunOwners) 
        return dev.warning(player + " already has vecgun.")
    
    local vecgun = VectronicGun(player)
    vecgunOwners[player] <- vecgun

    local gameui = entLib.CreateByClassname("game_ui", {FieldOfView = -1});
    gameui.ConnectOutputEx("PressedAttack", function() : (vecgun) {
        vecgun.Shoot()
    })
    gameui.ConnectOutputEx("PressedAttack2", function() : (vecgun) {
        vecgun.switchMode()
    })

    EntFireByHandle(gameui, "Activate", "", 0, player)
}


// DEV CODE FOR FUN!
for(local player; player = Entities.FindByClassname(player, "player");) {
    giveVecGun(player)
}

// Sound Precache
IncludeScript("Fanctronic/precache")
SendToConsole("sv_alternateticks 0")