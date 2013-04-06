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

SqlColumn <- function(name, type, constraints = character()) {
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
                        database = "character",
                        columns = "list",
                        constraints = "SqlConstraints"))

SqlTable <- function(name, database = character(), columns = list(), constraints = character()) {
  new("SqlTable", name = name[1], database = database,
      columns = columns, constraints = SqlConstraints())
}

setMethod("format", "SqlTable",
          function(x, temp = FALSE, ifnotexists=FALSE) {
            col_constr <-
              paste(format(x@columns), format_constraints(x@constraints),
                    sep = ", ")
            table_name <- paste(x@database, x@name, sep=".")
            sprintf("CREATE %sTABLE%s %s (%s);",
                    if (temp) "TEMP " else "",
                    if (ifnotexists) " IF NOT EXISTS" else "",
                    table_name, col_constr)
          })

setMethod("show", "SqlTable",
          function(object) {
            cat(sprintf("An object of class %s\n%s\n",
                        dQuote(class(object)), format(object)))
          })

