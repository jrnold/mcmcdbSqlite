# Generate SQL CREATE TABLE command
# 
# @param table_name \code{character} Table name
# @param columns \code{data.frame} with columns
# \description{
# \code{\item{name}}{code{character}. Column name}
# \code{\item{type}}{code{character}. Data type}
# \code{\item{name}}{code{character}. All column-level constraints}
# }
# @param temp \code{logical}. Is this a temporary table?
# @param ifexists \code{logical}. If \code{TRUE}, then will only create
# table if it does not already exist, i.e. includes \code{IF NOT EXISTS} in
# the command.
# @return \code{character} string of the SQL \code{CREATE TABLE} command.
sql_create_table <- function(table_name, columns, temp=FALSE,
                             ifexists=TRUE, constraints = character()) {
  columns[["last"]] <- (seq_len(nrow(columns)) == nrow(columns))
  template <- "CREATE {{#temp}}TEMP {{/temp}}TABLE
  {{#ifexists}}IF NOT EXISTS{{/ifexists}}
  {{table_name}} (
  {{#columns}}
    {{name}} {{type}} {{constraints}} {{^last}},{{/last}}
  {{/columns}}
  {{#anyconstr}}, {{/anyconstr}}{{constraints}}
  );"
  whisker.render(template, list(table_name = table_name,
                                columns = unname(rowSplit(columns)),
                                temp = temp,
                                ifexists = ifexists,
                                anyconstr = as.logical(length(constraints)),
                                constraints = paste(constraints, collapse=", ")))
}

emptystring <- function(x) {
  if (is(x, "character")) {
    x == "" | is.na(x)
  } else if (is.null(x)) {
    TRUE
  } else {
    FALSE
  }
}

constraints <- c(a = "a", b = "c", "d")

foo <- SqlColumn("foo", "INTEGER", c("a" = "PRIMARY KEY", "CHECK (foo > 1)"))
