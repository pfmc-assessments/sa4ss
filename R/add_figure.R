#' Read, render, and use a figure from a specific directory.
#'
#' Concatenate input regarding a specified figure with
#' the caption, alternative caption for accessibility, and
#' reference label.
#'
#' @param filein The path of the figure to be added
#' (e.g., "C:\\My figure directory\\plot.png").
#' @param caption A character string providing the figure caption that will be
#' added below the figure in the document.
#' A default text string is provided, but it is not informative and should be changed.
#' @param alt_caption A character string providing alternative text for the figure.
#' The default is `NULL`, which will force the alternative text to be equal to `caption`.
#' Note, that the default is not ideal. Instead, alternative text that describes what
#' is going on in the figure should be included.
#' @param label A character string that will be used as the figure reference
#' for citation of figure in the document.
#' @param width A numeric value between 0 and 100 that dictates the figure width
#' in terms of percentage of size. The default is 100.
#' @param height A numeric value between 0 and 100 that dictates the figure height
#' in terms of percentage of size. The default is 100.
#'
#' @author Chantel R. Wetzel
#' @export
#' @return
#'
#' \code{cat} is used to print output to the screen if you run this function
#' on its own or to a resulting rendered file if called within an .Rmd file,
#' where the latter is more likely.
#' @examples
#' \dontrun{
#'
#' # See below for how to include this function in your .Rmd file.
#' 
#' ```{r, results = 'asis'}
#' add_figure(filein = file.path("My figure directory", "plots", "ts7_Spawning_output.png")
#'   caption = "Spawning output timeseries.",
#'   alt_caption = NULL,
#'   label = "ssb",
#'   width = 100, height = 100
#' )
#' ```
#' }
#'
add_figure <- function(
  filein,
  caption = "Add figure caption",
  alt_caption = NULL,
  label = "default",
  width = 100,
  height = 100
) {

  if (is.null(alt_caption)) { alt_caption = caption }

  cat('\n![',caption,'.\\label{fig:',label,'}](',filein,'){width=',width,'% height=',height,'% alt="',alt_caption,'."}\n',sep='')

}
