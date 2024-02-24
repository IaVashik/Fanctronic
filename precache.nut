local soundScripts = [
    "VecLauncher.Fire", "Weapon_VecGun.Upgrade", "Weapon_Vecgun.Change", "Weapon_VecGun.Fizzle",
    "VecBox.Activate", "VecBox.Deactivate", "ParticleBall.Impact", "VecBox.ClearShield", "ParticleBall.Explosion",

    // game_sounds_vectronic
    "Vectronic.Beep1", "Vectronic.Blower_idle", "Vectronic.Blower_fast_idle", "Vectronic.Blower_stop", 
    "Vectronic.ButtonDown", "Vectronic.ButtonUp", 
    "Vectronic.Conveyor_StepLeft", "Vectronic.Conveyor_StepRight", "Vectronic.Conveyor_BulletImpact", "Vectronic.Conveyor_startup", 
    "Vectronic.Conveyor_idle", "Vectronic.Conveyor_shutdown", "Vectronic.Dispenser_loop", "Vectronic.Dispenser_Start", "Vectronic.DoorChime", 
    "Vectronic.Boxshoot_DoorOpen", "Vectronic.Boxshoot_DoorClose", "Vectronic.Door1Open", "Vectronic.Door1Close", "Vectronic.Door1StopClose", 
    "Vectronic.Door2Open", "Vectronic.Door2Close", "Vectronic.Door2StopClose", "Vectronic.Door3Open", "Vectronic.Door3Close", "Vectronic.Door3StopClose", 
    "Vectronic.ChamberDoorOpen", "Vectronic.ChamberDoorClose", "Vectronic.BulkheadMoving", "Vectronic.BulkheadStop", "Vectronic.Door", "Vectronic.TickTock", 
    "Vectronic.TickTock_Loop", "Vectronic.SwitchDown", "Vectronic.SwitchUp", "Vectronic.SwitchLocked", "Vectronic.LaserLoop", "Vectronic.CatcherHit", 
    "Doors.Move11", "Doors.FullOpen11", "Doors.FullClose11", "Doors.Metal.FullClose1",

    // game_sounds_player_fanctronic
    "Player.Use", "Player.UseDeny", "Player.FallWoosh", "Player.FallWoosh2", "Player.HeartbeatLoop", "Player.Death", "Player.PlasmaDamage", 
    "Player.SonicDamage", "Player.DrownStart", "Player.Swim", "Player.FallGib", "Player.DrownContinue", "Player.Wade", "Player.AmbientUnderWater", 
    "Player.UseTrain", "Player.UseDeny", "Player.PickupWeapon",

    // soundscapes_vectronic
    "Vectronic.Chamberlock", "Vectronic.OpenSpace", "Vectronic.TightSpace", "vectronic.Cleanser", "Vectronic.BTS", "Vectronic.Goo"
]

function SoundPrecache() : (soundScripts) {
    Precache(soundScripts)
}
// Precache("ParticleBall.AmbientLoop")