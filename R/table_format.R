#' Custom table for sa4ss
#'
#'
#' @param x An R object, typically a matrix or data frame.
#' @param format As defined by [kableExtra::kbl()]. Default for sa4ss is 'latex'.
#' @param caption As defined by [kableExtra::kbl()].
#' @param label As defined by [kableExtra::kbl()].
#' @param booktabs As defined by [kableExtra::kbl()]. Logical.
#' @param digits As defined by [kableExtra::kbl()].
#' @param col_names Names for the columns to show on table.
#' @param linesep As defined by [kableExtra::kbl()].
#' @param longtable As defined by [kableExtra::kbl()].
#' @param font_size Font size in pts. If NULL, document font size is used.
#' @param align As defined by [kableExtra::kbl()].
#' @param col_names_align As defined in [kableExtra::linebreak()].
#' @param hold_position As defined in [kableExtra::kable_styling()]. Logical.
#' @param escape As defined by [kableExtra::kable_styling()].
#' @param bold_header Make headers bold. Logical
#' @param landscape Make this table in landscape orientation?
#' @param repeat_header If landscape, repeat the header on subsequent pages?
#' @param header_grouping As defined by [kableExtra::kable_styling()]
#' @param format.args As defined by [kableExtra::kbl()].
#' @param custom_width Logical. Allow for custom column widths
#' @param col_to_adjust Vector of columns to adjust width. Only used if custom_width = TRUE.
#' @param width Vector or single value of column widths (i.e. c('2cm', '2cm')) for the columns defined
#' in the col_to_adjust.
#' @param create_png Logical. If set to true tables will be created as png objects in the doc.
#' @param ... Extra arguments supplied to \code{\link[kableExtra]{kbl}}.
#'
#' @importFrom kableExtra kbl row_spec kable_styling landscape linebreak
#' @examples
#' table_format(head(iris))
#' @export
table_format <- function(x,
             format = 'latex',
             caption = "Add Caption",
             label = NULL,
             digits = getOption('digits'),
             booktabs = TRUE,
             col_names = NULL,
             linesep = "",
             longtable = TRUE,
             font_size = 10,
             align = 'c',
             col_names_align = 'c',
             hold_position = TRUE,
             escape = FALSE,
             bold_header = FALSE,
             landscape = FALSE,
             repeat_header = FALSE,
             header_grouping = NULL,
             format.args = NULL,
             custom_width = FALSE,
             col_to_adjust = NULL, 
             width = NULL,
             create_png = FALSE,
             ...) {

  if(is.null(label)){
    message('Need to define label to reference table.')
  }

  if (is.null(format.args)) {format.args = format(x)}

  # Use user specified col names
  if (!is.null(col_names)) {
      # Check for newlines in column headers and convert to proper latex linebreaks
      # See 'Insert linebreak in table' section in the following
      # http://haozhu233.github.io/kableExtra/best_practice_for_newline_in_latex_table.pdf
      if (length(grep("\n", col_names))) {
        ## Only use kableExtra if there are newlines
        col_names <- kableExtra::linebreak(col_names, align = col_names_align)
      }

      k <- kableExtra::kbl(x = x,
                 format = format,
                 digits = digits,
                 booktabs = booktabs,
                 caption = caption,
                 label = label,
                 align = align,
                 linesep = linesep,
                 longtable = longtable,
                 col.names = col_names,
                 escape = escape,
                 format.args = format.args,
                 ...)
      suppressWarnings(k <- kableExtra::kable_styling(k, font_size = font_size, latex_options = c('repeat_header')))
  } else {
      k <- kableExtra::kbl(x = x,
                 format = format,
                 digits = digits,
                 booktabs = booktabs,
                 caption = caption,
                 label = label,
                 align = align,
                 linesep = linesep,
                 longtable = longtable,
                 escape = escape,
                 format.args = format.args,
                 ...)
      suppressWarnings(k <- kableExtra::kable_styling(k, font_size = font_size, latex_options = c('repeat_header')))
  } 

  # Add bold to a table
  if (bold_header) {
    suppressWarnings(k <- kableExtra::row_spec(k, 0, bold = TRUE))
  }

  # Add control of column width
  if (custom_width){
    suppressWarnings(k <- kableExtra::column_spec(k, column = col_to_adjust, width = width) )
  } else {
    # Create some logic of how to dynamically determine width
    if(ncol(x) >= 5){ 
      adj_wid = paste0(round(11 / ncol(x), 2), 'cm')
    } else { adj_wid = '2cm'}

    suppressWarnings(k <- kableExtra::column_spec(k, column = 2:ncol(x), width = adj_wid))
  }

  # Landscape table
  if (landscape) {
    k <- kableExtra::landscape(k)
  }

  # Add a header above the row names
  if (repeat_header) {
    suppressWarnings(
    k <- kableExtra::add_header_above(kable_input = k,
                                      header = header_grouping))
    suppressWarnings(
    k <- kableExtra::kable_styling(kable_input = k,
                                   latex_options = c("repeat_header")))
  }
  
  suppressWarnings(k <- kableExtra::kable_styling(k, font_size = font_size))

  # Allow users to specify the hold level
  if (hold_position){
    suppressWarnings(k <- kableExtra::kable_styling(k, latex_options = "HOLD_position"))
  }

  if(create_png){
    if(is.null(label)) { 
      message("Need to specifiy label to name the .png") 
    } else {
    suppressWarnings(k <- kableExtra::save_kable(k, file = paste0("/inst/", label, ".png")))
    } 
  }

  k 
} # End function
