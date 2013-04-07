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

