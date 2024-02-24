::EventListener <- class { // Singleton & Observer
    constructor() {
        if("VScriptEventListener" in getroottable())
            return getroottable()["VScriptEventListener"]
        getroottable()["VScriptEventListener"] <- this
    }

    function Notify(eventName, args = null) return null
    function GetEvent(eventName) return GameEvent
}


function EventListener::Notify(eventName, args = null) {
    if(eventName in AllGameEvents)
        return AllGameEvents[eventName].Trigger(args)
    return dev.warning("Unknown GameEvent")
}

function EventListener::GetEvent(EventName) {
    return eventName in AllGameEvents ? AllGameEvents[eventName] : null
}