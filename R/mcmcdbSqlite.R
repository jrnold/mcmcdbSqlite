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
         

#' Create \code{McmcdbSqlite} object
#'
#' @param dbname \code{character} Name of the database.
#' @return An object of class \code{McmcdbSqlite}.
McmcdbSqlite <- function(dbname = ":memory:") {
  con <- dbConnect(SQLite(), dbname)
  new("McmcdbSqlite", connection = con)
}

