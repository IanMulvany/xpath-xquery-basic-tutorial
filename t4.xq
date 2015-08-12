let $docs := .
for $elem in $docs//kwd-group[@kwd-group-type="author-keywords"]/kwd
return $elem
