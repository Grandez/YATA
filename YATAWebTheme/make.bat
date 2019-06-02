: Crea el tema y lo copia a YATAWeb
@echo off
grunt swatch:yata
copy /Y .\dist\yata\yata.css D:\R\YATA\YATAWeb\www\yata
