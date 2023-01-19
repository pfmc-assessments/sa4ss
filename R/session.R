#' Test your installation of sa4ss
#'
#' Test the installation of sa4ss to build the template pdf.
#'
#' @details
#' sa4ss relies on a lot of back-end functionality that typical R packages
#' do not require. Ensuring that these are installed properly is facilitated
#' when you use Rstudio because the developers of Rstudio have put in a lot of
#' work towards making it easy for users to compile documents. sa4ss also relies
#' on `sed` which is available in the tools provided by R, i.e., rtools40, but
#' not always available in your path.
#'
#' The premise of this function is to store information if the pdf build is not
#' successful that is of use to the developers. If you provide the generic output
#' that is returned to the developers, then they will be able to help you and
#' future individuals like yourself work through installation problems.
#' So, thank you for being willing to help.
#'
#' @return
#' A list object is returned with two entries.
#' The first entry, `session_info`,
#' contains stored information about your work session.
#' The typical output from [Sys.getenv] is augmented with information pertinent
#' to the sa4ss package and compiling accessible pdf documents.
#' The second entry, `tried`, is the output from [tryCatch] when attempting
#' to compile the .Rmd files into a pdf using [bookdown::render_book].
#' If the function fails to produce a successful pdf, then a
#' [utils::bug.report] is generated and users are sent to github issues,
#' where they can fill out an issue based on the installation issue template.
#'
#' @author Kelli F. Johnson
#' @export
#' @examples
#' localtest <- session_test()
#'
session_test <- function() {

  #### Set up
  oldwd <- getwd()
  on.exit(setwd(oldwd), add = TRUE)
  newdir <- file.path(tempdir(), "sa4ss")
  on.exit(unlink(newdir, recursive = TRUE), add = TRUE)
  ignore <- dir.create(newdir, recursive = TRUE, showWarnings = FALSE)
  setwd(newdir)

  #### Make the test pdf
  localinfo <- session_info()
  sa4ss::draft(authors = "Kelli F. Johnson", create_dir = FALSE)
  theworks <- tryCatch(
    expr = bookdown::render_book("00a.Rmd", clean = FALSE, output_dir = getwd()),
    error = function(x) x)

  #### Test for success
  if (!file.exists("_main.pdf")) {
    writeLines(do.call(paste,list(names(localinfo)," -- ", localinfo)))
    utils::flush.console()
    utils::bug.report(package = "sa4ss")
    message("Use the template for installation issues to get help.\n",
      "Please, include the output returned from this function in the issue.")
  }

  #### Return information
  return(list(session_info = localinfo, tried = theworks))
}

session_find <- function(name) {
  location <- Sys.which(names = name)
  if (!file.exists(location)) {
    warning(name, " was not found on your system.", call. = FALSE)
  } else {
    location <- normalizePath(location)
  }

  return(location)
}

session_info <- function() {
  info <- Sys.getenv()
  info[["pandoc_version"]] <- rmarkdown::pandoc_version()
  info[["pandoc_location"]] <- rmarkdown::pandoc_exec()
  info[["sed_location"]] <- session_find("sed")

  return(info)
}
