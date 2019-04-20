library(XLConnect)


.CSVWriteData <- function(data, container, component) {
    fName = filePath(YATAENV$dirOut, name=component, ext="csv")
    write.table(data,fName,row.names=F,sep=";",dec=",")
}

.CSVAppendData <- function(data, container, component) {
    fName = filePath(YATAENV$dirOut, name=component, ext="csv")
    write.table(data, fName, sep=";", dec=",",row.names=F, col.names = F, append=T)
}

# .makeDir <- function(...) { do.call(file.path,c(DIRS["root"], ...)) }
