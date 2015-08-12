let $doc := doc("elife-articles/elife02535.xml")

let $dir := "elife-articles"
let $docs := file:list($dir, false(), "elife004*.xml")!concat($dir,"/",.)!doc(.)
for $elem in $docs//kwd-group[@kwd-group-type="author-keywords"]/kwd
return $elem
