#' Read, render, and use a figure from a specific directory
#'
#' This function is an easy way to add a figure to your document if the figure is already available in a png file. [cat()] is used to print the information to the screen; so, when your .Rmd file is rendered, the resulting LaTeX file will include all the information that was printed to the screen.
#'
#' @details
#' Translation of code from markdown to tex is developing for figures as more
#' and more features for accessibility are developed. This code offers a way to
#' ensure that your figures are coded in the resulting .tex file such that they
#' are most likely to take advantage of the latest and greatest features
#' available. For example, when this function was written, alternative text via
#' rmarkdown chunks was not an option. Instead, the insertion of a figure used
#' html code. Now, for pdf files, there are tagging capabilities such that
#' screen readers can access the alternative text without any post-processing
#' of files if the .tex structure is set up properly. Thus, rather than
#' constantly having to change your document ... just rely on the code within
#' in this function to ensure that your .tex files are up to date. Happy
#' texting!
#'
#' For potentially more information see the [GitHub Discussion Board](
#' www.github.com/pfmc-assessments/sa4ss/discussions) and search for
#' accessibility.
#'
#' @param filein The path of the figure to be added (e.g.,
#'   `"C:\\My figure directory\\plot.png"`). Relative paths are not recommended
#'   because the path of your working directory will change when you are
#'   rendering to the working directory of the file that you are rendering and
#'   the relative path no longer be valid.
#' @param caption A character string providing the figure caption that will be
#'   added below the figure in the document. A default text string is provided
#'   but it is not informative and should be changed. Consider being more
#'   verbose here than typical and remember that captions should be able to 
#'   stand on their own to ensure their portability between media.
#' @param alt_caption A character string providing alternative text for the
#'   figure. The default is `""`, which will force the alternative text to be
#'   blank. Using `NULL` will force the alternative text to also be blank;
#'   previously, this option copied the caption to the alternative text, which
#'   leads to the screen reader reading the same text twice. Note, that the
#'   default is not ideal. Instead, alternative text that describes the
#'   take-home message or information that is not available in the caption
#'   should be included.
#' @param label A character string that will be used as the figure reference for
#'   citation of figure in the document. There is no default value for this
#'   argument because each figure needs to have a unique label that is known by
#'   the user, and thus, the user needs to specify it.
#' @param width,height A numeric value between 0 and 100 that dictates the
#'   figure width or height in terms of a percentage of its size. The default
#'   is 100. `height`` does not work in html mode; instead, use `width` to
#'   scale the figure up or down.
#'
#' @author Chantel R. Wetzel
#' @seealso
#' * 
#' @export
#' @return
#' A string is returned with the label of the figure. You can use this label to
#' reference the figure elsewhere in the document.
#' 
#' [cat()] is used to print output to the
#' screen if you run this function on its own or to a resulting rendered file if
#' called within an .Rmd file, where the latter is more likely. Results are
#' specific to the document being rendered, i.e., where
#' [knitr::is_html_output()] is used to determine if your result is html or
#' latex.
#'
#' @examples
#' \dontrun{
#'
#' # See below for how to include this function in your .Rmd file.
#' #
#' # ```{r, results = 'asis'}
#' # add_figure(
#' #   filein = file.path(
#' #     "My figure directory",
#' #     "plots",
#' #     "ts7_Spawning_output.png"
#' #   ),
#' #   caption = "Spawning output time series.",
#' #   alt_caption = NULL,
#' #   label = "ssb",
#' #   width = 100,
#' #   height = 100
#' # )
#' # ```
#' }
#'
add_figure <- function(filein,
  caption = "Add figure caption",
  alt_caption = "",
  label,
  width = 100,
  height = 100) {

  # check for full stop
  caption <- add_fullstop(caption)
  alt_caption <- add_fullstop(alt_caption)

  if (is.null(alt_caption)) {
    alt_caption <- ""
  }

  if (knitr::is_html_output()) {
    cat(
      sep = "",
      '<figure><img src="',
      filein,
      '" alt="',
      alt_caption,
      '"',
      sprintf(" style=\"width: %f%%\"", width),
      '/><figcaption>',
      caption,
      '</figcaption></figure>'
    )
  } else {
    cat(
      '\n![',
      caption,
      '\\label{fig:',
      label,
      '}](',
      filein,
      '){width=',
      width,
      '% height=',
      height,
      '% alt="',
      alt_caption,
      '"}\n',
      sep = ''
    )
  }
  return(invisible(paste("fig", label, sep = ":")))
}

#' Format a figure or table label for use in a report
#'
#' Format a text string that was used to label a figure or a table such that
#' you can reference that figure or table elsewhere in a report. For example the
#' label might be `fig:my-best-figure` and in the text you might want `Look at
#' the beautiful pie chart in my best figure ever (Figure
#' \ref{fig:mybest-figure})`.
#'
#' @param x A vector of strings. The strings should be valid figure or table
#'   labels. For example `x = c("fig:apple", "fig:banana")`.
#'
#' @author Kelli F. Johnson
#' @seealso 
#' * [add_figure()]
#' @export
#' @examples
#' # Generate some figure references
#' report_ref_label("fig:apple")
#' report_ref_label(c("fig:apple", "fig:banana"))
#' report_ref_label(c("fig:apple", "fig:banana", "fig:carrot"))
#' # Works for tables too
#' report_ref_label("tab:apple")
report_ref_label <- function(x) {
  type <- ifelse(grepl("^fig", x[1]), "Figure", "Table")
  if (length(x) == 1) {
    out <- glue::glue(
      "{type} \\@ref({x})"
    )
  } else {
    out <- glue::glue(
      "{type}s \\@ref({x[1]})--\\@ref({tail(x, 1)})"
    )
  }
  return(out)
}
