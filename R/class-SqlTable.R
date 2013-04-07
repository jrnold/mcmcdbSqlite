#' @include package.R
#' @include utilities.R
#' @include class-SqlColumn.R
#' @include class-SqlConstraints.R
#' @exportClass SqlTable
#' @export SqlTable
NULL

setClass("SqlTable",
         representation =
         representation(name = "character",
                        columns = "list",
                        constraints = "SqlConstraints",
                        database = "character"))


SqlTable <- function(name, columns = list(), constraints = SqlConstraints(),
                     database = character()) {
  new("SqlTable", name = name[1], columns = columns,
      constraints = constraints, database = database)
}

format.SqlTable <- function(x, temp = FALSE, ifnotexists=FALSE) {
  columns <- paste(sapply(x@columns, format), collapse = ", ")
  if (length(x@constraints)) {
    colconstr <- paste(columns, format(x@constraints), sep = ", ")
  } else {
    colconstr <- columns
  }
  if (emptystring(x@database)) {
    table_name <- x@name
  } else {
    table_name <- paste(x@database, x@name, sep=".")
  }
  sprintf("CREATE %sTABLE%s %s (%s);",
          if (temp) "TEMP " else "",
          if (ifnotexists) " IF NOT EXISTS" else "",
          table_name, colconstr)
}

setMethod("format", "SqlTable", format.SqlTable)

setMethod("show", "SqlTable",
          function(object) {
            cat(sprintf("An object of class %s\n%s\n",
                        dQuote(class(object)), format(object)))
          })
