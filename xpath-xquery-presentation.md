

XQuery - a primer for the ignorant

	or ... how I learnt to stop worrying, and learn to love markup query syntax

@IanMulvany - 2015-08-26

---

- XPath and XQuery are technologies that can be used to preform structured queries and operations over XML documents.  
- They are both W3C specifications (think incomprehensible but comprehensive documentation and good vendor support).  
- XPath expressions are single line queries that are often run over a single document to extract a specific item, or item set, from an XML document (think regex).  
- XQuery is an entire query language, that incorporates XPath, but also includes the facility to write scripts, modify documents, or join results from queries over multiple documents (think SQL).  

---

# Micro XPath tutorial

We are going to learn how to run xpath queries from the command line, and we are going to run through a couple of trivial examples against a sample douument.

## instal tools

using homebrew we can install `xmllib2` which will provide the `xmlllint` command line tool which can be used to run XPath queries against a document from the commend line.  

``` terminal 
$ brew install xmllib2
$ brew install xmllib2
```



``` terminal
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!-- This file was created with the aha Ansi HTML Adapter. http://ziz.delphigl.com/tool_aha.php -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="application/xml+xhtml; charset=UTF-8" />
<title>stdin</title>
</head>
<body>
<pre>
</pre>
</body>
</html>
```

---

# Resources

XPath tutorial - http://zvon.org/comp/r/tut-XPath_1.html
- Balisage talk on XQuery  
- XPath W3C specification  
- XQuery W3C specification  
- XBase documentation
