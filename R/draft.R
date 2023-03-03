#' Initiate a \pkg{sa4ss} draft document, complete with directories and files
#'
#' Initiate a directory that contains all of the files needed for a
#' stock assessment document written with \pkg{sa4ss}.
#'
#' @details
#' ## Wrapper for [rmarkdown::draft]
#' The function is based on [rmarkdown::draft] that creates
#' new R Markdown documents based on templates stored within R packages.
#' The [rticles](https://github.com/rstudio/rticles) R package stores the
#' most templates, mainly for the submission of manuscripts to journals.
#'
#' User input for parameters such as `authors` and `species` help customize
#' the draft to your stock assessment document. Therefore,
#' users should focus on the input arguments that come before `type =`
#' because these will be specific to the stock assessment and are used to
#' set up the initial file structure.
#'
#' ## File structure
#' A template contains two mandatory objects,
#' * template.yaml
#' * skeleton/skeleton.Rmd,
#' and optional files include those in a directory named resources
#' and additional files within the skeleton directory.
#' Because it is not known what your directory will be named, the
#' skeleton file is renamed to `00a.Rmd` by this function to ensure that
#' it comes first in bookdown's rendering of all of the .Rmd files,
#' which is done alphabetically unless users specify all the files,
#' an option that we do not really want to use.
#'
#' @template authors
#' @template species
#' @template latin
#' @template coast
#' @param type The name of the template you want to initiate.
#' The default template is `sa`, which stands for stock assessment.
#' As development for \pkg{sa4ss} progresses, expect to see more templates
#' become available. Available templates are listed in the default function call.
#' Specify a single character value from those available if you want to change
#' the type from the default.
#' @param create_dir A logical value that leads to the draft document being
#' placed in its own directory called `"doc"`.
#' The default value of \code{FALSE} uses the current working directory
#' rather than containing all of the files in a new directory,
#' which is helpful if you want to use your own name for the directory.
#' \code{TRUE} will create the new directory `"doc"` and copy of the necessary
#' files into it.
#' A third option also exists, `"default"`, which allows [rmarkdown::draft],
#' to determine the appropriate directory structure.
#' @param edit A logical value, with a default of \code{FALSE}, specifying if
#' you want to open the indexing file for editing by default. The software chosen
#' by R is normally not ideal and
#' the file is not a file that is normally edited by users,
#' which is why \pkg{sa4ss} does not follow the default value used by
#' [rmarkdown::draft].
#' @param ... Additional arguments that you wish to pass to
#' [rmarkdown::draft]. See `args(rmarkdown::draft)`.
#'
#' @return Invisibly returns the file name of the document,
#' which will be the main indexing file that links to the auxiliary files.
#' If `edit = TRUE`, this file will be opened for editing.
#' @examples
#' \dontrun{
#' sa4ss::draft()
#' }
#' @export
#' @seealso
#' See \code{\link[rmarkdown]{draft}}.
#' @author Kelli F. Johnson
#'
draft <- function(authors,
                  species = "Species name",
                  latin = "Scientific name",
                  coast = "US West",
                  type = c("sa"),
                  create_dir = FALSE,
                  edit = FALSE,
                  ...) {
  type <- match.arg(type, several.ok = FALSE)

  filename <- rmarkdown::draft(
    file = "doc.Rmd",
    template = type,
    package = "sa4ss",
    create_dir = create_dir,
    edit = edit,
    ...
  )

  newname <- gsub("doc.Rmd", "00a.Rmd", filename)
  file.rename(filename, newname)
  thedir <- dirname(newname)
  write_title(
    species = species, latin = latin, coast = coast,
    fileout = file.path(thedir, formals(write_title)$fileout)
  )
  write_authors(authors,
    fileout = file.path(thedir, formals(write_authors)$fileout)
  )
  spp <- species
  Spp <- stringr::str_to_title(spp)
  spp.sci <- latin
  save(spp, Spp, spp.sci, coast, authors,
    file = file.path(thedir, "00opts.Rdata")
  )

  return(invisible(newname))
}
