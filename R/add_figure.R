#' Read, render, and use a figure from a specific directory.
#' This function concatinates input of a specified figure with 
#' the caption, alternative caption for accessibility, and
#' reference label.
#'
#' @param filein The path of the figure to be added
#' (e.g., "C:\\My figure directory\\plot.png").
#' @param caption figure caption to add below the figure in the document
#' @param alt_caption Default NULL. Alternative figure caption for accessibility.
#' If not specified the caption will be used.
#' @param label figure reference for citation of figure in the document
#' @param width figure width in terms of percentage of size. Default 100
#' @param height figure height in terms of perccentage of size. Default 100
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
#' 			  caption = "Spawning output timeseries.", 
#'			  alt_caption = NULL,
#' 			  label = "ssb",
#'			  width = 100, height = 100)
#' ```
#' }
#'
add_figure <- function(filein, caption = "Add figure caption", alt_caption = NULL, 
					   label = 'default', width = 100, height = 100) {

  if (is.null(alt_caption)) { alt_caption = caption }
  
  cat('\n![',caption,'.\\label{fig:',label,'}](',filein,'){width=',width,'% height=',height,'% alt="',alt_caption,'."}\n',sep='')

}
