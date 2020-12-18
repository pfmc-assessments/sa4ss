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
#' @param save_table optional input that requires a full path which will 
#' allow users to save the tex file to a specific location (e.g. inside doc folder)
#' other than the \code{file.path(dir, table_folder)}. Default NULL
#'
#' @author Chantel Wetzel
#' 
#' @examples
#' \dontrun{
#'	#example of creating tex files for those created by the 
#'  # r4ss function SSexecutivesummary
#' 	es_table_tex(dir = mod_loc)
#'	#example of using a user created csv file:
#'	es_table_tex(dir = "C:/models/table_to_add_to_doc",
#'				 save_loc = "C:/model/tex_tables",
#'				 csv_name = "non_es_document_tables.csv")
#' }			
#' 
es_table_tex <- function(dir, 
					     table_folder = "",
					     save_loc = NULL,
					     csv_name = "table_labels.csv"){

	# Function to round data-frame with characters and numeric values
	round_df <- function(df, digits) {
  		nums <- vapply(df, is.numeric, FUN.VALUE = logical(1))
		df[,nums] <- round(df[,nums], digits = digits)
		(df)
	}

	if (missing(table_folder)){
		if(dir.exists(file.path(dir, "tables"))){
			df = utils::read.csv(file.path(dir, "tables", csv_name))
		}else{
			df = utils::read.csv(file.path(dir, csv_name))			
		}
	} else {
		df = utils::read.csv(file.path(dir, table_folder, csv_name))
	}

	if (is.null(save_loc)) {
		save_loc = file.path(dir, table_folder) 
	}
	
	for(i in 1:length(df$filename)){
		if("loc" %in% colnames(df)){
			tab = utils::read.csv(file.path(df$loc[i], df$filename[i]), check.names = FALSE)
		} else {
			tab = utils::read.csv(file.path(dir, table_folder, df$filename[i]), check.names = FALSE)
		}

		tex_name = sub(pattern = ".csv", '', df$filename[i])
		col_names = gsub("\\_", " ", colnames(tab))
		n = ncol(tab) - 1

		if(col_names[1] == "Year"){ 
			t <- table_format(x = as.data.frame(tab),
			                  caption = df$caption[i],
			                  label = df$label[i],
			                  digits = c(0, rep(2, n)),
			                  longtable = TRUE,
			                  col_names = col_names,
			                  align = c('r',rep('c', n)))
		}else{
			t <- table_format(x = round_df(df = data.frame(tab), digits = 2),
			                  caption = df$caption[i],
			                  label = df$label[i],
			                  longtable = TRUE,
			                  col_names = col_names,
			                  align = c('r', rep('c', n)))
		}

		kableExtra::save_kable(t,
							   file = file.path(save_loc, paste0(tex_name, ".tex")))
	}

}