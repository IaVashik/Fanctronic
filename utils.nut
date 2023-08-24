function Reflect(dir, normal) 
    return dir - normal * (dir.Dot(normal) * 2)


function StrToVec(str) {
    local str_arr = split(str, " ")
    local vec = Vector(str_arr[0].tointeger(), str_arr[1].tointeger(), str_arr[2].tointeger())
    return vec
}


function SmoothAlphaTransition(ent, start, end, time, globalDelay = 0) {
    local transitionFrames = abs(time / FrameTime());    
    local alphaStep = (end - start) / transitionFrames;
    
    for (local i = 0; i < transitionFrames; i++) {
        local delay = FrameTime() * i + globalDelay;
        local newAlpha = start + alphaStep * (i + 1);
        EntFire(ent, "alpha", newAlpha.tostring(), delay)
    }
}