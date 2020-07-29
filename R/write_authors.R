#' Compile Authors Names in YAML Form
#' 
#' Write a file to the disk with all authors and their affiliations
#' using the yaml form for inclusion in the stock assessment.
#' 
#' @template authors
#' @template fileout
#' @author Kelli Faye Johnson
#' 
write_authors <- function(authors, fileout = "00authors.Rmd") {
  affil <- get_affiliation(authors)
  affil_u <- affil[!duplicated(affil)]
  matches <- match(affil, affil_u)
  persons <- utils::as.person(authors)
  first <- vapply(lapply(strsplit(format(persons, include = "given"), "\\s+"),
    "[[", 1), substr, "character", start = 1, stop = 1)
  middle <- vapply(lapply(strsplit(format(persons, include = "given"), "\\s+"),
    "[[", 2), substr, "character", start = 1, stop = 1)

  xfun::write_utf8(text = c("\n---",
    yaml::as.yaml(column.major = FALSE, indent.mapping.sequence = TRUE, list(
      author = data.frame(name = authors, code = matches,
        first = first, middle = middle, family = format(persons, include = "family")),
      affiliation = data.frame(
        code = matches[!duplicated(affil)], 
        address = affil[!duplicated(affil)]))),
    "---"), con = fileout)
}
