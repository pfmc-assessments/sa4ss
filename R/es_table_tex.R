#' Create tex file from executive summary tables
#'
#' @param dir The directory to look for the csv file that has a list of all
#' csv files to create tex files for. The csv file format should match
#' the table_labels.csv created by r4ss function SSexecutivesummary. The columns
#' names in this folder are caption, altcaption, label, filename, and loc (optional).
#' The loc column is a directory location to find the file (filename) that
#' a tex file should be created for. The \code{dir} can be set to the
#' \code{mod_loc} where the function will automatically look for them inside a
#' table folder in that location.
#' @param table_folder The relative path for the table directory, where it
#' must be relative to \code{dir} because it will be appended to this
#' argument using \code{file.path}. An alternative is to supply the full
#' file path in dir and use \code{table_folder = ""}.
#' @param save_loc optional input that requires a full path which will
#' allow users to save the tex file to a specific location (e.g. inside doc folder)
#' other than the \code{file.path(dir, table_folder)}. Default NULL
#' @param add_prefix Optional input that should be continous text if used that  
#' allows users to append a specific identifier to the tex table labels and the
#' created tex files save the tex file. This option supports the ability to create
#' a joint executive summary for a stock with multiple sub-area models. Default NULL
#' @param csv_name CSV file name to create tex table scripts for. This file should have
#' the following columns: caption, altcaption, label, filenem, loc (optional) where caption will
#' be the table caption, altcapation is the accessibility text for the table (can be
#' NA if the caption should be used), label is the text to reference the table, filename
#' is the file name of the csv file to be read, and loc (optional) is the location to file the
#' csv file indicated by the filename.
#'
#' @author Chantel Wetzel
#'
#' @examples
#' \dontrun{
#' # example of creating tex files for those created by the
#' # r4ss function SSexecutivesummary
#' es_table_tex(dir = mod_loc)
#' # example of using a user created csv file:
#' es_table_tex(
#'   dir = "C:/models/table_to_add_to_doc",
#'   save_loc = "C:/model/tex_tables",
#'   csv_name = "non_es_document_tables.csv"
#' )
#' 
#'  #example of creating tex files for those created by the 
#'  # r4ss function SSexecutivesummary
#' 	es_table_tex(dir = mod_loc)
#'	#example of using a user created csv file:
#'	es_table_tex(dir = "C:/models/model_to_reference",
#'				 save_loc = "C:/model/tex_tables",
#'				 add_prefix = "oregon",
#'				 csv_name = "table_labels.csv")
#' 
#' }
#' @export
es_table_tex <- function(dir,
                         table_folder = NULL,
                         save_loc = NULL,
                         add_prefix = NULL,
                         csv_name = "table_labels.csv") {
  # Function to round data-frame with characters and numeric values
  round_df <- function(df, digits) {
    nums <- vapply(df, is.numeric, FUN.VALUE = logical(1))
    df[, nums] <- round(df[, nums], digits = digits)
    (df)
  }

  if (is.null(table_folder)) {
    if (dir.exists(file.path(dir, "tables"))) {
      df <- utils::read.csv(file.path(dir, "tables", csv_name))
      table_folder <- "tables"
    } else {
      df <- utils::read.csv(file.path(dir, csv_name))
    }
  } else {
    df <- utils::read.csv(file.path(dir, table_folder, csv_name))
  }

  if (is.null(save_loc)) {
    save_loc <- file.path(dir, table_folder)
  }

  for (i in 1:length(df$filename)) {
    if ("loc" %in% colnames(df)) {
      tab <- utils::read.csv(file.path(df$loc[i], df$filename[i]), check.names = FALSE)
    } else {
      if (is.null(table_folder)) {
        tab <- utils::read.csv(file.path(dir, df$filename[i]), check.names = FALSE)
      } else {
        tab <- utils::read.csv(file.path(dir, table_folder, df$filename[i]), check.names = FALSE)
      }
    }

    tex_name <- sub(pattern = ".csv", "", df$filename[i])
    col_names <- gsub("\\_", " ", colnames(tab))
    n <- ncol(tab) - 1

    if (is.character(tab[, 1])) {
      tab[, 1] <- gsub("\\_", " ", tab[, 1])
    }
    
    if(!is.null(add_prefix)) {
      label <- paste0(add_prefix, "-", df$label[1])
    } else {
      label <- df$label[i]
    }

    if (col_names[1] == "Year") {
      t <- table_format(
        x = as.data.frame(tab),
        caption = df$caption[i],
        label = label,
        digits = c(0, rep(2, n)),
        longtable = TRUE,
        col_names = col_names,
        align = c("r", rep("c", n))
      )
    } else {
      t <- table_format(
        x = round_df(df = data.frame(tab), digits = 2),
        caption = df$caption[i],
        label = label,
        longtable = TRUE,
        col_names = col_names,
        align = c("r", rep("c", n))
      )
    }
    
    if(!is.null(add_prefix)) {
      save_name <- paste0(add_prefix, "_", tex_name, ".tex")
    } else {
      save_name <- paste0(tex_name, ".tex")
    }

    kableExtra::save_kable(t,
      file = file.path(save_loc, save_name)
    )
  }
}
