IncludeScript("Fanctronic/pcapture-lib")
IncludeScript("Fanctronic/projectile")
IncludeScript("Fanctronic/vecballs/main")
IncludeScript("Fanctronic/vecgun")

IncludeScript("Fanctronic/gameplay-elements/dispenser")


const maxDistance = 3000
const projectileSpeed = 13 // units per frame
const recursionDepth = 5
const maxProjectilesOnMap = 10


vecgunOwners <- {}

function giveVecGun(player) {
    local vecgun = VectronicGun(player)
    vecgunOwners[player] <- vecgun

    local gameui = entLib.CreateByClassname("game_ui", {FieldOfView = -1});
    gameui.ConnectOutputEx("PressedAttack", function() : (vecgun) {
        vecgun.Shoot()
    })

    EntFireByHandle(gameui, "Activate", "", 0, player)
}


// DEV CODE FOR FUN!
for(local player; player = Entities.FindByClassname(player, "player");) {
    giveVecGun(player)
}

Precache("VecLauncher.Fire")
Precache("VecBox.Activate")
Precache("ParticleBall.Impact")
// Precache("ParticleBall.AmbientLoop")
EntFireByHandle(self, "runscriptcode", "SendToConsole(\"sv_alternateticks 0\")", 1, null, null)