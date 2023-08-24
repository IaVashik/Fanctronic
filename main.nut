IncludeScript("Fanctronic/bboxcast")
IncludeScript("Fanctronic/utils")
IncludeScript("Fanctronic/projectile")
IncludeScript("Fanctronic/instances")



const maxDistance = 3000
const projectileSpeed = 12 // units per frame
const recursionDepth = 5

CurrentMode <- null
currentProjectile <- null
isCannonActive <- false



function fireProjectileByPlayer() {
    if(CurrentMode == null) return printl("Fanctronic: No projectile")

    local trace = bboxcast.TracePlayerEyes(maxDistance)
    local start = trace.GetStartPos() 
    local hit = trace.GetHitpos()
    fireProjectile(CurrentMode, start, hit)
}


function activateMode(mode) {
    projectileInfo[mode-1].available <- true
    if(CurrentMode == null)
        CurrentMode = mode
}


function deactivateAllMode() {
    foreach(info in projectileInfo){
        info.available <- false
    }
    CurrentMode = null
}


function switchMode() {
    if(CurrentMode == null)
        return printl("Fanctronic: No projectile")

    local Currentindex = CurrentMode

    foreach(index, info in projectileInfo){
        if (info.available && index > Currentindex - 1) {
            CurrentMode = index + 1
            break
        }
    }

    if(CurrentMode > projectileInfo.len() || (projectileInfo[0].available && CurrentMode == Currentindex)) {
        CurrentMode = 1
    }

    printl("Fanctronic: Set " + CurrentMode + " mode :>")
}


EntFireByHandle(self, "runscriptcode", "SendToConsole(\"sv_alternateticks 0\")", 1, null, null)