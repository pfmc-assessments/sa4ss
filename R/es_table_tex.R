#' Create tex file from executive summary tables
#'
#' @param mod_loc 
#' @param table_folder 
#' 
#' @author Chantel Wetzel
#' @importFrom dplyr mutate_if

#' 
es_table_tex <- function(mod_loc, 
					  table_folder = 'tables'){

	df = read.csv(file.path(mod_loc, table_folder, "table_labels.csv"))

	for(i in 1:length(df$filename)){

		tab = read.csv(file.path(mod_loc, table_folder, df$filename[i]),
					   check.names = FALSE)
		tex_name = sub(pattern = ".csv", '', df$filename[i])

		#col_names = gsub("\\.", " ", colnames(tab))
		col_names = gsub("\\_", " ", colnames(tab))
		# If there are repeat column names a number is added in the csv
		# The following line removes the trailing numbers hopefully
		#col_names = gsub("[0-9]$", "", col_names)
		
		n = ncol(tab) - 1

		if(col_names[1] == "Year"){ 
			dig = 2
			t <- table_format(x = as.data.frame(tab),
			                  caption = df$caption[i],
			                  label = df$label[i],
			                  digits = c(0, rep(dig, n)),
			                  longtable = TRUE,
			                  col_names = col_names,
			                  align = c('r',rep('c', n)))
		}else{
			tab <- data.frame(tab)
			tab <- tab %>% dplyr::mutate_if(is.numeric, round, digits = 2)
			t <- table_format(x = as.data.frame(tab),
			                  caption = df$caption[i],
			                  label = df$label[i],
			                  longtable = TRUE,
			                  col_names = col_names,
			                  align = c('r', rep('c', n)))
		}

		kableExtra::save_kable(t, 
							   file = file.path(mod_loc, table_folder, paste0(tex_name, ".tex")))
	}

}