let $docs := unparsed-text("test-eif-long.json")=>json:parse()
return
sort(distinct-values(
   $docs/string-join(//*/ancestor-or-self::*/name(.), '/&#xa;')
))
