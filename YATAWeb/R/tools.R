#' @description  Returns data for a combobox
#' @param table Can be a YATATAble Class definition or an instance
#' @param basedOn When not NULL and table base can be grouped, this parameter set the group
makeCombo = function(table, basedOn=NULL) { 
    if ("R6ClassGenerator" %in% class(table)) {
        t = table$new()
    }
    else {
        t = table
    }
    t$getCombo(basedOn) 
}

Rmd2HTML = function(text) {
  
#  t = withMathJax(markdown::markdownToHTML(text=text, fragment.only=T))
  #fname = paste0("IND_", self$symbol, ".Rmd")
  
  # f = system.file("rmd", "IND_SMA.Rmd", package = "YATAModels")
  # HTML(markdown::markdownToHTML(knit(f, quiet = TRUE)))
  HTML(markdown::markdownToHTML("test.md"))
  # if (file.exists(f)) {
  #   txt = knit(text=read_file(f), quiet = TRUE)
  # }
  # HTML(markdown::markdownToHTML(knit('RMarkdownFile.rmd', quiet = TRUE)))
  #Encoding(t) = "UTF-8"
  #HTML(t)
}

makeList = function(values, names) {
    l = as.list(values)
    names(l) = names
    l
}

.prepareTable = function(df) {
    tmp = df;
    
    # Remove auxiliar column: PRICE
    p=which(colnames(tmp) == "Price")
    if (length(p) > 0) tmp = tmp[,-p[1]]
    
    #tblHead = .makeHead(tmp)

    tmp = .convertDates(tmp)
    #dt = datatable(tmp, container = tblHead, rownames = FALSE)
    dt = datatable(tmp, rownames = FALSE)
    .formatColumns(tmp, dt)
}

.makeHead <- function(data) {
  
    dfh = data.frame(head=character(), beg=integer(), len=integer(), stringsAsFactors = F)
    pat = "^[A-Z0-9]+_"
    w = str_extract(colnames(data), pat)
    prfx = unique(w)
    for (p in prfx) {
        if (!is.na(p)) {
            r = which(w == p)
            l = list(head=p, beg=r[1], len=length(r))
            dfh = rbind(dfh, as.data.frame(l, stringAsFactors= F))
        }
    }
    l = list(head="Data", beg=dfh[1,"beg"] - 1, len=dfh[1,"beg"])
    dfh = rbind(as.data.frame(l, stringAsFactors= F), dfh)
    dfh$head = gsub('.{1}$', '', dfh$head)
    
    head2 = gsub(pat, "", colnames(data))
    # htmltools::withTags(table(
    #     class = 'display',
    #     thead(
    #         tr(
    #             lapply(1:nrow(dfh), function(x) { print(x) ; th(colspan=dfh[x,"len"], dfh[x, "head"])})
    #         ),
    #         tr(
    #             lapply(head2, th)
    #         )
    #     )
    # ))
    
}

.convertDates = function(tmp) {
  datedCol = c()
  datetCol = c()
  for (col in colnames(tmp)) {
    if ("dated"      %in% class(tmp[,col])) datedCol  = c(datedCol, col)
    if ("datet"      %in% class(tmp[,col])) datetCol  = c(datetCol, col)
  }
  if (length(datedCol)  > 0) {
    for (col in datedCol) tmp[,col] = as.Date(tmp[,col])
  }
  if (length(datetCol)  > 0) {
    for (col in datetCol) tmp[,col] = as.Date(tmp[,col])
  }
  tmp
}
.formatColumns <- function(tmp, dt, decFiat=2) {
    ctcCol   = c()
    lngCol   = c()
    prcCol   = c()
    datedCol = c()
    datetCol = c()
    fiatCol  = c()
    numberCol = c() 

    for (col in colnames(tmp)) {
        if ("fiat"       %in% class(tmp[,col])) fiatCol   = c(fiatCol, col)        
        if ("ctc"        %in% class(tmp[,col])) ctcCol    = c(ctcCol, col)
        if ("long"       %in% class(tmp[,col])) lngCol    = c(lngCol, col)
        if ("number"     %in% class(tmp[,col])) numberCol = c(numberCol, col)        
        if ("percentage" %in% class(tmp[,col])) prcCol    = c(prcCol, col)
    }
    
    if (length(ctcCol)    > 0) dt = dt %>% formatRound(ctcCol,    digits = 8)
    if (length(lngCol)    > 0) dt = dt %>% formatRound(lngCol,    digits = 0)
    if (length(prcCol)    > 0) dt = dt %>% formatRound(prcCol,    digits = 2)
    if (length(fiatCol)   > 0) dt = dt %>% formatRound(fiatCol,   digits = decFiat)
    if (length(numberCol) > 0) dt = dt %>% formatRound(numberCol, digits = 3)    
    
    dt   
}