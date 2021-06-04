#' Write yaml header for bibliography to its own .Rmd file
#'
#' Write the yaml header entry for bibliographies based on
#' `.bib` files found within the directory (`basedirectory`).
#' Users can also search through higher-level directories using `up` and
#' lower-level directories using `recursive`.
#' This function is helpful when using bookdown because you will often
#' be sourcing files from multiple levels and have many bibliography files,
#' which can all be included in a single call within your yaml header.
#' No need to put all references into a single bib file or specify
#' the bib files ahead of time. Let us use R for this!
#'
#' @details
#' Within this package, note that this function is not currently
#' called by any other function, which is fine because each template
#' has its own `.bib` file.
#' You can add `.bib` files later by running this function prior to compiling
#' your document. Or, you could add it to your index/skeleton.Rmd file
#' using a code chunk. For example,
#' `write_bibliography(getwd(), up = 1)` would update the yaml header
#' every time that you compile, but be aware that you will have to run
#' [bookdown::render_book] multiple times to get get this to work.
#' Developers are working on using the code within the yaml to get it
#' to work instantaneously; so, stay tuned.
#'
#' @param basedirectory The directory that you want to look for bib files
#' in. If `up = 0`, then this will be the only directory that is searched.
#' @param up An integer value specifying how many directory levels you want
#' to search above `basedirectory`.
#' The default is to only search the base directory.
#' @param recursive A logical value specifying if each directory should be
#' searched for using recursion. The default is to not search recursively
#' because you could have other folders higher up that are not relevant.
#' @template fileout
#'
#' @author Kelli F. Johnson
#' @export
#' @return A yaml header for markdown either printed to a file or
#' returned to the screen if using `fileout = stdout()`.
#' @family write
#' @examples
#' # print the output to the screen rather than save to a file
#' write_bibliography(getwd(), fileout = stdout())
write_bibliography <- function(
  basedirectory = getwd(),
  up = 0,
  recursive = FALSE,
  fileout = "00bibliography.Rmd"
) {

  changedirectory <- basedirectory
  bibfiles <- vector()
  while (up >= 0) {
    bibfiles <- append(
      x = bibfiles,
      after = length(bibfiles),
      values = dir(
        path = changedirectory,
        recursive = recursive,
        pattern = "\\.bib$",
        full.names = TRUE
      )
    )
    up <- up - 1
    changedirectory <- dirname(changedirectory)
  }
  relativepaths <- R.utils::getRelativePath(
    pathname = bibfiles,
    relativeTo = basedirectory
  )
  if (length(bibfiles) == 0) return()

  # Format for yaml
  writeLines(
    con = fileout,
    text =  utils::capture.output(
      ymlthis::yml_citations(
        .yml = ymlthis::yml_empty(),
        bibliography = relativepaths)
    )
  )

}
