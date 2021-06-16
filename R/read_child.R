#' Read, render, and use a child document
#'
#' Read a child document, render it based on the file extension,
#' which can be .R, .Rmd, .md, or .tex, and place the resulting text
#' into the main document. Acts as a wrapper for
#' [knitr::knit_child].
#'
#' @details
#' The input file will be [knitr::knit] quietly using internal
#' code to set `quiet = TRUE` to suppress the progress bar and messages
#' output from \pkg{knitr}. All R objects will be available in the global
#' environment after the file is rendered. That is, you will be able to inspect
#' all R objects that are created within `filein` after you attempt
#' to render parent file. This is helpful
#' when you receive and error message or you just want to investigate the
#' structure or results of an object made during the process.
#' For example, if the child document includes the creation of a data frame
#' named `test`, then you could inspect the data frame after rendering the
#' document, e.g., `dim(test)`.
#'
#' Child documents are extremely helpful for when you want to share scripts
#' or text across multiple assessments documents, e.g., north and south area
#' models for a given species.
#' In this situation, you could have two folders that store the each store an
#' individual assessment and a third folder that stores text that is common
#' to both documents. Then, you would call this common text within each of the
#' Introduction sections using
#' `read_child(file.path("..", "commonintro.Rmd"))` inside of an R chunk.
#' See the example section for more details.
#' @template filein
#'
#' @author Chantel R. Wetzel
#' @export
#' @return
#' [base::cat] is used to print output to the screen if you run this function
#' on its own or to a resulting rendered file if called within an .Rmd file,
#' where the latter is more likely.
#' @examples
#' \dontrun{
#'
#' # See below for how to include this function in your .Rmd file.
#' # Note that the label for the R chunk (e.g., child_firstexample)
#' # needs to be unique, that is each time you copy and paste this code
#' # you must change the label to be a new value that isn't used elsewhere.
#' # This example will look for a file called commonintro.Rmd inside a
#' # folder called {common_text} that is located
#' just outside of your current directory.
#' ```{r child_firstexample}
#' read_child(filein = file.path("..", "common_text", "commonintro.Rmd"))
#' ```
#' }
#'
read_child <- function(filein) {
  if (grepl("\\.[Rr]$", filein)) {
    ## Need to spin the document first
    chunk <- knitr::spin(filein, knit = FALSE, format = "Rmd", report = FALSE)
    filein <- gsub("\\.[rR]$", ".Rmd", filein)
  }
  res <- knitr::knit_child(filein, quiet = TRUE)
  cat(res, sep = "\n")
}
