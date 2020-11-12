#' Write Summary Files
#' 
#' Write a file to the disk with the title
#' using the yaml form for inclusion in the stock assessment.
#' 
#' @param type A vector of the type of summaries you want included in the
#' stock assessment document. Current options are listed in the default
#' call to \code{write_summary}
#' @template fileout
#' 
#' @author Kelli Faye Johnson

write_summary <- function(type = c("executive", "onepage"),
  fileout = "01summaries.Rmd") {

  type <- match.arg(type, several.ok = TRUE)
  xfun::write_utf8(text = c("\n---",
    yaml::as.yaml(list(title = paste0(species, " (\\emph{", latin, "})",
    " along the ", coast, " coast in ", year))),
    "---"), con = fileout)
}