library(plantuml)
library(YATA)

case = YATACase$new()
x=as.plantuml(case)
plot(x)

     