#' Add a full stop to the end of a sentence
#'
#' @param text A text string with or without punctuation at the end.
#' @param punctuation The desired punctuation for the end of your string.
#'
#' @author Kelli F. Johnson
#' @export
#' @return A character string with a punctuation at the end of the string.
#' @examples
#' test <- add_fullstop("I ate an apple today")
#' test <- add_fullstop(c("I ate an apple today", "Example with exclamation!"))
#'
add_fullstop <- function(text,
                         punctuation = ".") {
  check <- grepl("\\.$|[?!]$", text)
  out <- ifelse(check, text, paste0(text, punctuation))
  return(out)
}
