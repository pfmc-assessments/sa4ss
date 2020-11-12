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
  middle <- vapply(gsub("[A-Z][a-z]+\\s*", "", format(persons, include = "given")),
    FUN = substr, FUN.VALUE = "character", start = 1, stop = 1, USE.NAMES = FALSE)
  initials <- gsub("\\.\\.", "\\.", sprintf("%1$s.%2$s.", first, middle))
  last <- format(persons, include = "family")
  citation <- paste(last[1], initials[1], sep = ", ")
  if (length(last) > 1) {
    citation <- paste(citation, paste(initials[-1], last[-1],
      sep = " ", collapse = ", "), sep = ", ")
  }
  address <- sprintf("^%1$s^%2$s",
    seq_along(affil[!duplicated(affil)]), affil[!duplicated(affil)])

  xfun::write_utf8(
    c("---\n",
    yaml::as.yaml(column.major = FALSE, indent.mapping.sequence = TRUE, list(
      author = data.frame(name = authors, code = matches,
        first = first, middle = middle, family = format(persons, include = "family")),
      author_list = citation,
      affiliation = data.frame(
        code = matches[!duplicated(affil)],
        address = affil[!duplicated(affil)]),
      address = address)),
      "---"), con = fileout, sep = "")
}