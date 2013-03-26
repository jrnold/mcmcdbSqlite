#' @include package.R
NULL

setClass("mcmcdbSqlite", "mcmcdb",
         connection = "SQLiteConnection")
