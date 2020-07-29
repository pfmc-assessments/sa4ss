#' Compile Title in YAML format
#' 
#' Write a file to the disk with the title
#' using the yaml form for inclusion in the stock assessment.
#' 
#' @param species A character string specifying the species name.
#' @param latin A character string specifying the latin name.
#' @param coast A character string specifying which part of the coast
#' the stock assessment includes.
#' @param year A numeric or character string specifying the year.
#' The default uses \code{Sys.Date()} to format the year into a four
#' digit character value.
#' @template fileout
#' 
#' @author Kelli Faye Johnson

write_title <- function(species, latin, coast,
  year = format(Sys.Date(),"%Y"),
  fileout = "00title.Rmd") {
  xfun::write_utf8(text = c("\n---",
    yaml::as.yaml(list(title = paste0(species, " (\\emph{", latin, "})",
    " along the ", coast, " coast in ", year))),
    "---"), con = fileout)
}
