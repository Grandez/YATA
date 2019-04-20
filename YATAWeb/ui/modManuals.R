modManUserUI <- function(id) {
  # Create a namespace function using the provided id
  ns <- NS(id)
  tagList(
    #includeHTML("www/user/index.html")
    htmlOutput(ns("manual"))
  )
}
modManUser <- function(input, output, session, parent) {
  ns <- session$ns    
  changed = reactiveVal(FALSE)
  #    output$manual <- renderUI({tags$iframe(seamless="seamless",class="manual", src="www/user/index.html")})
  output$manual <- renderUI({tags$iframe(seamless="seamless"
                                         ,class="manual"
                                         , style="position: absolute; width: 100%; height: 100%; border: none"
                                         ,src="man/user/index.html")})
  return(reactiveVal({TRUE}))
}
modManTechUI <- function(id) {
  # Create a namespace function using the provided id
  ns <- NS(id)
  tagList(
    #includeHTML("www/user/index.html")
    htmlOutput(ns("manual"))
  )
}
modManTech <- function(input, output, session, parent) {
  ns <- session$ns    
  changed = reactiveVal(FALSE)
  #    output$manual <- renderUI({tags$iframe(seamless="seamless",class="manual", src="www/user/index.html")})
  output$manual <- renderUI({tags$iframe(seamless="seamless"
                                         ,class="manual"
                                         , style="position: absolute; width: 100%; height: 100%; border: none"
                                         ,src="man/tech/index.html")})
  return(reactiveVal({TRUE}))
}