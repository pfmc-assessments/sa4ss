#' Get Available \code{Rmd} Options For A Given Section
#' 
#' Get available options in the \code{sa4ss} package for a given section.
#' By section, we are referring to a section in the document such as the
#' section on fishery-independent information, which is denoted in the
#' files using \code{s} and is part of the Data section, i.e., section 03.
#' See the example for how to get a vector of available survey types.
#' 
#' @param precursor A character string that starts with a two-digit number
#' and is followed by a single alpha character that specifies the type.
#' Specifically, everything before the \code{"-"} in the \code{Rmd} files
#' that are available in the package.
#' @param dir A file path to the directory of interest. It can be relative
#' or absolute. The default value looks to see the available options in the
#' package folder, but you can change this to be the folder for your stock
#' assessment, which would be helpful if you have added or deleted certain
#' files from the default template.
#' @returns Returns a vector of character values. The resulting vector is most
#' likely used by other functions in \code{sa4ss}.
#' @export
#' @author Kelli Faye Johnson
#' @examples
#' get_avail(precursor = "11s")

get_avail <- function(precursor,
  dir = system.file("rmarkdown", "templates", "sa", package = "sa4ss")) {
  gsub(paste0(precursor, "-|\\.[rR][mM][dD]$"), "",
    basename(dir(dir, pattern = paste0(precursor, "-.+\\.Rmd$"),
    recursive = TRUE, ignore.case = TRUE)))
}
