::HudInterface <- class extends pcapEntity {
    function Enable() null
    function Disable() null
    function Update() null
    function Change(args) null

    function _tostring() {
        return "HUD element: " + this.CBaseEntity
    }
}

IncludeScript("Fanctronic/HUD-controller/GameText")
IncludeScript("Fanctronic/HUD-controller/HintInstructor")