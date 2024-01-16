::projectileModes <- arrayLib.new()

IncludeScript("fanctronic/vecballs/blue")
IncludeScript("fanctronic/vecballs/green")
IncludeScript("fanctronic/vecballs/orange")
IncludeScript("fanctronic/vecballs/gray")
// IncludeScript("fanctronic/vecballs/")

printl("Available Vecballs:")
foreach(idx, ball in projectileModes){
    fprint("► {} [{}]", ball.GetType(), idx + 1)
}

function getVecballIdx(vecball) {
    return projectileModes.search(vecball)
}