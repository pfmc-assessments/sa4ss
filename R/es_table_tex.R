#' Create tex file from executive summary tables
#'
#' @param mod_loc 
#' @param table_folder 
#' 
#' @author Chantel Wetzel
#' 
es_table_tex <- function(mod_loc, 
					  table_folder = 'tables'){

	df = read.csv(file.path(mod_loc, table_folder, "table_labels.csv"))

	for(i in 1:length(df$filename)){
		tab = read.csv(file.path(mod_loc, table_folder, df$filename[i]))
		tex_name = sub(pattern = ".csv", '', df$filename[i])

		col_names = gsub("\\.", " ", colnames(tab))
		col_names = gsub("\\_", " ", col_names)
		n = ncol(tab) - 1

		if(col_names[1] == "Year"){ dig = 2}

		t <- table_format(x = as.data.frame(tab),
		                  caption = df$caption[i],
		                  label = df$label[i],
		                  digits = c(0, rep(dig, n)),
		                  longtable = TRUE,
		                  col_names = col_names,
		                  align = c('r',rep('c', n)))

		# This does not work
		# Need to find way to save the kbl output into a useable tex file
		save(t, file = file.path(mod_loc, table_folder, paste0(tex_name, ".tex")))
	}

}