::projectileModes <- arrayLib.new()

IncludeScript("fanctronic/vecballs/blue")
IncludeScript("fanctronic/vecballs/green")
IncludeScript("fanctronic/vecballs/orange")
IncludeScript("fanctronic/vecballs/purple")
// IncludeScript("fanctronic/vecballs/")
IncludeScript("fanctronic/vecballs/gray")

printl("Available Vecballs:")
foreach(idx, ball in projectileModes){
    fprint("► {} [{}]", ball.GetType(), idx + 1)
}