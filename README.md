# JargonFileDictionaryService
XSL file for converting the Jargon File to DictionaryService format

To convert, [download the original](http://www.catb.org/~esr/jargon/) `jargon.xml` file then add the following entity declarations to make the parser happy

```
<!ENTITY % xhtml-lat1
    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN"
            "xhtml-lat1.ent" >
%xhtml-lat1;

<!ENTITY % xhtml-special
    PUBLIC "-//W3C//ENTITIES Special for XHTML//EN"
            "xhtml-special.ent" >
%xhtml-special;

<!ENTITY % xhtml-symbol
    PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN"
            "xhtml-symbol.ent" >
%xhtml-symbol;
```

Images from the Jargon File go in `./OtherResources/graphics/`.

We can then transform the xml

```
xsltproc -o Jargon.xml DictionaryService.xsl jargon.xml
```

Then build the dictionary
```
make; make install
```
