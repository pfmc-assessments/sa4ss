#' Create tex file from executive summary tables
#'
#' @template mod_loc
#' @param table_folder The relative path for the table directory, where it
#' must be relative to \code{mod_loc} because it will be appended to this
#' argument using \code{file.path}. An alternative is to supply the full
#' file path in \code{mod_loc} and use \code{table_folder = ""}.
#' @param save_table optional input that requires a full path which will 
#' allow users to save the tex file to a specific location (e.g. inside doc folder)
#' other than the \code{file.path(mod_loc, table_folder)}. Default NULL
#'
#' @author Chantel Wetzel
#' 
#' 
es_table_tex <- function(mod_loc, 
					  table_folder = 'tables',
					  save_loc = NULL){

	# Function to round data-frame with characters and numeric values
	round_df <- function(df, digits) {
  		nums <- vapply(df, is.numeric, FUN.VALUE = logical(1))
		df[,nums] <- round(df[,nums], digits = digits)
		(df)
	}

	df = utils::read.csv(file.path(mod_loc, table_folder, "table_labels.csv"))

	if (is.null(save_loc)) {
		save_loc = file.path(mod_loc, table_folder) }
	

	for(i in 1:length(df$filename)){

		tab = utils::read.csv(file.path(mod_loc, table_folder, df$filename[i]), check.names = FALSE)
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