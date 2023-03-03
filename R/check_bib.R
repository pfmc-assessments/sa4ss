#' Perform checks on a .bib file
#'
#' Perform checks on a .bib file to ensure compliance with guidelines
#' for stock assessment documents written using this package.
#' Any contributions are positive when it comes to making a bibliography,
#' but consistency is key.
#'
#' @details General Guidelines:
#' Consistency is great for readability and to change future formating.
#' The following includes a list of general guidelines to help increase
#' the consistency of entries across files:
#' * use double quotes to encase arguments within an entry
#' instead of curly brackets
#' * use title-case letters for the type argument, e.g., Article, Manual
#'
#' @details Citation-Key:
#' Citation keys are the first entry for each bibliography entry in a .bib file.
#' These citation-keys must be unique across all .bib files you wish to include
#' in a given build. Therefore, we strongly encourage users to use
#' [dois](https://www.doi.org/) as citation keys when they are available.
#' Not only are dois unique, but they also allow for consistency in formatting
#' compared to some combination of author name, journal, and year.
#'
#' It is important to not include special LaTeX characters in a citation key
#' because they will lead to compiling errors.
#' Remember that the citation keys are TeX commands without escaping.
#'
#' @details Author:
#' Many formatting styles are valid in .bib files for the
#' [Author field](https://nwalsh.com/tex/texhelp/bibtx-23.html).
#' The most important thing to remember is that authors are
#' separated by the word 'and', e.g., author = "Doe, J. and Smith, L.".
#' This format, with the last name first followed by a comma and then the
#' first initial of the first, is the preferred way to include authors.
#' Though TeX will also accept first name followed by last name.
#' Here, we highlight the use of the former with a comma separator because
#' special entries with Jr. can only be formatted this way, so why not format
#' all entries similarly to create continuity and less fatigue when on-boarding
#' new users? Here are some example names,
#' * "Doe, J.""
#' * "Ford, Jr., Henry"
#' * "{Steele Jr.}, Guy L."
#' * "{von Beethoven}, Ludwig"
#'
#' @param file A file path to the `.bib` file of interest.
#' @author Kelli F. Johnson
#' @export
#' @family check functions
#' @return
#' A character vector of logged messages from [bibtex::read.bib] is returned.
#' Additionally, all messages are printed to the screen.
#' If no messages/warnings are produced while reading in the file, the function
#' will return `"Success"`.
#' @examples
#' test <- check_bib(bibtex:::findBibFile("bibtex"))
#'
check_bib <- function(file) {
  logs <- vector("character")
  bib <- withCallingHandlers(
    bibtex::read.bib(file),
    message = function(w) logs <<- append(logs, w$message)
  )
  if (length(logs) == 0) {
    return("Success")
  }
  return(logs)
}
