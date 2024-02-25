dev["customPrint"] <- function(msg) printl("Fanctronic: " + msg)

// TODO comment
local noAlternateBalls = GameEvent("vecgun_powered_on")
noAlternateBalls.SetAction(function(player) {
    dev.customPrint(player + " got a vecgun")
})


// TODO comment
local newModeActivated = GameEvent("vecgun_mode_activated")
newModeActivated.SetAction(function(modeIdx) {
    dev.customPrint("A new mode has been activated: " + (modeIdx + 1))
})


// TODO comment
local modeDeactivated = GameEvent("vecgun_mode_deactivated")
modeDeactivated.SetAction(function(modeIdx) {
    dev.customPrint("A mode has been deactivated: " + (modeIdx + 1))
})


// TODO comment
local vecgunFired = GameEvent("vecgun_projectile_launched")
vecgunFired.SetAction(function(modeIdx) {
    
})


// TODO comment
local noProjectileAvailable = GameEvent("vecgun_no_projectile")
noProjectileAvailable.SetAction(function(_) {
    dev.customPrint("No projectile")  // todo change to viewmodel
})


// TODO comment
local reCharge = GameEvent("vecgun_recharge")
reCharge.SetAction(function(_) {
    dev.customPrint("Recharging now...")  // todo change to HUD? Sound? Idk
})


// TODO comment
local modeSwitched = GameEvent("vecgun_mode_switched")
modeSwitched.SetAction(function(modeIdx) {
    dev.customPrint("Set " + (modeIdx + 1) + " mode") // todo change to viewmodel
})


// TODO comment
local noAlternateBalls = GameEvent("vecgun_no_alternate_projectile")
noAlternateBalls.SetAction(function(_) {
    dev.customPrint("No other projectile")  // todo change to viewmodel
})

