let $doc := doc('elife-articles/elife01273.xml')
let $style := doc('elife_xmltohtml.xsl.xml')
return xslt:transform($doc, $style)
