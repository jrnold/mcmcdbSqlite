#' @include package.R
#' @include utilities.R
#' @include class-SqlConstraints.R
#' @exportClass SqlColumn
#' @export SqlColumn
NULL

setClass("SqlColumn",
         representation =
         representation(name = "character",
                        type = "character",
                        constraints = "SqlConstraints"))

SqlColumn <- function(name, type, constraints = SqlConstraints()) {
  new("SqlColumn", name = name[1], type = type[1], constraints = constraints)
}

setMethod("format", "SqlColumn",
          function(x) {
            sprintf("%s %s %s",
                    x@name,
                    x@type,
                    format(x@constraints))
          })

setMethod("show", "SqlColumn",
          function(object) {
            cat(sprintf("An object of class %s\n%s\n",
                        dQuote(class(object)), format(object)))
          })

