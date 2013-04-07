emptystring <- function(x) {
  if (! length(x)) {
    TRUE
  } else {
    x == "" | is.na(x)
  } 
}
