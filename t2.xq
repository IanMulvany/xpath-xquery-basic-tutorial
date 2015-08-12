let $doc := doc("elife-articles/elife02535.xml")

let $dir := "elife-articles"
let $docs := file:list($dir, false(), "elife004*.xml")!concat($dir,"/",.)!doc(.)
return sort(distinct-values($docs//*/local-name(.)))
