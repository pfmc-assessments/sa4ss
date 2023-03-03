#' Get Available `.Rmd` Template Files For A Given Section
#'
#' Get a vector of template file names that are available for a given section.
#' By section, we are referring to a section in the document such as the
#' section on fishery-independent information, which is denoted in the
#' files using `s` for survey and is part of the Data section.
#'
#' @details Motiviation:
#' As the package develops, it is the hope that the number of available template
#' files will increase because it is not fruitful for everyone to constantly
#' re-write default text. For example, the background information for the
#' Triennial survey should be the same regardless of species. Or, software used
#' to work up a given data set should be the same across most species such
#' as the ageing-error software that has been kindly provided by
#' Dr. Punt and others.
#'
#' @param precursor A character string that starts with a two-digit number
#' and is followed by a single alpha character that specifies the type.
#' Specifically, everything before the `"-"` in the `.Rmd` files
#' that are available in the package.
#' @param separator A character string that separates the `precursor` from
#' the rest of the file name. The default is a dash.
#' @param dir A file path to the directory of interest. It can be relative
#' or absolute. The default value looks to see the available options in the
#' package folder, but you can change this to be the folder for your stock
#' assessment, which would be helpful if you have added or deleted certain
#' files from the default template.
#' @returns Returns a vector of file names with their extensions.
#' @export
#' @author Kelli F. Johnson
#' @examples
#' # To list all available templates within each section
#' get_templatenames()
#' # To remove file extension from the returned names
#' gsub("\\..{3}$", "", get_templatenames())
get_templatenames <- function(precursor = "",
                              separator = "-",
                              dir = system.file(
                                "rmarkdown",
                                "templates", "sa",
                                package = "sa4ss"
                              )) {
  basename(dir(
    path = dir,
    pattern = paste0(precursor, separator, ".+\\.Rmd$"),
    recursive = TRUE,
    ignore.case = TRUE
  ))
}
