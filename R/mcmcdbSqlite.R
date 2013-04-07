#' @include package.R
#' @include class-SqlTable.R
#' @exportClass McmcdbSqlite
#' @export McmcdbSqlite
NULL

#' @docType class
#' @title \code{McmcdbSqlite} Class
#'
#' @description SQLite backend for storing \code{mcmcdb}
#' objects.
#'
#' @section Slots:
#'
#' \describe{
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
                          SqlConstraints(c("PRIMARY KEY", "NOT NULL"))))),
  
  iters =
  SqlTable("iters",
           list(SqlColumn("chain_id", "INTEGER", SqlConstraints(c("NOT NULL"))),
                SqlColumn("iter", "INTEGER", SqlConstraints(c("NOT NULL")))),
           SqlConstraints(c(foreign_key("chain_id", "chains", "chain_id"),
                            "PRIMARY KEY (chain_id, iter)"))),

  pararrays =
  SqlTable("pararrays",
           list(SqlColumn("pararray", "VARCHAR",
                          SqlConstraints(c("PRIMARY KEY", "NOT NULL"))))),

  pardim =
  SqlTable("pararrays",
           list(SqlColumn("pararray", "VARCHAR", SqlConstraints("NOT NULL")),
                SqlColumn("dimension", "INTEGER", SqlConstraints("NOT NULL")),
                SqlColumn("dimsize", "INTEGER", SqlConstraints("NOT NULL"))),
           SqlConstraints(c("PRIMARY KEY (pararray, dimension)",
                            foreign_key("pararray", "pararrays", "pararray")))),
           

  flatpars =
  SqlTable("flatpars",
           list(SqlColumn("flatpar", "VARCHAR", SqlConstraints("NOT NULL")),
                SqlColumn("pararray", "VARCHAR", SqlConstraints("NOT NULL")),
                SqlColumn("paridx", "INTEGER", SqlConstraints("NOT NULL"))),
           SqlConstraints(c("PRIMARY KEY (flatpar)", 
                            foreign_key("pararray", "pararrays", "pararray")))),

  flatpars =
  SqlTable("flatpars",
           list(SqlColumn("flatpar", "VARCHAR", SqlConstraints("NOT NULL")),
                SqlColumn("chain_id", "INTEGER", SqlConstraints("NOT NULL")),
                SqlColumn("init", "FLOAT")),
           SqlConstraints(c("PRIMARY KEY (flatpar, chain_id)",
                            foreign_key("flatpar", "flatpars", "flatpar"),
                            foreign_key("chain_id", "chains", "chain_id")))),


  samples =
  SqlTable("samples",
           list(SqlColumn("flatpar", "VARCHAR", SqlConstraints("NOT NULL")), 
                SqlColumn("chain_id", "INTEGER", SqlConstraints("NOT NULL")),
                SqlColumn("iter", "INTEGER", SqlConstraints("NOT NULL")),
                SqlColumn("val", "FLOAT")),
           SqlConstraints(c("PRIMARY KEY (flatpar, chain_id, iter)",
                            foreign_key("flatpar", "flatpars", "flatpar"),
                            foreign_key(c("chain_id", "iter"), "iters",
                                        c("chain_id", "iter"))))),

  metadata =
  SqlTable("metadata",
           list(SqlColumn("ky", "VARCHAR",
                          SqlConstraints(c("PRIMARY KEY", "NOT NULL"))),
                SqlColumn("val", "BLOB"))),

  model_data =
  SqlTable("model_data",
           list(SqlColumn("ky", "VARCHAR", SqlConstraints(c("PRIMARY KEY", "NULL"))),
                SqlColumn("val", "BLOB"))),

  version =
  SqlTable("version",
           list(SqlColumn("version", "VARCHAR",
                          SqlConstraints(c("PRIMARY KEY", "NOT NULL")))))
  )

mcmcdb_sqlite_create_tables <- function(object) {
  for (tbl in TABLES) {
    dbGetQuery(object@connection, format(tbl, ifnotexists=TRUE))
  }
}

McmcdbSqlite <- function(dbname = ":memory:") {
  con <- dbConnect(SQLite(), dbname)
  tablelist <- dbListTables(foo@connection)
  object <- new("McmcdbSqlite", connection = con)
  mcmcdb_sqlite_create_tables(object)
  object
}
