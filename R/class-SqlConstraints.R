#' @include package.R
#' @include utilities.R
#' @exportClass SqlConstraints
#' @export SqlConstraints
NULL

SqlConstraints <-
  setClass("SqlConstraints",
           contains = "character",
           representation = representation(names = "character"))

setMethod("initialize", "SqlConstraints", 
          function(.Object, .Data = character()) {
            .Object@.Data <- as(.Data, "character")
            if (!is.null(names(.Data))) {
              .Object@names <- names(.Data)
            }
            .Object
          })

setMethod("show", "SqlConstraints",
          function(object) {
            cat(sprintf("An object of class %s\n", dQuote(class(object))))
            print(unname(format(object, collapse=FALSE)))
          })

setMethod("format", "SqlConstraints", 
  function(x, collapse=TRUE) {
    sql <-
      mapply(function(name, value) {
        if (is.na(name) | name == "") {
          value
        } else {
          paste("CONSTRAINT", name, value)
        }
      }, names(x), unname(x))
    if (collapse) {
      sql <- paste(sql, collapse=" ")
    }
    sql
  })

