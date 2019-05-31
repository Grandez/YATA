dataModal <- function(failed = FALSE) {
  modalDialog(
    textInput("dataset", "Choose data set",
              placeholder = 'Try "mtcars" or "abc"'
    ),
    span('(Try the name of a valid data object like "mtcars", ',
         'then a name of a non-existent object like "abc")'),
    if (failed)
      div(tags$b("Invalid name of data object", style = "color: red;")),
    
    footer = tagList(
      modalButton("Cancel"),
      actionButton("ok", "OK")
    )
  )
}
