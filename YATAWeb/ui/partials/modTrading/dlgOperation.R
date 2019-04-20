dlgOper <- function() {
  ns <- session$ns
  modalDialog(actionButton(ns("closeModalBtn"), "Close Modal"))
}