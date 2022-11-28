#' Technical report output formatting
#'
#' Format for creating a technical report with the \code{.pdf} extension.
#' This format will be used to generate markdown from R Markdown and a
#' resulting pdf will be saved to the disk.
#'
#' @param latex_engine The desired latex engine, where luaLaTex is the
#' default because it leads to a 508 compliant document. This argument
#' is passed to \code{\link[bookdown]{pdf_book}}. Only a single value
#' can be passed, but all options are listed below.
#' @param pandoc_args A vector of strings that lead to arguments for pandoc.
#'   This argument is passed to [bookdown::pdf_book()]. An optional argument
#'   that users may wish to add to the default arguments is
#'   `"--lua-filter=tagged-filter.lua"` which will lead to the package-supplied
#'   filter being used to generate tags. This is no longer the preferred method
#'   for creating accessible documents as the kernel for LaTeX now includes
#'   much of this functionality by default.
#' @param ... Additional arguments passed to \code{\link[bookdown]{pdf_book}}.
#' @export
techreport_pdf <- function(
  latex_engine = c("lualatex", "pdflatex"),
  pandoc_args = c("--top-level-division=section", "--wrap=none", "--default-image-extension=png"),
  ...) {
  latex_engine <- match.arg(latex_engine, several.ok = FALSE)
  file <- system.file("rmarkdown","templates", "sa", "resources", "sadraft.tex", package = "sa4ss")

  base <- bookdown::pdf_book(
    template = file,
    keep_tex = TRUE,
    keep_md = TRUE,
    pandoc_args = pandoc_args,
    latex_engine = latex_engine,
    ...
  )

  base$knitr$opts_chunk$comment <- NA
  old_opt <- getOption("bookdown.post.latex")
  on.exit(options(bookdown.post.late = old_opt))
  base
}

inject_refstepcounters <- function(x) {
  chpts <- grep("^\\\\starredchapter\\{", x)
  for (i in chpts) {
    # in very rare setups hypertarget doesn't appear(?):
    .i <- if (grepl("hypertarget", x[i - 1])) i else i + 1
    x <- c(
      x[seq(1, .i - 3)],
      paste0(x[.i - 2], "\n\n\\clearpage\n\n\\refstepcounter{chapter}"),
      x[seq(.i - 1, length(x))]
    )
  }
  x
}


is_windows <- function() {
  identical(.Platform$OS.type, "windows")
}

#' Check to make sure index.Rmd contains all current YAML options
#'
#' As the csasdown package is updated, sometimes new mandatory YAML options are added
#' to the `index.Rmd` file. Running this function will compare your file to the
#' version built into the currently installed version of csasdown and issue
#' a `stop()` statement telling you what doesn't match if needed.
#'
#' @param type Type of document. Currently this is only implemented for research
#'   documents.
#'
#' @export
check_yaml <- function(type = "resdoc") {
  x_skeleton <- names(rmarkdown::yaml_front_matter(
    system.file("rmarkdown", "templates", "resdoc", "skeleton", "skeleton.Rmd",
      package = "csasdown"
    )
  ))
  x_index <- names(rmarkdown::yaml_front_matter("index.Rmd"))
  .diff <- setdiff(x_skeleton, x_index)
  if (length(.diff) > 0L) {
    stop("Your `index.Rmd` file is missing: ", paste(.diff, collapse = ", "), ".")
  } else {
    message("Your `index.Rmd` file contains all necessary YAML options.")
  }
}

#' Creates a temporary directory for compiling the latex file with latex commands for a csasdown type
#'
#' @details The compiled tex file will be copied from either the root directory or the _book directory, depending
#' on the value of `where`. The necessary directories knitr-figs-pdf, knitr-figs-word, knitr-cache-pdf, and
#' knitr-cache-word will be copied recursively into the temporary directory, preserving the directory structure
#' necessary for the build.
#'
#' @param type The csasdown document type. See [draft()]
#' @param where Where to look for the tex file. If "r", look in root directory, if "b", look in the _book
#' subdirectory. Any other value will cause an error
#' @param tmp_dir A temporary directory. If NULL, once will be created in the filesystem using [tempdir()]
#' @param root_dir A directory where everything will be copied from
#'
#' @return The temporary directory's full path
#' @export
#'
#' @examples
#' \dontrun{
#' root_dir <- getwd()
#' tmp_dir <- create_tempdir_for_latex("resdoc", "b")
#' setwd(tmp_dir)
#' tinytex::latexmk("resdoc.tex")
#' setwd(root_dir)
#' }
create_tempdir_for_latex <- function(type = NULL,
                                     where = "r",
                                     tmp_dir = NULL,
                                     root_dir = here::here()) {
  stopifnot(type == "resdoc" ||
    type == "sr" ||
    type == "techreport")
  stopifnot(where == "r" ||
    where == "b")

  if (is.null(tmp_dir)) {
    tmp_dir <- tempdir()
  }

  copy_dir <- function(from_dir, to_dir, recursive = TRUE) {
    dir.create(to_dir, showWarnings = FALSE)
    to_dir <- file.path(to_dir, from_dir)
    dir.create(to_dir, showWarnings = FALSE)
    from_dir <- file.path(root_dir, from_dir)
    from_files <- file.path(from_dir, dir(from_dir))
    invisible(file.copy(from_files, to_dir, recursive = recursive))
  }

  # Copy required directories and files recursively
  copy_dir("csas-style", tmp_dir)
  copy_dir("knitr-cache-pdf", tmp_dir)
  copy_dir("knitr-cache-word", tmp_dir)
  copy_dir("knitr-figs-pdf", tmp_dir)
  copy_dir("knitr-figs-word", tmp_dir)

  # Copy the TEX file
  tex_file_name <- paste0(type, ".tex")
  if (where == "b") {
    tex_file <- file.path(root_dir, "_book", tex_file_name)
  } else if (where == "r") {
    tex_file <- file.path(root_dir, tex_file_name)
  }
  if (!file.exists(tex_file)) {
    stop(paste0(type, ".tex"), " does not exist in the ", ifelse(where == "b", "_book", "root"), " directory")
  }
  invisible(file.copy(tex_file, tmp_dir))
  tmp_dir
}
