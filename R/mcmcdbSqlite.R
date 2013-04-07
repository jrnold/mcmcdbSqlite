#' @include package.R
#' @include sql.R
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


foreign_key <- function(column_name, foreign_table, foreign_columns) {
  FK_OPTS <- paste("ON DELETE CASCADE", "ON UPDATE CASCADE",
                 "DEFERRABLE INITIALLY DEFERRED")
  sprintf("FOREIGN KEY (%s) REFERENCES %s (%s) %s",
          paste(column_name, collapse = ", "),
          foreign_table, 
          paste(foreign_columns, collapse = ", "),
          FK_OPTS)
}

TABLES <- list(
  chains = 
  SqlTable("chains",
           list(SqlColumn("chain_id", "INTEGER",
                          SqlConstraints(c("PRIMARY KEY"))))),
  iters =
  SqlTable("iters",
           list(SqlColumn("chain_id", "INTEGER",
                          SqlConstraints("PRIMARY KEY")),
                SqlColumn("iter", "INTEGER",
                          SqlConstraints(c("PRIMARY KEY")))),
           SqlConstraints(foreign_key("chain_id", "chains", "chain_id"))),

  pararrays =
  SqlTable("pararrays",
           list(SqlColumn("pararray", "VARCHAR",
                          SqlConstraints("PRIMARY KEY")))),

  pardim =
  SqlTable("pararrays",
           list(SqlColumn("pararray", "VARCHAR", 
                          SqlConstraints("PRIMARY KEY")),
                SqlColumn("dimension", "INTEGER",
                          SqlConstraints("PRIMARY KEY")),
                SqlColumn("dimsize", "INTEGER", SqlConstraints("NOT NULL"))),
           SqlConstraints(foreign_key("pararray", "pararrays", "pararray"))),

  flatpars =
  SqlTable("flatpars",
           list(SqlColumn("flatpar", "VARCHAR", SqlConstraints("PRIMARY KEY")),
                SqlColumn("pararray", "VARCHAR", SqlConstraints("NOT NULL")),
                SqlColumn("paridx", "INTEGER", SqlConstraints("NOT NULL"))),
           SqlConstraints(foreign_key("pararray", "pararrays", "pararray"))),

  flatpars =
  SqlTable("flatpar_chains",
           list(SqlColumn("flatpar", "VARCHAR", SqlConstraints("PRIMARY KEY")),
                SqlColumn("chain_id", "INTEGER",
                          SqlConstraints("PRIMARY KEY")),
                SqlColumn("init", "FLOAT")),
           SqlConstraints(c(foreign_key("flatpar", "flatpars", "flatpar"),
                            foreign_key("chain_id", "chains", "chain_id")))),


  samples =
  SqlTable("flatpars",
           list(SqlColumn("flatpar", "VARCHAR", SqlConstraints("PRIMARY KEY")),
                SqlColumn("chain_id", "INTEGER",
                          SqlConstraints("PRIMARY KEY")),
                SqlColumn("iter", "INTEGER", SqlConstraints("PRIMARY KEY")),
                SqlColumn("val", "FLOAT")),
           SqlConstraints(c(foreign_key("flatpar", "flatpars", "flatpar"),
                            foreign_key(c("chain_id", "iter"), "iters",
                                        c("chain_id", "iter"))))),

  metadata =
  SqlTable("metadata",
           list(SqlColumn("ky", "VARCHAR", SqlConstraints("PRIMARY KEY")),
                SqlColumn("val", "BLOB"))),

  model_data =
  SqlTable("model_data",
           list(SqlColumn("ky", "VARCHAR", SqlConstraints("PRIMARY KEY")),
                SqlColumn("val", "BLOB"))),

  version =
  SqlTable("version",
           list(SqlColumn("version", "VARCHAR", SqlConstraints("PRIMARY KEY"))))
  )

#' Create \code{McmcdbSqlite} object
#'
#' @param dbname \code{character} Name of the database.
#' @return An object of class \code{McmcdbSqlite}.
McmcdbSqlite <- function(dbname = ":memory:") {
  con <- dbConnect(SQLite(), dbname)
  new("McmcdbSqlite", connection = con)
}
