# JargonFileDictionaryService
XSL file for converting the Jargon File to DictionaryService format

To convert the original `jargon.xml` file, run the following command:
```
xsltproc -o Jargon.xml DictionaryService.xsl jargon.xml
```

Then build the dictionary
```
make; make install
```
