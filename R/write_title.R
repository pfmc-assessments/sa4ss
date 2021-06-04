#' Compile Title in YAML format
#' 
#' Write a file to the disk with the title
#' using the yaml form for inclusion in the stock assessment.
#'
#' @details The Latin name as specified in \code{"latin"} argument
#' will be encased in underscores to facilitate it being italicized.
#' Using emph is not allowed because the tagging structure
#' for the creation of the 508 compliant pdf will not render the LaTex
#' code here. Nevertheless, the use of markdown inside the yaml seems
#' to work just fine.
#' 
#' @template species
#' @template latin
#' @template coast
#' @param year A numeric or character string specifying the year.
#' The default uses \code{Sys.Date()} to format the year into a four
#' digit character value.
#' @template fileout
#'
#' @author Kelli Faye Johnson
#' @family write

write_title <- function(species, latin, coast,
  year = format(Sys.Date(),"%Y"),
  fileout = "00title.Rmd") {
  xfun::write_utf8(text = c("---\n",
    yaml::as.yaml(list(title = paste0("Status of ", species, " (_", latin, "_)",
    " along the ", coast, " coast in ", year))),
    "---"), con = fileout, sep = "")
}
