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

FK_OPTS <- paste("ON DELETE CASCADE", "ON UPDATE CASCADE",
                 "DEFERRABLE INITIALLY DEFERRED")

chains <-
  SqlTable("chains",
           list(SqlColumn("chain_id", "INTEGER",
                          SqlConstraints(c("PRIMARY KEY")))))

iters <-
  SqlTable("iters",
           list(SqlColumn("chain_id", "INTEGER",
                          SqlConstraints("PRIMARY KEY")),
                SqlColumn("iter", "INTEGER",
                          SqlConstraints(c("PRIMARY KEY")))),
           SqlConstraints(paste("FOREIGN KEY (chain_id) REFERENCES chains (chain_id)",
                                FK_OPTS)))

pararrays <-
  SqlTable("pararrays",
           list(SqlColumn("pararray", "VARCHAR",
                          SqlConstraints("PRIMARY KEY"))))

pardim <-
  SqlTable("pararrays",
           list(SqlColumn("pararray", "VARCHAR",
                          SqlConstraints("PRIMARY KEY")),
                SqlColumn("dimension", "INTEGER",
                          SqlConstraints("PRIMARY KEY")),
                SqlColumn("dimsize", "INTEGER",
                          SqlConstraints("NOT NULL"))),
           SqlConstraints(paste("FOREIGN KEY (pararray) REFERENCES pararrays (pararray)",
                                FK_OPTS)))

flatpars <-
  SqlTable("flatpars",
           list(SqlColumn("flatpar", "VARCHAR",
                          SqlConstraints("PRIMARY KEY")),
                SqlColumn("pararray", "VARCHAR"),
                SqlColumn("paridx", "INTEGER", SqlConstraints("NOT NULL"))),
           SqlConstraints(paste("FOREIGN KEY (pararray) REFERENCES pararrays (pararray)",
                                FK_OPTS)))

flatpars <-
  SqlTable("flatpar_chains",
           list(SqlColumn("flatpar", "VARCHAR",
                          SqlConstraints("PRIMARY KEY")),
                SqlColumn("chain_id", "INTEGER",
                          SqlConstraints("PRIMARY KEY")),
                SqlColumn("init", "FLOAT")),
           SqlConstraints(paste("FOREIGN KEY (flatpar) REFERENCES flatpars (flatpar)",
                                FK_OPTS)),
           SqlConstraints(paste("FOREIGN KEY (chain_id) REFERENCES chains (chain_id)",
                                FK_OPTS)))

samples <-
  SqlTable("flatpars",
           list(SqlColumn("flatpar", "VARCHAR",
                          SqlConstraints("PRIMARY KEY")),
                SqlColumn("chain_id", "INTEGER",
                          SqlConstraints("PRIMARY KEY")),
                SqlColumn("iter", "INTEGER",
                          SqlConstraints("PRIMARY KEY")),
                SqlColumn("val", "FLOAT")),
           SqlConstraints(paste("FOREIGN KEY (flatpar) REFERENCES flatpars (flatpar)",
                                FK_OPTS),
                          paste("FOREIGN KEY (chain_id, iter) REFERENCES iters (chain_id, iter)",
                                FK_OPTS)))

metadata <-
  SqlTable("metadata",
           list(SqlColumn("ky", "VARCHAR", SqlConstraints("PRIMARY KEY"),
                SqlColumn("val", "BLOB"))))

model_data <-
  SqlTable("model_data",
           list(SqlColumn("ky", "VARCHAR", SqlConstraints("PRIMARY KEY"),
                SqlColumn("val", "BLOB"))))

version <-
  SqlTable("version",
           list(SqlColumn("version", "VARCHAR", SqlConstraints("PRIMARY KEY"))))

#' Create \code{McmcdbSqlite} object
#'
#' @param dbname \code{character} Name of the database.
#' @return An object of class \code{McmcdbSqlite}.
McmcdbSqlite <- function(dbname = ":memory:") {
  con <- dbConnect(SQLite(), dbname)
  new("McmcdbSqlite", connection = con)
}
