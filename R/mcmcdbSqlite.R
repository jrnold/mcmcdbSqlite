#' @include package.R
NULL

#' @docType class
#' @title \code{McmcdbSqlite} Class
#'
#' @description SQLite backend for storing \code{mcmcdb}
#' objects.
#'
#' @section Slots:
#'
#' \description{
#' \item{\code{connection}}{\code{"SQLiteConnection"}. Connection to the SQLite Database used to store the MCMC data.}
#' }
setClass("McmcdbSqlite", "Mcmcdb",
         representation = representation(connection = "SQLiteConnection"))


setClass("SqlTable",
         representation =
         representation(name = "character",
                        columns = "list",
                        constraints = "character"))

SqlTable <- function(name, columns = list(), constraints = character()) {
  new("SqlTable", name = name, columns = columns, constraints = constraints)
}


setClass("SqlColumn",
         representation =
         representation(name = "character",
                        type = "character",
                        constraints = "character"))

SqlColumn <- function(name, type, constraints = character()) {
  new("SqlColumn", name = name, type = type, constraints = constraints)
}

## tablelist <-
##   list(
##     chains =
##     SqlTable(name = "chains",
##              columns =
##              list(SqlColumn("chain_id", "INTEGER",
##                             "PRIMARY KEY")))
##     ## iters = 
##     ## SqlTable(name = "iters",
##     ##          columns =
##     ##          list(
##     ##            SqlColumn(name = "chain_id",
##     ##                      type = "INTEGER",
##     ##                      constraints = "PRIMARY KEY"),
               
##     ##            type = c("INTEGER", "INTEGER")),
##     ##          constraints = c("PRIMARY KEY", "PRIMARY KEY")),
##     ## flatpars =
##     ## SqlTable(name = "flatpars",
##     ##          columns =
##     ##          data.frame(name = c("flatpar", "pararray", "offset"),
##     ##                     type = c("VARCHAR", "VARCHAR", "INTEGER")),
##     ##          constraints = c("PRIMARY KEY", "", "")),
##     ## pararrays =
##     ## SqlTable(name = "pararrays",
##     ##          columns =
##     ##          data.frame(name = c("pararray", "ndim"),
##     ##                     type = c("VARCHAR", "INTEGER")),
##     ##          constraints = c("PRIMARY KEY")),
##     ## pardim =
##     ## SqlTable(name = "pardim",
##     ##          columns = 
##     ##          data.frame(name = c("pararray", "dim", "index"),
##     ##                     type = c("VARCHAR", "INTEGER", "INTEGER")),
##     ##          constraints = c("PRIMARY KEY", "PRIMARY KEY", "")),
##     ## latpar_chains =
##     ## SqlTable(name = "flatpar_chains",
##     ##          columns =
##     ##          data.frame(name = c("flatpar", "chain_id"),
##     ##                     type = c("VARCHAR", "INTEGER")),
##     ##          constraints = c("PRIMARY KEY", "")),
##     ## samples =
##     ## SqlTable(name = "samples",
##     ##          columns = 
##     ##          data.frame(name = c("chain_id", "iter", "flatpar", "val"),
##     ##                     type = c("VARCHAR", "INTEGER", "INTEGER", "NUMERIC"))
##     ##          constraints =
##     ##          c("PRIMARY KEY", "PRIMARY KEY", "PRIMARY KEY", "")),
##     ## metadata =
##     ## SqlTable(name = "metadata",
##     ##          columns =
##     ##          data.frame(name = c("name", "value"),
##     ##                     type = c("VARCHAR", "BLOB")),
##     ##          constraints = c("PRIMARY KEY", "")),
##     ## model_data =
##     ## SqlTable(name = "model_data",
##     ##          columns =
##     ##          data.frame(name = c("name", "value"),
##     ##                     type = c("VARCHAR", "BLOB"))
##     ##          contraints = c("PRIMARY KEY", "")),
##     ## version =
##     ## SqlTable(name = "version",
##     ##          columns =
##     ##          data.frame(name = "version",
##     ##                     type = "VARCHAR"),
##     ##          constraints = c("PRIMARY KEY"))
##     )

#' Create \code{McmcdbSqlite} object
#'
#' @param dbname \code{character} Name of the database.
#' @return An object of class \code{McmcdbSqlite}.
McmcdbSqlite <- function(dbname = ":memory:") {
  con <- dbConnect(SQLite(), dbname)
  new("McmcdbSqlite", connection = con)
}
