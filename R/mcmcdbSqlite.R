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
         representation(name = "character",
                        columns = "data.frame",
                        constraints = "character"))

table_chains <-
  data.frame(name = c("chain_id"),
             type = c("INTEGER"),
             constraints = c("PRIMARY KEY"))

table_iter <-
  data.frame(name = c("chain_id", "iter"),
             type = c("INTEGER", "INTEGER"),
             constraints = c("PRIMARY KEY", "PRIMARY KEY"))

table_flatpars <-
  data.frame(name = c("flatpar", "pararray", "offset"),
             type = c("VARCHAR", "VARCHAR", "INTEGER"),
             constraints = c("PRIMARY KEY", "", ""))

table_pararrays <-
  data.frame(name = c("pararray", "ndim"),
             type = c("VARCHAR", "INTEGER"),
             constraints = c("PRIMARY KEY"))g

table_pardim <-
  data.frame(name = c("pararray", "dim", "index"),
             type = c("VARCHAR", "INTEGER", "INTEGER"),
             constraints = c("PRIMARY KEY", "PRIMARY KEY", ""))

table_flatpar_chains <-
  data.frame(name = c("flatpar", "chain_id"),
             type = c("VARCHAR", "INTEGER"),
             constraints = c("PRIMARY KEY", ""))

table_samples <-
  data.frame(name = c("chain_id", "iter", "flatpar", "val"),
             type = c("VARCHAR", "INTEGER", "INTEGER", "NUMERIC"),
             constraints = c("PRIMARY KEY", "PRIMARY KEY", "PRIMARY KEY", ""))

table_metadata <-
  data.frame(name = c("name", "value"),
             type = c("VARCHAR", "BLOB"))

table_model_data <-
  data.frame(name = c("name", "value"),
             type = c("VARCHAR", "BLOB"),
             contraints = c("PRIMARY KEY", ""))

table_version <-
  data.frame(name = c("versionid", "major", "minor", "patch"),
             type = c("INTEGER", "INTEGER", "INTEGER", "INTEGER"),
             contraints = c("PRIMARY KEY", "", "", ""))

#' Create \code{McmcdbSqlite} object
#'
#' @param dbname \code{character} Name of the database.
#' @return An object of class \code{McmcdbSqlite}.
McmcdbSqlite <- function(dbname = ":memory:") {
  con <- dbConnect(SQLite(), dbname)
  new("McmcdbSqlite", connection = con)
}
