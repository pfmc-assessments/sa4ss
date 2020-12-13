#' Read, render, and use a figure from a master csv
#'
#' @param filein location of the figure to be added
#' @param caption figure caption to use
#' @param alt_caption alternative figure caption Default NULL will use the caption.
#' @param label figure reference
#' @param png_name figure name that will be added to the document
#' @width figure width default 100
#' @height figure width default 100
#'
#' @author Chantel R. Wetzel
#' @export
#' @return
#'
#' @examples
#' \dontrun{
#'
#' 
#' ```{r, results = 'asis'}
#' add_figure(filein = file.path("..", "plots", "ts7_Spawning_output.png")
#' 			  caption = "Spawning output timeseries.", 
#'			  alt_caption = NULL,
#' 			  label = "ssb",
#'			  width = 100, height = 100)
#' ```
#' }
#'
add_figure <- function(filein, caption = "Add figure caption", alt_caption = NULL, 
					   label = 'default', width = 100, height = 100) {

  if (is.null(alt_caption)) { alt_caption = caption}
  
  cat('\n![', caption,
	  '.\\label{fig:', label, '}](', 
  	  filein, 
  	  '){width=', width,'% height=', height, '% alt=', alt_caption, '.}\n', sep ='')

}
