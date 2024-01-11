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
for(local player; player = Entities.FindByClassname(player, "player");) {
    local vecgun = VectronicGun(player)
    vecgunOwners[player] <- vecgun
}




EntFireByHandle(self, "runscriptcode", "SendToConsole(\"sv_alternateticks 0\")", 1, null, null)