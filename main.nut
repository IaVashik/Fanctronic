// IncludeScript("Fanctronic/pcapture-lib")
IncludeScript("pcapture-lib/PCapture-Lib.nut") // TODO

IncludeScript("Fanctronic/projectile")
IncludeScript("Fanctronic/vecballs/main")
IncludeScript("Fanctronic/vecgun")

IncludeScript("Fanctronic/gameplay-elements/vecbox")
IncludeScript("Fanctronic/gameplay-elements/dispenser")
IncludeScript("Fanctronic/gameplay-elements/ballshot")
IncludeScript("Fanctronic/gameplay-elements/fizzler")


const maxDistance = 3000
const projectileSpeed = 16.6 // units per frame
const recursionDepth = 8
const maxProjectilesOnMap = 10
::traceSettings <- { 
    ignoreClass = arrayLib.new("info_target", "viewmodel", "weapon_", "func_illusionary", "info_particle_system",
    "trigger_", "phys_", "env_sprite", "point_", "vgui_", "physicsclonearea", "env_beam", "func_breakable"),
    priorityClass = arrayLib.new("trigger_push"),
    customFilter = function(ent, ballType) {
        if(ent.GetClassname() != "trigger_multiple") 
            return false
        // fprint("ent: {}, health: {}. ballType: {}; RESULT: {}", ent, ent.GetHealth(), ballType, (ent.GetHealth() == ballType + 1))
        return ent.GetHealth() == ballType + 1 || ent.GetHealth() == 999    // TODO можно индексы на GetUserData заменить
    },
    ErrorCoefficient = 500,
}

vecgunOwners <- {}

function giveVecGun(player) {
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

Precache("VecLauncher.Fire")
Precache("Weapon_VecGun.Upgrade")
Precache("Weapon_Vecgun.Change")
Precache("Weapon_VecGun.Fizzle")
Precache("VecBox.Activate")
Precache("VecBox.Deactivate")
Precache("ParticleBall.Impact")
Precache("VecBox.ClearShield")
Precache("ParticleBall.Explosion")
// Precache("ParticleBall.AmbientLoop")

EntFireByHandle(self, "runscriptcode", "SendToConsole(\"sv_alternateticks 0\")", 1, null, null)