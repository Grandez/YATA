library(XLConnect)

.XLSLoadModelGroups <- function(shName) {
    wbName = filePath(YATAENV$modelsDBDir, name=YATAENV$modelsDBName, ext="xlsx")
    XLSLoadSheet(wbName, shName)
}
.XLSLoadModelModels <- function(shName) {
    wbName = filePath(YATAENV$modelsDBDir, name=YATAENV$modelsDBName, ext="xlsx")
    XLSLoadSheet(wbName, shName)
}
.XLSLoadCTCIndex <- function(shName) {
    wbName = filePath(YATAENV$dataSourceDir, name=YATAENV$dataSourceDBName, ext="xlsx")
    XLSLoadSheet(wbName, shName)
}
.XLSLoadCTCTickers <- function(symbol) {
    xlcFreeMemory()
    fp = filePath(YATAENV$dataSourceDir, name=YATAENV$dataSourceDBName, ext="xlsx")
    df = XLConnect::readWorksheetFromFile(fp, symbol)
    df
}

.XLSloadCases <- function() {
    xlcFreeMemory()
    xx = filePath(YATAENV$dataSourceDir, name=DB_CASES, ext="xlsx")
    sh = XLConnect::readWorksheetFromFile(xx, TCASES_CASES, startRow=2)
    sh
}

XLSLoadSheet <- function(file,sheet,start=1) {
    XLConnect::readWorksheetFromFile(file, sheet)
}

############################################################################3












.XLSsetSummaryFileName <- function(case) {
    fileName = .translateText(YATAENV$templateSummaryFile, case)
    file.path(YATAENV$outDir, paste(fileName, "xlsx", sep="."))
}
.XLSsetSummaryFileData <- function(case) {
    .translateText(YATAENV$templateSummaryData, case)
}

